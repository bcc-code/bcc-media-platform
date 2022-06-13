package auth0

import (
	"context"
	"net/http"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/davecgh/go-spew/spew"
	"github.com/gin-gonic/gin"
	"github.com/lestrrat-go/jwx/jwt"
	"go.opentelemetry.io/otel"
)

const (
	// CtxAnonymous indicates if the requests is anonymous or not
	CtxAnonymous = "jwt_anonymous"

	// CtxIsBCCMember indicates if the user has an active membership in BCC Norway
	// This is currently basically `!CtxAnonymous`, but may change in the future.
	// The reason for it's existance is that it can always exist and be checked more easily than
	// the presence of a PersonID for example
	CtxIsBCCMember = "jwt_is_bcc_member"

	// CtxPersonID is set if the user is not anonymous and has a BCC personId
	CtxPersonID = "jwt_person_id"

	// CtxJWTAudience is set if the person is not anonymous. It indicates what audience the
	// token was found valid for
	CtxJWTAudience = "jwt_audience"
)

// JWTConfig configures the JWT middleware
type JWTConfig struct {
	Domain    string
	Issuer    string
	Audiences []string
}

// JWT checks if there is s JWT in the Authorization header.
// If it is it will validate it, and set data in the context, or return a 403 forbidden
// If no JWT is found, TODO data in the context will be set to indicate an
// anonymous user
func JWT(ctx context.Context, config JWTConfig) gin.HandlerFunc {
	jwks := GetKeySet(ctx, config.Domain)

	return func(c *gin.Context) {
		ctx := c.Request.Context()
		ctx, span := otel.Tracer("auth0").Start(ctx, "JWT Check")
		defer span.End()

		if c.Request.Header.Get("Authorization") == "" {
			c.Set(CtxAnonymous, true)
			c.Set(CtxIsBCCMember, false)
			return
		}

		// middleware
		token, err := jwt.ParseRequest(
			c.Request,
			jwt.WithKeySet(jwks),
			jwt.WithHeaderKey("Authorization"),
		)

		if err != nil {
			c.AbortWithStatus(http.StatusForbidden)
			log.L.Debug().Err(err)
			return
		}

		valid := false
		errors := []error{}

		// Loop all allowed audiences, and collect errors
		// If none pass then print all errors for easier debugging,
		// else we can ignore the errors since we found a ok combo
		for _, audience := range config.Audiences {
			err := jwt.Validate(
				token,
				jwt.WithIssuer(config.Issuer),
				jwt.WithAudience(audience),
			)

			if err != nil {
				errors = append(errors, err)
			} else {
				valid = true
				c.Set(CtxJWTAudience, audience)
				break
			}
		}

		if !valid {
			log.L.Debug().
				Errs("Validation errors", errors).
				Msg("Validation")
			c.AbortWithStatus(http.StatusForbidden)
			return
		}

		// User is authenticated. Set the correct values and extract claims
		c.Set(CtxAnonymous, false)
		c.Set(CtxIsBCCMember, true)

		// If you want to see all possible claims use the following line:
		// spew.Dump(token.PrivateClaims())

		// For now we manually add claims that are actually useful to avoid polluting the ctx
		// with data that we don't actully need and may be considered private under GDPR
		// If posible convert the claim to a string in order to make it easier to extract it later

		if val, ok := token.Get("https://login.bcc.no/claims/personId"); ok {
			c.Set(CtxPersonID, spew.Sprintf("%.0f", val))
		}
	}
}
