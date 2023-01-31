package show

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func getEpisodeIDFromSeason(ctx context.Context, ls *common.FilteredLoaders, sID *int, first bool) (*int, error) {
	if sID == nil {
		return nil, nil
	}
	eIDs, err := ls.EpisodesLoader.Get(ctx, *sID)
	if err != nil || len(eIDs) == 0 {
		return nil, err
	}
	if !first {
		return lo.Last(eIDs)
	}
	return eIDs[0], nil
}

// DefaultEpisodeID returns the default episode for the show
func DefaultEpisodeID(ctx context.Context, ls *common.FilteredLoaders, show *common.Show) (*int, error) {
	// TODO: this should respect continue watching as well, or previously shown episodes
	sIDs, err := ls.SeasonsLoader.Get(ctx, show.ID)
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
		eId, err = getEpisodeIDFromSeason(ctx, ls, sIDs[0], true)
	case "last-of-first":
		eId, err = getEpisodeIDFromSeason(ctx, ls, sIDs[0], false)
	case "first-of-last":
		sID, _ := lo.Last(sIDs)
		eId, err = getEpisodeIDFromSeason(ctx, ls, sID, true)
	case "last-of-last":
		sID, _ := lo.Last(sIDs)
		eId, err = getEpisodeIDFromSeason(ctx, ls, sID, false)
	}

	if err != nil {
		return nil, err
	}

	for i := 0; i < len(sIDs) && eId == nil && err == nil; i++ {
		eId, err = getEpisodeIDFromSeason(ctx, ls, sIDs[i], true)
	}

	return eId, err
}
