package show

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func getEpisodeIDFromSeason(ctx context.Context, loaders *batchloaders.FilteredLoaders, sID *int, first bool) (*int, error) {
	if sID == nil {
		return nil, nil
	}
	eIDs, err := batchloaders.GetFromLoaderForKey(ctx, loaders.EpisodesLoader, *sID)
	if err != nil || len(eIDs) == 0 {
		return nil, err
	}
	if !first {
		return lo.Last(eIDs)
	}
	return eIDs[0], nil
}

// DefaultEpisodeID returns the default episode for the show
func DefaultEpisodeID(ctx context.Context, loaders *batchloaders.FilteredLoaders, show *common.Show) (*int, error) {
	// TODO: this should respect continue watching as well, or previously shown episodes
	sIDs, err := batchloaders.GetFromLoaderForKey(ctx, loaders.SeasonsLoader, show.ID)
	if err != nil || len(sIDs) == 0 {
		return nil, err
	}
	var defaultEpisode string
	if show.DefaultEpisode == nil {
		switch show.Type {
		case "event":
			defaultEpisode = "last-of-last"
		default:
			defaultEpisode = "first-of-last"
		}
	} else {
		defaultEpisode = *show.DefaultEpisode
	}
	switch defaultEpisode {
	case "first-of-first":
		return getEpisodeIDFromSeason(ctx, loaders, sIDs[0], true)
	case "first-of-last":
		sID, _ := lo.Last(sIDs)
		return getEpisodeIDFromSeason(ctx, loaders, sID, true)
	case "last-of-last":
		sID, _ := lo.Last(sIDs)
		return getEpisodeIDFromSeason(ctx, loaders, sID, false)
	}
	return nil, nil
}
