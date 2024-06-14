package graph

import (
	"context"
	"strconv"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/rs/zerolog/log"
)

func resolveContribution(ctx context.Context, i *common.Contribution, loaders *common.BatchLoaders) (*model.Contribution, error) {
	var item model.ContributionItem

	switch i.ItemType {
	case "episode":
		id := utils.AsInt(i.ItemID)
		ep, err := loaders.EpisodeLoader.Get(ctx, id)
		if err != nil || ep == nil {
			return nil, err
		}
		item = model.EpisodeFrom(ctx, ep)
	case "chapter":
		id := utils.AsUuid(i.ItemID)
		episodeID, err := loaders.MediaItemPrimaryEpisodeIDLoader.Get(ctx, i.MediaItemID)
		if episodeID == nil || err != nil {
			log.Error().Err(err).Msg("failed to get primary episode id")
			return nil, err
		}
		item, err = resolveChapter(ctx, loaders, strconv.Itoa(*episodeID), id)
		if err != nil {
			return nil, err
		}
	}

	return &model.Contribution{
		ContentType: &model.ContentType{Code: i.ContentType},
		Type:        &model.ContributionType{Code: i.Type},
		Item:        item,
	}, nil
}
