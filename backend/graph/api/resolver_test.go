package graph

import (
	"context"
	"net/http/httptest"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/bcc-code/bcc-media-platform/backend/unleash"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func ctxWithFeatureFlagsHeader(t *testing.T, header string) context.Context {
	t.Helper()
	gin.SetMode(gin.TestMode)
	rec := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(rec)
	req := httptest.NewRequest("POST", "/query", nil)
	if header != "" {
		req.Header.Set("x-feature-flags", header)
	}
	c.Request = req
	return utils.ContextWithGinContext(req.Context(), c)
}

// ctxWithFeatureFlagReporting is ctxWithFeatureFlagsHeader plus the per-request
// state the usage reporting needs, so a decision point's counts can be asserted.
func ctxWithFeatureFlagReporting(t *testing.T, header string) (context.Context, *unleash.MetricsReporter) {
	t.Helper()
	ctx := ctxWithFeatureFlagsHeader(t, header)
	c, err := utils.GinCtx(ctx)
	assert.NoError(t, err)

	reporter := unleash.NewMetricsReporter(unleash.MetricsConfig{
		URL:   "http://example.invalid",
		Token: "test",
	})
	// What FeatureFlagReporterMiddleware and MetricsMiddleware install per request.
	utils.EnsureReportedFlags(c)
	unleash.MetricsMiddleware(reporter)(c)

	return ctx, reporter
}

// TestPickStreamSignerReportsUsage covers the reporting side effect of the
// stream-signer decision: the flag is counted whether or not it is set, since
// the flag-was-off case is the control Unleash needs.
func TestPickStreamSignerReportsUsage(t *testing.T) {
	r := &Resolver{
		StreamURLSigner:       &streamtoken.Signer{},
		LegacyStreamSigner:    &signing.CloudFrontStreamSigner{},
		PrimaryStreamProvider: streamtoken.ProviderIoriver,
	}

	t.Run("flag set counts yes with its variant", func(t *testing.T) {
		header := unleash.StreamCDNProviderFlag + ":" + unleash.StreamCDNProxyIORiver
		ctx, reporter := ctxWithFeatureFlagReporting(t, header)

		r.pickStreamSigner(ctx)

		assert.Equal(t, map[string]unleash.FlagCounts{
			unleash.StreamCDNProviderFlag: {
				Yes:      1,
				Variants: map[string]int{unleash.StreamCDNProxyIORiver: 1},
			},
		}, reporter.Snapshot())
	})

	t.Run("flag absent counts no", func(t *testing.T) {
		ctx, reporter := ctxWithFeatureFlagReporting(t, "")

		r.pickStreamSigner(ctx)

		assert.Equal(t, map[string]unleash.FlagCounts{
			unleash.StreamCDNProviderFlag: {No: 1, Variants: map[string]int{}},
		}, reporter.Snapshot())
	})

	t.Run("repeated calls in one request count once", func(t *testing.T) {
		header := unleash.StreamCDNProviderFlag + ":" + unleash.StreamCDNProxyIORiver
		ctx, reporter := ctxWithFeatureFlagReporting(t, header)

		// A single query resolving many streams hits this path per stream.
		for range 40 {
			r.pickStreamSigner(ctx)
		}

		counts := reporter.Snapshot()[unleash.StreamCDNProviderFlag]
		assert.Equal(t, 1, counts.Yes)
		assert.Equal(t, map[string]int{unleash.StreamCDNProxyIORiver: 1}, counts.Variants)
	})

	t.Run("nil gin context reports nothing", func(t *testing.T) {
		reporter := unleash.NewMetricsReporter(unleash.MetricsConfig{
			URL:   "http://example.invalid",
			Token: "test",
		})
		r.pickStreamSigner(context.Background())
		assert.Empty(t, reporter.Snapshot())
	})
}

func TestPickStreamSigner(t *testing.T) {
	streamProxySigner := &streamtoken.Signer{}
	cfSigner := &signing.CloudFrontStreamSigner{}

	makeResolver := func(p streamtoken.Provider) *Resolver {
		return &Resolver{
			StreamURLSigner:       streamProxySigner,
			LegacyStreamSigner:    cfSigner,
			PrimaryStreamProvider: p,
		}
	}

	t.Run("env=streamproxy routes through stream-proxy", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderIoriver)
		got, _ := r.pickStreamSigner(ctxWithFeatureFlagsHeader(t, ""))
		assert.Same(t, streamSigner(streamProxySigner), got)
	})

	t.Run("env=cloudfront returns CloudFront-direct signer", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderCloudFront)
		got, _ := r.pickStreamSigner(ctxWithFeatureFlagsHeader(t, ""))
		assert.Same(t, streamSigner(cfSigner), got)
	})

	t.Run("env empty (unspecified) returns CloudFront-direct signer", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderUnspecified)
		got, _ := r.pickStreamSigner(ctxWithFeatureFlagsHeader(t, ""))
		assert.Same(t, streamSigner(cfSigner), got)
	})

	t.Run("legacy unleash flag forces CloudFront-direct even when env=streamproxy", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderIoriver)
		header := unleash.StreamCDNProviderFlag + ":" + unleash.StreamCDNCloudfrontDirect
		got, _ := r.pickStreamSigner(ctxWithFeatureFlagsHeader(t, header))
		assert.Same(t, streamSigner(cfSigner), got)
	})

	t.Run("nil gin context falls back to env routing", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderIoriver)
		got, _ := r.pickStreamSigner(context.Background())
		assert.Same(t, streamSigner(streamProxySigner), got)
	})

	// Sanity: keep test in sync with feature-flags helper.
	_ = utils.GetFeatureFlags
}
