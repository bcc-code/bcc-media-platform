package ratelimit

import (
	"strconv"
	"sync"
	"sync/atomic"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestAllowPermitsExactlyTheLimit(t *testing.T) {
	const limit = 5
	key := "sequential"

	for i := 1; i <= limit; i++ {
		assert.True(t, allow(key, limit), "hit %d of %d should be allowed", i, limit)
	}
	assert.False(t, allow(key, limit), "hit %d should be rejected", limit+1)
	assert.False(t, allow(key, limit), "further hits should stay rejected")
}

// The previous implementation read a counter out of the cache, incremented the
// copy and wrote it back. Concurrent requests all read the same value and all
// stored value+1, so the limit let far more than `limit` requests through —
// under exactly the concurrency it exists to guard against.
func TestAllowDoesNotLoseHitsUnderConcurrency(t *testing.T) {
	const (
		limit    = 50
		requests = 500
	)
	key := "concurrent"

	var allowed atomic.Int64
	var wg sync.WaitGroup
	for range requests {
		wg.Add(1)
		go func() {
			defer wg.Done()
			if allow(key, limit) {
				allowed.Add(1)
			}
		}()
	}
	wg.Wait()

	assert.Equal(t, int64(limit), allowed.Load(),
		"exactly %d of %d concurrent requests should be allowed", limit, requests)
}

func TestAllowCountsKeysIndependently(t *testing.T) {
	const limit = 2

	for i := range 3 {
		key := "independent-" + strconv.Itoa(i)
		assert.True(t, allow(key, limit))
		assert.True(t, allow(key, limit))
		assert.False(t, allow(key, limit), "key %s should be exhausted", key)
	}
}
