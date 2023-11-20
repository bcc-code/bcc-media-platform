package graph

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (r *Resolver) getShorts(ctx context.Context, cursor *string, limit *int) (*model.ShortsPagination, error) {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	var err error
	var c *utils.Cursor[uuid.UUID]
	if cursor != nil {
		c, err = utils.ParseCursor[uuid.UUID](*cursor)
		if err != nil {
			return nil, err
		}
	} else {
		shortIDs, err := r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
		if err != nil {
			return nil, err
		}
		arr := make([]uuid.UUID, len(shortIDs))
		copy(arr, shortIDs)
		ids := lo.Shuffle(arr)
		c = utils.ToCursor(ids, shortIDs[0])
	}
	l := 10
	if limit != nil {
		l = *limit
	}
	var nextCursor *utils.Cursor[uuid.UUID]
	{
		nextKey := c.Position(c.CurrentIndex + l)
		if nextKey != nil {
			nextCursor = c.CursorFor(*nextKey)
		} else {
			shortIDs, err := r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
			if err != nil {
				return nil, err
			}
			arr := make([]uuid.UUID, len(shortIDs))
			copy(arr, shortIDs)
			ids := lo.Shuffle(arr)
			nextCursor = utils.ToCursor(ids, ids[0])
		}
	}

	keys := c.NextKeys(l)

	shorts, err := r.GetLoaders().ShortLoader.GetMany(ctx, keys)
	if err != nil {
		return nil, err
	}

	currentCursorString, err := c.Encode()
	if err != nil {
		return nil, err
	}
	nextCursorString, err := nextCursor.Encode()
	if err != nil {
		return nil, err
	}

	return &model.ShortsPagination{
		Cursor:     currentCursorString,
		NextCursor: nextCursorString,
		Shorts: lo.Map(shorts, func(i *common.Short, _ int) *model.Short {
			return &model.Short{
				ID:          i.ID.String(),
				Title:       i.Title.Get(languages),
				Description: i.Description.GetValueOrNil(languages),
				Image:       i.Images.GetDefault(languages, common.ImageStyleDefault),
			}
		}),
	}, nil
}
