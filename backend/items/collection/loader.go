package collection

import (
	"context"
	"database/sql"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/jsonlogic"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Collection
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Collection] {
	return common.NewBatchLoader(queries.GetCollections)
}

// NewItemListBatchLoader returns a configured batch loader for GQL CollectionItem
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
						resMap[int(r.ID)] = nil
					}
					var filterObject map[string]any
					_ = json.Unmarshal(f.Filter, &filterObject)
					filterString := jsonlogic.GetSQLStringFromFilter(filterObject)
					rows, err := db.Query("SELECT id FROM " + r.Collection.ValueOrZero() + " WHERE " + filterString)
					if err != nil {
						log.L.Error().Err(err).
							Str("collection", r.Collection.ValueOrZero()).
							Msg("Failed to select itemIds from collection")
						continue
					}
					resMap[int(r.ID)] = itemIdsFromRows(rows)
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
