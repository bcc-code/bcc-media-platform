package utils

import (
	"context"
	"github.com/samber/lo"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/redis/go-redis/v9"
)

// RedisConfig contains configuration of the redis client
type RedisConfig struct {
	Address  string
	Username string
	Password string
	Database int
}

// MustCreateRedisClient throws a panic if redis is not reachable
func MustCreateRedisClient(ctx context.Context, config RedisConfig) (*redis.Client, <-chan error) {
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

	return rdb, lo.Async(func() error {
		err := rdb.Ping(ctx).Err()
		if err != nil {
			return err
		}
		log.L.Info().Msg("RDB setup")
		return nil
	})
}
