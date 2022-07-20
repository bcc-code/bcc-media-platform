package page

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Section
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.Page] {
	return common.NewBatchLoader(queries.GetPages, func(row sqlc.Page) int {
		return int(row.ID)
	}, func(id int) int32 {
		return int32(id)
	})
}
