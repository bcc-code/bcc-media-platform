package episode

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
	"strconv"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.EpisodeExpanded] {
	return common.NewBatchLoader(queries.GetEpisodesWithTranslationsByID, func(row sqlc.EpisodeExpanded) int {
		return int(row.ID)
	})
}

// NewListBatchLoader returns related data for a season
func NewListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*sqlc.EpisodeExpanded] {
	return common.NewKeyedListBatchLoader(queries.GetEpisodesWithTranslationsForSeasons, func(i sqlc.EpisodeExpanded) int {
		return int(i.SeasonID.Int64)
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

// GetEpisodesForSeason retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as available)
func GetEpisodesForSeason(ctx context.Context, loader *dataloader.Loader[int, []*sqlc.EpisodeExpanded], id string) ([]*sqlc.EpisodeExpanded, error) {
	intID, _ := strconv.ParseInt(id, 10, 32)
	thunk := loader.Load(ctx, int(intID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
