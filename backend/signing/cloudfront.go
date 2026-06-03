package signing

import (
	"net/url"
	"regexp"
	"strings"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
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

// SignURLCanned signs an absolute URL with a canned policy authorizing the
// resource's parent directory (`<dir>/*`) for ttl, returning the original URL
// with the CloudFront signature embedded in a single `EncodedPolicy` query
// parameter plus the expiry time.
//
// Unlike CloudFrontStreamSigner.SignURL it makes no assumptions about the path
// layout, so it works for arbitrary configured URLs (e.g. a livestream
// manifest). Mirrors the bcc-connect-live livestream signer.
func (s *CloudFrontSigner) SignURLCanned(rawURL string, ttl time.Duration) (string, time.Time, error) {
	urlToSign, err := url.Parse(rawURL)
	if err != nil {
		return "", time.Time{}, merry.Wrap(err)
	}

	// Authorize everything in the same directory as the resource.
	parts := strings.Split(rawURL, "/")
	dir := strings.Join(parts[:len(parts)-1], "/")

	expiresAt := time.Now().Add(ttl)
	policy := sign.NewCannedPolicy(dir+"/*", expiresAt)
	signed, err := s.inner.SignWithPolicy(urlToSign.String(), policy)
	if err != nil {
		return "", time.Time{}, merry.Wrap(err)
	}

	signedURL, err := url.Parse(signed)
	if err != nil {
		return "", time.Time{}, merry.Wrap(err)
	}

	urlToSign.RawQuery = "EncodedPolicy=" + url.QueryEscape(signedURL.RawQuery)
	return urlToSign.String(), expiresAt, nil
}

// streamBasePathRegex matches the `/out/v1/<group1>/<group2>` prefix of a
// MediaPackage manifest path — the directory level the legacy CloudFront
// stream signer authorizes with a `<dir>/*` canned policy.
var streamBasePathRegex = regexp.MustCompile(`(/out/v1/[a-z0-9]+/[a-z0-9]+)`)

// CloudFrontStreamSigner mints stream URLs in the legacy CloudFront form:
// the original path is preserved and a single `EncodedPolicy=<urlencoded>`
// query parameter carries the CloudFront `Policy`/`Signature`/`Key-Pair-Id`
// triple that authorizes the manifest's parent directory.
//
// Used as the default (feature-flag-off) path; the new stream-proxy + JWT
// flow lives in backend/streamtoken.
type CloudFrontStreamSigner struct {
	cf        *CloudFrontSigner
	cdnDomain string
}

// NewCloudFrontStreamSigner pairs a CloudFrontSigner with the VOD2 CDN host
// the resulting URLs should point at.
func NewCloudFrontStreamSigner(cf *CloudFrontSigner, cdnDomain string) *CloudFrontStreamSigner {
	return &CloudFrontStreamSigner{cf: cf, cdnDomain: cdnDomain}
}

// SignURL signs the directory containing the manifest with a `<dir>/*` canned
// policy and returns the original URL with the signature embedded in
// `EncodedPolicy`. Matches the streamURLSigner interface used by
// model.StreamFrom and streamtoken.Signer. The provider argument is unused
// here — the legacy CloudFront signer has a single CDN identity.
func (s *CloudFrontStreamSigner) SignURL(streamPath string, ttl time.Duration, _ streamtoken.Provider) (string, time.Time, error) {
	pathToSign := streamBasePathRegex.FindString(streamPath)
	if pathToSign == "" {
		return "", time.Time{}, merry.New("path does not match expected stream layout: " + streamPath)
	}

	urlToSign := url.URL{
		Path:   pathToSign,
		Host:   s.cdnDomain,
		Scheme: "https",
	}

	expiresAt := time.Now().Add(ttl)

	// The `*` is added via the policy resource (not the URL path) so the AWS
	// SDK doesn't URL-encode it.
	policy := sign.NewCannedPolicy(urlToSign.String()+"/*", expiresAt)
	signed, err := s.cf.SignWithPolicy(urlToSign.String(), policy)
	if err != nil {
		return "", time.Time{}, err
	}

	signedURL, err := url.Parse(signed)
	if err != nil {
		return "", time.Time{}, err
	}

	out := url.URL{
		RawQuery: "EncodedPolicy=" + url.QueryEscape(signedURL.RawQuery),
		Path:     streamPath,
		Host:     s.cdnDomain,
		Scheme:   "https",
	}
	return out.String(), expiresAt, nil
}
