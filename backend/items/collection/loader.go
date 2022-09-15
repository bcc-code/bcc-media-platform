package collection

import (
	"context"
	"database/sql"
	"strings"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// ErrUnsupportedCollection error
var (
	ErrUnsupportedCollection = merry.Sentinel("unsupported collection type")
)

// NewItemListBatchLoader returns a configured batch loader for collection-items
func NewItemListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.CollectionItem] {
	return common.NewListBatchLoader(queries.GetItemsForCollections, func(row common.CollectionItem) int {
		return row.CollectionID
	})
}

// NewCollectionItemIdsLoader returns a new loader for getting ItemIds for Collection
func NewCollectionItemIdsLoader(db *sql.DB, collectionLoader *dataloader.Loader[int, *common.Collection]) *dataloader.Loader[int, []int] {
	batchLoader := func(ctx context.Context, keys []int) []*dataloader.Result[[]int] {
		var results []*dataloader.Result[[]int]
		var err error

		res, errs := collectionLoader.LoadMany(ctx, keys)()
		if len(errs) > 0 {
			err = errs[0]
		}

		resMap := map[int][]int{}
		if err == nil {
			for _, r := range res {
				switch r.Type {
				case "query":
					if r.Filter == nil {
						resMap[r.ID] = nil
						continue
					}
					resMap[r.ID], err = GetItemIDsForFilter(ctx, db, r.Collection.ValueOrZero(), *r.Filter)
					if err != nil {
						log.L.Error().Err(err).
							Str("collection", r.Collection.ValueOrZero()).
							Msg("Failed to select itemIds from collection")
						continue
					}
				}
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[[]int]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}
	return dataloader.NewBatchedLoader(batchLoader)
}

// Item interface for a collection item
type Item interface {
	IsCollectionItem()
}

func toCollectionItemArray[t Item](items []t) []Item {
	return lo.Map(items, func(i t, _ int) Item {
		return i
	})
}

func getItemsForQueryCollection(ctx context.Context, loaders *common.BatchLoaders, id int, collection string) ([]Item, error) {
	itemIds, err := loaders.CollectionItemIdsLoader.Load(ctx, id)()
	if err != nil {
		return nil, err
	}

	switch collection {
	case "pages":
		items, err := common.GetManyFromLoader(ctx, loaders.PageLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(items), nil
	case "shows":
		items, err := common.GetManyFromLoader(ctx, loaders.ShowLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(items), nil
	case "seasons":
		items, err := common.GetManyFromLoader(ctx, loaders.SeasonLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(items), nil
	case "episodes":
		items, err := common.GetManyFromLoader(ctx, loaders.EpisodeLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(items), nil
	}
	return nil, ErrUnsupportedCollection
}

func preloadIds(ctx context.Context, loaders *common.BatchLoaders, idMap map[string][]int) {
	for t, ids := range idMap {
		switch t {
		case "page":
			loaders.PageLoader.LoadMany(ctx, ids)
		case "show":
			loaders.ShowLoader.LoadMany(ctx, ids)
		case "season":
			loaders.SeasonLoader.LoadMany(ctx, ids)
		case "episode":
			loaders.EpisodeLoader.LoadMany(ctx, ids)
		}
	}
}

func iterateAndPreloadCollectionItems(ctx context.Context, loaders *common.BatchLoaders, items []*common.CollectionItem) {
	var idMap = map[string][]int{}
	for _, item := range items {
		t := item.Type
		if _, ok := idMap[t]; !ok {
			idMap[t] = []int{}
		}
		idMap[t] = append(idMap[t], item.ItemID)
	}
	preloadIds(ctx, loaders, idMap)
}

func getItemsForSelectCollection(ctx context.Context, loaders *common.BatchLoaders, id int) ([]Item, error) {
	items, err := common.GetFromLoaderForKey(ctx, loaders.CollectionItemLoader, id)
	if err != nil {
		return nil, err
	}

	iterateAndPreloadCollectionItems(ctx, loaders, items)

	var result []Item
	for _, item := range items {
		switch item.Type {
		case "page":
			i, err := common.GetFromLoaderByID(ctx, loaders.PageLoader, item.ItemID)
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			result = append(result, i)
		case "show":
			i, err := common.GetFromLoaderByID(ctx, loaders.ShowLoader, item.ItemID)
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			result = append(result, i)
		case "season":
			i, err := common.GetFromLoaderByID(ctx, loaders.SeasonLoader, item.ItemID)
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			result = append(result, i)
		case "episode":
			i, err := common.GetFromLoaderByID(ctx, loaders.EpisodeLoader, item.ItemID)
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			result = append(result, i)
		}
	}
	return result, nil
}

// GetCollectionItems returns collection items
func GetCollectionItems(ctx context.Context, loaders *common.BatchLoaders, collectionId int) ([]Item, error) {
	col, err := common.GetFromLoaderByID(ctx, loaders.CollectionLoader, collectionId)
	if err != nil {
		return nil, err
	}

	switch col.Type {
	case "select":
		return getItemsForSelectCollection(ctx, loaders, col.ID)
	case "query":
		return getItemsForQueryCollection(ctx, loaders, col.ID, col.Collection.ValueOrZero())
	}
	return nil, nil
}

// Entry contains the ID and collection of a CollectionItem
type Entry struct {
	ID   int
	Type string
	Sort int
}

func collectionToType(collection string) string {
	switch collection {
	case "episodes", "pages", "shows", "seasons":
		return strings.TrimSuffix(collection, "s")
	default:
		return "unknown"
	}
}

// GetCollectionEntries returns entries for the specified collection
func GetCollectionEntries(ctx context.Context, loaders *common.BatchLoaders, collectionId int) ([]Entry, error) {
	col, err := common.GetFromLoaderByID(ctx, loaders.CollectionLoader, collectionId)
	if err != nil {
		return nil, err
	}

	switch col.Type {
	case "select":
		items, err := common.GetFromLoaderForKey(ctx, loaders.CollectionItemLoader, col.ID)
		if err != nil {
			return nil, err
		}
		return lo.Map(items, func(i *common.CollectionItem, _ int) Entry {
			return Entry{
				ID:   i.ItemID,
				Type: i.Type,
				Sort: i.Sort,
			}
		}), nil
	case "query":
		itemIds, err := loaders.CollectionItemIdsLoader.Load(ctx, col.ID)()
		if err != nil {
			return nil, err
		}
		return lo.Map(itemIds, func(id int, index int) Entry {
			return Entry{
				ID:   id,
				Type: collectionToType(col.Collection.ValueOrZero()),
				Sort: index,
			}
		}), nil
	}
	return nil, nil
}
