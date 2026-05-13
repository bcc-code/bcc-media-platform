package loaders

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/graph-gophers/dataloader/v7"
)

// NewMappingLoader returns a single-value loader for cases where the factory
// returns rows that carry both a lookup key and a converted value (the
// classic code -> id lookup). Each Mapping.Key indexes into a single
// Mapping.Value.
//
// Replaces the old NewConversionLoader.
func NewMappingLoader[K comparable, V any](
	ctx context.Context,
	factory func(ctx context.Context, keys []K) ([]common.Mapping[K, V], error),
	opts ...Option,
) *Loader[K, *V] {
	batchLoad := func(ctx context.Context, keys []K) []*dataloader.Result[*V] {
		res, err := factory(ctx, keys)
		resMap := map[K]*V{}
		if err == nil {
			for _, r := range res {
				v := r.Value
				resMap[r.Key] = &v
			}
		}
		return assembleBatch(keys, resMap, err)
	}

	options := getOptions[K, *V](ctx, opts...)
	return &Loader[K, *V]{Loader: dataloader.NewBatchedLoader(batchLoad, options...)}
}

// NewMappingListLoader returns a list-value loader for cases where the factory
// returns rows that describe a one-to-many relation between parent keys and
// child values. Multiple Mapping rows can share the same Mapping.Key.
//
// Replaces the old NewRelationLoader.
func NewMappingListLoader[K comparable, V any](
	ctx context.Context,
	factory func(ctx context.Context, keys []K) ([]common.Mapping[K, V], error),
	opts ...Option,
) *Loader[K, []*V] {
	batchLoad := func(ctx context.Context, keys []K) []*dataloader.Result[[]*V] {
		res, err := factory(ctx, keys)
		resMap := map[K][]*V{}
		if err == nil {
			for _, r := range res {
				v := r.Value
				resMap[r.Key] = append(resMap[r.Key], &v)
			}
		}
		return assembleBatch(keys, resMap, err)
	}

	options := getOptions[K, []*V](ctx, opts...)
	return &Loader[K, []*V]{Loader: dataloader.NewBatchedLoader(batchLoad, options...)}
}
