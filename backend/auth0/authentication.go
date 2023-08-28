package auth0

import (
	"context"
	"net/url"
	"strconv"
	"strings"
	"time"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"

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

func validateTokenAndFillCtx(vs []*validator.Validator) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		authHeader := ctx.GetHeader("Authorization")
		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			ctx.Set(CtxAuthenticated, false)
			return
		}

		var token any
		success := false
		for _, v := range vs {
			if success {
				break
			}
			var err error
			token, err = v.ValidateToken(ctx, parts[1])
			if err == nil {
				success = true
			}
		}
		if !success {
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

		ctx.Set(CtxPersonID, strconv.Itoa(custom.PersonID))

		ctx.Set(CtxIsBCCMember, custom.Metadata.HasMembership)
	}
}

// ValidateToken is a middleware that will check the validity of our JWT.
func (c *Client) ValidateToken() gin.HandlerFunc {
	config := c.config
	issuerURL, err := url.Parse("https://" + config.Domain + "/")
	if err != nil {
		log.L.Fatal().Msgf("Failed to parse the issuer url: %v", err)
		return func(ctx *gin.Context) {
			ctx.Set(CtxAuthenticated, false)
		}
	}

	provider := jwks.NewCachingProvider(issuerURL, 5*time.Minute)

	validators := lo.Map(config.Audiences, func(audience string, _ int) *validator.Validator {
		v, err := validator.New(
			provider.KeyFunc,
			validator.RS256,
			issuerURL.String(),
			[]string{audience},
			validator.WithAllowedClockSkew(time.Minute),
			validator.WithCustomClaims(func() validator.CustomClaims {
				return &customClaims{}
			}))
		if err != nil {
			log.L.Fatal().Err(err).Msg("Failed to setup validator")
		}
		return v
	})

	if err != nil {
		log.L.Fatal().Msg("Failed to set up the jwt validator")
		return func(ctx *gin.Context) {
			ctx.Set(CtxAuthenticated, false)
		}
	}

	return validateTokenAndFillCtx(validators)
}
