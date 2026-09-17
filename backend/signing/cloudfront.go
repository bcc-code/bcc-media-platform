package signing

import (
	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
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
	keyPath := cfg.GetAwsSigningKeyPath()
	if keyPath == "" {
		return nil, merry.New("CloudFront signing key path is empty (set CF_SIGNING_KEY_PATH)")
	}
	if cfg.GetAwsSigningKeyID() == "" {
		return nil, merry.New("CloudFront signing key id is empty (set CF_SIGNING_KEY_ID)")
	}
	key, err := sign.LoadPEMPrivKeyFile(keyPath)
	if err != nil {
		return nil, merry.Wrap(err, merry.WithMessagef("load CloudFront signing key from %q", keyPath))
	}
	return &CloudFrontSigner{inner: *sign.NewURLSigner(cfg.GetAwsSigningKeyID(), key)}, nil
}

// SignWithPolicy signs the URL with an explicit CloudFront policy.
func (s *CloudFrontSigner) SignWithPolicy(url string, policy *sign.Policy) (string, error) {
	return s.inner.SignWithPolicy(url, policy)
}
