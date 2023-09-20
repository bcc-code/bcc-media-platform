package memorycache

import (
	"context"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

var memoryCache = cache.New[string, any](cache.AsLRU[string, any]())

// Get retrieve a value from cache
func Get[V any](key string) (result V, success bool) {
	if v, ok := memoryCache.Get(key); ok {
		return v.(V), true
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
