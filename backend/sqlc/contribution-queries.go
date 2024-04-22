package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (q *Queries) GetContributionsForPersons(ctx context.Context, ids []uuid.UUID) ([]loaders.Relation[int32, uuid.UUID], error) {
	rows, err := q.getContributionIDsForPersons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionIDsForPersonsRow, _ int) loaders.Relation[int32, uuid.UUID] {
		return relation[int32, uuid.UUID](i)
	}), nil
}

func (q *Queries) GetContributionTypesForPersons(ctx context.Context, ids []uuid.UUID) ([]common.ContributionTypeCount, error) {
	rows, err := q.getContributionTypesForPersons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionTypesForPersonsRow, _ int) common.ContributionTypeCount {
		return common.ContributionTypeCount{
			Type:     common.ContributionType(i.Type.String),
			Count:    int(i.Count),
			PersonId: i.PersonID,
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
			ItemID:   i.ItemID.UUID.String(),
			ItemType: i.ItemType,
			Type:     common.ContributionType(i.Type.String),
			PersonID: i.PersonID.UUID.String(),
		}
	}), nil
}
