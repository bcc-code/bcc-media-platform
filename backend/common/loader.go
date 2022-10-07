package common

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
	"go.opentelemetry.io/otel"
)

// BatchLoaders contains loaders for the different items
type BatchLoaders struct {
	ApplicationLoader           *dataloader.Loader[int, *Application]
	ApplicationIDFromCodeLoader *dataloader.Loader[string, *int]
	PageLoader                  *dataloader.Loader[int, *Page]
	PageIDFromCodeLoader        *dataloader.Loader[string, *int]
	SectionLoader               *dataloader.Loader[int, *Section]
	SectionsLoader              *dataloader.Loader[int, []*int]
	SectionLinksLoader          *dataloader.Loader[int, []*SectionLink]
	CollectionLoader            *dataloader.Loader[int, *Collection]
	CollectionItemLoader        *dataloader.Loader[int, []*CollectionItem]
	ShowLoader                  *dataloader.Loader[int, *Show]
	SeasonLoader                *dataloader.Loader[int, *Season]
	EpisodeLoader               *dataloader.Loader[int, *Episode]
	FilesLoader                 *dataloader.Loader[int, []*File]
	StreamsLoader               *dataloader.Loader[int, []*Stream]
	EventLoader                 *dataloader.Loader[int, *Event]
	CalendarEntryLoader         *dataloader.Loader[int, *CalendarEntry]
	FAQCategoryLoader           *dataloader.Loader[int, *FAQCategory]
	QuestionLoader              *dataloader.Loader[int, *Question]
	QuestionsLoader             *dataloader.Loader[int, []*int]
	// Permissions
	ShowPermissionLoader    *dataloader.Loader[int, *Permissions[int]]
	SeasonPermissionLoader  *dataloader.Loader[int, *Permissions[int]]
	EpisodePermissionLoader *dataloader.Loader[int, *Permissions[int]]
	PagePermissionLoader    *dataloader.Loader[int, *Permissions[int]]
	SectionPermissionLoader *dataloader.Loader[int, *Permissions[int]]
}

// FilteredLoaders contains loaders that will be filtered by permissions.
type FilteredLoaders struct {
	EpisodesLoader          *dataloader.Loader[int, []*int]
	SeasonsLoader           *dataloader.Loader[int, []*int]
	CollectionItemsLoader   *dataloader.Loader[int, []*CollectionItem]
	CollectionItemIDsLoader *dataloader.Loader[int, []int]
}

// NewListBatchLoader returns a configured batch loader for Lists
func NewListBatchLoader[K comparable, V any](
	factory func(ctx context.Context, ids []K) ([]V, error),
	getKey func(item V) K,
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
	return dataloader.NewBatchedLoader(batchLoadLists, dataloader.WithCache[K, []*V](newLoaderCache[K, []*V]()))
}

// NewRelationBatchLoader returns a configured batch loader for Lists
func NewRelationBatchLoader[K comparable, R comparable](
	factory func(ctx context.Context, ids []R) ([]Relation[K, R], error),
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
	return dataloader.NewBatchedLoader(batchLoadLists, dataloader.WithCache[R, []*K](newLoaderCache[R, []*K]()))
}

// NewConversionBatchLoader returns a configured batch loader for Lists
func NewConversionBatchLoader[o comparable, rt comparable](
	factory func(ctx context.Context, ids []o) ([]Conversion[o, rt], error),
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
	return dataloader.NewBatchedLoader(batchLoadLists, dataloader.WithCache[o, *rt](newLoaderCache[o, *rt]()))
}

// NewBatchLoader returns a configured batch loader for items
func NewBatchLoader[K comparable, V HasKey[K]](
	factory func(ctx context.Context, ids []K) ([]V, error),
) *dataloader.Loader[K, *V] {
	return NewCustomBatchLoader(factory, func(i V) K {
		return i.GetKey()
	})
}

// NewCustomBatchLoader returns a configured batch loader for items
func NewCustomBatchLoader[K comparable, V any](
	factory func(ctx context.Context, ids []K) ([]V, error),
	getKey func(V) K,
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

	// Currently we do not want to cache at the GQL level
	return dataloader.NewBatchedLoader(batchLoadItems, dataloader.WithCache[K, *V](newLoaderCache[K, *V]()))
}

// GetFromLoaderByID returns the object from the loader
func GetFromLoaderByID[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, *t], id k) (*t, error) {
	ctx, span := otel.Tracer("loader").Start(ctx, "single")
	defer span.End()
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
	ctx, span := otel.Tracer("loader").Start(ctx, "keyed")
	defer span.End()
	thunk := loader.Load(ctx, key)
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}

// GetManyFromLoader retrieves multiple items from specified loader
func GetManyFromLoader[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, *t], ids []k) ([]*t, error) {
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
