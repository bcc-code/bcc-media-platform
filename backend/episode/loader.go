package episode

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.EpisodeExpanded] {
	batchLoadEpisodes := func(ctx context.Context, keys []int) []*dataloader.Result[*sqlc.EpisodeExpanded] {
		results := []*dataloader.Result[*sqlc.EpisodeExpanded]{}

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := queries.GetEpisodesWithTranslationsByID(ctx, ids)

		resMap := map[int]*sqlc.EpisodeExpanded{}

		if err == nil {
			for _, r := range res {
				resMap[int(r.ID)] = &r
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[*sqlc.EpisodeExpanded]{
				Error: err,
			}

			if val, ok := resMap[k]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	// Currently we do not want to cache at the GQL level
	return dataloader.NewBatchedLoader(batchLoadEpisodes)
}

// GetByID should be used for retrieving program data
//
// It uses the dataloader to efficiently load data from DB or cache (as avalilable)
func GetByID(ctx context.Context, loader *dataloader.Loader[int, *sqlc.EpisodeExpanded], id int) (*sqlc.EpisodeExpanded, error) {
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
