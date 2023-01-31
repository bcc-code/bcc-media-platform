package loaders

import (
	"context"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/graph-gophers/dataloader/v7"
	"time"
)

// LoaderCache is a cache for batchloaders
type LoaderCache[K comparable, V any] struct {
	expiration time.Duration
	cache      *cache.Cache[K, dataloader.Thunk[V]]
}

// NewMemoryLoaderCache returns a new memory cache
func NewMemoryLoaderCache[K comparable, V any](ctx context.Context, expiration time.Duration) *LoaderCache[K, V] {
	return &LoaderCache[K, V]{
		expiration: expiration,
		cache:      cache.NewContext[K, dataloader.Thunk[V]](ctx, cache.AsLRU[K, dataloader.Thunk[V]]()),
	}
}

// Get retrieves an entry from the cache
func (c *LoaderCache[K, V]) Get(ctx context.Context, key K) (dataloader.Thunk[V], bool) {
	return c.cache.Get(key)
}

// Set sets the specified key to value
func (c *LoaderCache[K, V]) Set(ctx context.Context, key K, val dataloader.Thunk[V]) {
	c.cache.Set(key, val, cache.WithExpiration(c.expiration))
}

// Delete deletes the specified key
func (c *LoaderCache[K, V]) Delete(ctx context.Context, key K) bool {
	c.cache.Delete(key)
	return true
}

// Clear clears the entire cache
func (c *LoaderCache[K, V]) Clear() {
	c.cache = cache.New[K, dataloader.Thunk[V]]()
}

func (mc MemoryCache) isOption() {

}

// MemoryCache is a simple memory cache
type MemoryCache struct {
	expiration time.Duration
}

// WithMemoryCache defines how long a key should live in the cache
func WithMemoryCache(expiration time.Duration) Option {
	return MemoryCache{
		expiration: expiration,
	}
}
