package signing

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/signing/mocks"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func init() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
}

func writeTempPEM(t *testing.T) string {
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

func TestSignRawQueryWrapsAllProviders(t *testing.T) {
	keyPath := writeTempPEM(t)

	cfg := &mocks.Config{}
	cfg.On("GetAwsSigningKeyPath").Return(keyPath)
	cfg.On("GetAwsSigningKeyID").Return("CF-KEY-ID")
	cfg.On("GetFastlySigningKeyID").Return("FS-KEY-ID")
	cfg.On("GetAkamaiSigningKeyID").Return("AK-KEY-ID")
	cfg.On("GetAkamaiEncryptionKey").Return("deadbeef")

	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	resource := "https://cdn.example.com/out/v1/aaaaaa/bbbbbb/*"
	raw, err := signer.SignRawQuery(resource, time.Hour)
	require.NoError(t, err)
	require.NotEmpty(t, raw)

	q, err := url.ParseQuery(raw)
	require.NoError(t, err)

	// CloudFront, Fastly, and Akamai params must all appear in the raw query.
	assert.Equal(t, "CF-KEY-ID", q.Get("Key-Pair-Id"), "CloudFront key id expected")
	assert.Equal(t, "FS-KEY-ID", q.Get("FS-Key-Id"), "Fastly key id expected")

	hasAkamai := false
	for k := range q {
		if strings.HasPrefix(k, "AK-Signature-") {
			hasAkamai = true
			break
		}
	}
	assert.True(t, hasAkamai, "Akamai params expected")
}

// TestSignRawQueryFastlyParamsHaveNoEqualsSign guards the property that broke
// live playback: the raw query is substituted into playlists verbatim, ioriver
// forwards it to the origin unchanged, and AWS MediaPackage v2 answers
// "400 InvalidQueryStringException" to any query value containing a literal
// '='. The Fastly signer therefore has to emit unpadded base64. Resource
// lengths are varied so every base64 padding residue (0, 1 and 2 '=') is
// exercised for FS-Policy.
//
// Scoped to FS-*: the CloudFront params encode '=' as '_', while Akamai's
// AK-Signature-* values embed literal '=' by design (ip=…~exp=…~hmac=…) and
// would hit the same MediaPackage rejection if ever enabled against it.
func TestSignRawQueryFastlyParamsHaveNoEqualsSign(t *testing.T) {
	keyPath := writeTempPEM(t)

	cfg := &mocks.Config{}
	cfg.On("GetAwsSigningKeyPath").Return(keyPath)
	cfg.On("GetAwsSigningKeyID").Return("CF-KEY-ID")
	cfg.On("GetFastlySigningKeyID").Return("FS-KEY-ID")
	cfg.On("GetAkamaiSigningKeyID").Return("")
	cfg.On("GetAkamaiEncryptionKey").Return("")

	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	for _, resource := range []string{
		"https://cdn.example.com/out/v1/aaaaaa/bbbbbb/*",
		"https://cdn.example.com/out/v1/aaaaaa/bbbbbbb/*",
		"https://cdn.example.com/out/v1/aaaaaa/bbbbbbbb/*",
	} {
		t.Run(resource, func(t *testing.T) {
			raw, err := signer.SignRawQuery(resource, time.Hour)
			require.NoError(t, err)

			seen := 0
			// Deliberately not url.ParseQuery: that decodes the values, and it is
			// the raw on-the-wire form the origin rejects.
			for param := range strings.SplitSeq(raw, "&") {
				key, value, found := strings.Cut(param, "=")
				require.True(t, found, "malformed query param %q", param)
				if !strings.HasPrefix(key, "FS-") {
					continue
				}
				seen++
				assert.NotContains(t, value, "=",
					"%s must not contain '=': MediaPackage v2 rejects it with InvalidQueryStringException", key)
			}
			assert.Equal(t, 3, seen, "expected FS-Policy, FS-Signature and FS-Key-Id")
		})
	}
}

func TestNewSigner_AllKeyIDsEmpty_Errors(t *testing.T) {
	keyPath := writeTempPEM(t)

	cfg := &mocks.Config{}
	cfg.On("GetAwsSigningKeyPath").Return(keyPath)
	cfg.On("GetAwsSigningKeyID").Return("")
	cfg.On("GetFastlySigningKeyID").Return("")
	cfg.On("GetAkamaiSigningKeyID").Return("")
	cfg.On("GetAkamaiEncryptionKey").Return("")

	_, err := NewSigner(cfg)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "at least one")
}

func TestSignRawQueryCloudFrontOnly(t *testing.T) {
	keyPath := writeTempPEM(t)

	cfg := &mocks.Config{}
	cfg.On("GetAwsSigningKeyPath").Return(keyPath)
	cfg.On("GetAwsSigningKeyID").Return("CF")
	cfg.On("GetFastlySigningKeyID").Return("")
	cfg.On("GetAkamaiSigningKeyID").Return("")
	cfg.On("GetAkamaiEncryptionKey").Return("")

	signer, err := NewSigner(cfg)
	require.NoError(t, err)

	raw, err := signer.SignRawQuery("https://cdn.example.com/out/v1/aaaaaa/bbbbbb/*", time.Hour)
	require.NoError(t, err)

	q, err := url.ParseQuery(raw)
	require.NoError(t, err)
	assert.Equal(t, "CF", q.Get("Key-Pair-Id"))
	assert.Empty(t, q.Get("FS-Key-Id"))
	for k := range q {
		assert.False(t, strings.HasPrefix(k, "AK-Signature-"), "no Akamai params expected, got %s", k)
	}
}
