package statistics

import (
	"context"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
)

func (h *Handler) resolveShorts(ctx context.Context, shorts []common.Short) ([]Short, error) {
	var bqShorts []Short
	for _, short := range shorts {
		tags, err := h.queries.GetTags(ctx, short.TagIDs)
		if err != nil {
			return nil, merry.Wrap(err)
		}
		bqShorts = append(bqShorts, ShortFromCommon(short, tags))
	}
	return bqShorts, nil
}

func (h *Handler) resolveEpisodes(ctx context.Context, ep []common.Episode) ([]Episode, error) {
	var bqEpisodes []Episode
	for _, ep := range ep {
		tags, err := h.queries.GetTags(ctx, ep.TagIDs)
		if err != nil {
			return nil, merry.Wrap(err)
		}
		bqEpisodes = append(bqEpisodes, EpisodeFromCommon(ep, tags))
	}
	return bqEpisodes, nil
}

func (h *Handler) resolveSeasons(ctx context.Context, seasons []common.Season) ([]Season, error) {
	var bqSeasons []Season
	for _, season := range seasons {
		tags, err := h.queries.GetTags(ctx, season.TagIDs)
		if err != nil {
			return nil, merry.Wrap(err)
		}
		bqSeasons = append(bqSeasons, SeasonFromCommon(season, tags))
	}
	return bqSeasons, nil
}

func (h *Handler) resolveShows(ctx context.Context, shows []common.Show) ([]Show, error) {
	var bqShows []Show
	for _, show := range shows {
		tags, err := h.queries.GetTags(ctx, show.TagIDs)
		if err != nil {
			return nil, merry.Wrap(err)
		}
		bqShows = append(bqShows, ShowFromCommon(show, tags))
	}
	return bqShows, nil
}
