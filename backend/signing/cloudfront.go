package signing

import (
	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/bcc-media-platform/backend/log"
)

// CloudFrontConfig supplies the CloudFront signing key path and key ID.
type CloudFrontConfig interface {
	GetAwsSigningKeyPath() string
	GetAwsSigningKeyID() string
}

// CloudFrontSigner wraps the AWS SDK CloudFront URL signer for non-stream
// downloadable file URLs (see graph/api/model/asset.go FileFrom).
type CloudFrontSigner struct {
	inner sign.URLSigner
}

// NewCloudFrontSigner loads the PEM key and constructs a CloudFront signer.
func NewCloudFrontSigner(cfg CloudFrontConfig) (*CloudFrontSigner, error) {
	key, err := sign.LoadPEMPrivKeyFile(cfg.GetAwsSigningKeyPath())
	if err != nil {
		log.L.Error().Err(err).Msg("Unable to load PEM file")
		return nil, merry.Wrap(err)
	}
	return &CloudFrontSigner{inner: *sign.NewURLSigner(cfg.GetAwsSigningKeyID(), key)}, nil
}

// SignWithPolicy signs the URL with an explicit CloudFront policy.
func (s *CloudFrontSigner) SignWithPolicy(url string, policy *sign.Policy) (string, error) {
	return s.inner.SignWithPolicy(url, policy)
}
