package main

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/push"
	"github.com/bcc-code/brunstadtv/backend/scheduler"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/go-redsync/redsync/v4"
	"github.com/google/uuid"
	"time"
)

type modelHandler struct {
	queries   *sqlc.Queries
	push      *push.Service
	scheduler *scheduler.Service
	locker    *redsync.Redsync
}

func (h *modelHandler) handleModelUpdate(ctx context.Context, collection string, key string) error {
	switch collection {
	case "notifications":
		id := uuid.MustParse(key)
		lock, err := utils.RedisLock(h.locker, "notification")
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to retrieve redis lock")
		} else {
			// We want to keep running the function, but unlocking will fail if the lock failed
			defer utils.UnlockRedisLock(lock)
		}
		ns, err := h.queries.GetNotifications(ctx, []uuid.UUID{id})
		if err != nil {
			return err
		}
		for _, n := range ns {
			if n.Status != common.StatusPublished || n.Sent {
				continue
			}
			if n.ScheduleAt.Valid && n.ScheduleAt.Time.After(time.Now()) {
				err = h.scheduler.Queue(ctx, "notifications", key, n.ScheduleAt.Time)
				if err != nil {
					return err
				}
				continue
			}

			err = h.queries.MarkAsSent(ctx, id)
			if err != nil {
				return err
			}
			err = h.push.PushNotificationToEveryone(ctx, n)
			if err != nil {
				return err
			}
		}
	}
	return nil
}
