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

func (q *Queries) GetContributionTypes(ctx context.Context, codes []string) ([]common.ContributionType, error) {
	rows, err := q.getContributionTypes(ctx, codes)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionTypesRow, _ int) common.ContributionType {
		return common.ContributionType{}
	}), nil
}

func (q *Queries) GetContributionTypesForPersons(ctx context.Context, ids []uuid.UUID) ([]common.ContributionTypeCount, error) {
	rows, err := q.getContributionTypesForPersons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionTypesForPersonsRow, _ int) common.ContributionTypeCount {
		return common.ContributionTypeCount{
			Type:     i.Type,
			PersonId: i.PersonID,
			Count:    i.Count,
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
