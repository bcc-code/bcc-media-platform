package main

import (
	"fmt"
	"time"

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

// validate parses and verifies the token, then returns the `base` claim.
func (v *jwtValidator) validate(token string) (base string, err error) {
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
		return "", err
	}

	raw, ok := tok.Get("base")
	if !ok {
		return "", fmt.Errorf("missing base claim")
	}
	s, ok := raw.(string)
	if !ok || s == "" {
		return "", fmt.Errorf("base claim is not a non-empty string")
	}
	return s, nil
}
