package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
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
		episodePointerIDs, err := r.GetFilteredLoaders(ctx).EpisodesLoader.Get(ctx, int(episode.SeasonID.Int64))
		if err != nil {
			return nil, err
		}
		episodeIDs = utils.PointerArrayToArray(episodePointerIDs)
	}

	// Get the index and try to get the next episodeID in the array
	index := lo.IndexOf(episodeIDs, utils.AsInt(episodeID))
	if index < 0 || index >= len(episodeIDs)-1 {
		return nil, nil
	}
	return []int{episodeIDs[index+1]}, nil
}
