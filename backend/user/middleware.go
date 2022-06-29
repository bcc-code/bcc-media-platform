package user

import (
	"context"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
)

// All well-known roles
const (
	RoleAnonymous  = "anonymous"
	RoleRegistered = "registered"
	RoleBCCMember  = "bcc-member"
)

// Various hardcoded keys
const (
	CtxUser    = "ctx-user"
	CacheRoles = "roles"
)

var userCache = cache.New[string, *common.User]()
var rolesCache = cache.New[string, map[string][]string]()

func getRoles(ctx context.Context, queries *sqlc.Queries) (map[string][]string, error) {
	if roles, ok := rolesCache.Get(CacheRoles); ok {
		return roles, nil
	}
	allRoles := map[string][]string{}
	roles, err := queries.GetRoles(ctx)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	lo.ForEach(roles, func(x sqlc.GetRolesRow, _ int) { allRoles[x.Code] = x.Emails })

	rolesCache.Set(CacheRoles, allRoles, cache.WithExpiration(60*time.Minute))
	return allRoles, nil
}

// GetRolesForEmail returns all roles applicable for a specific email address.
// The roles are fetched from a local cache or if that is not available from the DB
func GetRolesForEmail(ctx context.Context, queries *sqlc.Queries, email string) ([]string, error) {

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

// NewUserMiddleware returns a gin middleware that injests a populated User struct
// into the gin context
func NewUserMiddleware(queries *sqlc.Queries) func(*gin.Context) {
	return func(ctx *gin.Context) {
		roles := []string{}

		authed := ctx.GetBool(auth0.CtxAuthenticated)

		// If the user is anonymous we just create a simple object and bail
		if !authed {
			roles = append(roles, RoleAnonymous)
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
			ctx.Set(CtxUser, u)
			return
		}

		roles = append(roles, RoleRegistered)

		if ctx.GetBool(auth0.CtxIsBCCMember) {
			roles = append(roles, RoleBCCMember)
		}

		userRoles, err := GetRolesForEmail(ctx.Request.Context(), queries, email)
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
