package notifications

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/samber/lo"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/google/uuid"
)

// ResolveTargets resolves targetIDs to device tokens
func (u *Utils) ResolveTargets(ctx context.Context, applicationGroupID uuid.UUID, targetIDs []uuid.UUID) ([]common.Device, error) {
	log.L.Debug().Int("targetCount", len(targetIDs)).Msg("Resolving targets")

	var devices []common.Device
	for _, t := range targetIDs {
		ds, err := u.queries.GetSegmentedDevicesForTarget(ctx,
			sqlc.GetSegmentedDevicesForTargetParams{
				TargetID:           t,
				ApplicationgroupID: applicationGroupID,
			})
		if err != nil {
			return nil, err
		}

		dsConv := lo.Map(ds, func(i sqlc.UsersDevice, _ int) common.Device {
			return common.Device(i)
		})

		log.L.Debug().Int("deviceCount", len(ds)).Msg("Resolved target, retrieved devices")
		devices = append(devices, dsConv...)
	}
	return devices, nil
}
