package graph

import (
	"context"
	"fmt"
	"strconv"

	"github.com/99designs/gqlgen/graphql"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/items/collection"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"go.opentelemetry.io/otel"
	"gopkg.in/guregu/null.v4"
)

func (r *episodeResolver) getEpisodeContext(ctx context.Context, episodeID string) (common.EpisodeContext, error) {
	ctx, span := otel.Tracer("episode-resolver").Start(ctx, "getEpisodeContext")
	defer span.End()
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
	ctx, span := otel.Tracer("episode-resolver").Start(ctx, "getEpisodeQueue")
	defer span.End()
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

func (r *Resolver) episodeIDResolver(ctx context.Context, id string) (string, error) {
	ctx, span := otel.Tracer("episode-resolver").Start(ctx, "episodeIDResolver")
	defer span.End()
	if intID, err := strconv.ParseInt(id, 10, 64); err == nil {
		e, err := r.GetLoaders().EpisodeLoader.Get(ctx, int(intID))
		if err != nil {
			return "", err
		}
		ginCtx, _ := utils.GinCtx(ctx)
		u := user.GetFromCtx(ginCtx)
		if e == nil || (e.Unlisted() && u.Anonymous) {
			return "", ErrItemNotFound
		}
		return id, nil
	} else {
		uuidValue, err := uuid.Parse(id)
		if err != nil {
			return "", ErrItemNotFound
		}
		eid, err := r.GetLoaders().EpisodeIDFromUuidLoader.Get(ctx, uuidValue)
		if err != nil {
			return "", err
		}
		if eid == nil {
			return "", ErrItemNotFound
		}
		return strconv.Itoa(*eid), nil
	}
}

func (r *episodeResolver) getRootEpisodeID(ctx context.Context) (string, error) {
	ctx, span := otel.Tracer("episode-resolver").Start(ctx, "getRootEpisodeID")
	defer span.End()
	opCtx := graphql.GetRootFieldContext(ctx)
	arg := opCtx.Field.Arguments.ForName("id")
	if arg != nil {
		return r.episodeIDResolver(ctx, arg.Value.Raw)
	}
	return "", fmt.Errorf("no root episode found")
}

func (r *episodeResolver) getEpisodeCursor(ctx context.Context, episodeID string) (*utils.Cursor[int], error) {
	ctx, span := otel.Tracer("episode-resolver").Start(ctx, "getEpisodeCursor")
	defer span.End()
	return utils.GetOrSetContextWithLock(ctx, "cursor-lock-"+episodeID, func() (*utils.Cursor[int], error) {
		intID := utils.AsInt(episodeID)
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
			cursor = cursor.CursorFor(intID)
		}
		if cursor == nil {
			rootID, err := r.getRootEpisodeID(ctx)
			if err == nil && rootID != episodeID {
				cursor, err = r.getEpisodeCursor(ctx, rootID)
				if err != nil {
					return nil, err
				}
				cursor = cursor.CursorFor(intID)
			}
		}
		if cursor == nil {
			episodeIDs, err := r.getEpisodeQueue(ctx, episodeID)
			if err != nil {
				return nil, err
			}
			if episodeContext.Shuffle.Valid && episodeContext.Shuffle.Bool {
				episodeIDs = append([]int{intID}, lo.Shuffle(lo.Filter(episodeIDs, func(id int, _ int) bool {
					return id != intID
				}))...)
			}
			cursor = utils.ToCursor(episodeIDs, intID)
		}
		return cursor, nil
	})
}

func appendShuffledKeys[K comparable](keys []K, ids []K, maxLength int) []K {
	ids = lo.Shuffle(ids)
	for _, id := range ids {
		if !lo.Contains(keys, id) {
			keys = append(keys, id)
		}
		if len(keys) >= maxLength {
			break
		}
	}
	return keys
}

func (r *episodeResolver) getNextEpisodes(ctx context.Context, episodeID string, limit *int) ([]int, error) {
	ctx, span := otel.Tracer("episode-resolver").Start(ctx, "getNextEpisodes")
	defer span.End()
	cursor, err := r.getEpisodeCursor(ctx, episodeID)
	if err != nil {
		return nil, err
	}

	l := 1
	if limit != nil {
		l = *limit
	}

	keys := cursor.NextKeys(5)
	if len(keys) < l {
		var ids []int
		ids, err = r.getNextEpisodeIDsFromShowCollection(ctx, episodeID)
		if err != nil {
			return nil, err
		}

		keys = appendShuffledKeys(keys, ids, l)
		if len(keys) >= l {
			return keys[:l], nil
		}

		ids, err = r.getRelatedEpisodeIDs(ctx, episodeID)
		if err != nil {
			return nil, err
		}

		keys = appendShuffledKeys(keys, ids, l)
		if len(keys) >= l {
			return keys[:l], nil
		}
	}
	return keys, nil
}

func (r *episodeResolver) getNextEpisodeIDsFromShowCollection(ctx context.Context, episodeID string) ([]int, error) {
	ctx, span := otel.Tracer("episode-resolver").Start(ctx, "getNextEpisodeIDsFromShowCollection")
	defer span.End()
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
	var episodeIDs []int
	for _, i := range entries {
		if i.Collection == common.CollectionEpisodes && i.ID != episodeID {
			episodeIDs = append(episodeIDs, utils.AsInt(i.ID))
		}
	}
	return episodeIDs, nil
}

func (r *episodeResolver) getRelatedEpisodeIDs(ctx context.Context, episodeID string) ([]int, error) {
	ctx, span := otel.Tracer("episode-resolver").Start(ctx, "getRelatedEpisodeIDs")
	defer span.End()
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
	return episodeIDs, nil
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
