package graph

import (
	"context"
	"errors"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
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

// isItemUnavailableErr reports whether err is a permission/availability error that
// should resolve to a null item instead of failing the response.
func isItemUnavailableErr(err error) bool {
	return errors.Is(err, common.ErrItemNotPublished) ||
		errors.Is(err, common.ErrItemNotFound) ||
		errors.Is(err, common.ErrItemNoAccess)
}

// userCollectionEntryItemInfo loads the underlying item of a collection entry and returns
// its title and whether the item currently resolves for the user. The title is returned
// even when the item is unavailable (deliberately bypassing access rules — title only);
// a nil title means the item no longer exists.
func (r *Resolver) userCollectionEntryItemInfo(ctx context.Context, entryID string) (*string, bool, error) {
	e, err := r.Loaders.UserCollectionEntryLoader.Get(ctx, utils.AsUuid(entryID))
	if err != nil || e == nil {
		return nil, false, err
	}
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, false, err
	}
	languages := user.GetLanguagesFromCtx(ginCtx)

	validate := func(accessErr error) (bool, error) {
		if errors.Is(accessErr, common.ErrItemNotPublished) || errors.Is(accessErr, common.ErrItemNoAccess) {
			return false, nil
		}
		return accessErr == nil, accessErr
	}

	switch e.Type {
	case "episode":
		id, err := r.Loaders.EpisodeIDFromUuidLoader.Get(ctx, e.ItemID)
		if err != nil || id == nil {
			return nil, false, err
		}
		episode, err := r.Loaders.EpisodeLoader.Get(ctx, id.Value)
		if err != nil || episode == nil {
			return nil, false, err
		}
		title := episode.Title.Get(languages)
		if episode.Unlisted() && user.GetFromCtx(ginCtx).Anonymous {
			return &title, false, nil
		}
		available, err := validate(user.ValidateAccess(ctx, r.Loaders.EpisodePermissionLoader, episode.ID, user.CheckConditions{FromDate: true}))
		return &title, available, err
	case "show":
		id, err := r.Loaders.ShowIDFromUuidLoader.Get(ctx, e.ItemID)
		if err != nil || id == nil {
			return nil, false, err
		}
		show, err := r.Loaders.ShowLoader.Get(ctx, id.Value)
		if err != nil || show == nil {
			return nil, false, err
		}
		title := show.Title.Get(languages)
		available, err := validate(user.ValidateAccess(ctx, r.Loaders.ShowPermissionLoader, show.ID, user.CheckConditions{FromDate: true}))
		return &title, available, err
	case "short":
		short, err := r.Loaders.ShortLoader.Get(ctx, e.ItemID)
		if err != nil || short == nil {
			return nil, false, err
		}
		title := short.Title.Get(languages)
		shortIDSegments, err := r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
		if err != nil {
			return &title, false, err
		}
		return &title, lo.Contains(lo.Flatten(shortIDSegments), e.ItemID), nil
	}
	return nil, false, nil
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
	entryIDs := common.MappingValues(list)
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
