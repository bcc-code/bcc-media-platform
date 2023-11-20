package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

// GetShorts returns shorts by IDs from the database
func (q *Queries) GetShorts(ctx context.Context, ids []uuid.UUID) ([]common.Short, error) {
	rows, err := q.getShorts(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getShortsRow, _ int) common.Short {
		var startsAt null.Float
		var endsAt null.Float
		if i.ParentStartsAt.Valid {
			startsAt.SetValid(i.ParentStartsAt.Float64)
		}
		if i.ParentEndsAt.Valid {
			endsAt.SetValid(i.ParentEndsAt.Float64)
		}
		return common.Short{
			ID:          i.ID,
			AssetID:     i.AssetID,
			Title:       toLocaleString(i.Title, i.OriginalTitle.String),
			Description: toLocaleString(i.Description, i.OriginalDescription.String),
			EpisodeID:   i.ParentEpisodeID,
			StartsAt:    startsAt,
			EndsAt:      endsAt,
			Images:      q.getImages(i.Images),
		}
	}), nil
}
