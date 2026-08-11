package unleash

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"sync"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// newTestReporter builds a configured reporter pointed at url, bypassing the
// interval so tests can call flush directly.
func newTestReporter(url string) *MetricsReporter {
	r := NewMetricsReporter(MetricsConfig{
		URL:     url,
		Token:   "test-token",
		AppName: "test-api",
	})
	r.instanceID = "test-instance"
	return r
}

func TestCountAggregatesYesNoAndVariants(t *testing.T) {
	r := newTestReporter("http://example.invalid")

	r.Count("cdn-provider", "ioriver", true)
	r.Count("cdn-provider", "ioriver", true)
	r.Count("cdn-provider", "cloudfront", true)
	r.Count("cdn-provider", "", false)
	r.Count("shorts-with-scores3", "", false)

	b := r.swap()
	require.NotNil(t, b)

	cdn := b.Toggles["cdn-provider"]
	require.NotNil(t, cdn)
	assert.Equal(t, 3, cdn.Yes)
	assert.Equal(t, 1, cdn.No)
	assert.Equal(t, map[string]int{"ioriver": 2, "cloudfront": 1}, cdn.Variants)

	shorts := b.Toggles["shorts-with-scores3"]
	require.NotNil(t, shorts)
	assert.Equal(t, 0, shorts.Yes)
	assert.Equal(t, 1, shorts.No)
	assert.Empty(t, shorts.Variants)
}

// TestSwapResetsBucket verifies counts are not double-reported across windows.
func TestSwapResetsBucket(t *testing.T) {
	r := newTestReporter("http://example.invalid")

	r.Count("a", "", true)
	first := r.swap()
	require.NotNil(t, first)
	assert.Equal(t, 1, first.Toggles["a"].Yes)

	// Nothing counted since, so there is nothing to send.
	assert.Nil(t, r.swap())

	r.Count("a", "", true)
	second := r.swap()
	require.NotNil(t, second)
	assert.Equal(t, 1, second.Toggles["a"].Yes, "counts must not carry over between windows")

	// Windows are contiguous: each starts where the previous stopped.
	assert.Equal(t, first.Stop, second.Start)
}

func TestFlushPostsExpectedPayload(t *testing.T) {
	type received struct {
		method  string
		path    string
		headers http.Header
		body    []byte
	}

	got := make(chan received, 1)
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		body, _ := io.ReadAll(req.Body)
		got <- received{req.Method, req.URL.Path, req.Header.Clone(), body}
		w.WriteHeader(http.StatusAccepted)
	}))
	defer srv.Close()

	r := newTestReporter(srv.URL + "/api/frontend")
	r.Count("cdn-provider", "ioriver", true)
	r.flush(context.Background())

	select {
	case rec := <-got:
		assert.Equal(t, http.MethodPost, rec.method)
		assert.Equal(t, "/api/frontend/client/metrics", rec.path)
		assert.Equal(t, "test-token", rec.headers.Get("authorization"))
		assert.Equal(t, "application/json", rec.headers.Get("content-type"))
		assert.Equal(t, "test-api", rec.headers.Get("unleash-appname"))

		var payload struct {
			AppName    string `json:"appName"`
			InstanceID string `json:"instanceId"`
			Bucket     struct {
				Start   time.Time `json:"start"`
				Stop    time.Time `json:"stop"`
				Toggles map[string]struct {
					Yes      int            `json:"yes"`
					No       int            `json:"no"`
					Variants map[string]int `json:"variants"`
				} `json:"toggles"`
			} `json:"bucket"`
		}
		require.NoError(t, json.Unmarshal(rec.body, &payload))

		assert.Equal(t, "test-api", payload.AppName)
		assert.Equal(t, "test-instance", payload.InstanceID)
		assert.False(t, payload.Bucket.Start.IsZero())
		assert.False(t, payload.Bucket.Stop.IsZero())
		assert.Equal(t, 1, payload.Bucket.Toggles["cdn-provider"].Yes)
		assert.Equal(t, map[string]int{"ioriver": 1}, payload.Bucket.Toggles["cdn-provider"].Variants)
	case <-time.After(2 * time.Second):
		t.Fatal("no metrics request received")
	}
}

// TestFlushSkipsEmptyBucket verifies we don't spam Unleash with empty buckets
// on every tick of an idle instance, matching what the SDKs do.
func TestFlushSkipsEmptyBucket(t *testing.T) {
	var calls int
	var mu sync.Mutex
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		mu.Lock()
		calls++
		mu.Unlock()
		w.WriteHeader(http.StatusAccepted)
	}))
	defer srv.Close()

	r := newTestReporter(srv.URL)
	r.flush(context.Background())
	r.flush(context.Background())

	mu.Lock()
	defer mu.Unlock()
	assert.Zero(t, calls)
}

// TestUnconfiguredReporterIsInert covers the degraded path: a missing URL or
// token must not panic callers, since Count is on the request path.
func TestUnconfiguredReporterIsInert(t *testing.T) {
	for _, cfg := range []MetricsConfig{
		{},
		{URL: "http://example.invalid"},
		{Token: "t"},
		{URL: "http://example.invalid", Token: "t", Disabled: true},
	} {
		r := NewMetricsReporter(cfg)
		require.Nil(t, r)

		assert.NotPanics(t, func() {
			r.Count("a", "b", true)
			r.Start(context.Background())
			r.flush(context.Background())
		})
	}
}

func TestNewMetricsReporterDefaults(t *testing.T) {
	r := NewMetricsReporter(MetricsConfig{URL: "http://example.invalid", Token: "t"})
	require.NotNil(t, r)
	assert.Equal(t, DefaultAppName, r.cfg.AppName)
	assert.Equal(t, defaultInterval, r.cfg.Interval)
	assert.NotEmpty(t, r.instanceID)
}

// TestCountConcurrent exercises the bucket under -race: gqlgen resolves sibling
// fields on parallel goroutines, so Count is called concurrently.
func TestCountConcurrent(t *testing.T) {
	r := newTestReporter("http://example.invalid")

	const goroutines = 100
	var wg sync.WaitGroup
	wg.Add(goroutines)
	for i := range goroutines {
		go func() {
			defer wg.Done()
			r.Count("cdn-provider", "ioriver", i%2 == 0)
		}()
	}
	wg.Wait()

	b := r.swap()
	require.NotNil(t, b)
	cdn := b.Toggles["cdn-provider"]
	assert.Equal(t, goroutines, cdn.Yes+cdn.No)
	assert.Equal(t, goroutines, cdn.Variants["ioriver"])
}
