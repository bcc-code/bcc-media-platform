package utils

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/remotecache"
	"github.com/bcc-code/mediabank-bridge/log"
	"sync"
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
func UnlockRedisLock(ctx context.Context, lock remotecache.RemoteLock) {
	err := lock.Release(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("failed to release redis lock")
	}
}
