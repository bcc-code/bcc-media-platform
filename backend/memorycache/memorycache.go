package memorycache

import (
	"context"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

var memoryCache = cache.New[string, any]()

// Get retrieve a value from cache
func Get[V any](key string) *V {
	if v, ok := memoryCache.Get(key); ok {
		return v.(*V)
	}
	return nil
}

// Set return a value from cache
func Set[V any](key string, value *V, opts ...cache.ItemOption) {
	memoryCache.Set(key, value, opts...)
}

// GetOrSet a value with a lock
func GetOrSet[T any](ctx context.Context, key string, factory func(ctx context.Context) (T, error)) (*T, error) {
	stored := Get[T](key)
	if stored != nil {
		return stored, nil
	}
	lock := utils.Lock(key)
	lock.Lock()
	defer lock.Unlock()

	stored = Get[T](key)
	if stored != nil {
		return stored, nil
	}

	value, err := factory(ctx)
	if err != nil {
		return nil, err
	}
	stored = &value
	Set(key, stored)
	return stored, nil
}
