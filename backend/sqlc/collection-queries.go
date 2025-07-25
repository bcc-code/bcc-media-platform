package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/samber/lo"
)

func mapToCollections(collections []getCollectionsRow) []common.Collection {
	return lo.Map(collections, func(e getCollectionsRow, _ int) common.Collection {
		var title common.LocaleString
		var slugs common.LocaleString
		_ = json.Unmarshal(e.Title.RawMessage, &title)
		_ = json.Unmarshal(e.Slugs.RawMessage, &slugs)

		var filter *common.Filter

		switch e.FilterType.ValueOrZero() {
		case "randomized_query":
			fallthrough
		case "query":
			err := json.Unmarshal(e.QueryFilter.RawMessage, &filter)
			if err != nil {
				log.L.Error().Err(err).Msg("Unmarshalling filter")
			}
		}

		return common.Collection{
			ID:             int(e.ID),
			Type:           e.FilterType.ValueOrZero(),
			AdvancedType:   e.AdvancedType,
			Filter:         filter,
			Title:          title,
			Slugs:          slugs,
			NumberInTitles: e.NumberInTitles,
		}
	})
}

// GetCollections returns collections
func (q *Queries) GetCollections(ctx context.Context, ids []int) ([]common.Collection, error) {
	collections, err := q.getCollections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToCollections(collections), nil
}

func mapToCollectionItems(items []CollectionsEntry) []common.CollectionItem {
	return lo.Map(items, func(i CollectionsEntry, _ int) common.CollectionItem {
		c := common.Collections.Parse(i.Collection)
		if c == nil {
			c = &common.CollectionUnknown
		}
		return common.CollectionItem{
			ID:           int(i.ID),
			Sort:         int(i.Sort.ValueOrZero()),
			CollectionID: int(i.CollectionsID),
			Type:         *c,
			ItemID:       i.Item,
		}
	})
}

// GetItemsForCollections returns []common.CollectionItem for specified collections
func (q *Queries) GetItemsForCollections(ctx context.Context, ids []int) ([]common.CollectionItem, error) {
	items, err := q.getCollectionEntriesForCollections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}

	colEnts := make([]CollectionsEntry, len(items))
	for _, i := range items {
		colEnts = append(colEnts, CollectionsEntry{
			ID:            i.ID,
			Sort:          i.Sort,
			CollectionsID: i.CollectionsID,
			Item:          i.Item,
			Collection:    i.Collection,
		})
	}

	return mapToCollectionItems(colEnts), nil
}

// GetItemsForCollectionsWithRoles returns []common.CollectionItem for specified collections
func (rq *RoleQueries) GetItemsForCollectionsWithRoles(ctx context.Context, ids []int) ([]common.CollectionItem, error) {
	items, err := rq.queries.getCollectionEntriesForCollectionsWithRoles(ctx, getCollectionEntriesForCollectionsWithRolesParams{
		Ids:   intToInt32(ids),
		Roles: rq.roles,
	})
	if err != nil {
		return nil, err
	}

	colEnts := make([]CollectionsEntry, len(items))
	for _, i := range items {
		colEnts = append(colEnts, CollectionsEntry{
			ID:            i.ID,
			Sort:          i.Sort,
			CollectionsID: i.CollectionsID,
			Item:          i.Item,
			Collection:    i.Collection,
		})
	}

	return mapToCollectionItems(colEnts), nil
}

// GetOriginal returns the requested string
func (row getCollectionIDsForCodesRow) GetOriginal() string {
	return row.Slug.String
}

// GetResult returns the id from the query
func (row getCollectionIDsForCodesRow) GetResult() int {
	return int(row.ID)
}

// GetCollectionIDsForCodes returns ids for the requested codes
func (q *Queries) GetCollectionIDsForCodes(ctx context.Context, codes []string) ([]common.Conversion[string, int], error) {
	rows, err := q.getCollectionIDsForCodes(ctx, codes)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getCollectionIDsForCodesRow, _ int) common.Conversion[string, int] {
		return i
	}), nil
}
