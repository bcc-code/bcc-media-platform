package program

import (
	"context"

	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, gqlmodel.Program] {
	batchLoadPrograms := func(ctx context.Context, keys []int) []*dataloader.Result[gqlmodel.Program] {
		results := []*dataloader.Result[gqlmodel.Program]{}

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := queries.GetEpisodesWithTrnaslationsByID(ctx, ids)

		resMap := map[int]gqlmodel.Program{}

		if err == nil {
			for _, r := range res {
				resMap[int(r.ID)] = r.AsGQL()
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[gqlmodel.Program]{
				Error: err,
			}

			if val, ok := resMap[k]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	return dataloader.NewBatchedLoader(batchLoadPrograms)
}

func GetByID(ctx context.Context, loader *dataloader.Loader[int, gqlmodel.Program], id int) (gqlmodel.Program, error) {
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
