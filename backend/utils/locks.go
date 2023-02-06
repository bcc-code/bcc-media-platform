package utils

import (
	"sync"
	"time"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/go-redsync/redsync/v4"
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
func UnlockRedisLock(lock *redsync.Mutex) {
	_, err := lock.Unlock()
	if err != nil {
		log.L.Error().Err(err).Msg("failed to release redis lock")
	}
}

// RedisLock locks across nodes through redis
func RedisLock(rs *redsync.Redsync, key string) (*redsync.Mutex, error) {
	lock := rs.NewMutex(key, redsync.WithExpiry(time.Second*20))
	if err := lock.Lock(); err != nil {
		return nil, err
	}
	return lock, nil
}
