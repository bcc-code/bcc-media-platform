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
	secret          string
	issuer          string
	domain          string
	primaryProvider Provider
}

func (c fakeConfig) GetStreamJWTSecret() string         { return c.secret }
func (c fakeConfig) GetStreamJWTIssuer() string         { return c.issuer }
func (c fakeConfig) GetStreamProxyDomain() string       { return c.domain }
func (c fakeConfig) GetStreamPrimaryProvider() Provider { return c.primaryProvider }

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
	assert.Equal(t, string(DefaultPrimaryProvider), provRaw)
}

func TestSignURLUsesConfiguredPrimaryProvider(t *testing.T) {
	cfg := fakeConfig{secret: "s", domain: "proxy.example.com", primaryProvider: ProviderIoriver}
	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	signedURL, _, err := signer.SignURL("/out/v1/aaaaaa/bbbbbb/index.m3u8", time.Hour, ProviderUnspecified)
	require.NoError(t, err)

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	tokStr := parsed.Query().Get("jwt")
	tok, err := jwt.Parse([]byte(tokStr), jwt.WithKey(jwa.HS256, []byte(cfg.secret)), jwt.WithValidate(true))
	require.NoError(t, err)

	raw, ok := tok.Get("provider")
	require.True(t, ok)
	assert.Equal(t, "ioriver", raw)
}

func TestNewSignerRejectsInvalidPrimaryProvider(t *testing.T) {
	_, err := NewSigner(fakeConfig{secret: "s", domain: "proxy.example.com", primaryProvider: Provider("nope")})
	require.Error(t, err)
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

func TestSignURLRejectsUnexpectedPath(t *testing.T) {
	signer, err := NewSigner(fakeConfig{secret: "s", domain: "proxy.example.com"})
	require.NoError(t, err)

	_, _, err = signer.SignURL("/random/file.m3u8", time.Hour, ProviderUnspecified)
	require.Error(t, err)
}
