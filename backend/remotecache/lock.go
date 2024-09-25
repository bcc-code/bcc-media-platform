package remotecache

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bsm/redislock"

	"time"
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
		time.Second*10,
		&redislock.Options{RetryStrategy: redislock.LimitRetry(redislock.LinearBackoff(time.Millisecond*100), 20)},
	)
	if err != nil {
		return nil, err
	}
	return lock, nil
}

// Release the lock with logging the error occuring
func Release(ctx context.Context, lock RemoteLock) {
	err := lock.Release(ctx)
	if err != nil {
		log.L.Error().Err(err).Send()
	}
}
