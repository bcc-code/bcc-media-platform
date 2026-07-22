// Package directus provides helpers for integrating with the Directus instance
// that backs the platform, including validation of the access tokens Directus
// issues from its `/auth/login` and `/auth/refresh` endpoints.
package directus

import (
	"fmt"
	"time"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
)

// issuer is the value Directus sets in the `iss` claim of the JWTs it signs.
const issuer = "directus"

// Claims holds the subset of the Directus access-token payload we care about.
type Claims struct {
	// UserID is the Directus user id (`id` claim), a UUID string.
	UserID string
	// Role is the Directus role id (`role` claim), a UUID string. May be empty.
	Role string
	// AppAccess reports whether the user is allowed to use the Directus app.
	AppAccess bool
	// AdminAccess reports whether the user has Directus admin privileges.
	AdminAccess bool
}

// TokenValidator verifies Directus-issued access tokens. Directus signs these
// as HS256 JWTs using its `SECRET` environment variable, so the same secret
// must be provided here.
type TokenValidator struct {
	secret []byte
}

// NewTokenValidator returns a validator for Directus access tokens signed with
// the given secret (the Directus `SECRET` value).
func NewTokenValidator(secret string) (*TokenValidator, error) {
	if secret == "" {
		return nil, fmt.Errorf("directus jwt secret is empty")
	}
	return &TokenValidator{secret: []byte(secret)}, nil
}

// Validate parses and verifies a Directus access token, returning the claims we
// use for authorization. It checks the HS256 signature, the `directus` issuer
// and the expiry (with a small clock skew allowance).
func (v *TokenValidator) Validate(token string) (*Claims, error) {
	tok, err := jwt.Parse([]byte(token),
		jwt.WithKey(jwa.HS256, v.secret),
		jwt.WithValidate(true),
		jwt.WithIssuer(issuer),
		jwt.WithAcceptableSkew(time.Minute),
	)
	if err != nil {
		return nil, err
	}

	raw, ok := tok.Get("id")
	userID, _ := raw.(string)
	if !ok || userID == "" {
		return nil, fmt.Errorf("token is missing the user id claim")
	}

	claims := &Claims{
		UserID:      userID,
		AppAccess:   boolClaim(tok, "app_access"),
		AdminAccess: boolClaim(tok, "admin_access"),
	}

	if raw, ok := tok.Get("role"); ok {
		if s, ok := raw.(string); ok {
			claims.Role = s
		}
	}

	return claims, nil
}

// boolClaim reads a boolean claim, defaulting to false when it is absent or not
// a boolean.
func boolClaim(tok jwt.Token, key string) bool {
	raw, ok := tok.Get(key)
	if !ok {
		return false
	}
	val, _ := raw.(bool)
	return val
}
