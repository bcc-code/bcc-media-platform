package model

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

func PersonFrom(ctx context.Context, item *common.Person) *Person {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Person{
		ID:    item.ID.String(),
		Name:  item.Name,
		Image: item.Images.GetDefault(languages, common.ImageStyleDefault),
	}
}

func ContributionFrom(ctx context.Context, i *common.Contribution, loaders *common.BatchLoaders) (*Contribution, error) {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

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
		item = &Chapter{
			ID:          tm.ID.String(),
			Start:       int(tm.Timestamp),
			Title:       tm.Title.Get(languages),
			Description: tm.Description.GetValueOrNil(languages),
			Image:       tm.Images.GetDefault(languages, common.ImageStyleDefault),
		}
	}

	return &Contribution{
		Type: &ContributionType{Code: i.Type},
		Item: item,
	}, nil
}
