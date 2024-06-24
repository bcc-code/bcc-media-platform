package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (rq *Queries) GetPrimaryEpisodeIDForMediaItems(ctx context.Context, ids []uuid.UUID) ([]loaders.Conversion[uuid.UUID, int], error) {
	rows, err := rq.getPrimaryEpisodeIDForMediaItems(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(r getPrimaryEpisodeIDForMediaItemsRow, _ int) loaders.Conversion[uuid.UUID, int] {
		return conversion[uuid.UUID, int]{
			source: r.ID,
			result: int(r.PrimaryEpisodeID.Int64),
		}
	}), nil
}
