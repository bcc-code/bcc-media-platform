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

func getDefaultEpisodeString(show *common.Show) string {
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
	return defaultEpisode
}

// DefaultSeasonID retrieves the default seasonID from show
func DefaultSeasonID(ctx context.Context, ls *common.FilteredLoaders, show *common.Show) (*int, error) {
	sIDs, err := ls.SeasonsLoader.Get(ctx, show.ID)
	if err != nil || len(sIDs) == 0 {
		return nil, err
	}
	var sId *int
	switch getDefaultEpisodeString(show) {
	case "first-of-first", "last-of-first":
		sId = sIDs[0]
	case "first-of-last", "last-of-last":
		sId, _ = lo.Last(sIDs)
	}

	return sId, err
}

// DefaultEpisodeID returns the default episode for the show
func DefaultEpisodeID(ctx context.Context, ls *common.FilteredLoaders, show *common.Show) (*int, error) {
	sId, err := DefaultSeasonID(ctx, ls, show)
	if err != nil {
		return nil, err
	}
	var eId *int
	switch getDefaultEpisodeString(show) {
	case "first-of-first", "first-of-last":
		eId, err = getEpisodeIDFromSeason(ctx, ls, sId, true)
	case "last-of-first", "last-of-last":
		eId, err = getEpisodeIDFromSeason(ctx, ls, sId, false)
	}

	if err != nil {
		return nil, err
	}

	if eId == nil {
		var sIDs []*int
		sIDs, err = ls.SeasonsLoader.Get(ctx, show.ID)
		for i := 0; i < len(sIDs) && eId == nil && err == nil; i++ {
			eId, err = getEpisodeIDFromSeason(ctx, ls, sIDs[i], true)
		}
	}

	return eId, err
}
