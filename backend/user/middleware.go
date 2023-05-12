package user

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/members"
	"strconv"
	"sync"
	"time"

	"github.com/bcc-code/brunstadtv/backend/remotecache"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"go.opentelemetry.io/otel"
)

// All well-known roles as used in the DB
const (
	RolePublic       = "public"
	RoleRegistered   = "registered"
	RoleBCCMember    = "bcc-members"
	RoleNonBCCMember = "non-bcc-members"
)

// Various hardcoded keys
const (
	CtxUser          = "ctx-user"
	CacheRoles       = "roles"
	CtxLanguages     = "ctx-languages"
	CtxProfiles      = "ctx-profiles"
	CtxProfile       = "ctx-profile"
	CtxImpersonating = "ctx-impersonating"
)

var userCacheLocks = utils.SyncMap[string, *sync.Mutex]{}

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

// AgeGroups contains the different age groups keyed by the minimum age.
var AgeGroups = map[int]string{
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
func NewUserMiddleware(queries *sqlc.Queries, remoteCache *remotecache.Client, ls *common.BatchLoaders, auth0Client *auth0.Client) func(*gin.Context) {
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

		getUserFromMembers := func(o *remotecache.Options) (*common.User, error) {
			o.SetTTL(time.Minute * 5)
			pid := ctx.GetString(auth0.CtxPersonID)
			intID, _ := strconv.ParseInt(pid, 10, 32)

			roles = append(roles, RoleRegistered)
			if ctx.GetBool(auth0.CtxIsBCCMember) {
				roles = append(roles, RoleBCCMember)
			} else {
				roles = append(roles, RoleNonBCCMember, RolePublic)
			}

			if pid == "" || pid == "0" {
				pid = ctx.GetString(auth0.CtxUserID)
			}

			u := &common.User{
				PersonID:  pid,
				Roles:     roles,
				Anonymous: false,
				ActiveBCC: ctx.GetBool(auth0.CtxIsBCCMember),
				AgeGroup:  "unknown",
				Gender:    "unknown",
			}

			saveUser := func() error {
				return queries.UpsertUser(ctx, sqlc.UpsertUserParams{
					ID:            u.PersonID,
					Roles:         u.Roles,
					DisplayName:   u.DisplayName,
					FirstName:     u.FirstName,
					ActiveBcc:     u.ActiveBCC,
					EmailVerified: u.EmailVerified,
					Email:         u.Email,
					AgeGroup:      u.AgeGroup,
					Age:           int32(u.Age),
					Gender:        u.Gender,
					ChurchIds: lo.Map(u.ChurchIDs, func(i int, _ int) int32 {
						return int32(i)
					}),
				})
			}

			//info, err := auth0Client.GetUserInfoForAuthHeader(ctx, ctx.GetHeader("Authorization"))
			//if err != nil {
			//	return nil, err
			//}
			//u.EmailVerified = info.EmailVerified
			u.EmailVerified = true

			if u.IsActiveBCC() {
				member, err := ls.MemberLoader.Get(ctx, int(intID))
				if err != nil {
					log.L.Info().Err(err).Msg("Failed to retrieve user from members.")
					span.AddEvent("User failed to load from members")

					dbUser, err := ls.UserLoader.Get(ctx, pid)
					if err != nil {
						log.L.Error().Err(err).Msg("Failed to retrieve user from database.")
					}
					if dbUser != nil {
						u = dbUser
					}

					userCache.Set(userID, u, cache.WithExpiration(1*time.Minute))
					ctx.Set(CtxUser, u)
					return u, nil
				}
				u.FirstName = member.FirstName
				switch member.Gender {
				case "Male":
					u.Gender = "male"
				case "Female":
					u.Gender = "female"
				default:
					u.Gender = "unknown"
				}
				u.Email = member.Email
				u.DisplayName = member.DisplayName
				u.Age = member.Age
				u.ChurchIDs = lo.Map(lo.Filter(member.Affiliations, func(i members.Affiliation, _ int) bool {
					return i.Active && i.OrgType == "Church"
				}), func(i members.Affiliation, _ int) int {
					return i.OrgID
				})
			} else {
				info, err := auth0Client.GetUser(ctx, ctx.GetString(auth0.CtxUserID))
				if err != nil {
					return nil, err
				}
				u.PersonID = info.UserId
				u.Email = info.Email
				u.DisplayName = info.Nickname
				u.EmailVerified = info.EmailVerified

				if by, ok := info.UserMetadata["birth_year"]; ok {
					year, err := strconv.ParseInt(by, 10, 64)
					if err == nil {
						u.Age = time.Now().Year() - int(year)
					}
				}
				u.CompletedRegistration = info.CompletedRegistration()
			}

			if u.Email == "" {
				// Explicit values make it easier to see that it was intended when debugging
				u.Email = "<MISSING>"
			}

			if u.EmailVerified {
				userRoles, err := GetRolesForEmail(reqCtx, queries, u.Email)
				if err != nil {
					err = merry.Wrap(err)
					log.L.Warn().Err(err).Str("email", u.Email).Msg("Unable to get roles")
				} else {
					roles = append(roles, userRoles...)
				}
			}

			u.Roles = roles

			ageGroupMin := 0
			for minAge, group := range AgeGroups {
				// Note: Maps are not iterated in a sorted order, so we have to find the lowed applicable
				if u.Age >= minAge && minAge > ageGroupMin {
					u.AgeGroup = group
					ageGroupMin = minAge
				}
			}

			err := saveUser()

			if err != nil {
				log.L.Error().Err(err).Send()
			}

			return u, nil
		}

		lock, _ := userCacheLocks.LoadOrStore(userID, &sync.Mutex{})
		lock.Lock()
		defer func() {
			lock.Unlock()
			userCacheLocks.Delete(userID)
		}()
		if u, err := remotecache.GetOrCreate[*common.User](ctx, remoteCache, fmt.Sprintf("users:%s", userID), getUserFromMembers); err == nil {
			span.AddEvent("User loaded into cache")
			userCache.Set(userID, u, cache.WithExpiration(60*time.Second))
			ctx.Set(CtxUser, u)
			return
		} else {
			log.L.Error().Err(err).Send()
			ctx.Set(CtxUser, &common.User{
				Roles:     roles,
				Anonymous: true,
				ActiveBCC: false,
			})
		}
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

func getProfiles(ctx *gin.Context, queries *sqlc.Queries, remoteCache *remotecache.Client, user *common.User) ([]common.Profile, error) {
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

	profileFactory := func(o *remotecache.Options) ([]common.Profile, error) {
		o.SetTTL(time.Minute * 5)
		profiles, err := getProfilesFromDatabase(ctx, queries, user)
		if err != nil {
			return nil, err
		}
		return profiles, nil
	}
	profiles, err := remotecache.GetOrCreate(ctx, remoteCache, key, profileFactory)
	if err != nil {
		return nil, err
	}
	profileCache.Set(user.PersonID, profiles, cache.WithExpiration(time.Second*2))
	return profiles, nil
}

// NewProfileMiddleware prefills context with a profileID
func NewProfileMiddleware(queries *sqlc.Queries, client *remotecache.Client) func(*gin.Context) {
	return func(ctx *gin.Context) {
		u := GetFromCtx(ctx)

		if u.PersonID == "" {
			return
		}

		profiles, err := getProfiles(ctx, queries, client, u)
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
