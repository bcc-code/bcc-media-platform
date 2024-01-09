package notifications

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/targets"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// ResolveTargets resolves targetIDs to device tokens
func (u *Utils) ResolveTargets(ctx context.Context, applicationGroupID uuid.UUID, targetIDs []uuid.UUID) ([]common.Device, error) {
	log.L.Debug().Int("targetCount", len(targetIDs)).Msg("Resolving targets")
	targetRows, err := u.queries.GetTargets(ctx, targetIDs)
	if err != nil {
		return nil, err
	}

	var devices []common.Device
	for _, t := range targetRows {
		target := common.Target(t)
		ds, err := resolveDevices(ctx, u.queries, applicationGroupID, target)
		if err != nil {
			return nil, err
		}
		log.L.Debug().Int("deviceCount", len(ds)).Msg("Resolved target, retrieved devices")
		devices = append(devices, ds...)
	}
	return devices, nil
}

// resolveDevices resolves a target to specific devices
func resolveDevices(ctx context.Context, queries *sqlc.Queries, applicationGroupID uuid.UUID, target common.Target) ([]common.Device, error) {
	profileIDs, err := resolveProfileIDs(ctx, queries, applicationGroupID, target)
	if err != nil {
		return nil, err
	}

	devices, err := queries.GetDevices(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return devices, nil
}

// resolveProfileIDs resolves a target to specific profileIDs
func resolveProfileIDs(ctx context.Context, queries *sqlc.Queries, applicationGroupID uuid.UUID, target common.Target) ([]uuid.UUID, error) {
	userIDs, err := targets.ResolveUserIDs(ctx, queries, target)
	if err != nil {
		return nil, err
	}

	profiles, err := queries.ApplicationQueries(applicationGroupID).GetProfilesForUserIDs(ctx, userIDs)
	if err != nil {
		return nil, err
	}

	return lo.Map(profiles, func(i common.Profile, _ int) uuid.UUID {
		return i.ID
	}), nil
}
