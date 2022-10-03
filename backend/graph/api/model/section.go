package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
)

// SectionFrom converts common.Page to Section
func SectionFrom(ctx context.Context, s *common.Section) Section {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &ItemSection{
		ID:    strconv.Itoa(s.ID),
		Title: s.Title.Get(languages),
		Type:  ItemSectionType(s.Style),
		Page: &Page{
			ID: strconv.Itoa(s.PageID),
		},
		Style: s.Style,
		Size:  s.Size,
	}
}
