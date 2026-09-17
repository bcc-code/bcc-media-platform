package graph

import (
	"context"
	"net/url"
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// liveTestStreamCfg is a minimal streamtoken.Config for building a proxy signer
// in tests.
type liveTestStreamCfg struct {
	secret string
	issuer string
	domain string
}

func (c liveTestStreamCfg) GetStreamJWTSecret() string   { return c.secret }
func (c liveTestStreamCfg) GetStreamJWTIssuer() string   { return c.issuer }
func (c liveTestStreamCfg) GetStreamProxyDomain() string { return c.domain }

func newLiveProxyResolver(t *testing.T) *Resolver {
	t.Helper()
	signer, err := streamtoken.NewSigner(liveTestStreamCfg{secret: "s", domain: "stream.example.com"})
	require.NoError(t, err)
	return &Resolver{StreamURLSigner: signer}
}

// TestSignLiveManifest verifies the livestream manifest is minted as a
// stream-proxy URL (jwt at the proxy host) with the manifest path preserved,
// rather than a URL at the original CDN host.
func TestSignLiveManifest(t *testing.T) {
	r := newLiveProxyResolver(t)

	livestreamURL := "https://vod2.brunstad.tv/out/v1/aaaaaa/bbbbbb/index.m3u8"
	signed, expiresAt, err := r.signLiveManifest(livestreamURL, time.Hour, r.pickLiveProvider(context.Background()))
	require.NoError(t, err)
	assert.True(t, expiresAt.After(time.Now()))

	parsed, err := url.Parse(signed)
	require.NoError(t, err)
	assert.Equal(t, "stream.example.com", parsed.Host, "must point at the proxy, not the CDN")
	assert.Equal(t, "/out/v1/aaaaaa/bbbbbb/index.m3u8", parsed.Path)
	assert.NotEmpty(t, parsed.Query().Get("jwt"))
}

// TestSignLiveManifest_AdvertisedExpiry verifies the expiry that ends up on
// Live.expiresAt: streamtoken mints the JWT for at least 7h and reports an
// expiry 20m before it, so the advertised value outlives the requested window
// while still preceding the token's own death.
func TestSignLiveManifest_AdvertisedExpiry(t *testing.T) {
	r := newLiveProxyResolver(t)

	livestreamURL := "https://vod2.brunstad.tv/out/v1/aaaaaa/bbbbbb/index.m3u8"

	now := time.Now()
	_, expiresAt, err := r.signLiveManifest(livestreamURL, livestreamURLExpiry, streamtoken.ProviderUnspecified)
	require.NoError(t, err)

	assert.True(t, expiresAt.After(now.Add(livestreamURLExpiry)),
		"advertised expiry should extend past the requested window")
	assert.True(t, expiresAt.Before(now.Add(7*time.Hour)),
		"advertised expiry must land before the token's 7h lifetime")
}

// TestSignedBufferURL verifies the buffer URL keeps the time-shift window
// appended after the proxy jwt.
func TestSignedBufferURL(t *testing.T) {
	r := newLiveProxyResolver(t)

	start := time.Unix(1513717228, 0)
	end := time.Unix(1513720828, 0)
	livestreamURL := "https://vod2.brunstad.tv/out/v1/aaaaaa/bbbbbb/index.m3u8"

	signed, err := r.signedBufferURL(livestreamURL, start, end, time.Now().Add(time.Hour), streamtoken.ProviderUnspecified)
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
		in := "https://live.example.com/out/v1/abc/def/index.m3u8?jwt=xyz"
		got := appendTimeShiftTags(in, start, nil)
		assert.Equal(t, in+"&start=1513717228", got)
	})

	t.Run("start only, appends with ? when no query present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8"
		got := appendTimeShiftTags(in, start, nil)
		assert.Equal(t, in+"?start=1513717228", got)
	})

	t.Run("start and end, appends with & when the signed query is already present", func(t *testing.T) {
		in := "https://live.example.com/out/v1/abc/def/index.m3u8?jwt=xyz"
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
