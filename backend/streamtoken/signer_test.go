package streamtoken

import (
	"net/url"
	"testing"
	"time"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type fakeConfig struct {
	secret string
	issuer string
	domain string
}

func (c fakeConfig) GetStreamJWTSecret() string   { return c.secret }
func (c fakeConfig) GetStreamJWTIssuer() string   { return c.issuer }
func (c fakeConfig) GetStreamProxyDomain() string { return c.domain }

func TestNewSignerRequiresSecretAndDomain(t *testing.T) {
	_, err := NewSigner(fakeConfig{secret: "", domain: "proxy.example.com"})
	require.Error(t, err)

	_, err = NewSigner(fakeConfig{secret: "s", domain: ""})
	require.Error(t, err)

	_, err = NewSigner(fakeConfig{secret: "s", domain: "proxy.example.com"})
	require.NoError(t, err)
}

func TestSignURLRoundTrip(t *testing.T) {
	cfg := fakeConfig{
		secret: "topsecret",
		issuer: "https://api.example.com/",
		domain: "proxy.example.com",
	}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	streamPath := "/out/v1/2da6f0ab51344ff4a1048741da66d6df/1b5a8f5803a4459eb1bb430f8a79e524/2e0c61ef235f4945813fc7490745c8ff/index.m3u8"
	signedURL, expiresAt, err := signer.SignURL(streamPath, 6*time.Hour, ProviderUnspecified)
	require.NoError(t, err)

	assert.True(t, expiresAt.After(time.Now()))

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	assert.Equal(t, "https", parsed.Scheme)
	assert.Equal(t, "proxy.example.com", parsed.Host)
	assert.Equal(t, streamPath, parsed.Path)

	tokStr := parsed.Query().Get("jwt")
	require.NotEmpty(t, tokStr, "jwt query param must be present")

	// Validate using the same machinery the stream-proxy uses
	// (backend/cmd/stream-proxy/jwt.go).
	tok, err := jwt.Parse(
		[]byte(tokStr),
		jwt.WithKey(jwa.HS256, []byte(cfg.secret)),
		jwt.WithValidate(true),
		jwt.WithAcceptableSkew(time.Minute),
		jwt.WithIssuer(cfg.issuer),
	)
	require.NoError(t, err)

	raw, ok := tok.Get("base")
	require.True(t, ok, "base claim must be present")
	baseStr, ok := raw.(string)
	require.True(t, ok, "base claim must be a string")
	assert.Equal(t, "/out/v1/2da6f0ab51344ff4a1048741da66d6df/1b5a8f5803a4459eb1bb430f8a79e524/", baseStr)

	provRaw, ok := tok.Get("provider")
	require.True(t, ok, "provider claim must be present (default primary provider)")
	assert.Equal(t, "ioriver", provRaw)
}

func TestSignURLHyphenatedChannelPath(t *testing.T) {
	cfg := fakeConfig{secret: "topsecret", domain: "proxy.example.com"}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	streamPath := "/out/v1/some-channel/live/cloudfront/index.m3u8"
	signedURL, _, err := signer.SignURL(streamPath, time.Hour, ProviderUnspecified)
	require.NoError(t, err)

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	assert.Equal(t, streamPath, parsed.Path)

	tokStr := parsed.Query().Get("jwt")
	tok, err := jwt.Parse([]byte(tokStr), jwt.WithKey(jwa.HS256, []byte(cfg.secret)), jwt.WithValidate(true))
	require.NoError(t, err)

	raw, ok := tok.Get("base")
	require.True(t, ok, "base claim must be present")
	assert.Equal(t, "/out/v1/some-channel/live/", raw)
}

func TestSignURLSetsProviderClaim(t *testing.T) {
	cfg := fakeConfig{secret: "topsecret", domain: "proxy.example.com"}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	streamPath := "/out/v1/aaaaaa/bbbbbb/index.m3u8"
	signedURL, _, err := signer.SignURL(streamPath, time.Hour, ProviderCloudFront)
	require.NoError(t, err)

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	tokStr := parsed.Query().Get("jwt")
	require.NotEmpty(t, tokStr)

	tok, err := jwt.Parse(
		[]byte(tokStr),
		jwt.WithKey(jwa.HS256, []byte(cfg.secret)),
		jwt.WithValidate(true),
	)
	require.NoError(t, err)

	raw, ok := tok.Get("provider")
	require.True(t, ok, "provider claim must be present")
	assert.Equal(t, "cloudfront", raw)
}

func TestSignLiveURLSetsLiveClaim(t *testing.T) {
	cfg := fakeConfig{secret: "topsecret", domain: "proxy.example.com"}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	streamPath := "/out/v1/aaaaaa/bbbbbb/index.m3u8"
	signedURL, _, err := signer.SignLiveURL(streamPath, time.Hour, ProviderIoriver)
	require.NoError(t, err)

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	tokStr := parsed.Query().Get("jwt")
	require.NotEmpty(t, tokStr)

	tok, err := jwt.Parse(
		[]byte(tokStr),
		jwt.WithKey(jwa.HS256, []byte(cfg.secret)),
		jwt.WithValidate(true),
	)
	require.NoError(t, err)

	raw, ok := tok.Get("live")
	require.True(t, ok, "live claim must be present")
	assert.Equal(t, true, raw)

	prov, ok := tok.Get("provider")
	require.True(t, ok)
	assert.Equal(t, "ioriver", prov)
}

func TestSignURLOmitsLiveClaim(t *testing.T) {
	cfg := fakeConfig{secret: "topsecret", domain: "proxy.example.com"}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	signedURL, _, err := signer.SignURL("/out/v1/aaaaaa/bbbbbb/index.m3u8", time.Hour, ProviderUnspecified)
	require.NoError(t, err)

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	tok, err := jwt.Parse([]byte(parsed.Query().Get("jwt")), jwt.WithKey(jwa.HS256, []byte(cfg.secret)), jwt.WithValidate(true))
	require.NoError(t, err)

	_, ok := tok.Get("live")
	assert.False(t, ok, "VOD tokens must not carry a live claim")
}

func TestSignURLOmitsIssuerWhenUnset(t *testing.T) {
	cfg := fakeConfig{secret: "topsecret", domain: "proxy.example.com"}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	signedURL, _, err := signer.SignURL("/out/v1/aaaaaa/bbbbbb/index.m3u8", time.Hour, ProviderUnspecified)
	require.NoError(t, err)

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	tokStr := parsed.Query().Get("jwt")
	require.NotEmpty(t, tokStr)

	tok, err := jwt.Parse(
		[]byte(tokStr),
		jwt.WithKey(jwa.HS256, []byte(cfg.secret)),
		jwt.WithValidate(true),
	)
	require.NoError(t, err)

	assert.Empty(t, tok.Issuer(), "iss should be unset when not configured")
}

// The live token is minted for max(liveTokenMinTTL, ttl+liveTokenHeadroom) and
// the expiry handed back to the caller is liveTokenGrace earlier than the `exp`
// claim, so a client refreshing on the advertised schedule always still holds a
// working token.
func TestSignLiveURLExtendsTokenBeyondAdvertisedExpiry(t *testing.T) {
	cfg := fakeConfig{secret: "topsecret", domain: "proxy.example.com"}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	tests := []struct {
		name    string
		ttl     time.Duration
		wantExp time.Duration
	}{
		{"headroom on top of the live path's 6h", 6 * time.Hour, 7 * time.Hour},
		{"headroom wins for long windows", 10 * time.Hour, 11 * time.Hour},
		{"floor wins for short windows", 30 * time.Minute, 7 * time.Hour},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			now := time.Now()
			signedURL, expiresAt, err := signer.SignLiveURL("/out/v1/aaaaaa/bbbbbb/index.m3u8", tt.ttl, ProviderUnspecified)
			require.NoError(t, err)

			parsed, err := url.Parse(signedURL)
			require.NoError(t, err)
			tok, err := jwt.Parse([]byte(parsed.Query().Get("jwt")), jwt.WithKey(jwa.HS256, []byte(cfg.secret)), jwt.WithValidate(true))
			require.NoError(t, err)

			// exp is a NumericDate, so it is truncated to whole seconds.
			assert.WithinDuration(t, now.Add(tt.wantExp), tok.Expiration(), 2*time.Second)
			assert.WithinDuration(t, tok.Expiration().Add(-liveTokenGrace), expiresAt, 2*time.Second)
			assert.True(t, expiresAt.Before(tok.Expiration()), "advertised expiry must precede the token's exp")
		})
	}
}

// VOD tokens keep expiring exactly when the caller asked; only the live path
// carries the floor/headroom/grace behaviour.
func TestSignURLExpiryIsUnchanged(t *testing.T) {
	cfg := fakeConfig{secret: "topsecret", domain: "proxy.example.com"}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	now := time.Now()
	signedURL, expiresAt, err := signer.SignURL("/out/v1/aaaaaa/bbbbbb/index.m3u8", 6*time.Hour, ProviderUnspecified)
	require.NoError(t, err)

	assert.WithinDuration(t, now.Add(6*time.Hour), expiresAt, 2*time.Second)

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	tok, err := jwt.Parse([]byte(parsed.Query().Get("jwt")), jwt.WithKey(jwa.HS256, []byte(cfg.secret)), jwt.WithValidate(true))
	require.NoError(t, err)
	assert.WithinDuration(t, expiresAt, tok.Expiration(), 2*time.Second)
}

func TestSignURLRejectsUnexpectedPath(t *testing.T) {
	signer, err := NewSigner(fakeConfig{secret: "s", domain: "proxy.example.com"})
	require.NoError(t, err)

	_, _, err = signer.SignURL("/random/file.m3u8", time.Hour, ProviderUnspecified)
	require.Error(t, err)
}
