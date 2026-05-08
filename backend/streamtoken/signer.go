// Package streamtoken mints HS256 JWTs that authorize stream access through
// the stream-proxy service. The proxy validates these tokens (see
// backend/cmd/stream-proxy/jwt.go) and uses the `base` claim as a path-prefix
// authorization scope.
package streamtoken

import (
	"fmt"
	"net/url"
	"regexp"
	"strings"
	"time"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
)

// Config supplies the secret material and target host for stream-proxy URLs.
type Config interface {
	GetStreamJWTSecret() string
	GetStreamJWTIssuer() string
	GetStreamProxyDomain() string
	// GetStreamPrimaryProvider is the upstream CDN baked into JWTs when the
	// caller of SignURL passes ProviderUnspecified. Returning
	// ProviderUnspecified here means "use the package default"
	// (DefaultPrimaryProvider).
	GetStreamPrimaryProvider() Provider
}

// Provider names the upstream CDN identity the stream-proxy should use to
// sign and fetch the manifest. The value is carried in the JWT's `provider`
// claim and read by the proxy.
type Provider string

const (
	// ProviderUnspecified means the JWT carries no provider claim; the proxy
	// falls back to its configured default.
	ProviderUnspecified Provider = ""
	// ProviderCloudFront routes upstream traffic directly to CloudFront,
	// signed with the CloudFront-direct key pair.
	ProviderCloudFront Provider = "cloudfront"
	// ProviderIoriver routes upstream traffic via the ioriver-issued key
	// pair, producing signatures valid for any of ioriver's sub-providers
	// (CloudFront, Fastly, Akamai). The string value matches the JWT
	// `provider` claim the stream-proxy switches on; the API exposes the
	// same routing decision under the user-facing name "streamproxy" and
	// translates to this constant at config-read time.
	ProviderIoriver Provider = "ioriver"
)

// Valid reports whether p names a known upstream identity. ProviderUnspecified
// is intentionally not valid here — callers that want to allow it must check
// for the empty value separately.
func (p Provider) Valid() bool {
	switch p {
	case ProviderCloudFront, ProviderIoriver:
		return true
	}
	return false
}

// DefaultPrimaryProvider is the provider claim baked into JWTs when neither
// the SignURL caller nor Config specifies one. CloudFront-direct is the
// safer default since its key pair is always populated in production.
const DefaultPrimaryProvider = ProviderCloudFront

// Signer mints stream-proxy URLs with embedded HS256 JWTs.
type Signer struct {
	secret          []byte
	issuer          string
	proxyScheme     string
	proxyDomain     string
	primaryProvider Provider
}

// NewSigner returns a Signer or an error if required config is missing.
func NewSigner(cfg Config) (*Signer, error) {
	secret := cfg.GetStreamJWTSecret()
	if secret == "" {
		return nil, fmt.Errorf("STREAM_JWT_SECRET is empty")
	}
	domain := cfg.GetStreamProxyDomain()
	if domain == "" {
		return nil, fmt.Errorf("STREAM_PROXY_DOMAIN is empty")
	}
	scheme, host := splitProxyScheme(domain)
	primary := cfg.GetStreamPrimaryProvider()
	if primary == ProviderUnspecified {
		primary = DefaultPrimaryProvider
	} else if !primary.Valid() {
		return nil, fmt.Errorf("STREAM_PRIMARY_PROVIDER is invalid: %q", primary)
	}
	return &Signer{
		secret:          []byte(secret),
		issuer:          cfg.GetStreamJWTIssuer(),
		proxyScheme:     scheme,
		proxyDomain:     host,
		primaryProvider: primary,
	}, nil
}

// splitProxyScheme accepts a STREAM_PROXY_DOMAIN that may carry an explicit
// "http://" or "https://" prefix and returns (scheme, host). Bare hosts
// default to https — that's the production form and avoids a silent downgrade
// if the env var is misconfigured.
func splitProxyScheme(raw string) (scheme, host string) {
	switch {
	case strings.HasPrefix(raw, "http://"):
		return "http", strings.TrimPrefix(raw, "http://")
	case strings.HasPrefix(raw, "https://"):
		return "https", strings.TrimPrefix(raw, "https://")
	}
	return "https", raw
}

// streamBasePathRegex matches the `/out/v1/<group1>/<group2>` prefix of a
// MediaPackage manifest path. Mirrors the pattern previously used by the
// multi-CDN signer to scope the resource to a single stream's directory.
var streamBasePathRegex = regexp.MustCompile(`(/out/v1/[a-z0-9]+/[a-z0-9]+)`)

// SignURL returns a stream-proxy URL pointing at the configured proxy domain
// with an HS256 JWT in the `jwt` query parameter. The token's `base` claim
// authorizes any path under the manifest's directory so variant playlists and
// segments resolve under the same token. The `provider` claim names the
// upstream CDN; when the caller passes ProviderUnspecified the Signer's
// configured primary provider is used.
func (s *Signer) SignURL(streamPath string, ttl time.Duration, provider Provider) (string, time.Time, error) {
	if provider == ProviderUnspecified {
		provider = s.primaryProvider
	}
	matched := streamBasePathRegex.FindString(streamPath)
	if matched == "" {
		return "", time.Time{}, fmt.Errorf("path does not match expected stream layout: %s", streamPath)
	}
	base := matched + "/"

	expiresAt := time.Now().Add(ttl)

	tok := jwt.New()
	if err := tok.Set("base", base); err != nil {
		return "", time.Time{}, fmt.Errorf("set base claim: %w", err)
	}
	if err := tok.Set(jwt.ExpirationKey, expiresAt); err != nil {
		return "", time.Time{}, fmt.Errorf("set exp claim: %w", err)
	}
	if s.issuer != "" {
		if err := tok.Set(jwt.IssuerKey, s.issuer); err != nil {
			return "", time.Time{}, fmt.Errorf("set iss claim: %w", err)
		}
	}
	if provider != ProviderUnspecified {
		if err := tok.Set("provider", string(provider)); err != nil {
			return "", time.Time{}, fmt.Errorf("set provider claim: %w", err)
		}
	}

	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, s.secret))
	if err != nil {
		return "", time.Time{}, fmt.Errorf("sign jwt: %w", err)
	}

	u := url.URL{
		Scheme:   s.proxyScheme,
		Host:     s.proxyDomain,
		Path:     streamPath,
		RawQuery: "jwt=" + url.QueryEscape(string(signed)),
	}
	return u.String(), expiresAt, nil
}
