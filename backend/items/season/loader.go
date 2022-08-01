package season

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.SeasonExpanded] {
	return common.NewBatchLoader(queries.GetSeasonsWithTranslationsByID, func(row sqlc.SeasonExpanded) int {
		return int(row.ID)
	}, func(id int) int32 {
		return int32(id)
	})
}

// NewListBatchLoader returns related data for a show
func NewListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*sqlc.SeasonExpanded] {
	return common.NewListBatchLoader(queries.GetSeasonsWithTranslationsForShows, func(i sqlc.SeasonExpanded) int {
		return int(i.ShowID)
	}, func(id int) int32 {
		return int32(id)
	})
}
