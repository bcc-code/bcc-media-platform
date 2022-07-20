package collection

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Collection
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.CollectionExpanded] {
	return common.NewBatchLoader(queries.GetCollections, func(row sqlc.CollectionExpanded) int {
		return int(row.ID)
	}, func(id int) int32 {
		return int32(id)
	})
}
