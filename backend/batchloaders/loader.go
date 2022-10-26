package batchloaders

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/graph-gophers/dataloader/v7"
	"go.opentelemetry.io/otel"
	"time"
)

// BatchLoaders contains loaders for the different items
type BatchLoaders struct {
	ApplicationLoader           *dataloader.Loader[int, *common.Application]
	ApplicationIDFromCodeLoader *dataloader.Loader[string, *int]
	PageLoader                  *dataloader.Loader[int, *common.Page]
	PageIDFromCodeLoader        *dataloader.Loader[string, *int]
	SectionLoader               *dataloader.Loader[int, *common.Section]
	SectionsLoader              *dataloader.Loader[int, []*int]
	CollectionLoader            *dataloader.Loader[int, *common.Collection]
	CollectionItemLoader        *dataloader.Loader[int, []*common.CollectionItem]
	ShowLoader                  *dataloader.Loader[int, *common.Show]
	SeasonLoader                *dataloader.Loader[int, *common.Season]
	EpisodeLoader               *dataloader.Loader[int, *common.Episode]
	LinkLoader                  *dataloader.Loader[int, *common.Link]
	FilesLoader                 *dataloader.Loader[int, []*common.File]
	StreamsLoader               *dataloader.Loader[int, []*common.Stream]
	EventLoader                 *dataloader.Loader[int, *common.Event]
	CalendarEntryLoader         *dataloader.Loader[int, *common.CalendarEntry]
	FAQCategoryLoader           *dataloader.Loader[int, *common.FAQCategory]
	QuestionLoader              *dataloader.Loader[int, *common.Question]
	QuestionsLoader             *dataloader.Loader[int, []*int]
	ProfilesLoader              *dataloader.Loader[string, []*common.Profile]
	MessageGroupLoader          *dataloader.Loader[int, *common.MessageGroup]
	// Permissions
	ShowPermissionLoader    *dataloader.Loader[int, *common.Permissions[int]]
	SeasonPermissionLoader  *dataloader.Loader[int, *common.Permissions[int]]
	EpisodePermissionLoader *dataloader.Loader[int, *common.Permissions[int]]
	PagePermissionLoader    *dataloader.Loader[int, *common.Permissions[int]]
	SectionPermissionLoader *dataloader.Loader[int, *common.Permissions[int]]
}

// FilteredLoaders contains loaders that will be filtered by permissions.
type FilteredLoaders struct {
	EpisodeFilterLoader     *dataloader.Loader[int, *int]
	EpisodesLoader          *dataloader.Loader[int, []*int]
	SeasonFilterLoader      *dataloader.Loader[int, *int]
	SeasonsLoader           *dataloader.Loader[int, []*int]
	ShowFilterLoader        *dataloader.Loader[int, *int]
	SectionsLoader          *dataloader.Loader[int, []*int]
	CollectionItemsLoader   *dataloader.Loader[int, []*common.CollectionItem]
	CollectionItemIDsLoader *dataloader.Loader[int, []int]
}

// ProfileLoaders contains loaders per profile
type ProfileLoaders struct {
	ProgressLoader *dataloader.Loader[int, *common.Progress]
}

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

// NewListBatchLoader returns a configured batch loader for Lists
func NewListBatchLoader[K comparable, V any](
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

// NewRelationBatchLoader returns a configured batch loader for Lists
func NewRelationBatchLoader[K comparable, R comparable](
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

// NewConversionBatchLoader returns a configured batch loader for Lists
func NewConversionBatchLoader[o comparable, rt comparable](
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

// NewBatchLoader returns a configured batch loader for items
func NewBatchLoader[K comparable, V common.HasKey[K]](
	factory func(ctx context.Context, ids []K) ([]V, error),
	opts ...any,
) *dataloader.Loader[K, *V] {
	return NewCustomBatchLoader(factory, func(i V) K {
		return i.GetKey()
	}, opts...)
}

// NewFilterLoader is just for filtering a list of keys or checking if user has access to a specific id
func NewFilterLoader[K comparable](factory func(ctx context.Context, keys []K) ([]K, error), opts ...any) *dataloader.Loader[K, *K] {
	return NewCustomBatchLoader(factory, func(key K) K {
		return key
	}, opts...)
}

// NewCustomBatchLoader returns a configured batch loader for items
func NewCustomBatchLoader[K comparable, V any](
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
