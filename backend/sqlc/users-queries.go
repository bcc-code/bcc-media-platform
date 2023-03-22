package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

// GetUsers from database
func (q *Queries) GetUsers(ctx context.Context, ids []string) ([]common.User, error) {
	rows, err := q.getUsers(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getUsersRow, _ int) common.User {
		ag := i.AgeGroup
		if ag == "" {
			ag = "unknown"
		}
		return common.User{
			PersonID:      i.ID,
			Gender:        i.Gender,
			FirstName:     i.FirstName,
			EmailVerified: i.EmailVerified,
			Anonymous:     false,
			Roles:         i.Roles,
			Age:           int(i.Age),
			AgeGroup:      ag,
			ActiveBCC:     i.ActiveBcc,
			Email:         i.Email,
			ChurchIDs:     int32ToInt(i.ChurchIds),
			DisplayName:   i.DisplayName,
		}
	}), nil
}
