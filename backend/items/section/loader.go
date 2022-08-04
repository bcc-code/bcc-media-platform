package section

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Section
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Section] {
	return common.NewBatchLoader(queries.GetSections, func(row common.Section) int {
		return int(row.ID)
	})
}

// NewListBatchLoader returns related data for a page
func NewListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.Section] {
	return common.NewListBatchLoader(queries.GetSectionsForPageIDs, func(i common.Section) int {
		return i.PageID
	})
}
