package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// GetComputedDataForGroups returns computed data for specified groups
func (q *Queries) GetComputedDataForGroups(ctx context.Context, ids []uuid.UUID) ([]common.ComputedData, error) {
	rows, err := q.getComputedForGroups(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getComputedForGroupsRow, _ int) common.ComputedData {
		var conditions []common.ComputedCondition
		_ = json.Unmarshal(i.Conditions, &conditions)

		return common.ComputedData{
			GroupID:    i.GroupID,
			ID:         i.ID,
			Result:     i.Result,
			Conditions: conditions,
		}
	}), nil
}
