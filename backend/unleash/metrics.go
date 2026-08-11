package unleash

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"maps"
	"net/http"
	"os"
	"sync"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/log"
)

// Unleash usage reporting, from the API's side.
//
// The clients evaluate Unleash and forward the resulting toggles to us as the
// `x-feature-flags` request header, so this package deliberately does *not*
// embed an Unleash SDK: we are not a source of truth for flag values, we only
// submit usage counts for the decisions we made with the values we were given.
// The Go SDK cannot do that — it insists on fetching toggles and evaluating
// them against its own context.
//
// What we submit is the plain metrics bucket the Unleash SDKs post, which is
// what populates the toggle metrics and variant graphs in the Unleash UI.
// Impression events are *not* part of this: `impressionData` only makes a
// client SDK emit a local event for the app to forward to its own analytics,
// and is never sent to Unleash.
//
// Wire format mirrors unleash-proxy-client's Metrics.sendMetrics.

// DefaultAppName is the Unleash appName the API reports under. Deliberately
// distinct from the clients' own appNames (the web client is `bccm-web`) so
// backend-driven exposure stays separable, and so nothing is double-counted if
// a client later starts reporting its own metrics.
const DefaultAppName = "bccm-api"

const (
	defaultInterval = 30 * time.Second
	metricsPath     = "/client/metrics"
)

// MetricsConfig configures the reporter. When URL or Token is empty the
// reporter is inert.
type MetricsConfig struct {
	// URL is the Unleash API base *including* the api segment, e.g.
	// https://unleash.example/api/frontend. The token kind has to match the
	// base: a frontend token for /api/frontend, a client token for
	// /api/client.
	URL      string
	Token    string
	AppName  string
	Interval time.Duration
	Disabled bool
}

// toggleBucket is the per-flag count for one reporting window.
type toggleBucket struct {
	Yes      int            `json:"yes"`
	No       int            `json:"no"`
	Variants map[string]int `json:"variants"`
}

type bucket struct {
	Start   time.Time                `json:"start"`
	Stop    time.Time                `json:"stop"`
	Toggles map[string]*toggleBucket `json:"toggles"`
}

type metricsPayload struct {
	AppName    string `json:"appName"`
	InstanceID string `json:"instanceId"`
	Bucket     bucket `json:"bucket"`
}

// MetricsReporter aggregates flag exposure counts in memory and posts them to
// Unleash on an interval.
//
// Counting happens on the request path, so Count does nothing but take a mutex
// and bump a map entry; the HTTP round trip happens on the Start goroutine.
type MetricsReporter struct {
	cfg        MetricsConfig
	instanceID string
	httpClient *http.Client

	mu      sync.Mutex
	toggles map[string]*toggleBucket
	start   time.Time
}

// NewMetricsReporter returns a reporter for cfg. Following the convention of
// analytics.NewService, missing configuration degrades to a warning and an
// inert reporter rather than failing startup — feature-flag telemetry must
// never be the reason the API won't boot.
//
// Returns nil when there is nothing to report to. Every method is nil-safe, so
// callers never need to guard.
func NewMetricsReporter(cfg MetricsConfig) *MetricsReporter {
	if cfg.Disabled {
		log.L.Info().Msg("Unleash metrics reporting is disabled, feature flag usage will not be sent to Unleash")
		return nil
	}
	if cfg.URL == "" || cfg.Token == "" {
		log.L.Warn().Msg("Unleash is not configured, feature flag usage will not be sent to Unleash")
		return nil
	}

	if cfg.AppName == "" {
		cfg.AppName = DefaultAppName
	}
	if cfg.Interval <= 0 {
		cfg.Interval = defaultInterval
	}

	// The pod name, matching what the SDKs put here.
	instanceID, err := os.Hostname()
	if err != nil || instanceID == "" {
		instanceID = "unknown"
	}

	return &MetricsReporter{
		cfg:        cfg,
		instanceID: instanceID,
		httpClient: &http.Client{Timeout: 10 * time.Second},
		toggles:    map[string]*toggleBucket{},
		start:      time.Now(),
	}
}

// Count records one exposure of flag. enabled selects the yes/no counter;
// variant, when non-empty, additionally bumps that variant's counter. This
// matches the count/countVariant pair in the Unleash SDKs.
//
// Callers are responsible for deciding what an exposure is — see
// ReportConsidered, which dedups to one exposure per request per flag.
func (r *MetricsReporter) Count(flag string, variant string, enabled bool) {
	if r == nil || flag == "" {
		return
	}

	r.mu.Lock()
	defer r.mu.Unlock()

	t, ok := r.toggles[flag]
	if !ok {
		t = &toggleBucket{Variants: map[string]int{}}
		r.toggles[flag] = t
	}
	if enabled {
		t.Yes++
	} else {
		t.No++
	}
	if variant != "" {
		t.Variants[variant]++
	}
}

// FlagCounts is a flag's accumulated exposure for the current window.
type FlagCounts struct {
	Yes      int
	No       int
	Variants map[string]int
}

// Snapshot returns a copy of what has been counted since the last flush,
// without consuming it. For tests and diagnostics; the reporting path uses
// Count and the flusher.
func (r *MetricsReporter) Snapshot() map[string]FlagCounts {
	if r == nil {
		return nil
	}

	r.mu.Lock()
	defer r.mu.Unlock()

	out := make(map[string]FlagCounts, len(r.toggles))
	for flag, t := range r.toggles {
		variants := make(map[string]int, len(t.Variants))
		maps.Copy(variants, t.Variants)
		out[flag] = FlagCounts{Yes: t.Yes, No: t.No, Variants: variants}
	}
	return out
}

// Start flushes the bucket on cfg.Interval until ctx is cancelled. Blocks, so
// run it in its own goroutine.
//
// Note there is no flush on shutdown: cmd/api has no graceful-shutdown hook,
// so up to one interval of counts is lost on redeploy. That is why the default
// interval is short.
func (r *MetricsReporter) Start(ctx context.Context) {
	if r == nil {
		return
	}

	ticker := time.NewTicker(r.cfg.Interval)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			r.flush(ctx)
		}
	}
}

// swap takes the accumulated bucket and installs a fresh one, returning nil
// when nothing was counted. Held lock is released before any I/O.
func (r *MetricsReporter) swap() *bucket {
	if r == nil {
		return nil
	}

	r.mu.Lock()
	defer r.mu.Unlock()

	if len(r.toggles) == 0 {
		return nil
	}

	b := &bucket{
		Start:   r.start,
		Stop:    time.Now(),
		Toggles: r.toggles,
	}
	r.toggles = map[string]*toggleBucket{}
	r.start = b.Stop

	return b
}

// flush posts one bucket. Failures are logged and the bucket is dropped: usage
// metrics are not worth retry machinery or unbounded memory growth.
func (r *MetricsReporter) flush(ctx context.Context) {
	b := r.swap()
	if b == nil {
		// Empty buckets are skipped, as the SDKs do.
		return
	}

	body, err := json.Marshal(metricsPayload{
		AppName:    r.cfg.AppName,
		InstanceID: r.instanceID,
		Bucket:     *b,
	})
	if err != nil {
		log.L.Warn().Err(err).Msg("Failed to encode Unleash metrics")
		return
	}

	url := r.cfg.URL + metricsPath
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(body))
	if err != nil {
		log.L.Warn().Err(err).Msg("Failed to build Unleash metrics request")
		return
	}

	req.Header.Set("authorization", r.cfg.Token)
	req.Header.Set("content-type", "application/json")
	req.Header.Set("accept", "application/json")
	req.Header.Set("unleash-appname", r.cfg.AppName)
	req.Header.Set("unleash-sdk", "bccm-media-api")

	res, err := r.httpClient.Do(req)
	if err != nil {
		log.L.Warn().Err(err).Int("toggles", len(b.Toggles)).Msg("Failed to send Unleash metrics")
		return
	}
	defer func() { _ = res.Body.Close() }()

	if res.StatusCode >= 300 {
		// 401/403 here almost always means the token kind doesn't match the
		// URL base: a frontend token needs /api/frontend, a client token
		// needs /api/client.
		log.L.Warn().
			Int("status", res.StatusCode).
			Str("url", url).
			Int("toggles", len(b.Toggles)).
			Msg("Unleash rejected the metrics bucket")
	}
}

// String is only for logging/debugging the configured target.
func (c MetricsConfig) String() string {
	return fmt.Sprintf("unleash(url=%s, appName=%s, interval=%s)", c.URL, c.AppName, c.Interval)
}
