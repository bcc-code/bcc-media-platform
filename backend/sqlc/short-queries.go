package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
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
			MediaID:     i.MediaID,
			AssetID:     i.AssetID,
			Title:       toLocaleString(i.Title, i.OriginalTitle.String),
			Description: toLocaleString(i.Description, i.OriginalDescription.String),
			EpisodeID:   i.ParentEpisodeID,
			StartsAt:    startsAt,
			EndsAt:      endsAt,
			Images:      q.getImages(i.Images),
			DateUpdated: i.DateUpdated,
			Status:      common.Status(i.Status),
			Label:       i.Label,
		}
	}), nil
}

// GetMediaIDsForShortIDs returns media ids for the requested shortIds
func (q *Queries) GetMediaIDsForShortIDs(ctx context.Context, ids []uuid.UUID) ([]loaders.Conversion[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getMediaIDForShorts(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getMediaIDForShortsRow, _ int) loaders.Conversion[uuid.UUID, uuid.UUID] {
		return conversion[uuid.UUID, uuid.UUID]{
			source: i.ID,
			result: i.MediaitemID.UUID,
		}
	}), nil
}

// GetShortsByMediaItemIDs returns shorts by media item ids
func (q *Queries) GetShortsByMediaItemIDs(ctx context.Context, id uuid.UUID) ([]common.Short, error) {
	rows, err := q.getShortsByMediaItemID(ctx, id)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getShortsByMediaItemIDRow, _ int) common.Short {
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
			MediaID:     i.MediaID,
			AssetID:     i.AssetID,
			Title:       toLocaleString(i.Title, i.OriginalTitle.String),
			Description: toLocaleString(i.Description, i.OriginalDescription.String),
			EpisodeID:   i.ParentEpisodeID,
			StartsAt:    startsAt,
			EndsAt:      endsAt,
			Images:      q.getImages(i.Images),
			Label:       i.Label,
			DateUpdated: i.DateUpdated,
			Status:      common.Status(i.Status),
		}
	}), nil
}
