package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func mapToCollections(collections []Collection) []common.Collection {
	return lo.Map(collections, func(e Collection, _ int) common.Collection {
		var filter *common.Filter

		switch e.FilterType.ValueOrZero() {
		case "query":
			switch e.Collection.ValueOrZero() {
			case "pages":
				_ = json.Unmarshal(e.PagesQueryFilter.RawMessage, &filter)
			case "shows":
				_ = json.Unmarshal(e.ShowsQueryFilter.RawMessage, &filter)
			case "seasons":
				_ = json.Unmarshal(e.SeasonsQueryFilter.RawMessage, &filter)
			case "episodes":
				_ = json.Unmarshal(e.EpisodesQueryFilter.RawMessage, &filter)
			}
		}

		return common.Collection{
			ID:         int(e.ID),
			Collection: e.Collection,
			Type:       e.FilterType.ValueOrZero(),
			Filter:     filter,
			Name:       e.Name.ValueOrZero(),
		}
	})
}

// ListCollections returns a list of collections
func (q *Queries) ListCollections(ctx context.Context) ([]common.Collection, error) {
	collections, err := q.listCollections(ctx)
	if err != nil {
		return nil, err
	}
	return mapToCollections(collections), nil
}

// GetCollections returns collections
func (q *Queries) GetCollections(ctx context.Context, ids []int) ([]common.Collection, error) {
	collections, err := q.getCollections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToCollections(collections), nil
}

func mapToCollectionItems(items []CollectionsItem) []common.CollectionItem {
	return lo.Map(items, func(i CollectionsItem, _ int) common.CollectionItem {
		var itemID null.Int
		switch i.Type.ValueOrZero() {
		case "page":
			itemID = i.PageID
		case "show":
			itemID = i.ShowID
		case "season":
			itemID = i.SeasonID
		case "episode":
			itemID = i.EpisodeID
		}
		return common.CollectionItem{
			ID:           int(i.ID),
			Sort:         int(i.Sort.ValueOrZero()),
			CollectionID: int(i.CollectionID.Int64),
			Type:         common.ItemType(i.Type.ValueOrZero()),
			ItemID:       int(itemID.ValueOrZero()),
		}
	})
}

// GetItemsForCollections returns []common.CollectionItem for specified collections
func (q *Queries) GetItemsForCollections(ctx context.Context, ids []int) ([]common.CollectionItem, error) {
	items, err := q.getCollectionItemsForCollections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToCollectionItems(items), nil
}

// GetItemsForCollectionsWithRoles returns []common.CollectionItem for specified collections
func (rq *RoleQueries) GetItemsForCollectionsWithRoles(ctx context.Context, ids []int) ([]common.CollectionItem, error) {
	items, err := rq.queries.getCollectionItemsForCollectionsWithRoles(ctx, getCollectionItemsForCollectionsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return mapToCollectionItems(items), nil
}
