package ratelimit

import (
	"context"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"time"
)

var limitCache = cache.New[string, RateLimit]()

// RateLimit contains basic data for limit options
type RateLimit struct {
	Increment int
}

// Middleware protects the API globally from anonymous requests
func Middleware() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		u := user.GetFromCtx(ctx)

		if !u.Anonymous {
			return
		}

		const rateLimit = 10000

		forwardedFor := ctx.Request.Header.Get("X-Forwarded-For")

		limit, _ := limitCache.Get(forwardedFor)
		if limit.Increment >= rateLimit {
			ctx.JSON(429, map[string]string{
				"error": "Too many requests",
			})
			ctx.Abort()
			return
		}

		limit.Increment++

		limitCache.Set(forwardedFor, limit, cache.WithExpiration(time.Minute*5))
	}
}

func getUniqueKeyForCtx(ginCtx *gin.Context) string {
	u := user.GetFromCtx(ginCtx)

	var key string
	if u.Anonymous {
		key = ginCtx.Request.Header.Get("X-Forwarded-For")

		if key == "" {
			key = ginCtx.ClientIP()
		}
	} else {
		p := user.GetProfileFromCtx(ginCtx)
		key = p.ID.String()
	}
	return key
}

// Endpoint protects a specific endpoint from public clients
func Endpoint(ctx context.Context, endpoint string, rateLimit int, anonymousOnly bool) error {
	ginCtx, _ := utils.GinCtx(ctx)

	u := user.GetFromCtx(ginCtx)

	if anonymousOnly && !u.Anonymous {
		return nil
	}

	key := getUniqueKeyForCtx(ginCtx)

	limit, _ := limitCache.Get(endpoint + ":" + key)
	if limit.Increment >= rateLimit {
		return merry.New("Rate limit exceeded", merry.WithUserMessage("Too many requests"), merry.WithHTTPCode(429))
	}

	limit.Increment++

	limitCache.Set(endpoint+":"+key, limit, cache.WithExpiration(time.Minute*5))

	return nil
}

// Remote protects a specific endpoint from public clients, with remote client
func Remote(ctx context.Context, remoteClient *remotecache.Client, endpoint string, rateLimit int, anonymousOnly bool) error {
	ginCtx, _ := utils.GinCtx(ctx)

	u := user.GetFromCtx(ginCtx)

	if anonymousOnly && !u.Anonymous {
		return nil
	}

	key := getUniqueKeyForCtx(ginCtx)

	cacheKey := "ratelimit:" + endpoint + ":" + key

	limit, err := remoteClient.Client().Get(ctx, cacheKey).Int()
	if err != nil && err != remotecache.Nil {
		return err
	}
	if limit >= rateLimit {
		return merry.New("Rate limit exceeded", merry.WithUserMessage("Too many requests"), merry.WithHTTPCode(429))
	}

	limit++

	_, err = remoteClient.Client().Set(ctx, cacheKey, limit, time.Minute*1).Result()

	return err
}

// Clear the specified remote entry
func Clear(ctx context.Context, remoteClient *remotecache.Client, endpoint string) error {
	ginCtx, _ := utils.GinCtx(ctx)

	key := getUniqueKeyForCtx(ginCtx)

	cacheKey := "ratelimit:" + endpoint + ":" + key

	_, err := remoteClient.Client().Del(ctx, cacheKey).Result()
	if err != nil && err != remotecache.Nil {
		return err
	}
	return nil
}
