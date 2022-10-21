package memorycache

import (
	cache "github.com/Code-Hex/go-generics-cache"
	"time"
)

var memoryCache = cache.New[string, any]()

var truncateTime = time.Second * 1

// GetWithTimestamp returns the stored value while invalidating it with comparing to timestamp
func GetWithTimestamp[V any](key string, timestamp *string) (*V, error) {
	t, err := timestampFromString(timestamp)
	if err != nil {
		return nil, err
	}
	if t != nil {
		now := time.Now()
		if t.After(now) {
			t = &now
		}
		truncated := t.Truncate(truncateTime)
		t = &truncated
	}
	var entry timedCacheEntry[*V]
	if result, ok := memoryCache.Get(key); ok {
		if entry, ok = result.(timedCacheEntry[*V]); ok {
			if t == nil || t.Equal(entry.Cached) || t.Before(entry.Cached) {
				return entry.Entry, nil
			}
		}
	}
	return nil, nil
}

// SetWithTimestamp primes the entry with the current time
func SetWithTimestamp[V any](key string, value *V, opts ...cache.ItemOption) {
	memoryCache.Set(key, timedCacheEntry[*V]{
		Cached: time.Now().Truncate(truncateTime),
		Entry:  value,
	}, opts...)
}

type timedCacheEntry[t any] struct {
	Cached time.Time
	Entry  t
}

func timestampFromString(timestamp *string) (*time.Time, error) {
	var r *time.Time
	if timestamp != nil {
		t, err := time.Parse(time.RFC3339, *timestamp)
		if err != nil {
			return nil, err
		}
		r = &t
	}
	return r, nil
}
