package collection

import (
	"context"
	"database/sql"
	"encoding/json"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/jsonlogic"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/lib/pq"
	"github.com/samber/lo"
)

// ErrUnsupportedCollection error
var (
	ErrUnsupportedCollection = merry.Sentinel("unsupported collection type")
)

// NewBatchLoader returns a configured batch loader for collections
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Collection] {
	return common.NewBatchLoader(queries.GetCollections)
}

// NewItemListBatchLoader returns a configured batch loader for collection-items
func NewItemListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.CollectionItem] {
	return common.NewListBatchLoader(queries.GetItemsForCollections, func(row common.CollectionItem) int {
		return row.CollectionID
	})
}

type filter struct {
	ID              uuid.UUID
	Filter          json.RawMessage
	SortBy          string
	SortByDirection string
}

func getFilterForQueryCollection(collection *common.Collection) filter {
	var f filter
	if collection.Filter != nil {
		_ = json.Unmarshal(*collection.Filter, &f)
	}
	return f
}

func itemIdsFromRows(rows *sql.Rows) []int {
	var ids []int

	for rows.Next() {
		var id int
		_ = rows.Scan(&id)
		ids = append(ids, id)
	}

	_ = rows.Close()
	return ids
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
					f := getFilterForQueryCollection(r)
					if f.Filter == nil {
						resMap[r.ID] = nil
					}

					var filterObject map[string]any
					_ = json.Unmarshal(f.Filter, &filterObject)
					filterString := jsonlogic.GetSQLStringFromFilter(filterObject)

					var orderByString string
					if f.SortBy != "" {
						orderByString = " ORDER BY " + pq.QuoteIdentifier(f.SortBy)
					}
					if orderByString != "" && f.SortByDirection != "" {
						switch f.SortByDirection {
						case "desc":
							orderByString += " DESC"
						case "asc":
							orderByString += " ASC"
						}
					}

					queryString := "SELECT id FROM " + r.Collection.ValueOrZero() + " WHERE " + filterString + orderByString

					rows, err := db.Query(queryString)
					if err != nil {
						log.L.Error().Err(err).
							Str("collection", r.Collection.ValueOrZero()).
							Msg("Failed to select itemIds from collection")
						continue
					}
					resMap[r.ID] = itemIdsFromRows(rows)
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
			result = append(result, i)
		case "show":
			i, err := common.GetFromLoaderByID(ctx, loaders.ShowLoader, item.ItemID)
			if err != nil {
				return nil, err
			}
			result = append(result, i)
		case "season":
			i, err := common.GetFromLoaderByID(ctx, loaders.SeasonLoader, item.ItemID)
			if err != nil {
				return nil, err
			}
			result = append(result, i)
		case "episode":
			i, err := common.GetFromLoaderByID(ctx, loaders.EpisodeLoader, item.ItemID)
			if err != nil {
				return nil, err
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
