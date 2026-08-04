package remotecache

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/redis/go-redis/v9"
	"github.com/vmihailenco/msgpack/v5"
	"time"
)

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
	value, err := Get[T](ctx, rc.Client(), key)
	if err == nil {
		return value, nil
	}
	if err != Nil {
		return value, err
	}
	options := &Options{
		expiry: time.Minute,
	}
	lock, lockErr := Lock(ctx, rc.Locker(), key)
	if lockErr != nil {
		// Proceed without the lock: doing the work twice is preferable to failing the
		// request. Note that lock is nil here, so it must not be released.
		ev := log.L.Error()
		if lockContended(lockErr) {
			ev = log.L.Warn()
		}
		ev.Err(lockErr).Str("key", key).Msg("Failed to obtain remote cache lock")
	} else {
		defer Release(ctx, lock)
	}

	// Whoever held the lock has likely populated the key by now. Any error here just
	// means we fall through and produce the value ourselves.
	if value, err := Get[T](ctx, rc.Client(), key); err == nil {
		return value, nil
	}

	value, err = valueFactory(options)
	if err != nil {
		return value, err
	}
	err = Set(ctx, rc.Client(), key, value, options.expiry)
	return value, err
}
