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
		var filter *json.RawMessage

		switch e.FilterType.ValueOrZero() {
		case "query":
			switch e.Collection.ValueOrZero() {
			case "pages":
				msg := e.PagesQueryFilter.RawMessage
				filter = &msg
			case "shows":
				msg := e.ShowsQueryFilter.RawMessage
				filter = &msg
			case "seasons":
				msg := e.SeasonsQueryFilter.RawMessage
				filter = &msg
			case "episodes":
				msg := e.EpisodesQueryFilter.RawMessage
				filter = &msg
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

// GetItemsForCollections returns []common.CollectionItem for specified collections
func (q *Queries) GetItemsForCollections(ctx context.Context, ids []int) ([]common.CollectionItem, error) {
	items, err := q.getCollectionItemsForCollections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(items, func(i CollectionItem, _ int) common.CollectionItem {
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
			Type:         i.Type.ValueOrZero(),
			ItemID:       int(itemID.ValueOrZero()),
		}
	}), nil
}
