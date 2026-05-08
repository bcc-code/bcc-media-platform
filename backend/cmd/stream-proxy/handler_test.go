package main

import (
	"bytes"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/gin-gonic/gin"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func init() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
}

const handlerTestSecret = "handler-test-secret"

func writeTempStreamProxyPEM(t *testing.T) string {
	t.Helper()
	key, err := rsa.GenerateKey(rand.Reader, 2048)
	require.NoError(t, err)

	pemBytes := pem.EncodeToMemory(&pem.Block{
		Type:  "RSA PRIVATE KEY",
		Bytes: x509.MarshalPKCS1PrivateKey(key),
	})

	path := filepath.Join(t.TempDir(), "key.pem")
	require.NoError(t, os.WriteFile(path, pemBytes, 0o600))
	return path
}

// recordingTransport captures the upstream request URL the proxy emits and
// serves a canned playlist body so the handler can complete normally.
type recordingTransport struct {
	lastURL atomic.Value // string
	body    []byte
}

func (t *recordingTransport) RoundTrip(r *http.Request) (*http.Response, error) {
	t.lastURL.Store(r.URL.String())
	return &http.Response{
		StatusCode: http.StatusOK,
		Body:       io.NopCloser(bytes.NewReader(t.body)),
		Header:     make(http.Header),
		Request:    r,
	}, nil
}

func (t *recordingTransport) last() string {
	v, _ := t.lastURL.Load().(string)
	return v
}

// mintTestJWT mints a token like streamtoken.Signer would, but inline so the
// tests don't depend on the producer's host/path-validation rules. provider is
// passed through as a raw string (not streamtoken.Provider) so tests can
// exercise unknown values.
func mintTestJWT(t *testing.T, base, provider string) string {
	t.Helper()
	tok := jwt.New()
	require.NoError(t, tok.Set("base", base))
	require.NoError(t, tok.Set(jwt.ExpirationKey, time.Now().Add(time.Hour)))
	if provider != "" {
		require.NoError(t, tok.Set("provider", provider))
	}
	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, []byte(handlerTestSecret)))
	require.NoError(t, err)
	return string(signed)
}

func newTestHandler(t *testing.T) (*proxyHandler, *recordingTransport) {
	t.Helper()
	cfPEM := writeTempStreamProxyPEM(t)
	ioriverPEM := writeTempStreamProxyPEM(t)

	cfSigner, err := signing.NewSigner(cloudfrontSigningConfig{
		KeyPath: cfPEM,
		KeyID:   "CF-DIRECT-ID",
	})
	require.NoError(t, err)

	ioriverSigner, err := signing.NewSigner(ioriverSigningConfig{
		KeyPath:         ioriverPEM,
		CloudFrontKeyID: "IORIVER-CF-ID",
		FastlyKeyID:     "IORIVER-FS-ID",
	})
	require.NoError(t, err)

	validator, err := newJWTValidator(handlerTestSecret, "")
	require.NoError(t, err)

	transport := &recordingTransport{
		body: []byte("#EXTM3U\n#EXT-X-VERSION:6\n"),
	}
	httpc := &http.Client{Transport: transport}

	cfg := envConfig{
		CDNDomainCloudFront: "cf.example.com",
		CDNDomainIoriver:    "ioriver.example.com",
		DefaultProvider:     streamtoken.ProviderIoriver,
		CacheTTL:            time.Minute,
		SignTTL:             time.Hour,
	}
	return newProxyHandler(validator, cfSigner, ioriverSigner, httpc, cfg), transport
}

func runHandler(h *proxyHandler, target string) *httptest.ResponseRecorder {
	gin.SetMode(gin.TestMode)
	rec := httptest.NewRecorder()
	r := gin.New()
	r.NoRoute(h.handle)
	req := httptest.NewRequest(http.MethodGet, target, nil)
	r.ServeHTTP(rec, req)
	return rec
}

func upstreamHostFor(t *testing.T, lastURL string) string {
	t.Helper()
	parsed, err := url.Parse(lastURL)
	require.NoError(t, err)
	return parsed.Host
}

func TestHandle_ProviderClaim_CloudFront(t *testing.T) {
	h, transport := newTestHandler(t)

	base := "/out/v1/aa/bb/"
	tok := mintTestJWT(t, base, string(streamtoken.ProviderCloudFront))
	// Use the master playlist so authStringFor stays simple (no extra signing
	// against a directory wildcard that would also need recording).
	target := fmt.Sprintf("/out/v1/aa/bb/cc/index.m3u8?jwt=%s", url.QueryEscape(tok))

	rec := runHandler(h, target)
	require.Equal(t, http.StatusOK, rec.Code, "body=%s", rec.Body.String())

	last := transport.last()
	require.NotEmpty(t, last, "upstream must have been called")
	assert.Equal(t, "cf.example.com", upstreamHostFor(t, last))
	assert.Contains(t, last, "Key-Pair-Id=CF-DIRECT-ID")
	assert.NotContains(t, last, "FS-Key-Id")
}

func TestHandle_ProviderClaim_Ioriver(t *testing.T) {
	h, transport := newTestHandler(t)

	base := "/out/v1/cc/dd/"
	tok := mintTestJWT(t, base, string(streamtoken.ProviderIoriver))
	target := fmt.Sprintf("/out/v1/cc/dd/ee/index.m3u8?jwt=%s", url.QueryEscape(tok))

	rec := runHandler(h, target)
	require.Equal(t, http.StatusOK, rec.Code, "body=%s", rec.Body.String())

	last := transport.last()
	require.NotEmpty(t, last)
	assert.Equal(t, "ioriver.example.com", upstreamHostFor(t, last))
	assert.Contains(t, last, "Key-Pair-Id=IORIVER-CF-ID")
	assert.Contains(t, last, "FS-Key-Id=IORIVER-FS-ID")
}

func TestHandle_NoProviderClaim_FallsBackToDefault(t *testing.T) {
	h, transport := newTestHandler(t)
	// default in newTestHandler is streamtoken.ProviderIoriver.

	base := "/out/v1/ee/ff/"
	tok := mintTestJWT(t, base, "")
	target := fmt.Sprintf("/out/v1/ee/ff/gg/index.m3u8?jwt=%s", url.QueryEscape(tok))

	rec := runHandler(h, target)
	require.Equal(t, http.StatusOK, rec.Code, "body=%s", rec.Body.String())

	last := transport.last()
	require.NotEmpty(t, last)
	assert.Equal(t, "ioriver.example.com", upstreamHostFor(t, last))
}

func TestHandle_UnknownProvider_400(t *testing.T) {
	h, transport := newTestHandler(t)

	base := "/out/v1/gg/hh/"
	tok := mintTestJWT(t, base, "fastly-rogue")
	target := fmt.Sprintf("/out/v1/gg/hh/ii/index.m3u8?jwt=%s", url.QueryEscape(tok))

	rec := runHandler(h, target)
	assert.Equal(t, http.StatusBadRequest, rec.Code)
	assert.Contains(t, rec.Body.String(), "unknown provider")
	assert.Empty(t, transport.last(), "upstream must not have been called")
}

func TestHandle_InvalidJWT_401(t *testing.T) {
	h, transport := newTestHandler(t)

	target := "/out/v1/aa/bb/cc/index.m3u8?jwt=not-a-real-jwt"
	rec := runHandler(h, target)
	assert.Equal(t, http.StatusUnauthorized, rec.Code)
	assert.Empty(t, transport.last())
}

func TestHandle_DefaultProviderUnset_NoClaim_400(t *testing.T) {
	h, transport := newTestHandler(t)
	h.defaultProvider = streamtoken.ProviderUnspecified

	base := "/out/v1/aa/bb/"
	tok := mintTestJWT(t, base, "")
	target := fmt.Sprintf("/out/v1/aa/bb/cc/index.m3u8?jwt=%s", url.QueryEscape(tok))

	rec := runHandler(h, target)
	assert.Equal(t, http.StatusBadRequest, rec.Code)
	assert.True(t, strings.Contains(rec.Body.String(), "unknown provider"))
	assert.Empty(t, transport.last())
}
