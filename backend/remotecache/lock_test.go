package remotecache

import (
	"context"
	"errors"
	"testing"

	"github.com/bsm/redislock"
)

// TestReleaseNilLock guards against the panic that took down api-prod requests: Lock
// returns a nil RemoteLock when it fails to obtain the lock, and Release used to
// dereference it.
func TestReleaseNilLock(t *testing.T) {
	Release(context.Background(), nil)
}

// TestLockTimingsAreCoherent pins the relationship between the lease and the retry
// budget. The original bug behind the production panic burst was a 2s budget against a
// 10s lease, which failed every waiter as soon as a factory ran longer than 2s.
func TestLockTimingsAreCoherent(t *testing.T) {
	// redislock bounds Obtain with its own now+ttl deadline, so a budget at or above
	// the lease cannot be spent and only turns ErrNotObtained into a deadline error.
	if lockWait >= lockTTL {
		t.Errorf("lockWait (%s) must stay below lockTTL (%s)", lockWait, lockTTL)
	}
	// The budget should still cover most of the lease, so waiters wait out a holder
	// instead of stampeding the factory.
	if lockWait*2 < lockTTL {
		t.Errorf("lockWait (%s) is far below lockTTL (%s): waiters give up while the lock is still held", lockWait, lockTTL)
	}
	if lockWait%lockRetryInterval != 0 {
		t.Errorf("lockWait (%s) is not a whole number of lockRetryInterval (%s), retry count would truncate", lockWait, lockRetryInterval)
	}
}

func TestLockContendedClassification(t *testing.T) {
	for _, err := range []error{redislock.ErrNotObtained, context.DeadlineExceeded, context.Canceled} {
		if !lockContended(err) {
			t.Errorf("expected %v to be classified as contention", err)
		}
	}
	if lockContended(errors.New("dial tcp: connection refused")) {
		t.Error("a redis connection failure must not be classified as contention")
	}
}
