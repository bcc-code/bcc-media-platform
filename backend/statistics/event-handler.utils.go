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
