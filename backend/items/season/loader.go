package season

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for seasons
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Season] {
	return common.NewBatchLoader(queries.GetSeasons)
}

// NewListBatchLoader returns related data for a show
func NewListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.Season] {
	return common.NewListBatchLoader(queries.GetSeasonsForShows, func(i common.Season) int {
		return i.ShowID
	})
}
