package collection

import (
	"context"
	"database/sql"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"strings"
	"time"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewItemListBatchLoader returns a configured batch loader for collection-items
func NewItemListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.CollectionItem] {
	return batchloaders.NewListLoader(queries.GetItemsForCollections, func(row common.CollectionItem) int {
		return row.CollectionID
	})
}

// NewCollectionItemLoader returns a new loader for getting ItemIds for Collection
func NewCollectionItemLoader(db *sql.DB, collectionLoader *dataloader.Loader[int, *common.Collection], roles []string) *dataloader.Loader[int, []common.Identifier] {
	batchLoader := func(ctx context.Context, keys []int) []*dataloader.Result[[]common.Identifier] {
		var results []*dataloader.Result[[]common.Identifier]
		var err error

		res, errs := collectionLoader.LoadMany(ctx, keys)()
		if len(errs) > 0 {
			err = errs[0]
		}

		resMap := map[int][]common.Identifier{}
		if err == nil {
			for _, r := range res {
				switch r.Type {
				case "query":
					if r.Filter == nil {
						resMap[r.ID] = nil
						continue
					}
					resMap[r.ID], err = GetItemIDsForFilter(ctx, db, roles, *r.Filter)
					if err != nil {
						log.L.Error().Err(err).
							Msg("Failed to select itemIds from collection")
						continue
					}
				}
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[[]common.Identifier]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	return dataloader.NewBatchedLoader(batchLoader, dataloader.WithCache[int, []common.Identifier](batchloaders.NewMemoryLoaderCache[int, []common.Identifier](time.Minute*5)))
}

// Entry contains the ID and collection of a CollectionItem
type Entry struct {
	ID         int
	Collection common.ItemCollection
	Sort       int
}

func collectionToType(collection string) common.ItemCollection {
	switch collection {
	// !!! Watch out for which collections you enter here, as this will only work for simple plurals
	case "episodes", "pages", "shows", "seasons":
		return common.ItemCollection(strings.TrimSuffix(collection, "s"))
	default:
		return "unknown"
	}
}

// GetCollectionEntries returns entries for the specified collection
func GetCollectionEntries(ctx context.Context, loaders *common.BatchLoaders, filteredLoaders *common.FilteredLoaders, collectionId int) ([]Entry, error) {
	col, err := batchloaders.GetByID(ctx, loaders.CollectionLoader, collectionId)
	if err != nil {
		return nil, err
	}

	switch col.Type {
	case "select":
		items, err := batchloaders.GetForKey(ctx, filteredLoaders.CollectionItemsLoader, col.ID)
		if err != nil {
			return nil, err
		}
		return lo.Map(items, func(i *common.CollectionItem, _ int) Entry {
			return Entry{
				ID:         i.ItemID,
				Collection: i.Type,
				Sort:       i.Sort,
			}
		}), nil
	case "query":
		itemIds, err := filteredLoaders.CollectionItemIDsLoader.Load(ctx, col.ID)()
		if err != nil {
			return nil, err
		}
		return lo.Map(itemIds, func(id common.Identifier, index int) Entry {
			return Entry{
				ID:         id.ID,
				Collection: common.ItemCollection(id.Collection),
				Sort:       index,
			}
		}), nil
	}
	return nil, nil
}
