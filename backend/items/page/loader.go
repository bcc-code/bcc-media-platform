package page

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for pages
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Page] {
	return common.NewBatchLoader(queries.GetPages)
}

// NewCodeBatchLoader returns a loader for batch loading
func NewCodeBatchLoader(queries sqlc.Queries) *dataloader.Loader[string, *common.Page] {
	return common.NewCustomBatchLoader(queries.GetPagesByCode, func(i common.Page) string {
		return i.Code
	})
}
