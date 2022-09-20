package collection

import (
	"context"
	"database/sql"
	"strings"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
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

// Entry contains the ID and collection of a CollectionItem
type Entry struct {
	ID   int
	Type common.ItemType
	Sort int
}

func collectionToType(collection string) common.ItemType {
	switch collection {
	// !!! Watch out for which collections you enter here, as this will only work for simple plurals
	case "episodes", "pages", "shows", "seasons":
		return common.ItemType(strings.TrimSuffix(collection, "s"))
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
