package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (q *RoleQueries) GetContributionsForPersonsWithRoles(ctx context.Context, ids []uuid.UUID) ([]loaders.Relation[int32, uuid.UUID], error) {
	rows, err := q.queries.getContributionIDsForPersonsWithRoles(ctx, getContributionIDsForPersonsWithRolesParams{
		PersonIds: ids,
		Roles:     q.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionIDsForPersonsWithRolesRow, _ int) loaders.Relation[int32, uuid.UUID] {
		return relation[int32, uuid.UUID](i)
	}), nil
}

func (q *Queries) GetContributionCountByType(ctx context.Context, ids []int32) ([]common.ContributionTypeCount, error) {
	rows, err := q.getContributionCountByType(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionCountByTypeRow, _ int) common.ContributionTypeCount {
		return common.ContributionTypeCount{
			Type:  i.Type,
			Count: int(i.Count),
		}
	}), nil
}

func (q *Queries) GetContributions(ctx context.Context, ids []int32) ([]common.Contribution, error) {
	rows, err := q.getContributionItems(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionItemsRow, _ int) common.Contribution {
		return common.Contribution{
			ID:       i.ID,
			ItemID:   i.ItemID,
			ItemType: i.ItemType,
			Type:     i.Type,
			PersonID: i.PersonID.UUID.String(),
		}
	}), nil
}
