//go:build integration

package remotecache

import (
	"context"
	"os"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/bsm/redislock"
	"github.com/redis/go-redis/v9"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func testClient(t *testing.T) *Client {
	t.Helper()

	addr := os.Getenv("REDIS_ADDRESS")
	rdb := redis.NewClient(&redis.Options{Addr: addr})
	if err := rdb.Ping(context.Background()).Err(); err != nil {
		t.Fatalf("Failed to ping redis database. DB: %s", addr)
	}
	return New(rdb, redislock.New(rdb))
}

// TestGetOrCreateLockUnobtainable covers the production panic: when the lock is already
// held by someone else, GetOrCreate must still produce a value instead of dereferencing
// the nil lock in the deferred Release.
func TestGetOrCreateLockUnobtainable(t *testing.T) {
	ctx := context.Background()
	rc := testClient(t)
	key := "test:unobtainable"

	require.NoError(t, rc.Client().Del(ctx, key).Err())

	// Hold the lock for longer than GetOrCreate is willing to wait for it.
	held, err := rc.Locker().Obtain(ctx, "locks:"+key, lockWait*2, nil)
	require.NoError(t, err)
	defer func() { _ = held.Release(ctx) }()

	value, err := GetOrCreate(ctx, rc, key, func(o *Options) (string, error) {
		return "produced-without-lock", nil
	})

	assert.NoError(t, err)
	assert.Equal(t, "produced-without-lock", value)
}

// TestGetOrCreateSuppressesDuplicateWork asserts the lock plus the re-read after
// acquiring it actually collapse a herd of concurrent callers into a single factory run.
func TestGetOrCreateSuppressesDuplicateWork(t *testing.T) {
	ctx := context.Background()
	rc := testClient(t)
	key := "test:herd"

	require.NoError(t, rc.Client().Del(ctx, key).Err())
	defer func() { _ = rc.Client().Del(ctx, key).Err() }()

	var calls int32
	var wg sync.WaitGroup
	for i := 0; i < 10; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			v, err := GetOrCreate(ctx, rc, key, func(o *Options) (string, error) {
				atomic.AddInt32(&calls, 1)
				// Slow enough that every other caller is waiting on the lock.
				time.Sleep(time.Millisecond * 500)
				return "value", nil
			})
			assert.NoError(t, err)
			assert.Equal(t, "value", v)
		}()
	}
	wg.Wait()

	assert.Equal(t, int32(1), atomic.LoadInt32(&calls),
		"factory should run once for a herd of 10 concurrent callers")
}
