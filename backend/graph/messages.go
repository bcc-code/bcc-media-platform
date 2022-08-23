package graph

import (
	"context"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"sync"
	"time"
)

type timedCacheEntry struct {
	Cached time.Time
	Entry  any
}

var messageCache = cache.New[string, timedCacheEntry]()

var messageLock = sync.Mutex{}

func getMessagesFromCache(timestamp *time.Time) ([]common.MaintenanceMessage, bool) {
	if messages, ok := messageCache.Get("maintenance"); ok && (timestamp == nil || messages.Cached.Equal(*timestamp) || messages.Cached.After(*timestamp)) {
		return messages.Entry.([]common.MaintenanceMessage), true
	}
	return nil, false
}

var truncateTimeInterval time.Duration = 1

func (r *Resolver) getMaintenanceMessages(ctx context.Context, timestamp *time.Time) ([]common.MaintenanceMessage, error) {
	// Truncate time to avoid updating again within seconds
	if timestamp != nil {
		if timestamp.After(time.Now()) {
			return nil, merry.New("invalid time (future)")
		}
		truncated := timestamp.Truncate(time.Second * truncateTimeInterval)
		timestamp = &truncated
	}
	if messages, ok := getMessagesFromCache(timestamp); ok {
		return messages, nil
	}

	// Locking or waiting for another locked thread to complete
	messageLock.Lock()
	defer messageLock.Unlock()

	if messages, ok := getMessagesFromCache(timestamp); ok {
		return messages, nil
	}

	messages, err := r.Queries.GetMaintenanceMessages(ctx)
	if err != nil {
		return nil, err
	}

	messageCache.Set("maintenance", timedCacheEntry{
		Cached: time.Now().Truncate(time.Second * truncateTimeInterval),
		Entry:  messages,
	}, cache.WithExpiration(time.Minute*10))

	return messages, nil
}
