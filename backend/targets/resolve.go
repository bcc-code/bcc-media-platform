package targets

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

const targetTypeUsergroups = "usergroups"

// ResolveUserIDs resolves a target to specific userIDs
func ResolveUserIDs(ctx context.Context, queries *sqlc.Queries, target common.Target) ([]string, error) {
	if target.Type != targetTypeUsergroups {
		return nil, nil
	}
	return queries.GetUserIDsWithRoles(ctx, target.GroupCodes)
}

// ResolveProfileIDs resolves a target to specific profileIDs
func ResolveProfileIDs(ctx context.Context, queries *sqlc.Queries, target common.Target) ([]uuid.UUID, error) {
	userIDs, err := ResolveUserIDs(ctx, queries, target)
	if err != nil {
		return nil, err
	}

	profiles, err := queries.ApplicationQueries(target.ApplicationGroupID).GetProfilesForUserIDs(ctx, userIDs)
	if err != nil {
		return nil, err
	}

	return lo.Map(profiles, func(i common.Profile, _ int) uuid.UUID {
		return i.ID
	}), nil
}

// ResolveDevices resolves a target to specific devices
func ResolveDevices(ctx context.Context, queries *sqlc.Queries, target common.Target) ([]common.Device, error) {
	profileIDs, err := ResolveProfileIDs(ctx, queries, target)
	if err != nil {
		return nil, err
	}

	devices, err := queries.GetDevices(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return devices, nil
}
