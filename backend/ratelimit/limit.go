package ratelimit

import (
	"context"
	"errors"
	"sync/atomic"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
)

// ErrRateLimited is returned by Key when the limit for the window is reached.
var ErrRateLimited = errors.New("rate limit exceeded")

// Key increments the distributed counter for an arbitrary key and returns
// ErrRateLimited once the limit within the fixed window is exceeded.
//
// This is the shared, cross-replica limiter, and unlike Endpoint it does not
// derive the key from the request context, so it works on routes without the
// user middleware. INCR is atomic, so concurrent requests cannot slip past the
// limit. Any other error is a Redis failure — callers decide whether to fail
// open or closed.
func Key(ctx context.Context, remoteClient *remotecache.Client, key string, limit int, window time.Duration) error {
	cacheKey := "ratelimit:" + key
	count, err := remoteClient.Client().Incr(ctx, cacheKey).Result()
	if err != nil {
		return err
	}
	if count == 1 {
		remoteClient.Client().Expire(ctx, cacheKey, window)
	} else if ttl, err := remoteClient.Client().TTL(ctx, cacheKey).Result(); err == nil && ttl < 0 {
		// The first hit's Expire was lost (e.g. that process died between
		// INCR and EXPIRE); without this the counter would never reset.
		remoteClient.Client().Expire(ctx, cacheKey, window)
	}
	if count > int64(limit) {
		return ErrRateLimited
	}
	return nil
}

// window is how long an in-memory counter accumulates before it is discarded and
// the caller starts from zero again.
const window = time.Minute * 5

// counter is stored by pointer so that the increment happens on one shared
// value rather than on a copy read out of the cache.
type counter struct {
	hits atomic.Int64
}

var limitCache = cache.New[string, *counter]()

// allow records one hit against key and reports whether it is still within
// limit for the current window.
//
// Both steps are atomic, which the previous read-modify-write was not: it did
// cache.Get, incremented the returned copy, and wrote it back, so concurrent
// requests all read the same value and all stored value+1. The counter
// undercounted by roughly the concurrency factor, meaning the limit gave way
// under precisely the load it exists to stop. Creation is serialised per key and
// the counter itself is an atomic.Int64, so no hit is lost.
//
// The expiry is set only when the counter is created, so the window is fixed
// from the first hit. Refreshing it on every hit — as the old code did by
// calling Set each time — means a client that keeps trying never rolls out of
// the window and stays blocked indefinitely once it trips the limit. Get treats
// an expired entry as absent, so the next hit after the window starts a fresh
// counter.
//
// Accounting is per pod, as before; this is not shared across replicas.
func allow(key string, limit int) bool {
	c, ok := limitCache.Get(key)
	if !ok {
		// The pinned cache library has no atomic get-or-create, so serialise
		// creation on the key. Without this two goroutines racing a cold key both
		// store a fresh counter and one of them loses its hit.
		unlock := utils.Lock("ratelimit:" + key)
		c, ok = limitCache.Get(key)
		if !ok {
			c = &counter{}
			limitCache.Set(key, c, cache.WithExpiration(window))
		}
		unlock()
	}
	return c.hits.Add(1) <= int64(limit)
}

// Middleware protects the API globally from anonymous requests
func Middleware(ctx *gin.Context) {
	u := user.GetFromCtx(ctx)

	if !u.Anonymous {
		return
	}

	const rateLimit = 10000

	forwardedFor := ctx.Request.Header.Get("X-Forwarded-For")

	if !allow("anon:"+forwardedFor, rateLimit) {
		ctx.JSON(429, map[string]string{
			"error": "Too many requests",
		})
		ctx.Abort()
		return
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

	if !allow("endpoint:"+endpoint+":"+key, rateLimit) {
		return merry.New("Rate limit exceeded", merry.WithUserMessage("Too many requests"), merry.WithHTTPCode(429))
	}

	return nil
}
