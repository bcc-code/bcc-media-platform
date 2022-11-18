package utils

import (
	"context"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/go-redis/redis/v9"
)

// RedisConfig contains configuration of the redis client
type RedisConfig struct {
	Address  string
	Username string
	Password string
	Database int
}

// MustCreateRedisClient throws a panic if redis is not reachable
func MustCreateRedisClient(ctx context.Context, config RedisConfig) *redis.Client {
	rdb := redis.NewClient(&redis.Options{
		Addr:     config.Address,
		Username: config.Username,
		Password: config.Password,
		DB:       config.Database,
	})

	status := rdb.Ping(ctx)
	if status.Err() != nil {
		log.L.Panic().Err(status.Err()).Msg("Failed to ping redis database")
	}

	return rdb
}
