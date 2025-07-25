package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.74

import (
	"context"
	"strconv"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/cursors"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/generated"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
)

// EmailVerified is the resolver for the emailVerified field.
func (r *userResolver) EmailVerified(ctx context.Context, obj *model.User) (bool, error) {
	if obj.EmailVerified || obj.Anonymous || obj.ID == nil {
		return obj.EmailVerified, nil
	}

	userinfo, err := r.getUserInfo(ctx, *obj.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to get user info")

		// We do not want to break the whole query if we can't get the updated user info
		return false, nil
	}

	return userinfo.EmailVerified, nil
}

// CompletedRegistration is the resolver for the completedRegistration field.
func (r *userResolver) CompletedRegistration(ctx context.Context, obj *model.User) (bool, error) {
	if obj.CompletedRegistration || obj.Anonymous || obj.ID == nil {
		return obj.CompletedRegistration, nil
	}
	userinfo, err := r.getUserInfo(ctx, *obj.ID)
	if err != nil {
		return false, err
	}
	return userinfo.CompletedRegistration(), nil
}

// Entries is the resolver for the entries field.
func (r *userCollectionResolver) Entries(ctx context.Context, obj *model.UserCollection, first *int, offset *int, cursor *string) (*model.UserCollectionEntryPagination, error) {
	ids, err := r.Loaders.UserCollectionEntryIDsLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}

	offsetCursor := cursors.ParseOrDefaultOffsetCursor(cursor)
	page := utils.Paginate(ids, first, offset, nil, offsetCursor)
	entries, err := r.Loaders.UserCollectionEntryLoader.GetMany(ctx, utils.PointerArrayToArray(page.Items))
	if err != nil {
		return nil, err
	}

	return &model.UserCollectionEntryPagination{
		Offset:      page.Offset,
		First:       page.First,
		Total:       page.Total,
		Cursor:      page.Cursor.Encode(),
		NextCursor:  page.NextCursor.Encode(),
		HasNext:     page.HasNext,
		HasPrevious: page.HasPrevious,
		Items: lo.Map(entries, func(i *common.UserCollectionEntry, _ int) *model.UserCollectionEntry {
			return &model.UserCollectionEntry{
				ID: i.ID.String(),
			}
		}),
	}, nil
}

// Item is the resolver for the item field.
func (r *userCollectionEntryResolver) Item(ctx context.Context, obj *model.UserCollectionEntry) (model.UserCollectionEntryItem, error) {
	e, err := r.Loaders.UserCollectionEntryLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	switch e.Type {
	case "show":
		id, err := r.Loaders.ShowIDFromUuidLoader.Get(ctx, e.ItemID)
		if err != nil {
			return nil, err
		}
		if id == nil {
			return &model.Show{}, nil
		}
		return r.QueryRoot().Show(ctx, strconv.Itoa(*id))
	case "episode":
		id, err := r.Loaders.EpisodeIDFromUuidLoader.Get(ctx, e.ItemID)
		if err != nil {
			return nil, err
		}
		if id == nil {
			return &model.Episode{}, nil
		}
		return r.QueryRoot().Episode(ctx, strconv.Itoa(*id), nil)
	case "short":
		return r.QueryRoot().Short(ctx, e.ItemID.String())
	}
	return nil, common.ErrItemNotFound
}

// User returns generated.UserResolver implementation.
func (r *Resolver) User() generated.UserResolver { return &userResolver{r} }

// UserCollection returns generated.UserCollectionResolver implementation.
func (r *Resolver) UserCollection() generated.UserCollectionResolver {
	return &userCollectionResolver{r}
}

// UserCollectionEntry returns generated.UserCollectionEntryResolver implementation.
func (r *Resolver) UserCollectionEntry() generated.UserCollectionEntryResolver {
	return &userCollectionEntryResolver{r}
}

type userResolver struct{ *Resolver }
type userCollectionResolver struct{ *Resolver }
type userCollectionEntryResolver struct{ *Resolver }
