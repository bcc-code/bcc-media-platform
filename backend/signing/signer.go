package signing

import (
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"net/url"
	"regexp"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
)

// Signer capable of producing signed urls for various services
type Signer struct {
	cloudfrontSigner sign.URLSigner
}

// Config for Signer
type Config interface {
	GetAwsSigningKeyPath() string
	GetAwsSigningKeyID() string
}

// NewSigner with all secret material configured
func NewSigner(config Config) (*Signer, error) {
	// Set up urlSigner for CDN urls access
	key, err := sign.LoadPEMPrivKeyFile(config.GetAwsSigningKeyPath())
	if err != nil {
		log.L.Error().Err(err).Msg("Unable to load PEM file")
		return nil, merry.Wrap(err)
	}

	urlSigner := sign.NewURLSigner(config.GetAwsSigningKeyID(), key)

	return &Signer{
		cloudfrontSigner: *urlSigner,
	}, nil
}

// SignCloudfrontURL takes the path and the domain and returns a string with the following properties:
//   - HTTPS
//   - Unchanged path
//   - QueryParameter "EncodedPolicy" with a url encoded string representing full signature parameters,
//     needed for signed urls. The URL specified in the canned policy is truncated to the first 2 folders
//     after the /out/v1/ part
//
// For example: https://CLOUDFLARE-CDN.com/out/v1/2da6f0ab51344ff4a1048741da66d6df/1b5a8f5803a4459eb1bb430f8a79e524/2e0c61ef235f4945813fc7490745c8ff/index.m3u8?EncodedPolicy=<URL ENCODED POLICY>
func (s Signer) SignCloudfrontURL(path string, domain string, duration time.Duration) (string, error) {
	// We need to sign the directory, else other parts of the stream will not be downloadable
	// In order to do this we chop off everything after the first 4 folders

	// /alksjd/alksdjl/kajshdl/lkajdlkjw/laksjdlkas/laksjdlkajsd/index.m3u8

	re := regexp.MustCompile(`(/out/v1/[a-z0-9]+/[a-z0-9]+)`)
	pathToSign := re.FindString(path)

	// /alksjd/alksdjl/kajshdl/

	urlToSign := url.URL{
		Path:   pathToSign,
		Host:   domain,
		Scheme: "https",
	}

	// https://cdn.com/alksjd/alksdjl/kajshdl/

	// The policy needs to be valid for all sub-documents, that's why the * is added
	// If we add it as part of the path, golang will encode it and the policy will be invalid
	policy := sign.NewCannedPolicy(urlToSign.String()+"/*", time.Now().Add(duration))
	signed, err := s.cloudfrontSigner.SignWithPolicy(urlToSign.String(), policy)
	if err != nil {
		return "", err
	}

	// https://cdn.com/alksjd/alksdjl/kajshdl/?Policy=<BASE64>KeyID=lkajsdlkj

	// Extract the query string
	signedURL, err := url.Parse(signed)
	if err != nil {
		return "", err
	}

	// https://cdn.com/alksjd/alksdjl/kajshdl/?Policy=<BASE64>KeyID=lkajsdlkj

	// Add the query string as "EncodedPolicy" parameter to the original path + domain
	url := url.URL{
		RawQuery: "EncodedPolicy=" + url.QueryEscape(signedURL.RawQuery),
		Path:     path,
		Host:     domain,
		Scheme:   "https",
	}

	// https://cdn.com/alksjd/alksdjl/kajshdl/?EncodedPolicy=URLENCODE(Policy=<BASE64>KeyID=lkajsdlkj)
	return url.String(), nil
}

// SignWithPolicy is a wrapper for cloudfrontSigner.SignWithPolicy
func (s Signer) SignWithPolicy(url string, policy *sign.Policy) (string, error) {
	return s.cloudfrontSigner.SignWithPolicy(url, policy)
}
