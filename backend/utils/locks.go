package utils

import (
	"context"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/bsm/redislock"
	"sync"
	"time"
)

var mapLock = &sync.Mutex{}
var locks = sync.Map{}

// Lock returns a new stored lock
func Lock(key string) *sync.Mutex {
	lock, ok := locks.Load(key)
	if !ok {
		mapLock.Lock()
		defer mapLock.Unlock()
		lock, ok = locks.Load(key)
		if !ok {
			lock = &sync.Mutex{}
			locks.Store(key, lock)
		}
	}
	return lock.(*sync.Mutex)
}

// UnlockRedisLock unlocks the specified lock
func UnlockRedisLock(ctx context.Context, lock *redislock.Lock) {
	err := lock.Release(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("failed to release redis lock")
	}
}

// RedisLock locks across nodes through redis
func RedisLock(ctx context.Context, locker *redislock.Client, key string) (*redislock.Lock, error) {
	key = "lock:" + key
	lock, err := locker.Obtain(ctx, key, 10*time.Second, &redislock.Options{
		RetryStrategy: redislock.LimitRetry(redislock.LinearBackoff(time.Millisecond*100), 20),
	})
	if err != nil {
		return nil, err
	}
	return lock, nil
}
