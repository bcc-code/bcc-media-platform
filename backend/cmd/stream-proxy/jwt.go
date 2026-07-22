package main

import (
	"fmt"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
)

// jwtValidator verifies HS256 tokens against a shared secret and extracts the
// `base` path-prefix claim that authorizes a request.
type jwtValidator struct {
	secret []byte
	issuer string
}

func newJWTValidator(secret, issuer string) (*jwtValidator, error) {
	if secret == "" {
		return nil, fmt.Errorf("jwt secret is empty")
	}
	return &jwtValidator{
		secret: []byte(secret),
		issuer: issuer,
	}, nil
}

// claims are the authorization details carried by a validated stream token.
type claims struct {
	// base is the path-prefix the token authorizes.
	base string
	// provider names the upstream CDN; ProviderUnspecified when the claim is
	// absent, in which case callers fall back to the configured default.
	provider streamtoken.Provider
	// live is true for livestream tokens, which the handler serves with a short
	// cache TTL, time-shift forwarding, and no-store — false for VOD.
	live bool
}

// validate parses and verifies the token, then returns its claims.
func (v *jwtValidator) validate(token string) (claims, error) {
	opts := []jwt.ParseOption{
		jwt.WithKey(jwa.HS256, v.secret),
		jwt.WithValidate(true),
		jwt.WithAcceptableSkew(time.Minute),
	}

	if v.issuer != "" {
		opts = append(opts, jwt.WithIssuer(v.issuer))
	}

	tok, err := jwt.Parse([]byte(token), opts...)
	if err != nil {
		return claims{}, err
	}

	raw, ok := tok.Get("base")
	if !ok {
		return claims{}, fmt.Errorf("missing base claim")
	}
	baseStr, ok := raw.(string)
	if !ok || baseStr == "" {
		return claims{}, fmt.Errorf("base claim is not a non-empty string")
	}

	out := claims{base: baseStr}

	if rawProv, ok := tok.Get("provider"); ok {
		s, ok := rawProv.(string)
		if !ok {
			return claims{}, fmt.Errorf("provider claim is not a string")
		}
		out.provider = streamtoken.Provider(s)
	}

	if rawLive, ok := tok.Get("live"); ok {
		b, ok := rawLive.(bool)
		if !ok {
			return claims{}, fmt.Errorf("live claim is not a bool")
		}
		out.live = b
	}

	return out, nil
}
