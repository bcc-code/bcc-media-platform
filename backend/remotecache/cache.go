package remotecache

import (
	"context"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/bsm/redislock"
	"github.com/redis/go-redis/v9"
	"github.com/vmihailenco/msgpack/v5"
	"time"
)

// RemoteLock is a lock that can be released
type RemoteLock interface {
	Release(context.Context) error
}

// Options are definable options for caching an entry
type Options struct {
	expiry time.Duration
}

// SetTTL sets the relative expiration of the key
func (o *Options) SetTTL(ttl time.Duration) {
	o.expiry = ttl
}

// Nil is the error value in case the specified key does not exist
var Nil = redis.Nil

// KeepTTL keeps the old TTL
var KeepTTL = redis.KeepTTL

// Get the specified key. Returns Nil as error if not present
func Get[T any](ctx context.Context, client *redis.Client, key string) (T, error) {
	result := client.Get(ctx, key)
	var value T
	if result.Err() != nil {
		return value, result.Err()
	}
	bs, err := result.Bytes()
	if err != nil {
		return value, err
	}
	err = msgpack.Unmarshal(bs, &value)
	return value, err
}

// Set the specified key to the provided value with ttl.
func Set[T any](ctx context.Context, client *redis.Client, key string, value T, ttl time.Duration) error {
	marshalled, err := msgpack.Marshal(value)
	if err != nil {
		return err
	}
	return client.Set(ctx, key, marshalled, ttl).Err()
}

// GetOrCreate the cache entry
func GetOrCreate[T any](ctx context.Context, rc *Client, key string, valueFactory func(*Options) (T, error)) (T, error) {
	client := rc.Client()
	result := client.Get(ctx, key)
	var value T
	if result.Err() == nil {
		bs, err := result.Bytes()
		if err != nil {
			return value, err
		}
		err = msgpack.Unmarshal(bs, &value)
		return value, err
	} else if result.Err() != Nil {
		return value, result.Err()
	}
	options := &Options{}
	lock, err := Lock(ctx, rc.Locker(), key)
	defer Release(ctx, lock)
	value, err = valueFactory(options)
	if err != nil {
		return value, err
	}
	str, err := msgpack.Marshal(value)
	if err != nil {
		return value, err
	}
	status := client.Set(ctx, key, str, options.expiry)
	return value, status.Err()
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
