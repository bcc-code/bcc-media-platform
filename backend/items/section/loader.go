package section

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for sections
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Section] {
	return common.NewBatchLoader(queries.GetSections)
}
