//go:build integration

package utils

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bsm/redislock"
	"github.com/redis/go-redis/v9"
	"github.com/samber/lo/parallel"
	"github.com/stretchr/testify/assert"
	"os"
	"strconv"
	"testing"
	"time"
)

func TestRedisLock(t *testing.T) {
	ctx := context.Background()

	addr := os.Getenv("REDIS_ADDRESS")
	rdb := redis.NewClient(&redis.Options{
		Addr: addr,
	})

	status := rdb.Ping(ctx)
	if status.Err() != nil {
		t.Fatalf("Failed to ping redis database. DB: %s", addr)
		return
	}

	locker := redislock.New(rdb)

	lockKey := "key"

	running := 0

	parallel.Times(10, func(index int) bool {
		rl, err := remotecache.Lock(ctx, locker, lockKey+strconv.Itoa(index%2))
		if err != nil {
			t.Fatal(err)
			return false
		}
		running++
		assert.LessOrEqual(t, running, 2)

		time.Sleep(time.Millisecond * 200)
		running--
		remotecache.Release(ctx, rl)

		return true
	})
}
