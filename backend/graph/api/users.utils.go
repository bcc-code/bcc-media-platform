package graph

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
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
	case "short":
		gql, err := r.QueryRoot().Short(ctx, itemID)
		if err != nil {
			return nil, err
		}
		uid = utils.AsUuid(gql.ID)
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

func (r *Resolver) isInMyList(ctx context.Context, id uuid.UUID) (bool, error) {
	myList, err := r.QueryRoot().MyList(ctx)
	if err != nil {
		return false, nil
	}
	list, err := r.Loaders.UserCollectionEntryIDsLoader.Get(ctx, utils.AsUuid(myList.ID))
	if err != nil {
		return false, err
	}
	entryIDs := utils.PointerArrayToArray(list)
	chunks := lo.Chunk(entryIDs, 20)
	for _, chunk := range chunks {
		entries, err := r.Loaders.UserCollectionEntryLoader.GetMany(ctx, chunk)
		if err != nil {
			return false, err
		}
		for _, entry := range entries {
			if entry.ItemID == id {
				return true, nil
			}
		}
	}
	return false, nil
}
