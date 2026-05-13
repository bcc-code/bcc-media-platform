package loaders

import (
	"context"

	"github.com/graph-gophers/dataloader/v7"
)

// NewMapped returns a single-value loader for cases where the factory's row
// type differs from the value stored in the loader. The caller supplies a
// keyFn to extract the lookup key from each row and a valFn to extract the
// stored value.
//
// Use this when the underlying query returns rows that pair a lookup key
// with a converted value (e.g. code -> id lookups).
func NewMapped[K comparable, V any, Row any](
	ctx context.Context,
	factory func(ctx context.Context, keys []K) ([]Row, error),
	keyFn func(Row) K,
	valFn func(Row) V,
	opts ...Option,
) *Loader[K, *V] {
	batchLoad := func(ctx context.Context, keys []K) []*dataloader.Result[*V] {
		res, err := factory(ctx, keys)
		resMap := map[K]*V{}
		if err == nil {
			for _, r := range res {
				v := valFn(r)
				resMap[keyFn(r)] = &v
			}
		}
		return assembleBatch(keys, resMap, err)
	}

	options := getOptions[K, *V](ctx, opts...)
	return &Loader[K, *V]{Loader: dataloader.NewBatchedLoader(batchLoad, options...)}
}

// NewListMapped returns a list-value loader for cases where the factory's
// row type differs from the values stored in the loader. The caller supplies
// a keyFn to extract the lookup key (parent) from each row and a valFn to
// extract the stored value (child) from each row. Multiple rows can map to
// the same key.
//
// Use this when the underlying query returns rows that describe a one-to-many
// relation between parent keys and child values.
func NewListMapped[K comparable, V any, Row any](
	ctx context.Context,
	factory func(ctx context.Context, keys []K) ([]Row, error),
	keyFn func(Row) K,
	valFn func(Row) V,
	opts ...Option,
) *Loader[K, []*V] {
	batchLoad := func(ctx context.Context, keys []K) []*dataloader.Result[[]*V] {
		res, err := factory(ctx, keys)
		resMap := map[K][]*V{}
		if err == nil {
			for _, r := range res {
				v := valFn(r)
				key := keyFn(r)
				resMap[key] = append(resMap[key], &v)
			}
		}
		return assembleBatch(keys, resMap, err)
	}

	options := getOptions[K, []*V](ctx, opts...)
	return &Loader[K, []*V]{Loader: dataloader.NewBatchedLoader(batchLoad, options...)}
}
