package season

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
	"strconv"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.SeasonExpanded] {
	return common.NewBatchLoader(queries.GetSeasonsWithTranslationsByID, func(row sqlc.SeasonExpanded) int {
		return int(row.ID)
	})
}

// NewListBatchLoader returns related data for a show
func NewListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*sqlc.SeasonExpanded] {
	return common.NewKeyedListBatchLoader(queries.GetSeasonsWithTranslationsForShows, func(i sqlc.SeasonExpanded) int {
		return int(i.ShowID)
	})
}

// GetByID should be used for retrieving data
//
// It uses the dataloader to efficiently load data from DB or cache (as available)
func GetByID(ctx context.Context, loader *dataloader.Loader[int, *sqlc.SeasonExpanded], id int) (*sqlc.SeasonExpanded, error) {
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}

// GetSeasonsForShow retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as available)
func GetSeasonsForShow(ctx context.Context, loader *dataloader.Loader[int, []*sqlc.SeasonExpanded], id string) ([]*sqlc.SeasonExpanded, error) {
	intID, _ := strconv.ParseInt(id, 10, 32)
	thunk := loader.Load(ctx, int(intID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
