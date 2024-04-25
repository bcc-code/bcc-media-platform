package model

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

func ContributionFrom(ctx context.Context, i *common.Contribution, loaders *common.BatchLoaders) (*Contribution, error) {

	var item ContributionItem

	switch i.ItemType {
	case "episode":
		id := utils.AsInt(i.ItemID)
		ep, err := loaders.EpisodeLoader.Get(ctx, id)
		if err != nil || ep == nil {
			return nil, err
		}
		item = EpisodeFrom(ctx, ep)
	case "chapter":
		id := utils.AsUuid(i.ItemID)
		tm, err := loaders.TimedMetadataLoader.Get(ctx, id)
		if err != nil || tm == nil {
			return nil, err
		}
		item = ChapterFrom(ctx, tm, loaders)
	}

	return &Contribution{
		Type: &ContributionType{Code: i.Type},
		Item: item,
	}, nil
}
