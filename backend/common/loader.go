package common

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
)

// BatchLoaders contains loaders for the different items
type BatchLoaders struct {
	PageLoader              *dataloader.Loader[int, *Page]
	PageLoaderByCode        *dataloader.Loader[string, *Page]
	SectionLoader           *dataloader.Loader[int, *Section]
	SectionsLoader          *dataloader.Loader[int, []*int]
	CollectionLoader        *dataloader.Loader[int, *Collection]
	CollectionItemIdsLoader *dataloader.Loader[int, []int]
	CollectionItemLoader    *dataloader.Loader[int, []*CollectionItem]
	ShowLoader              *dataloader.Loader[int, *Show]
	SeasonLoader            *dataloader.Loader[int, *Season]
	EpisodeLoader           *dataloader.Loader[int, *Episode]
	SeasonsLoader           *dataloader.Loader[int, []*int]
	EpisodesLoader          *dataloader.Loader[int, []*int]
	FilesLoader             *dataloader.Loader[int, []*File]
	StreamsLoader           *dataloader.Loader[int, []*Stream]
	EventLoader             *dataloader.Loader[int, *Event]
	CalendarEntryLoader     *dataloader.Loader[int, *CalendarEntry]
	ShowPermissionLoader    *dataloader.Loader[int, *Permissions]
	SeasonPermissionLoader  *dataloader.Loader[int, *Permissions]
	EpisodePermissionLoader *dataloader.Loader[int, *Permissions]
}

// NewListBatchLoader returns a configured batch loader for Lists
func NewListBatchLoader[k comparable, t any](
	factory func(ctx context.Context, ids []k) ([]t, error),
	getKey func(item t) k,
) *dataloader.Loader[k, []*t] {
	batchLoadLists := func(ctx context.Context, keys []k) []*dataloader.Result[[]*t] {
		var results []*dataloader.Result[[]*t]

		res, err := factory(ctx, keys)

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

// NewRelationBatchLoader returns a configured batch loader for Lists
func NewRelationBatchLoader[k comparable, kr comparable](
	factory func(ctx context.Context, ids []kr) ([]Relation[k, kr], error),
) *dataloader.Loader[kr, []*k] {
	batchLoadLists := func(ctx context.Context, keys []kr) []*dataloader.Result[[]*k] {
		var results []*dataloader.Result[[]*k]

		res, err := factory(ctx, keys)

		resMap := map[kr][]*k{}

		if err == nil {
			for _, r := range res {
				key := r.GetRelationID()

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*k{}
				}
				id := r.GetID()
				resMap[key] = append(resMap[key], &id)
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[[]*k]{
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
func NewBatchLoader[k comparable, t HasKey[k]](
	factory func(ctx context.Context, ids []k) ([]t, error),
) *dataloader.Loader[k, *t] {
	return NewCustomBatchLoader(factory, func(i t) k {
		return i.GetKey()
	})
}

// NewCustomBatchLoader returns a configured batch loader for items
func NewCustomBatchLoader[k comparable, t any](
	factory func(ctx context.Context, ids []k) ([]t, error),
	getKey func(t) k,
) *dataloader.Loader[k, *t] {
	batchLoadItems := func(ctx context.Context, keys []k) []*dataloader.Result[*t] {
		var results []*dataloader.Result[*t]

		res, err := factory(ctx, keys)

		resMap := map[k]*t{}

		if err == nil {
			for _, r := range res {
				item := r
				resMap[getKey(r)] = &item
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

// GetManyFromLoader retrieves multiple items from specified loader
func GetManyFromLoader[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, *t], ids []k) ([]*t, error) {
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
