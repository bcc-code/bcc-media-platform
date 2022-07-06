package asset

import (
	"context"
	"strconv"

	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewBatchLoader returns a configured batch loader for GQL File
func NewBatchFileLoader(queries sqlc.Queries) *dataloader.Loader[int, []*gqlmodel.File] {
	batchLoadFiles := func(ctx context.Context, keys []int) []*dataloader.Result[[]*gqlmodel.File] {
		results := []*dataloader.Result[[]*gqlmodel.File]{}

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := queries.GetFilesForEpisodes(ctx, ids)

		resMap := map[int][]*gqlmodel.File{}

		if err == nil {
			for _, r := range res {

				if _, ok := resMap[int(r.ID)]; !ok {
					resMap[int(r.ID)] = []*gqlmodel.File{}
				}

				gql := gqlmodel.FileFromSQL(ctx, r)
				resMap[int(r.ID)] = append(resMap[int(r.ID)], gql)
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[[]*gqlmodel.File]{
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
	cache := &dataloader.NoCache[int, []*gqlmodel.File]{}
	return dataloader.NewBatchedLoader(batchLoadFiles, dataloader.WithCache[int, []*gqlmodel.File](cache))
}

// GetFilesForEpisode retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as avalilable)
func GetFilesForEpisode(ctx context.Context, loader *dataloader.Loader[int, []*gqlmodel.File], id string) ([]*gqlmodel.File, error) {
	intID, _ := strconv.ParseInt(id, 10, 32)
	thunk := loader.Load(ctx, int(intID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
