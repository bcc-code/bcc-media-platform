package memorycache

import (
	"context"
	"fmt"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/Code-Hex/go-generics-cache/policy/lru"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// capacity bounds the shared LRU.
//
// It used to be the library default of 128, which was far too small: this one
// cache is shared by every caller in the process, and the high-cardinality keys
// — userinfo:<userID>, one calendar entry per requested date range, one entry
// per role combination — continuously evicted the handful of long-lived
// process-wide entries like "applications" and "languages". Those nominally
// cache for up to an hour but in practice survived only a few requests, so the
// queries behind them ran far more often than intended.
//
// This is a ceiling, not an expected size: every caller sets a TTL and the
// library's janitor sweeps expired entries once a minute, so steady-state
// occupancy is driven by churn within that window rather than by this number.
const capacity = 10000

var memoryCache = cache.New[string, any](cache.AsLRU[string, any](lru.WithCapacity(capacity)))

// Get retrieve a value from cache
func Get[V any](key string) (result V, success bool) {
	if v, ok := memoryCache.Get(key); ok {
		// The cache is shared across packages and holds `any`, so a key reused
		// with a different type is possible. Treat that as a miss: the caller
		// refetches, where an unchecked assertion would panic the goroutine.
		typed, ok := v.(V)
		if !ok {
			log.L.Error().
				Str("key", key).
				Str("stored", fmt.Sprintf("%T", v)).
				Str("wanted", fmt.Sprintf("%T", result)).
				Msg("Cached value has an unexpected type; treating as a cache miss")
			return result, false
		}
		return typed, true
	}
	return
}

// Set return a value from cache
func Set[V any](key string, value V, opts ...cache.ItemOption) {
	memoryCache.Set(key, value, opts...)
}

// Delete a value from cache
func Delete(key string) {
	memoryCache.Delete(key)
}

// GetOrSet a value with a lock
func GetOrSet[T any](ctx context.Context, key string, factory func(ctx context.Context) (T, error), opts ...cache.ItemOption) (T, error) {
	stored, success := Get[T](key)
	if success {
		return stored, nil
	}
	lock := utils.Lock(key)
	lock.Lock()
	defer lock.Unlock()

	stored, success = Get[T](key)
	if success {
		return stored, nil
	}

	stored, err := factory(ctx)
	if err != nil {
		return stored, err
	}
	Set(key, stored, opts...)
	return stored, nil
}
