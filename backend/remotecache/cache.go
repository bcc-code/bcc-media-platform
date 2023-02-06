package remotecache

import (
	"context"
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
	lock, err := Lock(ctx, rc.Locker(), key)
	defer Release(ctx, lock)
	value, err = valueFactory(options)
	if err != nil {
		return value, err
	}
	err = Set(ctx, rc.Client(), key, value, options.expiry)
	return value, err
}
