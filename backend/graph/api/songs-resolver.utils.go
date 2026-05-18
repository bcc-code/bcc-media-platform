package graph

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/google/uuid"
)

// loadSongsForMediaItem batch-loads the songs linked to a mediaitem via the
// mediaitems_songs junction table. Returns model.Song slices ready for GQL.
func (r *Resolver) loadSongsForMediaItem(ctx context.Context, mediaItemID uuid.UUID) ([]*model.Song, error) {
	songIDMappings, err := r.Loaders.SongIDsForMediaItemLoader.Get(ctx, mediaItemID)
	if err != nil {
		return nil, err
	}
	if len(songIDMappings) == 0 {
		return []*model.Song{}, nil
	}

	songIDs := common.MappingValues(songIDMappings)

	songs, err := r.Loaders.SongLoader.GetMany(ctx, songIDs)
	if err != nil {
		return nil, err
	}

	out := make([]*model.Song, 0, len(songs))
	for _, s := range songs {
		if s == nil {
			continue
		}
		out = append(out, model.SongFrom(ctx, s))
	}
	return out, nil
}
