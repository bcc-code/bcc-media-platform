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
	return context.WithValue(req.Context(), "GinContextKey", c)
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
		got := r.pickStreamSigner(ctxWithFeatureFlagsHeader(t, ""))
		assert.Same(t, streamSigner(streamProxySigner), got)
	})

	t.Run("env=cloudfront returns CloudFront-direct signer", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderCloudFront)
		got := r.pickStreamSigner(ctxWithFeatureFlagsHeader(t, ""))
		assert.Same(t, streamSigner(cfSigner), got)
	})

	t.Run("env empty (unspecified) returns CloudFront-direct signer", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderUnspecified)
		got := r.pickStreamSigner(ctxWithFeatureFlagsHeader(t, ""))
		assert.Same(t, streamSigner(cfSigner), got)
	})

	t.Run("legacy unleash flag forces CloudFront-direct even when env=streamproxy", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderIoriver)
		header := unleash.StreamCDNProviderFlag + ":" + unleash.StreamCDNCloudfrontDirect
		got := r.pickStreamSigner(ctxWithFeatureFlagsHeader(t, header))
		assert.Same(t, streamSigner(cfSigner), got)
	})

	t.Run("nil gin context falls back to env routing", func(t *testing.T) {
		r := makeResolver(streamtoken.ProviderIoriver)
		got := r.pickStreamSigner(context.Background())
		assert.Same(t, streamSigner(streamProxySigner), got)
	})

	// Sanity: keep test in sync with feature-flags helper.
	_ = utils.GetFeatureFlags
}
