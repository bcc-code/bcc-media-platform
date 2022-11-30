package ratelimit

import (
	"context"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
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

		const rateLimit = 200

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

// Endpoint protects a specific endpoint from public clients
func Endpoint(ctx context.Context, endpoint string, rateLimit int) error {
	ginCtx, _ := utils.GinCtx(ctx)

	u := user.GetFromCtx(ginCtx)

	if !u.Anonymous {
		return nil
	}

	forwardedFor := ginCtx.Request.Header.Get("X-Forwarded-For")

	if forwardedFor == "" {
		forwardedFor = ginCtx.ClientIP()
	}

	limit, _ := limitCache.Get(endpoint + ":" + forwardedFor)
	if limit.Increment >= rateLimit {
		return merry.New("Rate limit exceeded", merry.WithUserMessage("Too many requests"))
	}

	limit.Increment++

	limitCache.Set(forwardedFor, limit, cache.WithExpiration(time.Minute*5))

	return nil
}
