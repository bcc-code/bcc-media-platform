package loaders

import (
	"context"
	"fmt"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/google/uuid"
	"github.com/graph-gophers/dataloader/v7"
	"strings"
	"sync"
	"time"
)

var loaderCacheLock = &sync.Mutex{}
var loaderCaches = map[string]any{}

// LoaderCache is a cache for batchloaders
type LoaderCache[K comparable, V any] struct {
	expiration  time.Duration
	cachePrefix string
	cache       *cache.Cache[string, dataloader.Thunk[V]]
}

// NewMemoryLoaderCache returns a new memory cache
func NewMemoryLoaderCache[K comparable, V any](ctx context.Context, cacheKey string, expiration time.Duration) dataloader.Cache[K, V] {
	return &LoaderCache[K, V]{
		expiration:  expiration,
		cachePrefix: uuid.New().String(),
		cache:       getCache[V](cacheKey),
	}
}

func getCache[V any](cacheKey string) *cache.Cache[string, dataloader.Thunk[V]] {
	loaderCacheLock.Lock()
	defer loaderCacheLock.Unlock()
	if r, ok := loaderCaches[cacheKey]; ok {
		return r.(*cache.Cache[string, dataloader.Thunk[V]])
	}
	r := cache.New[string, dataloader.Thunk[V]]()
	loaderCaches[cacheKey] = r
	return r
}

func (c *LoaderCache[K, V]) key(key K) string {
	return c.cachePrefix + ":" + fmt.Sprint(key)
}

func (c *LoaderCache[K, V]) isKey(key string) bool {
	return strings.HasPrefix(c.cachePrefix, key)
}

// Get retrieves an entry from the cache
func (c *LoaderCache[K, V]) Get(_ context.Context, key K) (dataloader.Thunk[V], bool) {
	return c.cache.Get(c.key(key))
}

// Set sets the specified key to value
func (c *LoaderCache[K, V]) Set(_ context.Context, key K, val dataloader.Thunk[V]) {
	c.cache.Set(c.key(key), val, cache.WithExpiration(c.expiration))
}

// Delete deletes the specified key
func (c *LoaderCache[K, V]) Delete(_ context.Context, key K) bool {
	c.cache.Delete(c.key(key))
	return true
}

// Clear clears the entire cache
func (c *LoaderCache[K, V]) Clear() {
	for _, key := range c.cache.Keys() {
		if c.isKey(key) {
			c.cache.Delete(key)
		}
	}
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
