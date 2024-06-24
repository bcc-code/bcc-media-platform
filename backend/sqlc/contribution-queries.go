package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (q *RoleQueries) GetContributionsForPersonsWithRoles(ctx context.Context, ids []uuid.UUID) ([]common.Contribution, error) {
	rows, err := q.queries.getContributionIDsForPersonsWithRoles(ctx, getContributionIDsForPersonsWithRolesParams{
		PersonIds: ids,
		Roles:     q.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionIDsForPersonsWithRolesRow, _ int) common.Contribution {
		return common.Contribution{
			PersonID:    i.PersonID,
			Type:        i.Type,
			ItemID:      i.ItemID,
			ItemType:    i.ItemType,
			ContentType: i.ContentType,
			MediaItemID: i.MediaitemID,
		}
	}), nil
}
