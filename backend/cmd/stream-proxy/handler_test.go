package main

import (
	"bytes"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/base64"
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
	calls   atomic.Int64
	body    []byte
}

func (t *recordingTransport) RoundTrip(r *http.Request) (*http.Response, error) {
	t.lastURL.Store(r.URL.String())
	t.calls.Add(1)
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

// mintTestJWTLive is mintTestJWT plus the `live: true` claim.
func mintTestJWTLive(t *testing.T, base, provider string) string {
	t.Helper()
	tok := jwt.New()
	require.NoError(t, tok.Set("base", base))
	require.NoError(t, tok.Set(jwt.ExpirationKey, time.Now().Add(time.Hour)))
	if provider != "" {
		require.NoError(t, tok.Set("provider", provider))
	}
	require.NoError(t, tok.Set("live", true))
	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, []byte(handlerTestSecret)))
	require.NoError(t, err)
	return string(signed)
}

func newTestHandler(t *testing.T) (*proxyHandler, *recordingTransport) {
	t.Helper()

	newSigners := func(cfID, ioCFID, ioFSID string) cdnTarget {
		cfSigner, err := signing.NewSigner(cloudfrontSigningConfig{
			KeyPath: writeTempStreamProxyPEM(t),
			KeyID:   cfID,
		})
		require.NoError(t, err)
		ioriverSigner, err := signing.NewSigner(ioriverSigningConfig{
			KeyPath:         writeTempStreamProxyPEM(t),
			CloudFrontKeyID: ioCFID,
			FastlyKeyID:     ioFSID,
		})
		require.NoError(t, err)
		return cdnTarget{cfSigner: cfSigner, ioriverSigner: ioriverSigner}
	}

	vod := newSigners("CF-DIRECT-ID", "IORIVER-CF-ID", "IORIVER-FS-ID")
	vod.cfDomain = "cf.example.com"
	vod.ioriverDomain = "ioriver.example.com"

	// Distinct live hosts + key ids so tests can assert the live claim routes to
	// the live target rather than reusing the VOD signers/hosts.
	live := newSigners("LIVE-CF-DIRECT-ID", "LIVE-IORIVER-CF-ID", "LIVE-IORIVER-FS-ID")
	live.cfDomain = "live-cf.example.com"
	live.ioriverDomain = "live.example.com"

	validator, err := newJWTValidator(handlerTestSecret, "")
	require.NoError(t, err)

	transport := &recordingTransport{
		body: []byte("#EXTM3U\n#EXT-X-VERSION:6\n"),
	}
	httpc := &http.Client{Transport: transport}

	cfg := envConfig{
		DefaultProvider: streamtoken.ProviderIoriver,
		CacheTTL:        time.Minute,
		LiveCacheTTL:    time.Minute,
		SignTTL:         time.Hour,
	}
	return newProxyHandler(validator, vod, live, httpc, cfg), transport
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

// decodeCloudFrontPolicy reverses CloudFront's URL-safe base64 substitutions
// (`-`→`+`, `_`→`=`, `~`→`/`) and base64-decodes the result.
func decodeCloudFrontPolicy(t *testing.T, policy string) string {
	t.Helper()
	std := strings.NewReplacer("-", "+", "_", "=", "~", "/").Replace(policy)
	raw, err := base64.StdEncoding.DecodeString(std)
	require.NoError(t, err, "decode CF policy %q", policy)
	return string(raw)
}

// TestHandle_VariantPlaylist_SignsJWTBaseWildcard guards the regression where
// the proxy signed the variant playlist's own directory (`<dir>/*`). MediaPackage
// VOD scatters segments across sibling directories under the asset root, so the
// signature must cover the JWT `base` prefix (`/out/v1/<g1>/<g2>/*`) — that is
// exactly the scope the JWT already authorizes.
func TestHandle_VariantPlaylist_SignsJWTBaseWildcard(t *testing.T) {
	h, transport := newTestHandler(t)

	// A minimal variant playlist with one segment URI. Content doesn't have to
	// resolve to a sibling directory for this test — we're asserting on what the
	// proxy puts in the auth string, which depends only on the JWT base and the
	// request path.
	transport.body = []byte("#EXTM3U\n#EXT-X-VERSION:6\n#EXTINF:6,\nseg1.ts\n")

	base := "/out/v1/aaaaaa/bbbbbb/"
	tok := mintTestJWT(t, base, string(streamtoken.ProviderCloudFront))
	// Request a variant playlist that lives several levels below the asset root,
	// mirroring the production layout where this bug surfaced.
	target := fmt.Sprintf(
		"/out/v1/aaaaaa/bbbbbb/cccccc/dddddd/eeeeee/index_1.m3u8?jwt=%s",
		url.QueryEscape(tok),
	)

	rec := runHandler(h, target)
	require.Equal(t, http.StatusOK, rec.Code, "body=%s", rec.Body.String())

	// Find the segment line and extract its query string (the auth blob the
	// proxy appended in place of the placeholder).
	var segQuery string
	for line := range strings.SplitSeq(rec.Body.String(), "\n") {
		line = strings.TrimRight(line, "\r")
		if strings.HasPrefix(line, "#") || line == "" {
			continue
		}
		idx := strings.Index(line, "?")
		require.GreaterOrEqual(t, idx, 0, "segment line %q has no query string", line)
		segQuery = line[idx+1:]
		break
	}
	require.NotEmpty(t, segQuery, "no segment line found in body: %q", rec.Body.String())

	values, err := url.ParseQuery(segQuery)
	require.NoError(t, err)

	require.Equal(t, "CF-DIRECT-ID", values.Get("Key-Pair-Id"))
	require.NotEmpty(t, values.Get("Signature"))

	policy := values.Get("Policy")
	require.NotEmpty(t, policy, "Policy param missing in segment query %q", segQuery)

	decoded := decodeCloudFrontPolicy(t, policy)
	assert.Contains(t, decoded,
		`"https://cf.example.com/out/v1/aaaaaa/bbbbbb/*"`,
		"policy must authorize the JWT base wildcard")
	assert.NotContains(t, decoded, "eeeeee/*",
		"policy must not be scoped to the variant playlist's directory")
}

// TestHandle_Live_ForwardsTimeShiftAndNoStore verifies the live path: the
// MediaPackage start/end params are forwarded to the upstream fetch, the
// response is marked no-store, and the master playlist's variant URIs carry the
// jwt plus the same time-shift window so the variant request comes back through
// the proxy with the window intact.
func TestHandle_Live_ForwardsTimeShiftAndNoStore(t *testing.T) {
	h, transport := newTestHandler(t)
	// A master playlist with one variant URI so we can assert on how the
	// placeholder is filled in for the index case.
	transport.body = []byte("#EXTM3U\n#EXT-X-STREAM-INF:BANDWIDTH=1\nvariant.m3u8\n")

	base := "/out/v1/aa/bb/"
	tok := mintTestJWTLive(t, base, string(streamtoken.ProviderIoriver))
	target := fmt.Sprintf("/out/v1/aa/bb/index.m3u8?jwt=%s&start=1000&end=2000", url.QueryEscape(tok))

	rec := runHandler(h, target)
	require.Equal(t, http.StatusOK, rec.Code, "body=%s", rec.Body.String())

	// Downstream caching disabled for live.
	assert.Equal(t, "no-store, max-age=0", rec.Header().Get("Cache-Control"))

	// Routed to the live ioriver target (host + key ids), not the VOD one.
	last := transport.last()
	require.NotEmpty(t, last)
	assert.Equal(t, "live.example.com", upstreamHostFor(t, last))
	assert.Contains(t, last, "Key-Pair-Id=LIVE-IORIVER-CF-ID")
	assert.Contains(t, last, "FS-Key-Id=LIVE-IORIVER-FS-ID")
	// Time-shift forwarded to the upstream fetch.
	assert.Contains(t, last, "start=1000")
	assert.Contains(t, last, "end=2000")

	// Master variant URI carries jwt + the same window back to the proxy.
	body := rec.Body.String()
	assert.Contains(t, body, "variant.m3u8?jwt=")
	assert.Contains(t, body, "start=1000")
	assert.Contains(t, body, "end=2000")
}

// TestHandle_Live_SegmentsOmitTimeShift verifies the start-over window is NOT
// appended to segment (.ts/.mp4) URIs in a live variant playlist — those get
// only the wildcard CDN signature. It also confirms an init segment (.mp4 in an
// EXT-X-MAP URI) is left free of the window.
func TestHandle_Live_SegmentsOmitTimeShift(t *testing.T) {
	h, transport := newTestHandler(t)
	transport.body = []byte("#EXTM3U\n#EXT-X-MAP:URI=\"init.mp4\"\n#EXTINF:6,\nseg1.mp4\n")

	base := "/out/v1/cc/dd/"
	tok := mintTestJWTLive(t, base, string(streamtoken.ProviderIoriver))
	// Variant playlist (not index.m3u8) so the segment/wildcard branch runs.
	target := fmt.Sprintf("/out/v1/cc/dd/ee/index_1.m3u8?jwt=%s&start=1000&end=2000", url.QueryEscape(tok))

	rec := runHandler(h, target)
	require.Equal(t, http.StatusOK, rec.Code, "body=%s", rec.Body.String())

	body := rec.Body.String()
	assert.NotContains(t, body, "start=1000", "segments must not carry the time-shift window")
	assert.NotContains(t, body, "end=2000")
	// But the upstream variant fetch still forwarded the window.
	assert.Contains(t, transport.last(), "start=1000")
}

// TestHandle_Live_CacheKeyedByWindow verifies different start-over windows are
// cached separately (each hits the upstream) while a repeat of the same window
// is served from the short-lived cache (single upstream fetch).
func TestHandle_Live_CacheKeyedByWindow(t *testing.T) {
	h, transport := newTestHandler(t)

	base := "/out/v1/cc/dd/"
	tok := mintTestJWTLive(t, base, string(streamtoken.ProviderIoriver))
	reqFor := func(start string) string {
		return fmt.Sprintf("/out/v1/cc/dd/index.m3u8?jwt=%s&start=%s", url.QueryEscape(tok), start)
	}

	require.Equal(t, http.StatusOK, runHandler(h, reqFor("1000")).Code)
	require.Equal(t, http.StatusOK, runHandler(h, reqFor("1000")).Code) // cache hit
	require.Equal(t, http.StatusOK, runHandler(h, reqFor("2000")).Code) // new window

	assert.Equal(t, int64(2), transport.calls.Load(),
		"same window should coalesce to one upstream fetch; a different window is a separate fetch")
}

// TestHandle_VOD_NoCacheControlHeader guards that the VOD path is unchanged: no
// live claim means no Cache-Control header is emitted.
func TestHandle_VOD_NoCacheControlHeader(t *testing.T) {
	h, _ := newTestHandler(t)

	base := "/out/v1/aa/bb/"
	tok := mintTestJWT(t, base, string(streamtoken.ProviderIoriver))
	target := fmt.Sprintf("/out/v1/aa/bb/index.m3u8?jwt=%s", url.QueryEscape(tok))

	rec := runHandler(h, target)
	require.Equal(t, http.StatusOK, rec.Code)
	assert.Empty(t, rec.Header().Get("Cache-Control"))
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
