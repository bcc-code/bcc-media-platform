package targets

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// ResolveUserIDs resolves a target to specific userIDs
func ResolveUserIDs(ctx context.Context, queries *sqlc.Queries, target common.Target) ([]string, error) {
	return queries.GetUserIDsWithRoles(ctx, target.GroupCodes)

}

// ResolveProfileIDs resolves a target to specific profileIDs
func ResolveProfileIDs(ctx context.Context, queries *sqlc.Queries, applicationGroupID uuid.UUID, target common.Target) ([]uuid.UUID, error) {
	userIDs, err := ResolveUserIDs(ctx, queries, target)
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
