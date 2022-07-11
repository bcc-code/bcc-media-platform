package episode

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/graph"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.EpisodeExpanded] {
	return graph.NewBatchLoader(queries.GetEpisodesWithTranslationsByID, func(row sqlc.EpisodeExpanded) int {
		return int(row.ID)
	})
}

// GetByID should be used for retrieving program data
//
// It uses the dataloader to efficiently load data from DB or cache (as available)
func GetByID(ctx context.Context, loader *dataloader.Loader[int, *sqlc.EpisodeExpanded], id int) (*sqlc.EpisodeExpanded, error) {
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
