// Package streamtoken mints HS256 JWTs that authorize stream access through
// the stream-proxy service. The proxy validates these tokens (see
// backend/cmd/stream-proxy/jwt.go) and uses the `base` claim as a path-prefix
// authorization scope.
package streamtoken

import (
	"fmt"
	"net/url"
	"regexp"
	"time"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
)

// Config supplies the secret material and target host for stream-proxy URLs.
type Config interface {
	GetStreamJWTSecret() string
	GetStreamJWTIssuer() string
	GetStreamProxyDomain() string
}

// Signer mints stream-proxy URLs with embedded HS256 JWTs.
type Signer struct {
	secret      []byte
	issuer      string
	proxyDomain string
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
	return &Signer{
		secret:      []byte(secret),
		issuer:      cfg.GetStreamJWTIssuer(),
		proxyDomain: domain,
	}, nil
}

// streamBasePathRegex matches the `/out/v1/<group1>/<group2>` prefix of a
// MediaPackage manifest path. Mirrors the pattern previously used by the
// multi-CDN signer to scope the resource to a single stream's directory.
var streamBasePathRegex = regexp.MustCompile(`(/out/v1/[a-z0-9]+/[a-z0-9]+)`)

// SignURL returns a stream-proxy URL pointing at the configured proxy domain
// with an HS256 JWT in the `jwt` query parameter. The token's `base` claim
// authorizes any path under the manifest's directory so variant playlists and
// segments resolve under the same token.
func (s *Signer) SignURL(streamPath string, ttl time.Duration) (string, time.Time, error) {
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

	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, s.secret))
	if err != nil {
		return "", time.Time{}, fmt.Errorf("sign jwt: %w", err)
	}

	u := url.URL{
		Scheme:   "https",
		Host:     s.proxyDomain,
		Path:     streamPath,
		RawQuery: "jwt=" + url.QueryEscape(string(signed)),
	}
	return u.String(), expiresAt, nil
}
