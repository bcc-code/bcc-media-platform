package user

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/members"
	"github.com/google/uuid"
	"strconv"
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
	CtxProfiles  = "ctx-profiles"
	CtxProfile   = "ctx-profile"
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

// NewUserMiddleware returns a gin middleware that ingests a populated User struct
// into the gin context
func NewUserMiddleware(queries *sqlc.Queries, members *members.Client) func(*gin.Context) {
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

		userID := ctx.GetString(auth0.CtxUserID)

		if u, ok := userCache.Get(userID); ok {
			span.AddEvent("User From Cache")
			ctx.Set(CtxUser, u)
			return
		}

		pid := ctx.GetString(auth0.CtxPersonID)
		intID, _ := strconv.ParseInt(pid, 10, 32)

		member, err := members.Lookup(ctx, int(intID))
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to retrieve user")
		}

		email := member.Email

		if email == "" {
			// Explicit values make it easier to see that it was intended when debugging
			email = "<MISSING>"
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

		u := &common.User{
			PersonID:    pid,
			DisplayName: member.DisplayName,
			Roles:       roles,
			Email:       email,
			Anonymous:   false,
			ActiveBCC:   ctx.GetBool(auth0.CtxIsBCCMember),
		}

		// Add the user to the cache
		span.AddEvent("User loaded into cache")
		userCache.Set(userID, u, cache.WithExpiration(60*time.Minute))
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

// NewProfileMiddleware prefills context with a profileID
func NewProfileMiddleware(queries *sqlc.Queries, loaders *common.BatchLoaders) func(*gin.Context) {
	return func(ctx *gin.Context) {
		u := GetFromCtx(ctx)

		if u.PersonID == "" {
			return
		}
		profiles, err := common.GetFromLoaderForKey(ctx, loaders.ProfilesLoader, u.PersonID)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to retrieve profiles from loader")
			return
		}
		profileID := ctx.GetHeader("x-profile")
		profile, found := lo.Find(profiles, func(p *common.Profile) bool {
			return p.ID.String() == profileID || p.Name == profileID
		})
		if !found {
			if len(profiles) == 0 {
				profile = &common.Profile{
					ID:     uuid.New(),
					Name:   u.DisplayName,
					UserID: u.PersonID,
				}
				profiles = append(profiles, profile)
				loaders.ProfilesLoader.Prime(ctx, u.PersonID, profiles)
				err = queries.SaveProfile(ctx, *profile)
				if err != nil {
					log.L.Error().Err(err).Msg("Error occurred trying to save new profile")
				}
			} else {
				profile = profiles[0]
			}
		}

		ctx.Set(CtxProfiles, profiles)
		ctx.Set(CtxProfile, profile)
	}
}

// GetProfileFromCtx returns the current profile
func GetProfileFromCtx(ctx *gin.Context) *common.Profile {
	p, ok := ctx.Get(CtxProfile)
	if !ok {
		return nil
	}
	return p.(*common.Profile)
}

// GetProfilesFromCtx returns the current profile
func GetProfilesFromCtx(ctx *gin.Context) []*common.Profile {
	p, ok := ctx.Get(CtxProfiles)
	if !ok {
		return nil
	}
	return p.([]*common.Profile)
}

// GetLanguagesFromCtx as provided in the request
func GetLanguagesFromCtx(ctx *gin.Context) []string {
	l, ok := ctx.Get(CtxLanguages)
	if !ok {
		return []string{}
	}

	return l.([]string)
}
