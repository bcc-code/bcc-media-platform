package loaders

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
)

// NewListLoader returns a configured batch loader for Lists
func NewListLoader[K comparable, V any](
	ctx context.Context,
	factory func(ctx context.Context, ids []K) ([]V, error),
	getKey func(item V) K,
	opts ...Option,
) *Loader[K, []*V] {
	batchLoadLists := func(ctx context.Context, keys []K) []*dataloader.Result[[]*V] {
		res, err := factory(ctx, keys)
		resMap := map[K][]*V{}
		if err == nil {
			for _, r := range res {
				key := getKey(r)
				item := r
				resMap[key] = append(resMap[key], &item)
			}
		}
		return assembleBatch(keys, resMap, err)
	}

	options := getOptions[K, []*V](ctx, opts...)
	return &Loader[K, []*V]{Loader: dataloader.NewBatchedLoader(batchLoadLists, options...)}
}
