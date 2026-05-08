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

// validate parses and verifies the token, then returns the `base` claim and
// the optional `provider` claim. provider is ProviderUnspecified when the
// claim is absent; callers fall back to the configured default in that case.
func (v *jwtValidator) validate(token string) (base string, provider streamtoken.Provider, err error) {
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
		return "", streamtoken.ProviderUnspecified, err
	}

	raw, ok := tok.Get("base")
	if !ok {
		return "", streamtoken.ProviderUnspecified, fmt.Errorf("missing base claim")
	}
	baseStr, ok := raw.(string)
	if !ok || baseStr == "" {
		return "", streamtoken.ProviderUnspecified, fmt.Errorf("base claim is not a non-empty string")
	}

	if rawProv, ok := tok.Get("provider"); ok {
		s, ok := rawProv.(string)
		if !ok {
			return "", streamtoken.ProviderUnspecified, fmt.Errorf("provider claim is not a string")
		}
		provider = streamtoken.Provider(s)
	}
	return baseStr, provider, nil
}
