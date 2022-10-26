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

	id := strconv.Itoa(s.ID)

	var title *string
	if s.ShowTitle {
		title = s.Title.GetValueOrNil(languages)
	}

	switch s.Type {
	case "item":
		switch s.Style {
		case "featured":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &FeaturedSection{
				ID:    id,
				Title: title,
				Size:  size,
			}
		case "default":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &DefaultSection{
				ID:    id,
				Title: title,
				Size:  size,
			}
		case "posters":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &PosterSection{
				ID:    id,
				Title: title,
				Size:  size,
			}
		case "grid":
			size := GridSectionSize(s.Size)
			if !size.IsValid() {
				size = GridSectionSizeHalf
			}
			return &DefaultGridSection{
				ID:    id,
				Title: title,
				Size:  size,
			}
		case "poster_grid":
			size := GridSectionSize(s.Size)
			if !size.IsValid() {
				size = GridSectionSizeHalf
			}
			return &PosterGridSection{
				ID:    id,
				Title: title,
				Size:  size,
			}
		case "icons":
			return &IconSection{
				ID:    id,
				Title: title,
			}
		case "labels":
			return &LabelSection{
				ID:    id,
				Title: title,
			}
		}
	case "message":
		return &MessageSection{
			ID:    id,
			Title: title,
		}
	}

	return &DefaultSection{
		ID:    id,
		Title: title,
		Size:  SectionSizeMedium,
	}
}

// LinkSectionItemFrom creates a sectionitem from a link
func LinkSectionItemFrom(ctx context.Context, s *common.Link, sort int, sectionStyle string) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	img := s.Images.GetDefault(languages, sectionStyle)

	return &SectionItem{
		ID: strconv.Itoa(s.ID),
		Item: &Link{
			ID:  strconv.Itoa(s.ID),
			URL: s.URL,
		},
		Title:       s.Title.Get(languages),
		Description: s.Description.Get(languages),
		Image:       img,
		Sort:        sort,
	}
}
