package model

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// PlaylistFrom returns a playlist from common
func PlaylistFrom(ctx context.Context, item *common.Playlist) *Playlist {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Playlist{
		ID:          item.ID.String(),
		Title:       item.Title.Get(languages),
		Description: item.Description.GetValueOrNil(languages),
	}
}

// PlaylistSectionItemFrom returns a section item for a playlist
func PlaylistSectionItemFrom(ctx context.Context, item *common.Playlist, sort int, style common.ImageStyle) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &SectionItem{
		ID:          item.ID.String(),
		Title:       item.Title.Get(languages),
		Description: item.Description.Get(languages),
		Image:       item.Images.GetDefault(languages, style),
		Item:        PlaylistFrom(ctx, item),
		Sort:        sort,
	}
}
