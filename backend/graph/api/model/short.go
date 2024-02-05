package model

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// ShortFrom returns a short from common
func ShortFrom(ctx context.Context, item *common.Short) *Short {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Short{
		ID:          item.ID.String(),
		Title:       item.Title.Get(languages),
		Description: item.Description.GetValueOrNil(languages),
	}
}

// ShortSectionItemFrom returns a section item for a short
func ShortSectionItemFrom(ctx context.Context, item *common.Short, sort int, style common.ImageStyle) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &SectionItem{
		ID:          item.ID.String(),
		Sort:        sort,
		Title:       item.Title.Get(languages),
		Description: item.Description.Get(languages),
		Image:       item.Images.GetDefault(languages, style),
		Item:        ShortFrom(ctx, item),
	}
}
