package utils

import (
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/go-redsync/redsync/v4"
	"sync"
)

var mapLock = &sync.Mutex{}
var locks = map[string]*sync.Mutex{}

// Lock returns a new stored lock
func Lock(key string) *sync.Mutex {
	lock, ok := locks[key]
	if !ok {
		mapLock.Lock()
		defer mapLock.Unlock()
		lock = &sync.Mutex{}
		locks[key] = lock
	}
	return lock
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
	lock := rs.NewMutex(key)
	if err := lock.Lock(); err != nil {
		return nil, err
	}
	return lock, nil
}
