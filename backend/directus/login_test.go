package directus

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// signToken mints a Directus-shaped token. The secret is irrelevant — Login
// parses insecurely — but signing keeps the token structurally realistic.
func signToken(t *testing.T, build func(b *jwt.Builder) *jwt.Builder) string {
	t.Helper()
	b := jwt.NewBuilder().
		Issuer(issuer).
		IssuedAt(time.Now()).
		Expiration(time.Now().Add(15 * time.Minute))
	tok, err := build(b).Build()
	require.NoError(t, err)
	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, []byte("any-secret")))
	require.NoError(t, err)
	return string(signed)
}

// loginServer returns a Directus-like test server that asserts the request
// shape and responds with the given handler's body.
func loginServer(t *testing.T, wantOtp string, respond func(w http.ResponseWriter, body map[string]string)) *httptest.Server {
	t.Helper()
	return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, http.MethodPost, r.Method)
		assert.Equal(t, "/auth/login", r.URL.Path)
		assert.Equal(t, "application/json", r.Header.Get("Content-Type"))

		var body map[string]string
		require.NoError(t, json.NewDecoder(r.Body).Decode(&body))
		assert.Equal(t, "json", body["mode"])
		if wantOtp == "" {
			_, hasOtp := body["otp"]
			assert.False(t, hasOtp, "otp must be omitted when empty")
		} else {
			assert.Equal(t, wantOtp, body["otp"])
		}

		respond(w, body)
	}))
}

func TestLogin_Success(t *testing.T) {
	token := signToken(t, func(b *jwt.Builder) *jwt.Builder {
		return b.
			Claim("id", "11111111-1111-1111-1111-111111111111").
			Claim("role", "22222222-2222-2222-2222-222222222222").
			Claim("app_access", true).
			Claim("admin_access", true)
	})

	srv := loginServer(t, "", func(w http.ResponseWriter, body map[string]string) {
		assert.Equal(t, "user@example.com", body["email"])
		assert.Equal(t, "hunter2", body["password"])
		fmt.Fprintf(w, `{"data":{"access_token":%q,"expires":900000}}`, token)
	})
	defer srv.Close()

	c, err := NewClient(srv.URL)
	require.NoError(t, err)

	claims, err := c.Login(context.Background(), "user@example.com", "hunter2", "")
	require.NoError(t, err)
	assert.Equal(t, "11111111-1111-1111-1111-111111111111", claims.UserID)
	assert.Equal(t, "22222222-2222-2222-2222-222222222222", claims.Role)
	assert.True(t, claims.AppAccess)
	assert.True(t, claims.AdminAccess)
}

func TestLogin_OtpPassthrough(t *testing.T) {
	token := signToken(t, func(b *jwt.Builder) *jwt.Builder {
		return b.Claim("id", "11111111-1111-1111-1111-111111111111")
	})

	srv := loginServer(t, "123456", func(w http.ResponseWriter, _ map[string]string) {
		fmt.Fprintf(w, `{"data":{"access_token":%q}}`, token)
	})
	defer srv.Close()

	c, err := NewClient(srv.URL)
	require.NoError(t, err)

	_, err = c.Login(context.Background(), "user@example.com", "hunter2", "123456")
	require.NoError(t, err)
}

func TestLogin_InvalidCredentials(t *testing.T) {
	srv := loginServer(t, "", func(w http.ResponseWriter, _ map[string]string) {
		w.WriteHeader(http.StatusUnauthorized)
		fmt.Fprint(w, `{"errors":[{"message":"Invalid user credentials.","extensions":{"code":"INVALID_CREDENTIALS"}}]}`)
	})
	defer srv.Close()

	c, err := NewClient(srv.URL)
	require.NoError(t, err)

	_, err = c.Login(context.Background(), "user@example.com", "wrong", "")
	var loginErr *LoginError
	require.ErrorAs(t, err, &loginErr)
	assert.Equal(t, "INVALID_CREDENTIALS", loginErr.Code)
	assert.True(t, loginErr.IsCredentialError())
}

func TestLogin_ServerError(t *testing.T) {
	srv := loginServer(t, "", func(w http.ResponseWriter, _ map[string]string) {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprint(w, `boom`)
	})
	defer srv.Close()

	c, err := NewClient(srv.URL)
	require.NoError(t, err)

	_, err = c.Login(context.Background(), "user@example.com", "hunter2", "")
	require.Error(t, err)
	var loginErr *LoginError
	assert.False(t, errors.As(err, &loginErr), "non-Directus errors must not be LoginError")
}

func TestLogin_MissingUserID(t *testing.T) {
	token := signToken(t, func(b *jwt.Builder) *jwt.Builder {
		return b.Claim("app_access", true)
	})

	srv := loginServer(t, "", func(w http.ResponseWriter, _ map[string]string) {
		fmt.Fprintf(w, `{"data":{"access_token":%q}}`, token)
	})
	defer srv.Close()

	c, err := NewClient(srv.URL)
	require.NoError(t, err)

	_, err = c.Login(context.Background(), "user@example.com", "hunter2", "")
	assert.Error(t, err)
}

func TestLogin_WrongIssuer(t *testing.T) {
	token := signToken(t, func(b *jwt.Builder) *jwt.Builder {
		return b.Issuer("not-directus").Claim("id", "user")
	})

	srv := loginServer(t, "", func(w http.ResponseWriter, _ map[string]string) {
		fmt.Fprintf(w, `{"data":{"access_token":%q}}`, token)
	})
	defer srv.Close()

	c, err := NewClient(srv.URL)
	require.NoError(t, err)

	_, err = c.Login(context.Background(), "user@example.com", "hunter2", "")
	assert.Error(t, err)
}

func TestNewClient_EmptyURL(t *testing.T) {
	_, err := NewClient("")
	assert.Error(t, err)
}
