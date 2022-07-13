package show

import (
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
