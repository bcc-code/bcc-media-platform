package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// SaveDevice saves the specified device to database, keyed by token and profileId
func (q *Queries) SaveDevice(ctx context.Context, device common.Device) error {
	return q.setDeviceToken(ctx, setDeviceTokenParams{
		Column1: device.Token,
		Column2: device.ProfileID,
		Column3: device.UpdatedAt,
		Column4: device.Name,
	})
}

// GetDevices returns devices for the specified profileIDs
func (q *Queries) GetDevices(ctx context.Context, profileIDs []uuid.UUID) ([]common.Device, error) {
	devices, err := q.getDevicesForProfiles(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(devices, func(i UsersDevice, _ int) common.Device {
		return common.Device(i)
	}), nil
}
