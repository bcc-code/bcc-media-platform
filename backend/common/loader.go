package common

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewListBatchLoader returns a configured batch loader for Lists
func NewListBatchLoader[k comparable, kd comparable, t any](
	factory func(ctx context.Context, ids []kd) ([]t, error),
	getKey func(item t) k,
	toDBKey func(key k) kd,
) *dataloader.Loader[k, []*t] {
	batchLoadLists := func(ctx context.Context, keys []k) []*dataloader.Result[[]*t] {
		var results []*dataloader.Result[[]*t]

		ids := lo.Map(keys, func(key k, _ int) kd {
			return toDBKey(key)
		})

		res, err := factory(ctx, ids)

		resMap := map[k][]*t{}

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

		for _, key := range keys {
			r := &dataloader.Result[[]*t]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}
	return dataloader.NewBatchedLoader(batchLoadLists)
}

// NewBatchLoader returns a configured batch loader for items
func NewBatchLoader[k comparable, kd comparable, t any](
	factory func(ctx context.Context, ids []kd) ([]t, error),
	getID func(item t) k,
	toDBKey func(key k) kd,
) *dataloader.Loader[k, *t] {
	batchLoadItems := func(ctx context.Context, keys []k) []*dataloader.Result[*t] {
		var results []*dataloader.Result[*t]

		ids := lo.Map(keys, func(key k, _ int) kd {
			return toDBKey(key)
		})

		res, err := factory(ctx, ids)

		resMap := map[k]*t{}

		if err == nil {
			for _, r := range res {
				resMap[getID(r)] = &r
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[*t]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
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

// GetFromLoaderForKey retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as available)
func GetFromLoaderForKey[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, []*t], key k) ([]*t, error) {
	thunk := loader.Load(ctx, key)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
