package batchloaders

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/graph-gophers/dataloader/v7"
	"go.opentelemetry.io/otel"
	"time"
)

func getOptions[K comparable, V any](opts ...any) []dataloader.Option[K, V] {
	var options []dataloader.Option[K, V]

	memoryCacheAdded := false

	for _, opt := range opts {
		switch t := opt.(type) {
		case memoryCache:
			options = append(options, dataloader.WithCache[K, V](newMemoryLoaderCache[K, V](t.expiration)))
			memoryCacheAdded = true
		}
	}

	// We want a TTL for everything.
	if !memoryCacheAdded {
		options = append(options, dataloader.WithCache[K, V](newMemoryLoaderCache[K, V](time.Minute*5)))
	}

	return options
}

// NewListLoader returns a configured batch loader for Lists
func NewListLoader[K comparable, V any](
	factory func(ctx context.Context, ids []K) ([]V, error),
	getKey func(item V) K,
	opts ...any,
) *dataloader.Loader[K, []*V] {
	batchLoadLists := func(ctx context.Context, keys []K) []*dataloader.Result[[]*V] {
		var results []*dataloader.Result[[]*V]

		res, err := factory(ctx, keys)

		resMap := map[K][]*V{}

		if err == nil {
			for _, r := range res {
				key := getKey(r)

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*V{}
				}
				item := r
				resMap[key] = append(resMap[key], &item)
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[[]*V]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	options := getOptions[K, []*V](opts...)

	return dataloader.NewBatchedLoader(batchLoadLists, options...)
}

// NewRelationLoader returns a configured batch loader for Lists
func NewRelationLoader[K comparable, R comparable](
	factory func(ctx context.Context, ids []R) ([]common.Relation[K, R], error),
	opts ...any,
) *dataloader.Loader[R, []*K] {
	batchLoadLists := func(ctx context.Context, keys []R) []*dataloader.Result[[]*K] {
		var results []*dataloader.Result[[]*K]

		res, err := factory(ctx, keys)

		resMap := map[R][]*K{}

		if err == nil {
			for _, r := range res {
				key := r.GetRelationID()

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*K{}
				}
				id := r.GetKey()
				resMap[key] = append(resMap[key], &id)
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[[]*K]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	options := getOptions[R, []*K](opts...)

	return dataloader.NewBatchedLoader(batchLoadLists, options...)
}

// NewConversionLoader returns a configured batch loader for Lists
func NewConversionLoader[o comparable, rt comparable](
	factory func(ctx context.Context, ids []o) ([]common.Conversion[o, rt], error),
	opts ...any,
) *dataloader.Loader[o, *rt] {
	batchLoadLists := func(ctx context.Context, keys []o) []*dataloader.Result[*rt] {
		var results []*dataloader.Result[*rt]

		res, err := factory(ctx, keys)

		resMap := map[o]*rt{}

		if err == nil {
			for _, r := range res {
				v := r.GetResult()
				resMap[r.GetOriginal()] = &v
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[*rt]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	options := getOptions[o, *rt](opts...)

	return dataloader.NewBatchedLoader(batchLoadLists, options...)
}

// NewLoader returns a configured batch loader for items
func NewLoader[K comparable, V common.HasKey[K]](
	factory func(ctx context.Context, ids []K) ([]V, error),
	opts ...any,
) *dataloader.Loader[K, *V] {
	return NewCustomLoader(factory, func(i V) K {
		return i.GetKey()
	}, opts...)
}

// NewFilterLoader is just for filtering a list of keys or checking if user has access to a specific id
func NewFilterLoader[K comparable](factory func(ctx context.Context, keys []K) ([]K, error), opts ...any) *dataloader.Loader[K, *K] {
	return NewCustomLoader(factory, func(key K) K {
		return key
	}, opts...)
}

// NewCustomLoader returns a configured batch loader for items
func NewCustomLoader[K comparable, V any](
	factory func(ctx context.Context, ids []K) ([]V, error),
	getKey func(V) K,
	opts ...any,
) *dataloader.Loader[K, *V] {
	batchLoadItems := func(ctx context.Context, keys []K) []*dataloader.Result[*V] {
		var results []*dataloader.Result[*V]

		res, err := factory(ctx, keys)

		resMap := map[K]*V{}

		if err == nil {
			for _, r := range res {
				item := r
				resMap[getKey(r)] = &item
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[*V]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	options := getOptions[K, *V](opts...)

	// Currently we do not want to cache at the GQL level
	return dataloader.NewBatchedLoader(batchLoadItems, options...)
}

// GetByID returns the object from the loader
func GetByID[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, *t], id k) (*t, error) {
	ctx, span := otel.Tracer("loader").Start(ctx, "single")
	defer span.End()
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}

// GetForKey retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as available)
func GetForKey[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, []*t], key k) ([]*t, error) {
	ctx, span := otel.Tracer("loader").Start(ctx, "keyed")
	defer span.End()
	thunk := loader.Load(ctx, key)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}

// GetMany retrieves multiple items from specified loader
func GetMany[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, *t], ids []k) ([]*t, error) {
	ctx, span := otel.Tracer("loader").Start(ctx, "multiple")
	defer span.End()
	thunk := loader.LoadMany(ctx, ids)
	result, errs := thunk()
	if len(errs) > 0 {
		return nil, errs[0]
	}

	var items []*t
	for _, i := range result {
		items = append(items, i)
	}
	return items, nil
}
