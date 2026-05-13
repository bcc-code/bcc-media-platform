package show

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/samber/lo"
)

func getEpisodeIDFromSeason(ctx context.Context, ls *loaders.LoadersWithPermissions, sID *int, first bool) (*int, error) {
	if sID == nil {
		return nil, nil
	}
	eIDs, err := ls.EpisodesLoader.Get(ctx, *sID)
	if err != nil || len(eIDs) == 0 {
		return nil, err
	}
	pick := eIDs[0]
	if !first {
		pick, _ = lo.Last(eIDs)
	}
	if pick == nil {
		return nil, nil
	}
	return &pick.Value, nil
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
func DefaultSeasonID(ctx context.Context, ls *loaders.LoadersWithPermissions, show *common.Show) (*int, error) {
	sIDs, err := ls.SeasonsLoader.Get(ctx, show.ID)
	if err != nil || len(sIDs) == 0 {
		return nil, err
	}
	var s *common.Mapping[int, int]
	switch getDefaultEpisodeString(show) {
	case "first-of-first", "last-of-first":
		s = sIDs[0]
	case "first-of-last", "last-of-last":
		s, _ = lo.Last(sIDs)
	}
	if s == nil {
		return nil, err
	}
	return &s.Value, err
}

// DefaultEpisodeID returns the default episode for the show
func DefaultEpisodeID(ctx context.Context, ls *loaders.LoadersWithPermissions, show *common.Show) (*int, error) {
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
		var sIDs []*common.Mapping[int, int]
		sIDs, err = ls.SeasonsLoader.Get(ctx, show.ID)
		for i := 0; i < len(sIDs) && eId == nil && err == nil; i++ {
			if sIDs[i] == nil {
				continue
			}
			seasonID := sIDs[i].Value
			eId, err = getEpisodeIDFromSeason(ctx, ls, &seasonID, true)
		}
	}

	return eId, err
}
