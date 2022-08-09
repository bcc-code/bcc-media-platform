package show

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for shows
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Show] {
	return common.NewBatchLoader(queries.GetShows)
}
