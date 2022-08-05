package episode

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Episode] {
	return common.NewBatchLoader(queries.GetEpisodes)
}

// NewListBatchLoader returns related data for a season
func NewListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.Episode] {
	return common.NewListBatchLoader(queries.GetEpisodesForSeasons, func(i common.Episode) int {
		return int(i.SeasonID.Int64)
	})
}
