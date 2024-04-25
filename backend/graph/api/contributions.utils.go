package graph

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
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
		tm, err := loaders.TimedMetadataLoader.Get(ctx, id)
		if err != nil || tm == nil {
			return nil, err
		}
		item = resolveChapter(ctx, tm, loaders)
	}

	return &model.Contribution{
		Type: &model.ContributionType{Code: i.Type},
		Item: item,
	}, nil
}
