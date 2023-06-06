package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/google/uuid"
)

func (r *Resolver) addItemToCollection(ctx context.Context, itemType string, itemID string) (*common.UserCollectionEntry, error) {
	myList, err := r.QueryRoot().MyList(ctx)
	if err != nil {
		return nil, err
	}
	var uid uuid.UUID
	switch itemType {
	case "show":
		gql, err := r.QueryRoot().Show(ctx, itemID)
		if err != nil {
			return nil, err
		}
		i, err := r.Loaders.EpisodeLoader.Get(ctx, utils.AsInt(gql.ID))
		if err != nil {
			return nil, err
		}
		uid = i.UUID
	case "episode":
		gql, err := r.QueryRoot().Episode(ctx, itemID, nil)
		if err != nil {
			return nil, err
		}
		i, err := r.Loaders.EpisodeLoader.Get(ctx, utils.AsInt(gql.ID))
		if err != nil {
			return nil, err
		}
		uid = i.UUID
	default:
		return nil, common.ErrItemNotFound
	}
	entryID := uuid.New()
	entry := &common.UserCollectionEntry{
		ID:           entryID,
		CollectionID: utils.AsUuid(myList.ID),
		ItemID:       uid,
		Type:         itemType,
	}
	err = r.Queries.UpsertUserCollectionEntry(ctx, sqlc.UpsertUserCollectionEntryParams{
		CollectionID: entry.CollectionID,
		ID:           entry.ID,
		ItemID:       entry.ItemID,
		Type:         entry.Type,
	})
	if err != nil {
		return nil, err
	}
	myListID := utils.AsUuid(myList.ID)
	r.Loaders.UserCollectionEntryIDsLoader.Clear(ctx, myListID)
	return entry, nil
}
