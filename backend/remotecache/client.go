package remotecache

import (
	"context"
	"github.com/bsm/redislock"
	"github.com/redis/go-redis/v9"
)

// Client contains the client and locker
type Client struct {
	client *redis.Client
	locker *redislock.Client
}

// New remote cache struct
func New(client *redis.Client, locker *redislock.Client) *Client {
	return &Client{
		client,
		locker,
	}
}

// Client returns the redis client
func (rc *Client) Client() *redis.Client {
	return rc.client
}

// Locker returns the redis locker
func (rc *Client) Locker() *redislock.Client {
	return rc.locker
}

// Lock returns a new lock
func (rc *Client) Lock(ctx context.Context, key string) (RemoteLock, error) {
	return Lock(ctx, rc.Locker(), key)
}
