package signing

import (
	"net/url"
	"strings"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/bcc-media-platform/backend/signing/mocks"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestCloudFrontSignerSignWithPolicy(t *testing.T) {
	keyPath := writeTempPEM(t)

	cfg := &mocks.CloudFrontConfig{}
	cfg.On("GetAwsSigningKeyPath").Return(keyPath)
	cfg.On("GetAwsSigningKeyID").Return("CF-ID")

	signer, err := NewCloudFrontSigner(cfg)
	require.NoError(t, err)

	target := "https://files.example.com/some/file.zip"
	policy := sign.NewCannedPolicy(target, time.Now().Add(time.Hour))
	signed, err := signer.SignWithPolicy(target, policy)
	require.NoError(t, err)

	parsed, err := url.Parse(signed)
	require.NoError(t, err)
	assert.Equal(t, "files.example.com", parsed.Host)
	assert.Equal(t, "/some/file.zip", parsed.Path)
	assert.Equal(t, "CF-ID", parsed.Query().Get("Key-Pair-Id"))
	assert.NotEmpty(t, parsed.Query().Get("Signature"))
	assert.NotEmpty(t, parsed.Query().Get("Policy"))
}

func TestCloudFrontStreamSignerSignURL(t *testing.T) {
	keyPath := writeTempPEM(t)

	cfg := &mocks.CloudFrontConfig{}
	cfg.On("GetAwsSigningKeyPath").Return(keyPath)
	cfg.On("GetAwsSigningKeyID").Return("CF-ID")

	cf, err := NewCloudFrontSigner(cfg)
	require.NoError(t, err)

	signer := NewCloudFrontStreamSigner(cf, "vod2.example.com")

	streamPath := "/out/v1/aaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbbbbbbb/ccccccccccccccccccc/ddddd/index.m3u8"
	signedURL, expiresAt, err := signer.SignURL(streamPath, time.Hour, "" /* provider unused */)
	require.NoError(t, err)

	assert.WithinDuration(t, time.Now().Add(time.Hour), expiresAt, 5*time.Second)

	parsed, err := url.Parse(signedURL)
	require.NoError(t, err)
	assert.Equal(t, "https", parsed.Scheme)
	assert.Equal(t, "vod2.example.com", parsed.Host)
	assert.Equal(t, streamPath, parsed.Path, "original path must be preserved")

	encoded := parsed.Query().Get("EncodedPolicy")
	require.NotEmpty(t, encoded, "EncodedPolicy parameter must be present")

	innerQuery, err := url.ParseQuery(encoded)
	require.NoError(t, err)
	assert.Equal(t, "CF-ID", innerQuery.Get("Key-Pair-Id"))
	assert.NotEmpty(t, innerQuery.Get("Policy"))
	assert.NotEmpty(t, innerQuery.Get("Signature"))
}

func TestCloudFrontStreamSignerRejectsBadPath(t *testing.T) {
	keyPath := writeTempPEM(t)

	cfg := &mocks.CloudFrontConfig{}
	cfg.On("GetAwsSigningKeyPath").Return(keyPath)
	cfg.On("GetAwsSigningKeyID").Return("CF-ID")

	cf, err := NewCloudFrontSigner(cfg)
	require.NoError(t, err)

	signer := NewCloudFrontStreamSigner(cf, "vod2.example.com")

	_, _, err = signer.SignURL("/some/non-stream/path.m3u8", time.Hour, "" /* provider unused */)
	require.Error(t, err)
	assert.True(t, strings.Contains(err.Error(), "expected stream layout"))
}
