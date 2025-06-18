package graph

import (
	"context"
	"errors"
	"github.com/bcc-code/bcc-media-platform/backend/cursors"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/unleash"

	"github.com/99designs/gqlgen/graphql"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

const shortsWatchedThreshold = 0.4

func (r *Resolver) getShuffledShortIDs(ctx context.Context, seed int64) ([]uuid.UUID, error) {
	shortIDSegments, err := r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
	if err != nil {
		return nil, err
	}

	ids := lo.Flatten(shortIDSegments)

	return cursors.ShuffleSegmentedArray(ids, 10, 1, seed), nil
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

type shortsShuffledResult struct {
	Cursor     *cursors.RandomizedCursor
	NextCursor *cursors.RandomizedCursor
	Keys       []uuid.UUID
}

func (r *Resolver) getShuffledShortIDsWithCursor(ctx context.Context, p *common.Profile, cursor *cursors.RandomizedCursor, limit *int, initialID uuid.UUID) (*shortsShuffledResult, error) {
	if cursor == nil {
		cursor = cursors.NewRandomizedCursor(true, 1)
	}

	if cursor.Seed == nil {
		seed := time.Now().UnixMilli()
		cursor.Seed = &seed
	}

	ginCtx, _ := utils.GinCtx(ctx)
	featureFlags := utils.GetFeatureFlags(ginCtx)

	var shortIDSegments [][]uuid.UUID
	var err error

	if value, ok := featureFlags.GetVariant(unleash.ShortsWithScoresFlag); ok && value == unleash.ShortsWithScoresEnabledVariant {
		cursor.RandomFactor = 0 // Else random shorts are inserted, but here we want total control
		utils.ReportFlagActivation(ginCtx, unleash.ShortsWithScoresFlag, unleash.ShortsWithScoresEnabledVariant)
		shortIDs, iErr := r.GetFilteredLoaders(ctx).ShortWithScoresLoader(ctx)
		err = iErr

		declumpedShortIds := declumpShorts(shortIDs, 5)
		shortIDSegments = [][]uuid.UUID{}

		segment := []uuid.UUID{}

		// Split the sorts into groups, so the shuffling happens only within each group
		for i, short := range declumpedShortIds {
			segment = append(segment, short)

			if i%5 == 0 {
				shortIDSegments = append(shortIDSegments, segment)
				segment = []uuid.UUID{}
			}
		}
	} else {
		shortIDSegments, err = r.GetFilteredLoaders(ctx).ShortIDsLoader(ctx)
	}

	if err != nil {
		return nil, err
	}

	shortIDs := lo.Flatten(shortIDSegments)

	if p != nil {
		shortIDs, err = r.applyWatchedFilter(ctx, shortIDs, p)
		if err != nil {
			return nil, err
		}
	}

	shortIDs = cursors.ApplyRandomizedCursorToSegments(*cursor, shortIDs, 5)

	if initialID != uuid.Nil {
		shortIDs = applyInitialShort(shortIDs, initialID, *cursor)
	}

	l := 20
	if limit != nil {
		l = *limit
	}

	var keys []uuid.UUID

	for _, id := range shortIDs {

		keys = append(keys, id)

		if len(keys) >= l {
			break
		}
	}

	lastID, _ := lo.Last(keys)

	nextCursor := &cursors.RandomizedCursor{
		Seed:         cursor.Seed,
		RandomFactor: cursor.RandomFactor,
		CurrentIndex: cursor.CurrentIndex + lo.IndexOf(shortIDs, lastID) + 1,
	}

	// if we don't have enough keys, restart the cursor while also setting progress for all shorts to 0.0,
	// also add the shorts from the beginning onwards.
	if len(keys) < l {
		nextCursor.CurrentIndex = 0
		err = r.clearShortsProgress(ctx, p)
		if err != nil {
			return nil, err
		}

		shortIDs, err = r.getShuffledShortIDs(ctx, *cursor.Seed)
		if err != nil {
			return nil, err
		}

		for _, id := range shortIDs {
			keys = append(keys, id)
			nextCursor.CurrentIndex++
			if len(keys) >= l {
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

// declumpShorts attempts to reduce the number of shorts from the same episode
// by making sure there is only one from a given episode inside a "declumpingTreshold" window
// in order to not have "clumps" of shorts that have material from the same episode
func declumpShorts(shortIDs []common.ShortIDWithMeta, declumpingTreshold int) []uuid.UUID {
	lastSeen := map[int64]int{}
	var declumpedShortIds []uuid.UUID

	for i, short := range shortIDs {
		if short.ParentEpisodeID.Valid {
			if lastIdx, ok := lastSeen[short.ParentEpisodeID.Int64]; ok && i-lastIdx < declumpingTreshold {
				continue
			}
			lastSeen[short.ParentEpisodeID.Int64] = i
		}
		declumpedShortIds = append(declumpedShortIds, short.ID)
	}

	return declumpedShortIds
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
	if err != nil {
		return err
	}
	err = r.GetQueries().RemoveProgressForMediaIDs(ctx, sqlc.RemoveProgressForMediaIDsParams{
		ProfileID: p.ID,
		ItemIds:   mediaIDs,
	})
	if err != nil {
		return err
	}
	return nil
}

func (r *Resolver) getShorts(ctx context.Context, cursor *string, limit *int, initialID *string) (*model.ShortsPagination, error) {
	p, err := getProfile(ctx)
	if err != nil && !errors.Is(err, ErrProfileNotSet) {
		return nil, err
	}
	var c *cursors.RandomizedCursor
	if cursor != nil {
		c, err = cursors.ParseRandomizedCursor(*cursor)
	}
	if err != nil {
		return nil, err
	}

	var initialUUID uuid.UUID
	if initialID != nil {
		initialUUID, err = uuid.Parse(*initialID)
		if err != nil {
			return nil, err
		}
	}

	result, err := r.getShuffledShortIDsWithCursor(ctx, p, c, limit, initialUUID)
	if err != nil {
		return nil, err
	}

	shorts, err := r.GetLoaders().ShortLoader.GetMany(ctx, result.Keys)
	if err != nil {
		return nil, err
	}

	if initialUUID != uuid.Nil && result.Cursor.CurrentIndex == 0 {
		isInResult := false
		for _, s := range shorts {
			if s.ID == initialUUID {
				isInResult = true
				break
			}
		}
		if !isInResult {
			graphql.AddError(ctx, ErrItemNotFound)
		}
	}

	currentCursorString, err := cursors.MarshalAndBase64Encode(result.Cursor)
	if err != nil {
		return nil, err
	}

	nextCursorString, err := cursors.MarshalAndBase64Encode(result.NextCursor)
	if err != nil {
		return nil, err
	}

	shortsOut := lo.Map(shorts, func(i *common.Short, _ int) *model.Short {
		return shortToShort(ctx, i)
	})

	return &model.ShortsPagination{
		Cursor:     currentCursorString,
		NextCursor: nextCursorString,
		Shorts:     shortsOut,
	}, nil
}

func shortToShort(ctx context.Context, short *common.Short) *model.Short {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	return &model.Short{
		ID:          short.ID.String(),
		Title:       short.Title.Get(languages),
		Description: short.Description.GetValueOrNil(languages),
		Score:       short.Score,
	}
}

func applyInitialShort(shortIDs []uuid.UUID, initialID uuid.UUID, cursor cursors.RandomizedCursor) []uuid.UUID {
	for i, id := range shortIDs {
		if id == initialID {
			shortIDs = append(shortIDs[:i], shortIDs[i+1:]...)
			break
		}
	}
	if cursor.CurrentIndex == 0 {
		shortIDs = append([]uuid.UUID{initialID}, shortIDs...)
	}
	return shortIDs
}

// applyWatchedFilter filters out shorts that are watched
// keep in mind that this messes up the cursor,
// so the same cursor will not return the same shorts if they are watched
func (r *Resolver) applyWatchedFilter(ctx context.Context, shortIDs []uuid.UUID, p *common.Profile) ([]uuid.UUID, error) {
	mappedIDs, err := r.getShortToMediaIDMap(ctx, shortIDs)
	if err != nil {
		return nil, err
	}
	progress, err := r.GetProfileLoaders(ctx).MediaProgressLoader.GetMany(ctx, lo.Values(mappedIDs))
	if err != nil {
		return nil, err
	}
	var ignoreIDs []uuid.UUID
	for _, pr := range progress {
		if pr == nil {
			continue
		}
		if pr.Progress > 0.1 {
			ignoreIDs = append(ignoreIDs, pr.MediaID)
		}
	}
	shortIDs = lo.Filter(shortIDs, func(i uuid.UUID, _ int) bool {
		return !lo.Contains(ignoreIDs, mappedIDs[i])
	})
	return shortIDs, nil
}
