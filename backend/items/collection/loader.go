package collection

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/jsonlogic"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/google/uuid"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Collection
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.CollectionExpanded] {
	return common.NewBatchLoader(queries.GetCollections, func(row sqlc.CollectionExpanded) int {
		return int(row.ID)
	}, func(id int) int32 {
		return int32(id)
	})
}

type filter struct {
	ID              uuid.UUID
	Filter          json.RawMessage
	SortBy          string
	SortByDirection string
}

func getItemIdsForSelectCollection(collection *sqlc.CollectionExpanded) []int {
	var itemIds []int
	switch collection.Collection.ValueOrZero() {
	case "pages":
		_ = json.Unmarshal(collection.PageIds.RawMessage, &itemIds)
	case "shows":
		_ = json.Unmarshal(collection.ShowIds.RawMessage, &itemIds)
	case "seasons":
		_ = json.Unmarshal(collection.SeasonIds.RawMessage, &itemIds)
	case "episodes":
		_ = json.Unmarshal(collection.EpisodeIds.RawMessage, &itemIds)
	}
	if itemIds == nil {
		itemIds = []int{}
	}
	return itemIds
}

func getFilterForQueryCollection(collection *sqlc.CollectionExpanded) filter {
	var f filter
	switch collection.Collection.ValueOrZero() {
	case "pages":
		_ = json.Unmarshal(collection.PagesQueryFilter.RawMessage, &f)
	case "shows":
		_ = json.Unmarshal(collection.ShowsQueryFilter.RawMessage, &f)
	case "seasons":
		_ = json.Unmarshal(collection.SeasonsQueryFilter.RawMessage, &f)
	case "episodes":
		_ = json.Unmarshal(collection.EpisodesQueryFilter.RawMessage, &f)
	}
	return f
}

// NewCollectionItemIdsLoader returns a new loader for getting ItemIds for Collection
func NewCollectionItemIdsLoader(queries sqlc.Queries, collectionLoader *dataloader.Loader[int, *sqlc.CollectionExpanded]) *dataloader.Loader[int, []int] {
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
				switch r.FilterType.ValueOrZero() {
				case "select":
					resMap[int(r.ID)] = getItemIdsForSelectCollection(r)
				case "query":
					f := getFilterForQueryCollection(r)
					if f.Filter == nil {
						resMap[int(r.ID)] = nil
					}
					var filterObject map[string]any
					_ = json.Unmarshal(f.Filter, &filterObject)
					filterString := jsonlogic.GetSQLStringFromFilter(filterObject)

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
