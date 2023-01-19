package show

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func getEpisodeIDFromSeason(ctx context.Context, loaders *common.FilteredLoaders, sID *int, first bool) (*int, error) {
	if sID == nil {
		return nil, nil
	}
	eIDs, err := batchloaders.GetForKey(ctx, loaders.EpisodesLoader, *sID)
	if err != nil || len(eIDs) == 0 {
		return nil, err
	}
	if !first {
		return lo.Last(eIDs)
	}
	return eIDs[0], nil
}

// DefaultEpisodeID returns the default episode for the show
func DefaultEpisodeID(ctx context.Context, loaders *common.FilteredLoaders, show *common.Show) (*int, error) {
	// TODO: this should respect continue watching as well, or previously shown episodes
	sIDs, err := batchloaders.GetForKey(ctx, loaders.SeasonsLoader, show.ID)
	if err != nil || len(sIDs) == 0 {
		return nil, err
	}
	var defaultEpisode string
	if show.DefaultEpisodeBehaviour.Valid {
		defaultEpisode = show.DefaultEpisodeBehaviour.String
	} else {
		switch show.Type {
		case "event":
			defaultEpisode = "last-of-last"
		default:
			defaultEpisode = "first-of-last"
		}
	}
	var eId *int
	switch defaultEpisode {
	case "first-of-first":
		eId, err = getEpisodeIDFromSeason(ctx, loaders, sIDs[0], true)
	case "last-of-first":
		eId, err = getEpisodeIDFromSeason(ctx, loaders, sIDs[0], false)
	case "first-of-last":
		sID, _ := lo.Last(sIDs)
		eId, err = getEpisodeIDFromSeason(ctx, loaders, sID, true)
	case "last-of-last":
		sID, _ := lo.Last(sIDs)
		eId, err = getEpisodeIDFromSeason(ctx, loaders, sID, false)
	}

	if err != nil {
		return nil, err
	}

	for i := 0; i < len(sIDs) && eId == nil && err == nil; i++ {
		eId, err = getEpisodeIDFromSeason(ctx, loaders, sIDs[i], true)
	}

	return eId, err
}
