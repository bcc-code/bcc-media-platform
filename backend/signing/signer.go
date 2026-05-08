package signing

import (
	"os"
	"time"

	"github.com/ansel1/merry/v2"
	urlsigner "github.com/bcc-media/ioriver-url-signer-golang"
)

// Signer produces multi-CDN signed query strings via the ioriver signer. It is
// used by the stream-proxy to sign upstream requests to CloudFront, Fastly, and
// Akamai.
type Signer struct {
	iov *urlsigner.Signer
}

// Config supplies the keys and ids needed to sign for all three CDNs.
type Config interface {
	GetAwsSigningKeyPath() string
	GetAwsSigningKeyID() string
	GetFastlySigningKeyID() string
	GetAkamaiSigningKeyID() string
	GetAkamaiEncryptionKey() string
}

// NewSigner loads the CloudFront PEM and constructs the ioriver signer.
func NewSigner(config Config) (*Signer, error) {
	keyPath := config.GetAwsSigningKeyPath()

	pemBytes, err := os.ReadFile(keyPath)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	cfKeyID := config.GetAwsSigningKeyID()
	fsKeyID := config.GetFastlySigningKeyID()
	akKeyID := config.GetAkamaiSigningKeyID()
	// The underlying ioriver signer skips each provider when its KeyID is empty
	// and returns "" with no error if all three are empty — silently producing
	// unsigned URLs that the CDN rejects with 403. Reject this at construction.
	if cfKeyID == "" && fsKeyID == "" && akKeyID == "" {
		return nil, merry.New("signing: at least one of CloudFront, Fastly, or Akamai key id must be set")
	}

	iov, err := urlsigner.NewSigner(pemBytes, config.GetAkamaiEncryptionKey(), urlsigner.KeyInfo{
		CloudFrontKeyID: cfKeyID,
		FastlyKeyID:     fsKeyID,
		AkamaiKeyID:     akKeyID,
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}

	return &Signer{iov: iov}, nil
}

// SignRawQuery signs a multi-CDN policy via the ioriver signer and returns
// the raw query string (e.g., `FS-Policy=...&FS-Signature=...&FS-Key-Id=...`
// for Fastly, Policy/Signature/Key-Pair-Id for CloudFront, AK-Signature-* for
// Akamai). The query is in the form the CDNs validate directly.
//
// `resource` is the policy's resource pattern. Pass the exact URL (e.g.
// `https://cdn.example.com/path/file.m3u8`) for a single-file policy, or a
// wildcard pattern (`https://cdn.example.com/path/*`) to authorize a whole
// directory in one signature.
func (s Signer) SignRawQuery(resource string, duration time.Duration) (string, error) {
	return s.iov.Sign(urlsigner.Policy{
		Resources: resource,
		Condition: urlsigner.Condition{
			EndTime: time.Now().Add(duration).Unix(),
		},
	})
}
