package graph

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/google/uuid"
)

// loadSongsForMediaItem batch-loads the songs linked to a mediaitem via the
// mediaitems_songs junction table. Returns model.Song slices ready for GQL.
func (r *Resolver) loadSongsForMediaItem(ctx context.Context, mediaItemID uuid.UUID) ([]*model.Song, error) {
	songIDPtrs, err := r.Loaders.SongIDsForMediaItemLoader.Get(ctx, mediaItemID)
	if err != nil {
		return nil, err
	}
	if len(songIDPtrs) == 0 {
		return []*model.Song{}, nil
	}

	songIDs := make([]uuid.UUID, 0, len(songIDPtrs))
	for _, p := range songIDPtrs {
		if p != nil {
			songIDs = append(songIDs, *p)
		}
	}

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
