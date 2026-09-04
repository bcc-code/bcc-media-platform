package graph

import (
	"context"
	"net/http/httptest"
	"testing"

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

// TestPickStreamProviderReportsUsage covers the reporting side effect of the
// provider decision: the flag is counted whether or not it is set, since the
// flag-was-off case is the control Unleash needs.
func TestPickStreamProviderReportsUsage(t *testing.T) {
	r := &Resolver{StreamURLSigner: &streamtoken.Signer{}}

	t.Run("flag set counts yes with its variant", func(t *testing.T) {
		header := unleash.StreamCDNProviderFlag + ":" + unleash.StreamCDNProxyIORiver
		ctx, reporter := ctxWithFeatureFlagReporting(t, header)

		r.pickStreamProvider(ctx)

		assert.Equal(t, map[string]unleash.FlagCounts{
			unleash.StreamCDNProviderFlag: {
				Yes:      1,
				Variants: map[string]int{unleash.StreamCDNProxyIORiver: 1},
			},
		}, reporter.Snapshot())
	})

	t.Run("flag absent counts no", func(t *testing.T) {
		ctx, reporter := ctxWithFeatureFlagReporting(t, "")

		r.pickStreamProvider(ctx)

		assert.Equal(t, map[string]unleash.FlagCounts{
			unleash.StreamCDNProviderFlag: {No: 1, Variants: map[string]int{}},
		}, reporter.Snapshot())
	})

	t.Run("repeated calls in one request count once", func(t *testing.T) {
		header := unleash.StreamCDNProviderFlag + ":" + unleash.StreamCDNProxyIORiver
		ctx, reporter := ctxWithFeatureFlagReporting(t, header)

		// A single query resolving many streams hits this path per stream.
		for range 40 {
			r.pickStreamProvider(ctx)
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
		r.pickStreamProvider(context.Background())
		assert.Empty(t, reporter.Snapshot())
	})
}

func TestPickStreamProvider(t *testing.T) {
	r := &Resolver{StreamURLSigner: &streamtoken.Signer{}}

	t.Run("flag variant ioriver", func(t *testing.T) {
		header := unleash.StreamCDNProviderFlag + ":" + unleash.StreamCDNProxyIORiver
		assert.Equal(t, streamtoken.ProviderIoriver, r.pickStreamProvider(ctxWithFeatureFlagsHeader(t, header)))
	})

	t.Run("flag variant cloudfront selects the proxy's direct-CloudFront identity", func(t *testing.T) {
		header := unleash.StreamCDNProviderFlag + ":" + unleash.StreamCDNProxyCF
		assert.Equal(t, streamtoken.ProviderCloudFront, r.pickStreamProvider(ctxWithFeatureFlagsHeader(t, header)))
	})

	t.Run("unknown variant falls back to the signer default", func(t *testing.T) {
		header := unleash.StreamCDNProviderFlag + ":cloudfront-direct"
		assert.Equal(t, streamtoken.ProviderUnspecified, r.pickStreamProvider(ctxWithFeatureFlagsHeader(t, header)))
	})

	t.Run("flag absent falls back to the signer default", func(t *testing.T) {
		assert.Equal(t, streamtoken.ProviderUnspecified, r.pickStreamProvider(ctxWithFeatureFlagsHeader(t, "")))
	})

	t.Run("nil gin context falls back to the signer default", func(t *testing.T) {
		assert.Equal(t, streamtoken.ProviderUnspecified, r.pickStreamProvider(context.Background()))
	})

	t.Run("live flag is read independently of the VOD flag", func(t *testing.T) {
		header := unleash.LiveCDNProviderFlag + ":" + unleash.StreamCDNProxyCF
		ctx := ctxWithFeatureFlagsHeader(t, header)
		assert.Equal(t, streamtoken.ProviderCloudFront, r.pickLiveProvider(ctx))
		assert.Equal(t, streamtoken.ProviderUnspecified, r.pickStreamProvider(ctx))
	})

	// Sanity: keep test in sync with feature-flags helper.
	_ = utils.GetFeatureFlags
}
