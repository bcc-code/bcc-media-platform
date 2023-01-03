package notifications

import (
	"context"
	"github.com/google/uuid"
)

// ResolveTargets resolves targetIDs to device tokens
func (u *Utils) ResolveTargets(ctx context.Context, targetIDs []uuid.UUID) ([]string, error) {
	targets, err := u.queries.GetTargets(ctx, targetIDs)
	if err != nil {
		return nil, err
	}

	var deviceTokens []string

	for _, t := range targets {
		switch t.Type {
		case "usergroups":
			groups, err := u.queries.GetRolesWithCode(ctx, t.Codes)
		}
	}

	return deviceTokens, nil
}
