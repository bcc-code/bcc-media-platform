package graph

import (
	"context"
	"errors"
	"math/rand"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (r *Resolver) getShuffledShortIDs(ctx context.Context, seed int64) ([]uuid.UUID, error) {
	shortIDSegments, err := r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
	if err != nil {
		return nil, err
	}

	return utils.ShuffleSegmentedArray(shortIDSegments, 10, seed), nil
}

func (r *Resolver) getShortToMediaIDMap(ctx context.Context, shortIDs []uuid.UUID) (map[uuid.UUID]uuid.UUID, error) {
	mediaIDLoader := r.GetLoaders().ShortsMediaIDLoader
	mediaIDLoader.LoadMany(ctx, shortIDs)

	mappedIDs := map[uuid.UUID]uuid.UUID{}
	for _, sID := range shortIDs {
		mID, err := mediaIDLoader.Get(ctx, sID)
		if err != nil {
			return nil, err
		}
		if mID == nil {
			continue
		}
		mappedIDs[sID] = *mID
	}
	return mappedIDs, nil
}

type shortsCursor struct {
	Seed         int64 `json:"seed"`
	CurrentIndex int   `json:"currentIndex"`
}

type shortsShuffledResult struct {
	Cursor     *shortsCursor
	NextCursor *shortsCursor
	Keys       []uuid.UUID
}

func (r *Resolver) getShuffledShortIDsCursor(ctx context.Context, p *common.Profile, cursor *shortsCursor) (*shortsShuffledResult, error) {
	if cursor == nil {
		cursor = &shortsCursor{
			Seed:         rand.Int63(),
			CurrentIndex: 0,
		}
	}

	shortIDs, err := r.getShuffledShortIDs(ctx, cursor.Seed)
	if err != nil {
		return nil, err
	}

	if p != nil {
		mappedIDs, err := r.getShortToMediaIDMap(ctx, shortIDs)
		if err != nil {
			return nil, err
		}
		progress, err := r.GetQueries().GetMediaProgress(ctx, sqlc.GetMediaProgressParams{
			ProfileID: p.ID,
			ItemIds:   lo.Values(mappedIDs),
		})
		if err != nil {
			return nil, err
		}
		var ignoreIDs []uuid.UUID
		for _, pr := range progress {
			if pr.Progress > 0.1 {
				ignoreIDs = append(ignoreIDs, pr.ItemID)
			}
		}
		shortIDs = lo.Filter(shortIDs, func(i uuid.UUID, _ int) bool {
			return !lo.Contains(ignoreIDs, mappedIDs[i])
		})
	}

	var keys []uuid.UUID
	for index, id := range shortIDs {
		if index < cursor.CurrentIndex {
			continue
		}

		keys = append(keys, id)

		if len(keys) >= 20 {
			break
		}
	}
	nextCursor := &shortsCursor{
		Seed:         cursor.Seed,
		CurrentIndex: cursor.CurrentIndex + 20,
	}
	if len(keys) < 20 {
		nextCursor.CurrentIndex = 0
		err = r.clearShortsProgress(ctx, p)
		if err != nil {
			return nil, err
		}

		shortIDs, err = r.getShuffledShortIDs(ctx, cursor.Seed)
		if err != nil {
			return nil, err
		}

		for _, id := range shortIDs {
			keys = append(keys, id)
			nextCursor.CurrentIndex++
			if len(keys) >= 20 {
				break
			}
		}
	}
	return &shortsShuffledResult{
		Cursor:     cursor,
		Keys:       keys,
		NextCursor: nextCursor,
	}, nil
}

func (r *Resolver) shortIDsToMediaIDs(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
	res, err := r.GetLoaders().ShortsMediaIDLoader.GetMany(ctx, ids)
	if err != nil {
		return nil, err
	}
	return utils.PointerArrayToArray(res), nil
}

func (r *Resolver) clearShortsProgress(ctx context.Context, p *common.Profile) error {
	shortIDSegments, err := r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
	if err != nil {
		return err
	}
	shortIDs := lo.Flatten(shortIDSegments)
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
	var c *shortsCursor
	if cursor != nil {
		c, err = utils.Base64DecodeAndUnmarshal[shortsCursor](*cursor)
	}
	if err != nil {
		return nil, err
	}

	result, err := r.getShuffledShortIDsCursor(ctx, p, c)
	if err != nil {
		return nil, err
	}

	shorts, err := r.GetLoaders().ShortLoader.GetMany(ctx, result.Keys)
	if err != nil {
		return nil, err
	}

	currentCursorString, err := utils.MarshalAndBase64Encode(result.Cursor)
	if err != nil {
		return nil, err
	}

	nextCursorString, err := utils.MarshalAndBase64Encode(result.NextCursor)
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
