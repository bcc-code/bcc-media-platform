package middleware

import (
	"context"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/applications"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

var profileCache = cache.New[string, []common.Profile]()

func getProfilesFromDatabase(ctx context.Context, queries *sqlc.ApplicationQueries, user *common.User) ([]common.Profile, error) {
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

func getProfiles(ctx *gin.Context, queries *sqlc.ApplicationQueries, remoteCache *remotecache.Client, user *common.User) ([]common.Profile, error) {
	key := "profiles:" + queries.GroupID.String() + ":" + user.PersonID
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
		u := user.GetFromCtx(ctx)
		if u.PersonID == "" {
			return
		}

		app, err := applications.GetFromCtx(ctx)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to get application from context")
			return
		}

		profiles, err := getProfiles(ctx, queries.ApplicationQueries(app.GroupID), client, u)
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

		ctx.Set(user.CtxProfiles, profiles)
		ctx.Set(user.CtxProfile, &profile)
	}
}
