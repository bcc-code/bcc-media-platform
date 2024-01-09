package main

import (
	"context"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/members"
	"github.com/bcc-code/bcc-media-platform/backend/notifications"
	"github.com/bcc-code/bcc-media-platform/backend/push"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/scheduler"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

type modelHandler struct {
	queries           *sqlc.Queries
	push              *push.Service
	scheduler         *scheduler.Service
	remoteCache       *remotecache.Client
	members           *members.Client
	notificationUtils *notifications.Utils
}

func (h *modelHandler) handleModelUpdate(ctx context.Context, collection string, key string) error {
	switch collection {
	case "notifications":
		id, err := uuid.Parse(key)
		if err != nil {
			return err
		}
		lock, err := h.remoteCache.Lock(ctx, "notification-model-update")
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to retrieve redis lock")
		} else {
			// We want to keep running the function, but unlocking will fail if the lock failed
			defer remotecache.Release(ctx, lock)
		}
		ns, err := h.queries.GetNotifications(ctx, []uuid.UUID{id})
		if err != nil {
			return err
		}
		for _, n := range ns {
			log.L.Debug().Str("notification", n.ID.String()).Msg("Processing notification update")
			if n.Status != common.StatusPublished || n.SendStarted.Valid {
				log.L.Debug().Msg("Skipping push of notification as it's not published or already sent.")
				continue
			}
			if n.ScheduleAt.Valid && n.ScheduleAt.Time.After(time.Now()) {
				log.L.Debug().Msg("Scheduling notification.")
				err = h.scheduler.Queue(ctx, "notifications", key, n.ScheduleAt.Time)
				if err != nil {
					return err
				}
				continue
			}

			service := h.push
			if n.FirebaseProjectID.Valid {
				service, err = push.NewService(ctx, n.FirebaseProjectID.String, h.queries)
				if err != nil {
					return err
				}
			}

			log.L.Debug().Msg("Marking notification as send started.")
			err = h.queries.NotificationMarkSendStarted(ctx, id)
			if err != nil {
				return err
			}
			var devices []common.Device
			if len(n.TargetIDs) > 0 {
				devices, err = h.notificationUtils.ResolveTargets(ctx, n.ApplicationGroupID, n.TargetIDs)
				if err != nil {
					return err
				}
			} else {
				var rows []sqlc.ListDevicesInApplicationGroupRow
				rows, err = h.queries.ListDevicesInApplicationGroup(ctx, n.ApplicationGroupID)
				if err != nil {
					return err
				}
				devices = lo.Map(rows, func(r sqlc.ListDevicesInApplicationGroupRow, _ int) common.Device {
					return common.Device(r)
				})
			}
			err = service.SendNotificationToDevices(ctx, devices, n)
			if err != nil {
				return err
			}
			err = h.queries.NotificationMarkSendCompleted(ctx, id)
			if err != nil {
				return err
			}
		}
	}
	return nil
}
