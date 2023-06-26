package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// GameFrom returns a game from common
func GameFrom(ctx context.Context, game *common.Game) *Game {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Game{
		ID:          game.ID.String(),
		Title:       game.Title.Get(languages),
		Description: game.Description.GetValueOrNil(languages),
		URL:         game.Url,
	}
}

// GameSectionItemFrom returns a section item for a game
func GameSectionItemFrom(ctx context.Context, game *common.Game, sort int, style common.ImageStyle) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &SectionItem{
		ID:          game.ID.String(),
		Title:       game.Title.Get(languages),
		Description: game.Description.Get(languages),
		Image:       game.Images.GetDefault(languages, style),
		Item:        GameFrom(ctx, game),
		Sort:        sort,
	}
}
