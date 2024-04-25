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

func PersonSectionItemFrom(ctx context.Context, item *common.Person, sort int, style common.ImageStyle) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &SectionItem{
		ID:    item.ID.String(),
		Sort:  sort,
		Title: item.Name,
		Image: item.Images.GetDefault(languages, style),
		Item:  PersonFrom(ctx, item),
	}
}
