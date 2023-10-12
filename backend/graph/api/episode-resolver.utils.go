package graph

import (
	"context"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/items/collection"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"math/rand"
)

func (r *episodeResolver) getEpisodeContext(ctx context.Context, episodeID string) (common.EpisodeContext, error) {
	ginCtx, _ := utils.GinCtx(ctx)
	episodeContext, ok := ginCtx.Value(episodeContextKey).(common.EpisodeContext)

	if ok {
		return episodeContext, nil
	}

	_, err := getProfile(ctx)
	if err != nil {
		return episodeContext, nil
	}
	progress, err := r.ProfileLoaders(ctx).ProgressLoader.Get(ctx, utils.AsInt(episodeID))
	if err != nil {
		return episodeContext, err
	}
	if progress != nil {
		episodeContext = progress.Context
	}

	return episodeContext, nil
}

func (r *episodeResolver) getEpisodeQueue(ctx context.Context, episodeID string) ([]int, error) {
	episodeContext, err := r.getEpisodeContext(ctx, episodeID)
	if err != nil {
		return nil, err
	}

	var episodeIDs []int
	// If the EpisodeContext has a valid CollectionID, use the collectionID to retrieve episodeIDs
	// else, use the episodes in the season (if any)
	if episodeContext.CollectionID.Valid {
		items, err := collection.GetCollectionEntries(ctx, r.Loaders, r.GetFilteredLoaders(ctx), int(episodeContext.CollectionID.Int64))
		if err != nil {
			return nil, err
		}
		items = lo.Filter(items, func(i collection.Entry, _ int) bool {
			return i.Collection == common.CollectionEpisodes
		})
		episodeIDs = lo.Map(items, func(i collection.Entry, _ int) int {
			return utils.AsInt(i.ID)
		})
	} else {
		episode, err := r.Loaders.EpisodeLoader.Get(ctx, utils.AsInt(episodeID))
		if err != nil || !episode.SeasonID.Valid {
			return nil, err
		}
		season, err := r.Loaders.SeasonLoader.Get(ctx, int(episode.SeasonID.Int64))
		if err != nil || season == nil {
			return nil, err
		}
		seasonIDs, err := r.GetFilteredLoaders(ctx).SeasonsLoader.Get(ctx, season.ShowID)
		if err != nil {
			return nil, err
		}
		episodePointerIDs, err := r.GetFilteredLoaders(ctx).EpisodesLoader.GetMany(ctx, utils.PointerArrayToArray(seasonIDs))
		if err != nil {
			return nil, err
		}
		episodeIDs = lo.Reduce(episodePointerIDs, func(a []int, b []*int, _ int) []int {
			return append(a, utils.PointerArrayToArray(b)...)
		}, []int{})
	}
	return episodeIDs, nil
}

func (r *episodeResolver) getEpisodeCursor(ctx context.Context, episodeID string) (*utils.Cursor[int], error) {
	return utils.GetOrSetContextWithLock(ctx, "cursor-lock-"+episodeID, func() (*utils.Cursor[int], error) {
		episodeContext, err := r.getEpisodeContext(ctx, episodeID)
		if err != nil {
			return nil, err
		}
		var cursor *utils.Cursor[int]
		if episodeContext.Cursor.Valid {
			cursor, err = utils.ParseCursor[int](episodeContext.Cursor.String)
			if err != nil {
				return nil, err
			}
			cursor = cursor.CursorFor(utils.AsInt(episodeID))
		}
		if cursor == nil {
			episodeIDs, err := r.getEpisodeQueue(ctx, episodeID)
			if err != nil {
				return nil, err
			}
			if episodeContext.Shuffle.Valid && episodeContext.Shuffle.Bool {
				episodeIDs = lo.Shuffle(episodeIDs)
			}
			cursor = utils.ToCursor(episodeIDs, utils.AsInt(episodeID))
		}
		return cursor, nil
	})
}

func (r *episodeResolver) getNextEpisodes(ctx context.Context, episodeID string, limit *int) ([]int, error) {
	cursor, err := r.getEpisodeCursor(ctx, episodeID)
	if err != nil {
		return nil, err
	}

	next := cursor.NextCursor()
	if next == nil {
		ids, err := r.getNextFromShowCollection(ctx, episodeID)
		if err != nil {
			return nil, err
		}
		if len(ids) > 0 {
			return ids, nil
		}
		return r.getRelatedEpisodes(ctx, episodeID)
	}

	l := 1
	if limit != nil {
		l = *limit
	}

	return cursor.NextKeys(l), nil
}

func (r *episodeResolver) getNextFromShowCollection(ctx context.Context, episodeID string) ([]int, error) {
	intID := utils.AsInt(episodeID)
	episode, err := r.Loaders.EpisodeLoader.Get(ctx, intID)
	if err != nil || !episode.SeasonID.Valid {
		return nil, err
	}
	season, err := r.Loaders.SeasonLoader.Get(ctx, int(episode.SeasonID.Int64))
	if err != nil || season == nil {
		return nil, err
	}
	show, err := r.Loaders.ShowLoader.Get(ctx, season.ShowID)
	if err != nil || show == nil || !show.RelatedCollectionID.Valid {
		return nil, err
	}
	entries, err := collection.GetCollectionEntries(ctx, r.Loaders, r.GetFilteredLoaders(ctx), int(show.RelatedCollectionID.Int64))
	if err != nil {
		return nil, err
	}
	episodeEntries := lo.Filter(entries, func(i collection.Entry, _ int) bool {
		return i.Collection == common.CollectionEpisodes && i.ID != episodeID
	})
	if len(episodeEntries) <= 0 {
		return nil, nil
	}
	randomIndex := rand.Intn(len(episodeEntries))
	return []int{
		utils.AsInt(episodeEntries[randomIndex].ID),
	}, nil
}

func (r *episodeResolver) getRelatedEpisodes(ctx context.Context, episodeID string) ([]int, error) {
	intID := utils.AsInt(episodeID)
	episode, err := r.Loaders.EpisodeLoader.Get(ctx, intID)
	if err != nil {
		return nil, err
	}
	episodeGroupIDs, err := r.GetFilteredLoaders(ctx).TagEpisodesLoader.GetMany(ctx, episode.TagIDs)
	if err != nil {
		return nil, err
	}
	episodeIDs := lo.Reduce(episodeGroupIDs, func(a []int, b []*int, _ int) []int {
		return append(a, utils.PointerArrayToArray(b)...)
	}, []int{})
	// Uncomment if we want all episodes to be treated equally.
	// Keep it commented out to weigh episode with more common tags higher.
	//episodeIDs = lo.Uniq(episodeIDs)
	episodeIDs = lo.Filter(episodeIDs, func(i int, _ int) bool {
		return i != intID
	})
	if len(episodeIDs) <= 0 {
		return nil, nil
	}
	randomIndex := rand.Intn(len(episodeIDs))
	return []int{episodeIDs[randomIndex]}, nil
}

func (r *episodeResolver) getTitleFromContext(ctx context.Context, obj *model.Episode) (string, error) {
	episode, err := r.Loaders.EpisodeLoader.Get(ctx, utils.AsInt(obj.ID))
	if err != nil {
		return "", err
	}

	if obj.Number == nil {
		return obj.Title, nil
	}

	episodeContext, err := r.getEpisodeContext(ctx, obj.ID)
	if err != nil {
		return "", err
	}

	if episodeContext.CollectionID.Valid {
		return r.getTitleWithCollection(ctx, obj, episodeContext.CollectionID)
	}

	if episode.NumberInTitle {
		return fmt.Sprintf("%d. %s", *obj.Number, obj.Title), nil
	}

	return obj.Title, nil
}

func (r *episodeResolver) getTitleWithCollection(ctx context.Context, episode *model.Episode, collectionID null.Int) (string, error) {
	col, err := r.Loaders.CollectionLoader.Get(ctx, int(collectionID.Int64))
	if err != nil || col == nil {
		return episode.Title, err
	}
	if col.NumberInTitles {
		return fmt.Sprintf("%d. %s", *episode.Number, episode.Title), nil
	}
	return episode.Title, nil
}
