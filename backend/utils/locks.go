package utils

import (
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
