package episode

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.EpisodeExpanded] {
	return common.NewBatchLoader(queries.GetEpisodesWithTranslationsByID, func(row sqlc.EpisodeExpanded) int {
		return int(row.ID)
	})
}

// NewListBatchLoader returns related data for a season
func NewListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*sqlc.EpisodeExpanded] {
	return common.NewKeyedListBatchLoader(queries.GetEpisodesWithTranslationsForSeasons, func(i sqlc.EpisodeExpanded) int {
		return int(i.SeasonID.Int64)
	})
}
