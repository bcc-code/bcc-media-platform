package middleware

import (
	"context"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"google.golang.org/api/idtoken"
)

const (
	testAudience = "https://worker.example.run.app"
	testInvoker  = "worker-invoker@project.iam.gserviceaccount.com"
)

func fakeValidator(claims map[string]any) TokenValidator {
	return func(_ context.Context, token, audience string) (*idtoken.Payload, error) {
		if token != "good" || audience != testAudience {
			return nil, errors.New("invalid token")
		}
		return &idtoken.Payload{Audience: audience, Claims: claims}, nil
	}
}

func invoke(t *testing.T, mw gin.HandlerFunc, authHeader string) int {
	t.Helper()
	gin.SetMode(gin.TestMode)
	r := gin.New()
	r.POST("/api/message", mw, func(c *gin.Context) { c.Status(http.StatusOK) })
	req := httptest.NewRequest(http.MethodPost, "/api/message", nil)
	if authHeader != "" {
		req.Header.Set("Authorization", authHeader)
	}
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)
	return w.Code
}

func TestGoogleInvokerMiddleware(t *testing.T) {
	valid := fakeValidator(map[string]any{"email": testInvoker, "email_verified": true})

	t.Run("open when no service account is configured", func(t *testing.T) {
		assert.Equal(t, http.StatusOK, invoke(t, GoogleInvokerMiddleware(testAudience, "", valid), ""))
	})

	mw := GoogleInvokerMiddleware(testAudience, testInvoker, valid)

	t.Run("rejects a missing token", func(t *testing.T) {
		assert.Equal(t, http.StatusUnauthorized, invoke(t, mw, ""))
	})

	t.Run("rejects a non-bearer header", func(t *testing.T) {
		assert.Equal(t, http.StatusUnauthorized, invoke(t, mw, "Basic good"))
	})

	t.Run("rejects an invalid token", func(t *testing.T) {
		assert.Equal(t, http.StatusUnauthorized, invoke(t, mw, "Bearer forged"))
	})

	t.Run("rejects the wrong audience", func(t *testing.T) {
		other := GoogleInvokerMiddleware("https://other.example", testInvoker, valid)
		assert.Equal(t, http.StatusUnauthorized, invoke(t, other, "Bearer good"))
	})

	t.Run("rejects another service account", func(t *testing.T) {
		v := fakeValidator(map[string]any{"email": "attacker@evil.iam.gserviceaccount.com", "email_verified": true})
		assert.Equal(t, http.StatusForbidden, invoke(t, GoogleInvokerMiddleware(testAudience, testInvoker, v), "Bearer good"))
	})

	t.Run("rejects an unverified email", func(t *testing.T) {
		v := fakeValidator(map[string]any{"email": testInvoker, "email_verified": false})
		assert.Equal(t, http.StatusForbidden, invoke(t, GoogleInvokerMiddleware(testAudience, testInvoker, v), "Bearer good"))
	})

	t.Run("accepts the invoker", func(t *testing.T) {
		assert.Equal(t, http.StatusOK, invoke(t, mw, "Bearer good"))
	})
}
