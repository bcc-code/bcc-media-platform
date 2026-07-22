package graph

import (
	"context"
	"net/url"
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// liveTestStreamCfg is a minimal streamtoken.Config for building a proxy signer
// in tests.
type liveTestStreamCfg struct {
	secret   string
	issuer   string
	domain   string
	provider streamtoken.Provider
}

func (c liveTestStreamCfg) GetStreamJWTSecret() string                     { return c.secret }
func (c liveTestStreamCfg) GetStreamJWTIssuer() string                     { return c.issuer }
func (c liveTestStreamCfg) GetStreamProxyDomain() string                   { return c.domain }
func (c liveTestStreamCfg) GetStreamPrimaryProvider() streamtoken.Provider { return c.provider }

func newLiveProxyResolver(t *testing.T) *Resolver {
	t.Helper()
	signer, err := streamtoken.NewSigner(liveTestStreamCfg{secret: "s", domain: "stream.example.com"})
	require.NoError(t, err)
	return &Resolver{
		StreamURLSigner:       signer,
		PrimaryStreamProvider: streamtoken.ProviderIoriver,
	}
}

// TestSignLiveManifest_ProxyPath verifies that when the primary provider selects
// the proxy, the livestream manifest is minted as a stream-proxy URL (jwt at the
// proxy host) with the manifest path preserved, rather than a CloudFront
// EncodedPolicy URL at the original host.
func TestSignLiveManifest_ProxyPath(t *testing.T) {
	r := newLiveProxyResolver(t)

	livestreamURL := "https://vod2.brunstad.tv/out/v1/aaaaaa/bbbbbb/index.m3u8"
	ls := r.resolveLiveSigning(context.Background())
	signed, expiresAt, err := r.signLiveManifestWith(ls, livestreamURL, time.Hour)
	require.NoError(t, err)
	assert.True(t, expiresAt.After(time.Now()))

	parsed, err := url.Parse(signed)
	require.NoError(t, err)
	assert.Equal(t, "stream.example.com", parsed.Host, "must point at the proxy, not the CDN")
	assert.Equal(t, "/out/v1/aaaaaa/bbbbbb/index.m3u8", parsed.Path)
	assert.NotEmpty(t, parsed.Query().Get("jwt"))
	assert.Empty(t, parsed.Query().Get("EncodedPolicy"), "proxy path must not use CloudFront EncodedPolicy")
}

// TestSignedBufferURL_ProxyPath verifies the buffer URL on the proxy path keeps
// the time-shift window appended after the proxy jwt.
func TestSignedBufferURL_ProxyPath(t *testing.T) {
	r := newLiveProxyResolver(t)

	start := time.Unix(1513717228, 0)
	end := time.Unix(1513720828, 0)
	livestreamURL := "https://vod2.brunstad.tv/out/v1/aaaaaa/bbbbbb/index.m3u8"

	signed, err := r.signedBufferURL(context.Background(), livestreamURL, start, end, time.Now().Add(time.Hour))
	require.NoError(t, err)

	parsed, err := url.Parse(signed)
	require.NoError(t, err)
	assert.Equal(t, "stream.example.com", parsed.Host)
	assert.NotEmpty(t, parsed.Query().Get("jwt"))
	assert.Equal(t, "1513717228", parsed.Query().Get("start"))
	assert.Equal(t, "1513720828", parsed.Query().Get("end"))
}

func TestAppendTimeShiftTags(t *testing.T) {
	start := time.Unix(1513717228, 0)
	end := time.Unix(1513720828, 0)

	t.Run("start only, appends with & when the signed query is already present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8?EncodedPolicy=xyz%3D"
		got := appendTimeShiftTags(in, start, nil)
		assert.Equal(t, in+"&start=1513717228", got)
	})

	t.Run("start only, appends with ? when no query present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8"
		got := appendTimeShiftTags(in, start, nil)
		assert.Equal(t, in+"?start=1513717228", got)
	})

	t.Run("start and end, appends with & when the signed query is already present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8?EncodedPolicy=xyz%3D"
		got := appendTimeShiftTags(in, start, &end)
		assert.Equal(t, in+"&start=1513717228&end=1513720828", got)
	})

	t.Run("start and end, appends start with ? and end with & when no query present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8"
		got := appendTimeShiftTags(in, start, &end)
		assert.Equal(t, in+"?start=1513717228&end=1513720828", got)
	})
}

func TestClampStart(t *testing.T) {
	now := time.Unix(1_700_000_000, 0)
	cutoff := now.Add(-maxLivestreamStartAge)

	t.Run("recent start is left untouched", func(t *testing.T) {
		start := now.Add(-30 * time.Minute)
		assert.Equal(t, start, clampStart(start, now))
	})

	t.Run("start older than the cap is clamped to the cutoff", func(t *testing.T) {
		start := now.Add(-3 * time.Hour)
		assert.Equal(t, cutoff, clampStart(start, now))
	})

	t.Run("start exactly at the cap is left untouched", func(t *testing.T) {
		assert.Equal(t, cutoff, clampStart(cutoff, now))
	})

	t.Run("future start is left untouched", func(t *testing.T) {
		start := now.Add(10 * time.Minute)
		assert.Equal(t, start, clampStart(start, now))
	})
}

func TestLivestreamExpiresAt(t *testing.T) {
	now := time.Unix(1_700_000_000, 0)

	// Legacy path (useProxy=false) keeps the Lambda@Edge from-start cap.
	t.Run("no program in progress falls back to the default expiry", func(t *testing.T) {
		assert.Equal(t, now.Add(livestreamURLExpiry), livestreamExpiresAt(nil, now, false))
	})

	t.Run("expiry is capped at 2h past the start time", func(t *testing.T) {
		start := now.Add(-30 * time.Minute)
		assert.Equal(t, start.Add(maxLivestreamURLAgeFromStart), livestreamExpiresAt(&start, now, false))
	})

	t.Run("a start at the clamp floor still yields a future expiry", func(t *testing.T) {
		// start clamped to 90m ago -> expiry 90m ago + 2h = 30m from now.
		start := now.Add(-maxLivestreamStartAge)
		assert.Equal(t, now.Add(30*time.Minute), livestreamExpiresAt(&start, now, false))
	})

	// Proxy path (useProxy=true) has no Lambda size limit, so the from-start cap
	// does not apply — the URL keeps the full livestreamURLExpiry (C).
	t.Run("proxy path is not capped from start", func(t *testing.T) {
		start := now.Add(-30 * time.Minute)
		assert.Equal(t, now.Add(livestreamURLExpiry), livestreamExpiresAt(&start, now, true))
	})

	t.Run("proxy path ignores an old start entirely", func(t *testing.T) {
		start := now.Add(-3 * time.Hour)
		assert.Equal(t, now.Add(livestreamURLExpiry), livestreamExpiresAt(&start, now, true))
	})
}

// TestCanSignLive covers the signer-availability gate (D): the proxy path is
// always serviceable, while the legacy path needs the dedicated CloudFront
// livestream signer configured.
func TestCanSignLive(t *testing.T) {
	t.Run("proxy path is available even without the legacy signer", func(t *testing.T) {
		r := &Resolver{}
		assert.True(t, r.canSignLive(liveSigning{useProxy: true}))
	})

	t.Run("legacy path without a signer is not available", func(t *testing.T) {
		r := &Resolver{}
		assert.False(t, r.canSignLive(liveSigning{useProxy: false}))
	})

	t.Run("legacy path with a signer is available", func(t *testing.T) {
		r := &Resolver{LivestreamSigner: &signing.CloudFrontSigner{}}
		assert.True(t, r.canSignLive(liveSigning{useProxy: false}))
	})
}

// TestSignedLiveURL_NoSigner verifies signedLiveURL reports "no URL" (nil result)
// without error — and without touching the database — when no signer is
// configured for the selected path, so the resolver serves the online flag only.
func TestSignedLiveURL_NoSigner(t *testing.T) {
	r := &Resolver{} // no StreamURLSigner and no LivestreamSigner
	signed, err := r.signedLiveURL(context.Background(), "https://vod2.brunstad.tv/out/v1/aaaaaa/bbbbbb/index.m3u8")
	require.NoError(t, err)
	assert.Nil(t, signed)
}
