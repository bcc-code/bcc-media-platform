package gqlmodel

import (
	"context"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// ShowFrom coverts a common.Show into an GQL episode type
func ShowFrom(ctx context.Context, s *common.Show) *Show {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Show{
		ID:          strconv.Itoa(s.ID),
		Title:       s.Title.Get(languages),
		Description: s.Description.Get(languages),
	}
}

// ShowItemFrom returns a ShowItem from a sql row
func ShowItemFrom(ctx context.Context, s *common.Show) *ShowItem {
	show := ShowFrom(ctx, s)

	return &ShowItem{
		ID:    show.ID,
		Show:  show,
		Title: show.Title,
	}
}
