package directus

import (
	"testing"
	"time"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const testSecret = "super-secret-directus-signing-key"

func signToken(t *testing.T, secret string, build func(b *jwt.Builder) *jwt.Builder) string {
	t.Helper()
	b := jwt.NewBuilder().
		Issuer(issuer).
		IssuedAt(time.Now()).
		Expiration(time.Now().Add(15 * time.Minute))
	tok, err := build(b).Build()
	require.NoError(t, err)
	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, []byte(secret)))
	require.NoError(t, err)
	return string(signed)
}

func TestValidate_ValidToken(t *testing.T) {
	v, err := NewTokenValidator(testSecret)
	require.NoError(t, err)

	token := signToken(t, testSecret, func(b *jwt.Builder) *jwt.Builder {
		return b.
			Claim("id", "11111111-1111-1111-1111-111111111111").
			Claim("role", "22222222-2222-2222-2222-222222222222").
			Claim("app_access", true).
			Claim("admin_access", false)
	})

	claims, err := v.Validate(token)
	require.NoError(t, err)
	assert.Equal(t, "11111111-1111-1111-1111-111111111111", claims.UserID)
	assert.Equal(t, "22222222-2222-2222-2222-222222222222", claims.Role)
	assert.True(t, claims.AppAccess)
	assert.False(t, claims.AdminAccess)
}

func TestValidate_WrongSecret(t *testing.T) {
	v, err := NewTokenValidator(testSecret)
	require.NoError(t, err)

	token := signToken(t, "a-different-secret", func(b *jwt.Builder) *jwt.Builder {
		return b.Claim("id", "user").Claim("app_access", true)
	})

	_, err = v.Validate(token)
	assert.Error(t, err)
}

func TestValidate_WrongIssuer(t *testing.T) {
	v, err := NewTokenValidator(testSecret)
	require.NoError(t, err)

	token := signToken(t, testSecret, func(b *jwt.Builder) *jwt.Builder {
		return b.Issuer("not-directus").Claim("id", "user")
	})

	_, err = v.Validate(token)
	assert.Error(t, err)
}

func TestValidate_Expired(t *testing.T) {
	v, err := NewTokenValidator(testSecret)
	require.NoError(t, err)

	token := signToken(t, testSecret, func(b *jwt.Builder) *jwt.Builder {
		return b.
			IssuedAt(time.Now().Add(-time.Hour)).
			Expiration(time.Now().Add(-30 * time.Minute)).
			Claim("id", "user")
	})

	_, err = v.Validate(token)
	assert.Error(t, err)
}

func TestValidate_MissingUserID(t *testing.T) {
	v, err := NewTokenValidator(testSecret)
	require.NoError(t, err)

	token := signToken(t, testSecret, func(b *jwt.Builder) *jwt.Builder {
		return b.Claim("app_access", true)
	})

	_, err = v.Validate(token)
	assert.Error(t, err)
}

func TestNewTokenValidator_EmptySecret(t *testing.T) {
	_, err := NewTokenValidator("")
	assert.Error(t, err)
}
