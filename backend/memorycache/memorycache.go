package memorycache

import (
	cache "github.com/Code-Hex/go-generics-cache"
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
