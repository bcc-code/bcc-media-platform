package model

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
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

// PageSectionItemFrom returns a SectionItem from common.Page
func PageSectionItemFrom(ctx context.Context, p *common.Page, sort int, sectionStyle string) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	page := PageFrom(ctx, p)

	img := p.Images.GetDefault(languages, sectionStyle)

	return &SectionItem{
		ID:    page.ID,
		Title: page.Title,
		Image: img,
		Item:  page,
		Sort:  sort,
	}
}
