package utils

import (
	"sync"
)

// keyedLock is one entry in the lock table. refs counts everyone currently
// holding or waiting for it, which is what lets the entry be removed once the
// last user is done.
type keyedLock struct {
	mu   sync.Mutex
	refs int
}

var (
	locksMu sync.Mutex
	locks   = map[string]*keyedLock{}
)

// Lock acquires the lock for key and returns the function that releases it. The
// caller must call that function exactly once, normally via defer:
//
//	unlock := utils.Lock(key)
//	defer unlock()
//
// Entries are reference counted and dropped when the last holder releases them.
// That matters because callers key this by things like a user or profile id, and
// the previous implementation only ever added to the table — so a process
// accumulated one mutex per distinct key it had ever seen and never freed any of
// them.
func Lock(key string) (unlock func()) {
	locksMu.Lock()
	l, ok := locks[key]
	if !ok {
		l = &keyedLock{}
		locks[key] = l
	}
	// Counted before releasing locksMu so the entry cannot be removed by another
	// goroutine's release between here and the Lock below.
	l.refs++
	locksMu.Unlock()

	l.mu.Lock()

	var once sync.Once
	return func() {
		once.Do(func() {
			l.mu.Unlock()

			locksMu.Lock()
			l.refs--
			if l.refs == 0 {
				delete(locks, key)
			}
			locksMu.Unlock()
		})
	}
}
