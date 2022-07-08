package user

import (
	"context"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
	"go.opentelemetry.io/otel"
)

// All well-known roles as used in the DB
const (
	RolePublic     = "public"
	RoleRegistered = "registered"
	RoleBCCMember  = "bcc-members"
)

// Various hardcoded keys
const (
	CtxUser      = "ctx-user"
	CacheRoles   = "roles"
	CtxLanguages = "ctx-languages"
)

var userCache = cache.New[string, *common.User]()
var rolesCache = cache.New[string, map[string][]string]()

func getRoles(ctx context.Context, queries *sqlc.Queries) (map[string][]string, error) {
	ctx, span := otel.Tracer("user").Start(ctx, "getRoles")
	defer span.End()

	if roles, ok := rolesCache.Get(CacheRoles); ok {
		span.AddEvent("from cache")
		return roles, nil
	}

	allRoles := map[string][]string{}
	roles, err := queries.GetRoles(ctx)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	lo.ForEach(roles, func(x sqlc.GetRolesRow, _ int) { allRoles[x.Code] = x.Emails })

	span.AddEvent("loaded into cache")
	rolesCache.Set(CacheRoles, allRoles, cache.WithExpiration(60*time.Minute))
	return allRoles, nil
}

// GetRolesForEmail returns all roles applicable for a specific email address.
// The roles are fetched from a local cache or if that is not available from the DB
func GetRolesForEmail(ctx context.Context, queries *sqlc.Queries, email string) ([]string, error) {
	ctx, span := otel.Tracer("user").Start(ctx, "GetRolesForEmail")
	defer span.End()
	rtnRoles := []string{}

	allRoles, err := getRoles(ctx, queries)
	if err != nil {
		return rtnRoles, merry.Wrap(err)
	}

	for k, emails := range allRoles {
		if lo.Contains(emails, email) {
			rtnRoles = append(rtnRoles, k)
		}
	}
	return rtnRoles, nil
}

// GetAcceptedLanguagesFromCtx as sent by the user
func GetAcceptedLanguagesFromCtx(ctx *gin.Context) []string {
	accLang := ctx.GetHeader("Accept-Language")
	return utils.ParseAcceptLanguage(accLang)
}

// NewUserMiddleware returns a gin middleware that injests a populated User struct
// into the gin context
func NewUserMiddleware(queries *sqlc.Queries) func(*gin.Context) {
	return func(ctx *gin.Context) {
		reqCtx, span := otel.Tracer("user/middleware").Start(ctx.Request.Context(), "run")
		defer span.End()

		roles := []string{}

		authed := ctx.GetBool(auth0.CtxAuthenticated)

		// This can't be on the user object because that is cached for too long
		ctx.Set(CtxLanguages, GetAcceptedLanguagesFromCtx(ctx))

		// If the user is anonymous we just create a simple object and bail
		if !authed {
			span.AddEvent("Anonymous")
			roles = append(roles, RolePublic)
			ctx.Set(CtxUser,
				&common.User{
					Roles:     roles,
					Anonymous: true,
					ActiveBCC: false,
				})
			return
		}

		email := ctx.GetString(auth0.CtxEmail)

		if email == "" {
			// Explicit values make it easier to see that it was intended when debugging
			email = "<MISSING>"
		}

		// We have the user in the cache
		// Return cached object
		if u, ok := userCache.Get(email); ok {
			span.AddEvent("User From Cache")
			ctx.Set(CtxUser, u)
			return
		}

		roles = append(roles, RoleRegistered)

		if ctx.GetBool(auth0.CtxIsBCCMember) {
			roles = append(roles, RoleBCCMember)
		}

		userRoles, err := GetRolesForEmail(reqCtx, queries, email)
		if err != nil {
			err = merry.Wrap(err)
			log.L.Warn().Err(err).Str("email", email).Msg("Unable to get roles")
		} else {
			roles = append(roles, userRoles...)
		}

		pid := ctx.GetString(auth0.CtxPersonID)

		u := &common.User{
			PersonID:  pid,
			Roles:     roles,
			Email:     email,
			Anonymous: false,
			ActiveBCC: ctx.GetBool(auth0.CtxIsBCCMember),
		}

		// Add the user to the cache
		span.AddEvent("User loaded into cache")
		userCache.Set(email, u, cache.WithExpiration(60*time.Minute))
		ctx.Set(CtxUser, u)
	}
}

// GetFromCtx gets the user stored in the context by the middleware
func GetFromCtx(ctx *gin.Context) *common.User {
	u, ok := ctx.Get(CtxUser)
	if !ok {
		return nil
	}

	return u.(*common.User)
}

// GetLanguagesFromCtx as provided in the request
func GetLanguagesFromCtx(ctx *gin.Context) []string {
	l, ok := ctx.Get(CtxLanguages)
	if !ok {
		return []string{}
	}

	return l.([]string)
}
