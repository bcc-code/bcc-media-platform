package targets

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
)

const targetTypeUsergroups = "usergroups"

// ResolveUserIDs resolves a target to specific userIDs
func ResolveUserIDs(ctx context.Context, queries *sqlc.Queries, target common.Target) ([]string, error) {
	if target.Type != targetTypeUsergroups {
		return nil, nil
	}
	return queries.GetUserIDsWithRoles(ctx, target.GroupCodes)
}
