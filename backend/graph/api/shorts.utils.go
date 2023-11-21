package graph

import (
	"context"
	"errors"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (r *Resolver) getShuffledShortIDsCursor(ctx context.Context, p *common.Profile) (*utils.Cursor[uuid.UUID], error) {
	shortIDs, err := r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
	if err != nil {
		return nil, err
	}
	// because we are shuffling, we need to copy the array to avoid editing the pointer value
	arr := make([]uuid.UUID, len(shortIDs))
	copy(arr, shortIDs)
	if p != nil {
		ids, err := r.GetQueries().GetProgressedVideoIDs(ctx, sqlc.GetProgressedVideoIDsParams{
			ProfileID: p.ID,
			ItemIds:   shortIDs,
		})
		if err != nil {
			return nil, err
		}
		arr = lo.Filter(arr, func(i uuid.UUID, _ int) bool {
			return !lo.Contains(ids, i)
		})
	}
	ids := lo.Shuffle(arr)
	return utils.NewCursor(ids), nil
}

func (r *Resolver) getShorts(ctx context.Context, cursor *string, limit *int) (*model.ShortsPagination, error) {
	p, err := getProfile(ctx)
	if err != nil && !errors.Is(err, ErrProfileNotSet) {
		return nil, err
	}
	var c *utils.Cursor[uuid.UUID]
	if cursor != nil {
		c, err = utils.ParseCursor[uuid.UUID](*cursor)
		if err != nil {
			return nil, err
		}
	} else {
		c, err = r.getShuffledShortIDsCursor(ctx, p)
		if err != nil {
			return nil, err
		}
	}
	l := 10
	if limit != nil {
		l = *limit
	}
	var nextCursor *utils.Cursor[uuid.UUID]
	{
		// if the cursor doesn't have enough to satisfy the length of the limit, the next cursor is a new random one
		// TODO: implement filling the required number of IDs instead of giving up and generating a new from scratch.
		nextKey := c.Position(c.CurrentIndex + l)
		if nextKey != nil {
			nextCursor = c.CursorFor(*nextKey)
		} else {
			if p != nil {
				err = r.GetQueries().RemoveProgressForVideoIDs(ctx, sqlc.RemoveProgressForVideoIDsParams{
					ProfileID: p.ID,
					ItemIds:   c.Keys,
				})
				if err != nil {
					return nil, err
				}
			}

			nextCursor, err = r.getShuffledShortIDsCursor(ctx, p)
			if err != nil {
				return nil, err
			}
		}
	}

	keys := c.GetKeys(l)

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
			return shortToShort(ctx, i)
		}),
	}, nil
}

func shortToShort(ctx context.Context, short *common.Short) *model.Short {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	return &model.Short{
		ID:          short.ID.String(),
		Title:       short.Title.Get(languages),
		Description: short.Description.GetValueOrNil(languages),
	}
}
