package common

import (
	"context"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/graph-gophers/dataloader/v7"
	"time"
)

type loaderCache[K comparable, V any] struct {
	expiration time.Duration
	cache      *cache.Cache[K, dataloader.Thunk[V]]
}

func newMemoryLoaderCache[K comparable, V any](expiration time.Duration) *loaderCache[K, V] {
	return &loaderCache[K, V]{
		expiration: expiration,
		cache:      cache.New[K, dataloader.Thunk[V]](),
	}
}

// Get retrieves an entry from the cache
func (c *loaderCache[K, V]) Get(ctx context.Context, key K) (dataloader.Thunk[V], bool) {
	return c.cache.Get(key)
}

// Set sets the specified key to value
func (c *loaderCache[K, V]) Set(ctx context.Context, key K, val dataloader.Thunk[V]) {
	c.cache.Set(key, val, cache.WithExpiration(c.expiration))
}

// Delete deletes the specified key
func (c *loaderCache[K, V]) Delete(ctx context.Context, key K) bool {
	c.cache.Delete(key)
	return true
}

// Clear clears the entire cache
func (c *loaderCache[K, V]) Clear() {
	c.cache = cache.New[K, dataloader.Thunk[V]]()
}
