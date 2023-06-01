package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
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

func (r *episodeResolver) getNextEpisodes(ctx context.Context, episodeID string) ([]int, error) {
	episodeContext, err := r.getEpisodeContext(ctx, episodeID)
	if err != nil {
		return nil, err
	}

	var episodeIDs []int

	// If the EpisodeContext has a valid CollectionID, use the collectionID to retrieve episodeIDs
	// else, use the episodes in the season (if any)
	if episodeContext.CollectionID.Valid {
		items, err := r.GetFilteredLoaders(ctx).CollectionItemsLoader.Get(ctx, int(episodeContext.CollectionID.Int64))
		if err != nil {
			return nil, err
		}
		items = lo.Filter(items, func(i *common.CollectionItem, _ int) bool {
			return i.Type == common.TypeEpisode
		})
		episodeIDs = lo.Map(items, func(i *common.CollectionItem, _ int) int {
			return utils.AsInt(i.ItemID)
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

	// Get the index and try to get the next episodeID in the array
	index := lo.IndexOf(episodeIDs, utils.AsInt(episodeID))
	if index < 0 {
		return nil, nil
	}
	// If the episode is the last episode in the show, look for alternative episodes
	if index >= len(episodeIDs)-1 {
		ids, err := r.getNextFromShowCollection(ctx, episodeID)
		if err != nil {
			return nil, err
		}
		if len(ids) > 0 {
			return ids, nil
		}
		return r.getRelatedEpisodes(ctx, episodeID)
	}
	return []int{episodeIDs[index+1]}, nil
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
		return i.Collection == common.TypeEpisode && i.ID != episodeID
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
