package collection

import (
	"context"
	"database/sql"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/samber/lo/parallel"
	"sync"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewCollectionItemLoader returns a new loader for getting ItemIds for Collection
func NewCollectionItemLoader(ctx context.Context, db *sql.DB, collectionLoader *loaders.Loader[int, *common.Collection], roles []string) *loaders.Loader[int, []common.Identifier] {
	batchLoader := func(ctx context.Context, keys []int) []*dataloader.Result[[]common.Identifier] {
		var results []*dataloader.Result[[]common.Identifier]
		var err error

		collections, errs := collectionLoader.LoadMany(ctx, keys)()
		if len(errs) > 0 {
			err = errs[0]
		}

		var resMap = map[int][]common.Identifier{}
		var lock = &sync.Mutex{}
		if err == nil {
			parallel.ForEach(collections, func(i *common.Collection, _ int) {
				var identifiers []common.Identifier
				if i.Type == "query" {
					if i.Filter == nil {
						i.Filter = &common.Filter{}
					}
					identifiers, err = GetItemIDsForFilter(ctx, db, roles, *i.Filter, i.AdvancedType.String == "continue_watching" || i.AdvancedType.String == "my_list")
					if err != nil {
						log.L.Error().Err(err).
							Msg("Failed to select itemIds from collection")
					}
				}
				lock.Lock()
				resMap[i.ID] = identifiers
				lock.Unlock()
			})
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

	return &loaders.Loader[int, []common.Identifier]{
		Loader: dataloader.NewBatchedLoader(batchLoader, dataloader.WithCache[int, []common.Identifier](loaders.NewMemoryLoaderCache[int, []common.Identifier](ctx, "collection-item", time.Minute*5))),
	}
}

// Entry contains the ID and collection of a CollectionItem
type Entry struct {
	ID         string
	Collection common.ItemCollection
	Sort       int
}

// GetCollectionEntries returns entries for the specified collection
func GetCollectionEntries(ctx context.Context, ls *common.BatchLoaders, filteredLoaders *common.FilteredLoaders, collectionId int) ([]Entry, error) {
	col, err := ls.CollectionLoader.Get(ctx, collectionId)
	if err != nil {
		return nil, err
	}

	switch col.Type {
	case "select":
		items, err := filteredLoaders.CollectionItemsLoader.Get(ctx, col.ID)
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
			c := common.Collections.Parse(id.Collection)
			if c == nil {
				c = &common.CollectionEpisodes
			}
			return Entry{
				ID:         id.ID,
				Collection: *c,
				Sort:       index,
			}
		}), nil
	}
	return nil, nil
}
