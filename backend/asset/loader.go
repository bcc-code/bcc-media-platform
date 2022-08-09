package asset

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchFilesLoader returns a configured batch loader for GQL File
func NewBatchFilesLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.File] {
	return common.NewListBatchLoader(queries.GetFilesForEpisodes, func(row common.File) int {
		return row.EpisodeID
	})
}

// NewBatchStreamsLoader returns a configured batch loader for GQL Stream
func NewBatchStreamsLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.Stream] {
	return common.NewListBatchLoader(queries.GetStreamsForEpisodes, func(row common.Stream) int {
		return row.EpisodeID
	})
}
