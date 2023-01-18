package user

import (
	"context"
	"strconv"
	"time"

	"github.com/bcc-code/brunstadtv/backend/members"
	"github.com/go-redis/redis/v9"
	"github.com/go-redsync/redsync/v4"
	"github.com/go-redsync/redsync/v4/redis/goredis/v9"
	"github.com/google/uuid"
	"github.com/vmihailenco/msgpack/v5"

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
	var rtnRoles []string

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

var ageGroups = map[int]string{
	65: "65+",
	51: "51 - 64",
	37: "37 - 50",
	26: "26 - 36",
	19: "19 - 25",
	13: "13 - 18",
	10: "10 - 12",
	0:  "0 - 9",
}

// NewUserMiddleware returns a gin middleware that ingests a populated User struct
// into the gin context
func NewUserMiddleware(queries *sqlc.Queries, membersClient *members.Client) func(*gin.Context) {
	return func(ctx *gin.Context) {
		reqCtx, span := otel.Tracer("user/middleware").Start(ctx.Request.Context(), "run")
		defer span.End()

		var roles []string

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

		roles = append(roles, RoleRegistered)
		if ctx.GetBool(auth0.CtxIsBCCMember) {
			roles = append(roles, RoleBCCMember)
		}

		u := &common.User{
			PersonID:  pid,
			Roles:     roles,
			Anonymous: false,
			ActiveBCC: ctx.GetBool(auth0.CtxIsBCCMember),
			AgeGroup:  "unknown",
		}

		member, err := membersClient.Lookup(ctx, int(intID))
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to retrieve user")
			span.AddEvent("User failed to load")
			userCache.Set(userID, u, cache.WithExpiration(1*time.Minute))
			ctx.Set(CtxUser, u)
		}

		email := member.Email

		if email == "" {
			// Explicit values make it easier to see that it was intended when debugging
			email = "<MISSING>"
		}

		userRoles, err := GetRolesForEmail(reqCtx, queries, email)
		if err != nil {
			err = merry.Wrap(err)
			log.L.Warn().Err(err).Str("email", email).Msg("Unable to get roles")
		} else {
			roles = append(roles, userRoles...)
		}

		u.Roles = roles
		u.Email = email
		u.DisplayName = member.DisplayName

		// Set AgeGroup and avoid passing identifying information through the application
		birthDate, err := time.Parse("2006-01-02", member.BirthDate)
		if err != nil {
			log.L.Error().Err(err).Msg("Error parsing birthday of user")
		} else {
			u.Age = time.Now().Year() - birthDate.Year()
			ageGrpupMin := 0
			for minAge, group := range ageGroups {
				// Note: Maps are not iterated in a sorted order so we have to find the lowed applicable
				if u.Age > minAge && minAge > ageGrpupMin {
					u.AgeGroup = group
					ageGrpupMin = minAge
				}
			}
		}

		u.ChurchIDs = lo.Map(lo.Filter(member.Affiliations, func(i members.Affiliation, _ int) bool {
			return i.Active && i.OrgType == "Church"
		}), func(i members.Affiliation, _ int) int {
			return i.OrgID
		})

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

var profileCache = cache.New[string, []common.Profile]()

func cacheProfilesAndReturn(ctx context.Context, redisCache *redis.Client, key string, profiles []common.Profile) ([]common.Profile, error) {
	profileCache.Set(key, profiles, cache.WithExpiration(time.Second*1))
	if redisCache != nil {
		bytes, err := msgpack.Marshal(profiles)
		if err != nil {
			return nil, err
		}
		err = redisCache.Set(ctx, key, bytes, time.Minute*5).Err()
		if err != nil {
			return nil, err
		}
	}
	return profiles, nil
}

func checkCachedProfiles(ctx context.Context, redisClient *redis.Client, key string) ([]common.Profile, error) {
	bytes, err := redisClient.Get(ctx, key).Bytes()
	if err != nil && err != redis.Nil {
		return nil, err
	}
	if err == nil {
		var profiles []common.Profile
		if err != nil {
			return nil, err
		}
		_ = msgpack.Unmarshal(bytes, &profiles)
		return cacheProfilesAndReturn(ctx, nil, key, profiles)
	}
	if err != redis.Nil {
		return nil, err
	}
	return nil, nil
}

func getProfilesFromDatabase(ctx context.Context, queries *sqlc.Queries, user *common.User) ([]common.Profile, error) {
	profiles, err := queries.GetProfilesForUserIDs(ctx, []string{user.PersonID})
	if err != nil {
		return nil, err
	}

	if len(profiles) > 0 {
		return profiles, nil
	}

	profile := common.Profile{
		ID:     uuid.New(),
		Name:   user.DisplayName,
		UserID: user.PersonID,
	}
	err = queries.SaveProfile(ctx, profile)
	if err != nil {
		return nil, err
	}

	profiles = append(profiles, profile)

	return profiles, nil
}

func getProfiles(ctx *gin.Context, queries *sqlc.Queries, redisClient *redis.Client, rs *redsync.Redsync, user *common.User) ([]common.Profile, error) {
	key := "profiles:" + user.PersonID
	if p, ok := profileCache.Get(key); ok && len(p) > 0 {
		return p, nil
	}

	lock := utils.Lock(key)
	lock.Lock()
	defer lock.Unlock()

	if p, ok := profileCache.Get(user.PersonID); ok && len(p) > 0 {
		return p, nil
	}

	profiles, err := checkCachedProfiles(ctx, redisClient, key)
	if err != nil || len(profiles) > 0 {
		return profiles, err
	}

	rl, err := utils.RedisLock(rs, key)
	if err != nil {
		return nil, err
	}
	defer utils.UnlockRedisLock(rl)

	profiles, err = checkCachedProfiles(ctx, redisClient, key)
	if err != nil || len(profiles) > 0 {
		return profiles, err
	}

	profiles, err = getProfilesFromDatabase(ctx, queries, user)
	if err != nil {
		return nil, err
	}

	return cacheProfilesAndReturn(ctx, redisClient, key, profiles)
}

// NewProfileMiddleware prefills context with a profileID
func NewProfileMiddleware(queries *sqlc.Queries, client *redis.Client) func(*gin.Context) {
	pool := goredis.NewPool(client)
	rs := redsync.New(pool)

	return func(ctx *gin.Context) {
		u := GetFromCtx(ctx)

		if u.PersonID == "" {
			return
		}

		profiles, err := getProfiles(ctx, queries, client, rs, u)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to retrieve profiles from loader")
			return
		}

		profileID := ctx.GetHeader("x-profile")
		profile, found := lo.Find(profiles, func(p common.Profile) bool {
			return p.ID.String() == profileID || p.Name == profileID
		})
		if !found {
			profile = profiles[0]
		}

		ctx.Set(CtxProfiles, profiles)
		ctx.Set(CtxProfile, &profile)
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
func GetProfilesFromCtx(ctx *gin.Context) []common.Profile {
	p, ok := ctx.Get(CtxProfiles)
	if !ok {
		return nil
	}
	return p.([]common.Profile)
}

// GetLanguagesFromCtx as provided in the request
func GetLanguagesFromCtx(ctx *gin.Context) []string {
	l, ok := ctx.Get(CtxLanguages)
	if !ok {
		return []string{}
	}

	return l.([]string)
}
