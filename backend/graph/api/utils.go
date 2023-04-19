package graph

import (
	"context"
	"time"
)

func withTimestampExpiration(ctx context.Context, key string, timestamp *string, onExpire func()) {
	_, _ = withCacheAndTimestamp(ctx, key, func(ctx context.Context) (bool, error) {
		onExpire()
		return true, nil
	}, time.Minute, timestamp)
}
