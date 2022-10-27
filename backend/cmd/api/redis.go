package main

import (
	"context"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/go-redis/redis/v9"
)

func mustCreateRedisClient(ctx context.Context, config redisConfig) *redis.Client {
	rdb := redis.NewClient(&redis.Options{
		Addr:     config.Address,
		Password: config.Password,
		Username: config.Username,
		DB:       config.Database,
	})

	status := rdb.Ping(ctx)
	if status.Err() != nil {
		log.L.Panic().Err(status.Err()).Msg("Failed to ping redis database")
	}

	return rdb
}
