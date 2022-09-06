package auth0

import (
	"github.com/gin-gonic/gin"
	"log"
	"net/url"
	"strings"
	"time"

	"github.com/auth0/go-jwt-middleware/v2/jwks"
	"github.com/auth0/go-jwt-middleware/v2/validator"
)

// Ctx keys
const (
	CtxAuthenticated = "authenticated"
	CtxAudience      = "audience"
	CtxUserID        = "user_id"
)

// EnsureValidToken is a middleware that will check the validity of our JWT.
func (c *Client) EnsureValidToken() gin.HandlerFunc {
	config := c.config
	issuerURL, err := url.Parse("https://" + config.Domain + "/")
	if err != nil {
		log.Fatalf("Failed to parse the issuer url: %v", err)
	}

	provider := jwks.NewCachingProvider(issuerURL, 5*time.Minute)

	jwtValidator, err := validator.New(
		provider.KeyFunc,
		validator.RS256,
		issuerURL.String(),
		config.Audiences,
		validator.WithAllowedClockSkew(time.Minute),
	)
	if err != nil {
		log.Fatalf("Failed to set up the jwt validator")
	}

	return func(ctx *gin.Context) {
		authHeader := ctx.GetHeader("Authorization")
		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			ctx.Set(CtxAuthenticated, false)
			return
		}

		token, err := jwtValidator.ValidateToken(ctx, parts[1])
		if err != nil {
			ctx.JSON(401, "Invalid token")
			ctx.Abort()
			return
		}
		ctx.Set(CtxAuthenticated, true)

		claims, ok := token.(*validator.ValidatedClaims)
		if !ok {
			return
		}

		ctx.Set(CtxAudience, claims.RegisteredClaims.Audience)
		ctx.Set(CtxUserID, claims.RegisteredClaims.Subject)
	}
}
