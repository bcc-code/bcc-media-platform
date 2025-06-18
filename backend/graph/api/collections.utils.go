package graph

import (
	"context"
	"fmt"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/cursors"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/items/collection"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"strconv"
	"time"
)

func preloadEntryLoaders(ctx context.Context, loaders *common.BatchLoaders, entries []collection.Entry) {
	for _, e := range entries {
		switch e.Collection {
		case common.CollectionShows:
			loaders.ShowLoader.Load(ctx, utils.AsInt(e.ID))
		case common.CollectionSeasons:
			loaders.SeasonLoader.Load(ctx, utils.AsInt(e.ID))
		case common.CollectionEpisodes:
			loaders.EpisodeLoader.Load(ctx, utils.AsInt(e.ID))
		case common.CollectionPages:
			loaders.PageLoader.Load(ctx, utils.AsInt(e.ID))
		case common.CollectionStudyTopics:
			loaders.StudyTopicLoader.Load(ctx, utils.AsUuid(e.ID))
		case common.CollectionLinks:
			loaders.LinkLoader.Load(ctx, utils.AsInt(e.ID))
		case common.CollectionPlaylists:
			loaders.PlaylistLoader.Load(ctx, utils.AsUuid(e.ID))
		case common.CollectionGames:
			loaders.GameLoader.Load(ctx, utils.AsUuid(e.ID))
		case common.CollectionShorts:
			loaders.ShortLoader.Load(ctx, utils.AsUuid(e.ID))
		}
	}
}

func collectionEntriesToModels(ctx context.Context, ls *common.BatchLoaders, entries []collection.Entry) ([]model.CollectionItem, error) {
	preloadEntryLoaders(ctx, ls, entries)

	var items []model.CollectionItem
	for _, e := range entries {
		switch e.Collection {
		case common.CollectionShows:
			i, err := ls.ShowLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			items = append(items, model.ShowFrom(ctx, i))
		case common.CollectionSeasons:
			i, err := ls.SeasonLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			items = append(items, model.SeasonFrom(ctx, i))
		case common.CollectionEpisodes:
			i, err := ls.EpisodeLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			items = append(items, model.EpisodeFrom(ctx, i))
		case common.CollectionPlaylists:
			i, err := ls.PlaylistLoader.Get(ctx, utils.AsUuid(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			items = append(items, model.PlaylistFrom(ctx, i))
		case common.CollectionGames:
			i, err := ls.GameLoader.Get(ctx, utils.AsUuid(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			items = append(items, model.GameFrom(ctx, i))
		case common.CollectionStudyTopics:
			i, err := ls.StudyTopicLoader.Get(ctx, utils.AsUuid(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			items = append(items, model.StudyTopicFrom(ctx, i))
		case common.CollectionShorts:
			i, err := ls.ShortLoader.Get(ctx, utils.AsUuid(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				continue
			}
			items = append(items, model.ShortFrom(ctx, i))
		}
	}
	return items, nil
}

func collectionCacheKey(ginCtx *gin.Context, languagePreferences common.LanguagePreferences, collectionId int, cursor *cursors.RandomizedCursor) string {
	profile := user.GetProfileFromCtx(ginCtx)

	cacheKey := "collection-entries-" + strconv.Itoa(collectionId) + "-"

	if profile != nil {
		cacheKey += profile.ID.String() + "-"
	}

	if cursor != nil {
		cacheKey += fmt.Sprintf("%d-%f-", cursor.CurrentIndex, cursor.RandomFactor)
	}

	cacheKey += languagePreferences.String()

	return cacheKey
}

func (r *Resolver) GetCollectionEntries(ctx context.Context, collectionId int, cursor *cursors.RandomizedCursor) ([]collection.Entry, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	languagePreferences := common.GetLanguagePreferencesFromCtx(ginCtx)

	cacheKey := collectionCacheKey(ginCtx, languagePreferences, collectionId, cursor)
	if entries, ok := memorycache.Get[[]collection.Entry](cacheKey); ok {
		return entries, nil
	}

	ls := r.GetLoaders()
	personalizedLoaders := r.PersonalizedLoaders(ctx)

	col, err := ls.CollectionLoader.Get(ctx, collectionId)
	if err != nil {
		return nil, err
	}

	entries, err := collection.GetBaseCollectionEntries(
		ctx,
		r.DB,
		ls,
		personalizedLoaders,
		collectionId,
		languagePreferences,
		null.IntFromPtr(cursor.Seed),
	)
	if err != nil {
		return nil, err
	}

	switch col.AdvancedType.String {
	case "continue_watching":
		ids, err := resolveContinueWatchingCollection(ctx, ls)
		if err != nil {
			return nil, err
		}
		entries = filterWithIds(col, entries, ids)
	case "my_list":
		ids, err := resolveMyListCollection(ctx, ls)
		if err != nil {
			return nil, err
		}
		entries = filterWithIds(col, entries, ids)
	case "shorts":
		ids, err := r.resolveShortsCollection(ctx)
		if err != nil {
			return nil, err
		}
		entries = filterWithUuids(col, common.CollectionShorts, entries, ids)
	}

	memorycache.Set(cacheKey, entries, cache.WithExpiration(time.Minute*10))

	return entries, nil
}

// getItemsPageAs returns a pagination result of items of type T
// returns only the items and no additional metadata like sort or other relational data
// it will also filter out items that don't conform to the interface or type T
func getItemsPageAs[T any](ctx context.Context, r *Resolver, collectionID int, first, offset *int, offsetCursor *cursors.OffsetCursor, collections ...common.ItemCollection) (*utils.PaginationResult[T], error) {
	entries, err := r.GetCollectionEntries(ctx, collectionID, nil)
	if err != nil {
		return nil, err
	}

	// In case we want to make sure to only use entries of a certain collection
	if len(collections) > 0 {
		entries = lo.Filter(entries, func(e collection.Entry, _ int) bool {
			return lo.Contains(collections, e.Collection)
		})
	}

	pagination := utils.Paginate[collection.Entry, *cursors.OffsetCursor](entries, first, offset, nil, offsetCursor)

	items, err := collectionEntriesToModels(ctx, r.Loaders, pagination.Items)
	if err != nil {
		return nil, err
	}

	var result []T
	for _, item := range items {
		if v, ok := item.(T); ok {
			result = append(result, v)
		}
	}

	return &utils.PaginationResult[T]{
		Total:       pagination.Total,
		First:       pagination.First,
		Offset:      pagination.Offset,
		Items:       result,
		Cursor:      pagination.Cursor,
		NextCursor:  pagination.NextCursor,
		HasNext:     pagination.HasNext,
		HasPrevious: pagination.HasPrevious,
	}, nil
}

func (r *Resolver) getPlaylistItemsPage(ctx context.Context, collectionID int, first, offset *int, cursor *string) (*model.PlaylistItemPagination, error) {
	offsetCursor := cursors.ParseOrDefaultOffsetCursor(cursor)
	p, err := getItemsPageAs[model.PlaylistItem](ctx, r, collectionID, first, offset, offsetCursor, common.CollectionEpisodes)
	if err != nil {
		return nil, err
	}
	return &model.PlaylistItemPagination{
		Total:       p.Total,
		First:       p.First,
		Offset:      p.Offset,
		Items:       p.Items,
		Cursor:      p.Cursor.Encode(),
		NextCursor:  p.NextCursor.Encode(),
		HasNext:     p.HasNext,
		HasPrevious: p.HasPrevious,
	}, nil
}
