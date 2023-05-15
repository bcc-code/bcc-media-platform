package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

func (r *episodeResolver) getEpisodeContext(ctx context.Context, episodeId string) (common.EpisodeContext, error) {
	ginCtx, _ := utils.GinCtx(ctx)
	episodeContext, ok := ginCtx.Value(episodeContextKey).(common.EpisodeContext)

	if !ok {
		progress, err := r.ProfileLoaders(ctx).ProgressLoader.Get(ctx, utils.AsInt(episodeId))
		if err != nil {
			return episodeContext, err
		}
		if progress != nil {
			episodeContext = progress.Context
		}
	}

	return episodeContext, nil
}

func (r *episodeResolver) getNextEpisodes(ctx context.Context, episodeId string) ([]int, error) {
	episodeContext, err := r.getEpisodeContext(ctx, episodeId)
	if err != nil {
		return nil, err
	}

	if episodeContext.CollectionID.Valid {
		items, err := r.Loaders.CollectionItemLoader.Get(ctx, int(episodeContext.CollectionID.Int64))
		if err != nil {
			return nil, err
		}
		items = lo.Filter(items, func(i *common.CollectionItem, _ int) bool {
			return i.Type == common.TypeEpisode
		})
		_, index, found := lo.FindIndexOf(items, func(i *common.CollectionItem) bool {
			return i.ID == utils.AsInt(episodeId)
		})
		if !found || index >= len(items)-1 {
			return nil, nil
		}
		item := items[index+1]
		return []int{utils.AsInt(item.ItemID)}, nil
	}

	episode, err := r.Loaders.EpisodeLoader.Get(ctx, utils.AsInt(episodeId))
	if err != nil {
		return nil, err
	}

	if !episode.SeasonID.Valid {
		return nil, nil
	}
	episodeIDs, err := r.GetFilteredLoaders(ctx).EpisodesLoader.Get(ctx, int(episode.SeasonID.Int64))
	if err != nil {
		return nil, err
	}
	ids := utils.PointerArrayToArray(episodeIDs)
	index := lo.IndexOf(ids, episode.ID)
	if index < 0 || index >= len(ids)-1 {
		return nil, nil
	}
	return []int{ids[index+1]}, nil
}
