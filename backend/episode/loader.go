package episode

import (
	"context"

	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *gqlmodel.Episode] {
	batchLoadEpisodes := func(ctx context.Context, keys []int) []*dataloader.Result[*gqlmodel.Episode] {
		results := []*dataloader.Result[*gqlmodel.Episode]{}

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := queries.GetEpisodesWithTranslationsByID(ctx, ids)

		resMap := map[int]*gqlmodel.Episode{}

		if err == nil {
			for _, r := range res {
				gql := gqlmodel.EpisodeFromSQL(ctx, r)
				resMap[int(r.ID)] = &gql
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[*gqlmodel.Episode]{
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
	cache := &dataloader.NoCache[int, *gqlmodel.Episode]{}
	return dataloader.NewBatchedLoader(batchLoadEpisodes, dataloader.WithCache[int, *gqlmodel.Episode](cache))
}

// GetByID should be used for retrieving program data
//
// It uses the dataloader to efficiently load data from DB or cache (as avalilable)
func GetByID(ctx context.Context, loader *dataloader.Loader[int, *gqlmodel.Episode], id int) (*gqlmodel.Episode, error) {
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
