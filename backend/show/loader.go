package show

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.ShowExpanded] {
	return common.NewBatchLoader(queries.GetShowsWithTranslationsByID, func(row sqlc.ShowExpanded) int {
		return int(row.ID)
	})
}

// GetByID should be used for retrieving data
//
// It uses the dataloader to efficiently load data from DB or cache (as available)
func GetByID(ctx context.Context, loader *dataloader.Loader[int, *sqlc.ShowExpanded], id int) (*sqlc.ShowExpanded, error) {
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
