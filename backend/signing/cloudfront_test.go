package signing

import (
	"net/url"
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
