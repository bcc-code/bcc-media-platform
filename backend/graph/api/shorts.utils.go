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
	mediaIDLoader := r.GetLoaders().ShortsMediaIDLoader
	mediaIDLoader.LoadMany(ctx, shortIDs)
	if err != nil {
		return nil, err
	}
	// because we are shuffling, we need to copy the array to avoid editing the pointer value
	arr := make([]uuid.UUID, len(shortIDs))
	copy(arr, shortIDs)
	if p != nil {
		mappedIDs := map[uuid.UUID]uuid.UUID{}
		var mIDs []uuid.UUID
		for _, sID := range arr {
			mID, err := mediaIDLoader.Get(ctx, sID)
			if err != nil {
				return nil, err
			}
			if mID == nil {
				continue
			}
			mappedIDs[sID] = *mID
			mIDs = append(mIDs, *mID)
		}
		mediaIDs, err := r.GetQueries().GetProgressedMediaIDs(ctx, sqlc.GetProgressedMediaIDsParams{
			ProfileID: p.ID,
			ItemIds:   mIDs,
		})
		if err != nil {
			return nil, err
		}
		arr = lo.Filter(arr, func(i uuid.UUID, _ int) bool {
			return !lo.Contains(mediaIDs, mappedIDs[i])
		})
	}
	ids := lo.Shuffle(arr)
	return utils.NewCursor(ids), nil
}

func (r *Resolver) shortIDsToMediaIDs(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
	res, err := r.GetLoaders().ShortsMediaIDLoader.GetMany(ctx, ids)
	if err != nil {
		return nil, err
	}
	return utils.PointerArrayToArray(res), nil
}

func (r *Resolver) clearShortsProgress(ctx context.Context, p *common.Profile) error {
	shortIDs, err := r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
	if err != nil {
		return err
	}
	mediaIDs, err := r.shortIDsToMediaIDs(ctx, shortIDs)
	err = r.GetQueries().RemoveProgressForMediaIDs(ctx, sqlc.RemoveProgressForMediaIDsParams{
		ProfileID: p.ID,
		ItemIds:   mediaIDs,
	})
	if err != nil {
		return err
	}
	return nil
}

func (r *Resolver) getShorts(ctx context.Context, cursor *string, limit *int) (*model.ShortsPagination, error) {
	p, err := getProfile(ctx)
	if err != nil && !errors.Is(err, ErrProfileNotSet) {
		return nil, err
	}
	var c *utils.Cursor[uuid.UUID]
	if cursor != nil {
		c, err = utils.ParseCursor[uuid.UUID](*cursor)
	} else {
		c, err = r.getShuffledShortIDsCursor(ctx, p)
	}
	if err != nil {
		return nil, err
	}
	l := 10
	if limit != nil {
		l = *limit
	}
	var nextCursor *utils.Cursor[uuid.UUID]
	// if the cursor doesn't have enough to satisfy the length of the limit, the next cursor is a new random one
	// TODO: implement filling the required number of IDs instead of giving up and generating a new from scratch.
	nextKey := c.Position(c.CurrentIndex + l)
	if nextKey != nil {
		nextCursor = c.CursorFor(*nextKey)
	} else {
		if p != nil {
			err = r.clearShortsProgress(ctx, p)
			if err != nil {
				return nil, err
			}
		}

		nextCursor, err = r.getShuffledShortIDsCursor(ctx, p)
		if err != nil {
			return nil, err
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
