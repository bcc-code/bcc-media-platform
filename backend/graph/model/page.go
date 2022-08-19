package gqlmodel

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
)

// PageFrom converts common.Page to Page
func PageFrom(ctx context.Context, p *common.Page) *Page {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Page{
		ID:          strconv.Itoa(p.ID),
		Code:        p.Code,
		Title:       p.Title.Get(languages),
		Description: p.Description.GetValueOrNil(languages),
	}
}

// PageItemFrom returns a PageItem from common.Page
func PageItemFrom(ctx context.Context, p *common.Page) *PageItem {
	page := PageFrom(ctx, p)

	return &PageItem{
		ID:    page.ID,
		Title: page.Title,
		Page:  page,
	}
}
