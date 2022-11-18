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
		metadata := &ItemSectionMetadata{
			SecondaryTitles:  s.Options.SecondaryTitles,
			ContinueWatching: s.Options.ContinueWatching,
			CollectionID:     strconv.Itoa(int(s.CollectionID.Int64)),
		}

		switch s.Style {
		case "featured":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &FeaturedSection{
				ID:       id,
				Title:    title,
				Size:     size,
				Metadata: metadata,
			}
		case "default":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &DefaultSection{
				ID:       id,
				Title:    title,
				Size:     size,
				Metadata: metadata,
			}
		case "list":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &ListSection{
				ID:       id,
				Title:    title,
				Size:     size,
				Metadata: metadata,
			}
		case "posters":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &PosterSection{
				ID:       id,
				Title:    title,
				Size:     size,
				Metadata: metadata,
			}
		case "grid":
			size := GridSectionSize(s.Size)
			if !size.IsValid() {
				size = GridSectionSizeHalf
			}
			return &DefaultGridSection{
				ID:       id,
				Title:    title,
				Size:     size,
				Metadata: metadata,
			}
		case "poster_grid":
			size := GridSectionSize(s.Size)
			if !size.IsValid() {
				size = GridSectionSizeHalf
			}
			return &PosterGridSection{
				ID:       id,
				Title:    title,
				Size:     size,
				Metadata: metadata,
			}
		case "icon_grid":
			size := GridSectionSize(s.Size)
			if !size.IsValid() {
				size = GridSectionSizeHalf
			}
			return &IconGridSection{
				ID:       id,
				Title:    title,
				Size:     size,
				Metadata: metadata,
			}
		case "icons":
			return &IconSection{
				ID:       id,
				Title:    title,
				Metadata: metadata,
			}
		case "labels":
			return &LabelSection{
				ID:       id,
				Title:    title,
				Metadata: metadata,
			}
		}
	case "message":
		return &MessageSection{
			ID:    id,
			Title: title,
		}
	case "embed_web":
		var size float64
		switch s.EmbedSize.ValueOrZero() {
		case "16:9":
			size = 16.0 / 9.0
		case "4:3":
			size = 4.0 / 3.0
		case "9:16":
			size = 9.0 / 16.0
		case "1:1":
			size = 1
		}

		return &WebSection{
			ID:             id,
			Title:          title,
			WidthRatio:     size,
			URL:            s.EmbedUrl.ValueOrZero(),
			Authentication: s.NeedsAuthentication.ValueOrZero(),
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
