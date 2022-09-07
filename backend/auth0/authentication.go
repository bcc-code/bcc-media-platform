package auth0

import (
	"context"
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
	CtxPersonID      = "person_id"
	CtxIsBCCMember   = "bcc_member"
)

type appMetadata struct {
	HasMembership bool `json:"hasMembership"`
	PersonID      int  `json:"personId"`
}

type customClaims struct {
	PersonID int         `json:"https://login.bcc.no/claims/personId"`
	Metadata appMetadata `json:"https://members.bcc.no/app_metadata"`
}

// Validate to satisfy validator.CustomClaims interface
func (c customClaims) Validate(ctx context.Context) error {
	return nil
}

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
		validator.WithCustomClaims(func() validator.CustomClaims {
			return &customClaims{}
		}),
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

		custom, ok := claims.CustomClaims.(*customClaims)
		if !ok {
			return
		}

		ctx.Set(CtxPersonID, custom.PersonID)
		ctx.Set(CtxIsBCCMember, custom.Metadata.HasMembership)
	}
}
