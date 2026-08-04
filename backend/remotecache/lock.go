package remotecache

import (
	"context"
	"errors"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bsm/redislock"

	"time"
)

const (
	// lockTTL bounds how long a crashed or killed holder can block other workers.
	lockTTL = time.Second * 5
	// lockRetryInterval is how often a waiter re-attempts to obtain the lock.
	lockRetryInterval = time.Millisecond * 100
	// lockWait is the total time a waiter blocks before giving up and doing the work
	// itself. It must stay below lockTTL: redislock caps Obtain with its own
	// now+ttl deadline, so a larger budget cannot be spent and merely turns a clean
	// ErrNotObtained into a context deadline error.
	lockWait = time.Second * 4
)

// RemoteLock is a lock that can be released
type RemoteLock interface {
	Release(context.Context) error
}

// Lock the specified key and get a release method in return
func Lock(ctx context.Context, locker *redislock.Client, key string) (RemoteLock, error) {
	key = "locks:" + key
	lock, err := locker.Obtain(
		ctx,
		key,
		lockTTL,
		// The retry strategy is stateful, so it has to be constructed per call.
		&redislock.Options{RetryStrategy: redislock.LimitRetry(
			redislock.LinearBackoff(lockRetryInterval),
			int(lockWait/lockRetryInterval),
		)},
	)
	if err != nil {
		return nil, err
	}
	return lock, nil
}

// lockContended reports whether a Lock error is ordinary contention or cancellation
// rather than an actual failure to talk to redis. redislock bounds Obtain with its own
// now+ttl deadline, so a fully contended lock surfaces as a deadline error rather than
// ErrNotObtained; a disconnecting client cancels the request context the same way.
// None of these are actionable, so callers log them below error level.
func lockContended(err error) bool {
	return errors.Is(err, redislock.ErrNotObtained) ||
		errors.Is(err, context.DeadlineExceeded) ||
		errors.Is(err, context.Canceled)
}

// Release the lock with logging the error occuring
func Release(ctx context.Context, lock RemoteLock) {
	if lock == nil {
		return
	}
	err := lock.Release(ctx)
	if err != nil {
		if errors.Is(err, redislock.ErrLockNotHeld) {
			// The lease expired before we were done, which is expected when the
			// factory outruns lockTTL. Another worker may have redone the work.
			log.L.Warn().Err(err).Msg("Remote lock expired before release")
			return
		}
		log.L.Error().Err(err).Msg("Releasing remote lock failed")
	}
}
