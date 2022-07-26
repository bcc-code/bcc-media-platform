package page

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Section
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.PageExpanded] {
	return common.NewBatchLoader(queries.GetPages, func(row sqlc.PageExpanded) int {
		return int(row.ID)
	}, func(id int) int32 {
		return int32(id)
	})
}

// NewCodeBatchLoader returns a loader for batch loading
func NewCodeBatchLoader(queries sqlc.Queries) *dataloader.Loader[string, *sqlc.PageExpanded] {
	return common.NewBatchLoader(queries.GetPagesByCode, func(row sqlc.PageExpanded) string {
		return row.Code.ValueOrZero()
	}, func(id string) string {
		return id
	})
}
