package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
	"strconv"
)

func mapToCollections(collections []Collection) []common.Collection {
	return lo.Map(collections, func(e Collection, _ int) common.Collection {
		var filter *common.Filter

		switch e.FilterType.ValueOrZero() {
		case "query":
			_ = json.Unmarshal(e.QueryFilter.RawMessage, &filter)
		}

		return common.Collection{
			ID:           int(e.ID),
			Type:         e.FilterType.ValueOrZero(),
			AdvancedType: e.AdvancedType,
			Filter:       filter,
			Name:         e.Name.ValueOrZero(),
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
		itemID, _ := strconv.ParseInt(i.Item.ValueOrZero(), 10, 64)
		return common.CollectionItem{
			ID:           int(i.ID),
			Sort:         int(i.Sort.ValueOrZero()),
			CollectionID: int(i.CollectionsID),
			Type:         common.ItemCollection(i.Collection.ValueOrZero()),
			ItemID:       int(itemID),
		}
	})
}

// GetItemsForCollections returns []common.CollectionItem for specified collections
func (q *Queries) GetItemsForCollections(ctx context.Context, ids []int) ([]common.CollectionItem, error) {
	items, err := q.getCollectionEntriesForCollections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToCollectionItems(items), nil
}

// GetItemsForCollectionsWithRoles returns []common.CollectionItem for specified collections
func (rq *RoleQueries) GetItemsForCollectionsWithRoles(ctx context.Context, ids []int) ([]common.CollectionItem, error) {
	items, err := rq.queries.getCollectionEntriesForCollectionsWithRoles(ctx, getCollectionEntriesForCollectionsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return mapToCollectionItems(items), nil
}
