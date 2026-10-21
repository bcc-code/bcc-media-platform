package middleware

import (
	"context"
	"net/http"
	"strings"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/idtoken"
)

// TokenValidator matches idtoken.Validate; swapped out in tests.
type TokenValidator func(ctx context.Context, token, audience string) (*idtoken.Payload, error)

// GoogleInvokerMiddleware requires a Google ID token for audience issued to serviceAccount; an empty serviceAccount leaves the routes open (local emulators).
func GoogleInvokerMiddleware(audience, serviceAccount string, validate TokenValidator) gin.HandlerFunc {
	if serviceAccount == "" {
		log.L.Warn().Msg("No invoker service account configured; worker endpoints are unauthenticated")
		return func(c *gin.Context) {}
	}
	if validate == nil {
		validate = idtoken.Validate
	}

	return func(c *gin.Context) {
		token, ok := strings.CutPrefix(c.GetHeader("Authorization"), "Bearer ")
		if !ok || token == "" {
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}

		payload, err := validate(c.Request.Context(), token, audience)
		if err != nil {
			log.L.Warn().Err(err).Str("path", c.Request.URL.Path).Msg("Rejected invoker token")
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}

		email, _ := payload.Claims["email"].(string)
		verified, _ := payload.Claims["email_verified"].(bool)
		if !verified || email != serviceAccount {
			log.L.Warn().Str("email", email).Str("path", c.Request.URL.Path).Msg("Rejected invoker identity")
			c.AbortWithStatus(http.StatusForbidden)
			return
		}
	}
}
