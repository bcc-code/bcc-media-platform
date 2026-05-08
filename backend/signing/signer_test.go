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
