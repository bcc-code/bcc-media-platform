package common

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewListBatchLoader returns a configured batch loader for Lists
func NewListBatchLoader[t any](
	factory func(ctx context.Context, ids []int32) ([]t, error),
	getKey func(item t) int,
) *dataloader.Loader[int, []*t] {
	batchLoadLists := func(ctx context.Context, keys []int) []*dataloader.Result[[]*t] {
		var results []*dataloader.Result[[]*t]

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := factory(ctx, ids)

		resMap := map[int][]*t{}

		if err == nil {
			for _, r := range res {
				key := getKey(r)

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*t{}
				}
				item := r
				resMap[key] = append(resMap[key], &item)
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[[]*t]{
				Error: err,
			}

			if val, ok := resMap[k]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}
	return dataloader.NewBatchedLoader(batchLoadLists)
}

// NewBatchLoader returns a configured batch loader for GQL Episode
func NewBatchLoader[t any](
	factory func(ctx context.Context, ids []int32) ([]t, error),
	getID func(item t) int,
) *dataloader.Loader[int, *t] {
	batchLoadItems := func(ctx context.Context, keys []int) []*dataloader.Result[*t] {
		var results []*dataloader.Result[*t]

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := factory(ctx, ids)

		resMap := map[int]*t{}

		if err == nil {
			for _, r := range res {
				resMap[getID(r)] = &r
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[*t]{
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
	return dataloader.NewBatchedLoader(batchLoadItems)
}

// GetFromLoaderByID returns the object from the loader
func GetFromLoaderByID[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, *t], id k) (*t, error) {
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
