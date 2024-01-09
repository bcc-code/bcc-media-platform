package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// SaveDevice saves the specified device to database, keyed by token and profileId
func (q *Queries) SaveDevice(ctx context.Context, device common.Device) error {
	return q.setDeviceToken(ctx, setDeviceTokenParams{
		Token:     device.Token,
		ProfileID: device.ProfileID,
		UpdatedAt: device.UpdatedAt,
		Name:      device.Name,
		Languages: device.Languages,
	})
}

// GetDevices returns devices for the specified profileIDs
func (q *Queries) GetDevices(ctx context.Context, profileIDs []uuid.UUID) ([]common.Device, error) {
	devices, err := q.getDevicesForProfiles(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(devices, func(i getDevicesForProfilesRow, _ int) common.Device {
		return common.Device(i)
	}), nil
}

// ListDevices return all devices
func (q *Queries) ListDevices(ctx context.Context) ([]common.Device, error) {
	devices, err := q.listDevices(ctx)
	if err != nil {
		return nil, err
	}
	return lo.Map(devices, func(i listDevicesRow, _ int) common.Device {
		return common.Device(i)
	}), nil
}
