package middleware

import (
	"context"
	"fmt"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/members"
	"github.com/bcc-code/brunstadtv/backend/remotecache"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"go.opentelemetry.io/otel"
	"strconv"
	"sync"
	"time"
)

var userCacheLocks = utils.SyncMap[string, *sync.Mutex]{}

var userCache = cache.New[string, *common.User]()
var rolesCache = cache.New[string, map[string][]string]()

func ageFromBirthDate(birthDate string) int {
	date, err := time.Parse("2006-04-02", birthDate)
	if err != nil {
		return 0
	}
	now := time.Now()

	// years since birth
	years := now.Year() - date.Year()

	// if the user hasn't had their birthday yet this year, subtract a year
	if now.Month() < date.Month() || (now.Month() == date.Month() && now.Day() < date.Day()) {
		years--
	}

	return years
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
		ctx.Set(user.CtxLanguages, user.GetAcceptedLanguagesFromCtx(ctx))

		// If the user is anonymous we just create a simple object and bail
		if !authed {
			span.AddEvent("Anonymous")
			roles = append(roles, user.RolePublic)
			ctx.Set(user.CtxUser,
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
			ctx.Set(user.CtxUser, u)
			return
		}

		getUserFromMembers := func(o *remotecache.Options) (*common.User, error) {
			o.SetTTL(time.Minute * 5)
			pid := ctx.GetString(auth0.CtxPersonID)
			intID, _ := strconv.ParseInt(pid, 10, 32)

			roles = append(roles, user.RoleRegistered)
			if ctx.GetBool(auth0.CtxIsBCCMember) {
				roles = append(roles, user.RoleBCCMember)
			} else {
				roles = append(roles, user.RoleNonBCCMember, user.RolePublic)
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
					ctx.Set(user.CtxUser, u)
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

				u.Age = ageFromBirthDate(member.BirthDate)

				now := time.Now()
				affiliations := lo.Filter(member.Affiliations, func(i members.Affiliation, _ int) bool {
					return (i.ValidTo == nil || i.ValidTo.After(now)) && (i.ValidFrom == nil || i.ValidFrom.Before(now))
				})
				organizations, err := ls.OrganizationLoader.GetMany(ctx, lo.Map(affiliations, func(i members.Affiliation, _ int) uuid.UUID {
					return i.OrgUid
				}))
				if err != nil {
					return nil, err
				}
				for _, org := range organizations {
					if org != nil && org.Type == "Church" {
						u.ChurchIDs = append(u.ChurchIDs, org.OrgID)
					}
				}
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
			for minAge, group := range user.AgeGroups {
				// Note: Maps are not iterated in a sorted order, so we have to find the lowest applicable range
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
			ctx.Set(user.CtxUser, u)
			return
		} else {
			log.L.Error().Err(err).Send()
			ctx.Set(user.CtxUser, &common.User{
				Roles:     roles,
				Anonymous: true,
				ActiveBCC: false,
			})
		}
	}
}

func getRoles(ctx context.Context, queries *sqlc.Queries) (map[string][]string, error) {
	ctx, span := otel.Tracer("user").Start(ctx, "getRoles")
	defer span.End()

	if roles, ok := rolesCache.Get(user.CacheRoles); ok {
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
	rolesCache.Set(user.CacheRoles, allRoles, cache.WithExpiration(60*time.Minute))
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
