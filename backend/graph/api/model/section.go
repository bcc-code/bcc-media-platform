package model

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"strconv"
)

// SectionFrom converts common.Page to Section
func SectionFrom(ctx context.Context, s *common.Section) Section {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	id := strconv.Itoa(s.ID)

	var title *string
	var description *string
	if s.ShowTitle {
		title = s.Title.GetValueOrNil(languages)
		if s.Description.Has("no") && s.Description["no"].String != "" {
			description = s.Description.GetValueOrNil(languages)
		}
	}

	switch s.Type {
	case "item":
		metadata := &ItemSectionMetadata{
			SecondaryTitles:    s.Options.SecondaryTitles,
			MyList:             s.Options.MyList,
			ContinueWatching:   s.Options.ContinueWatching,
			CollectionID:       strconv.Itoa(int(s.CollectionID.Int64)),
			UseContext:         s.Options.UseContext,
			PrependLiveElement: s.Options.PrependLiveElement,
		}

		switch s.Style {
		case "featured":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &FeaturedSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "default":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &DefaultSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "list":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &ListSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "posters":
			size := SectionSize(s.Size)
			if !size.IsValid() {
				size = SectionSizeMedium
			}
			return &PosterSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "cards":
			size := CardSectionSize(s.Size)
			if !size.IsValid() {
				size = CardSectionSizeLarge
			}
			return &CardSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "card_list":
			size := CardSectionSize(s.Size)
			if !size.IsValid() {
				size = CardSectionSizeLarge
			}
			return &CardListSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "grid":
			size := GridSectionSize(s.Size)
			if !size.IsValid() {
				size = GridSectionSizeHalf
			}
			return &DefaultGridSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "poster_grid":
			size := GridSectionSize(s.Size)
			if !size.IsValid() {
				size = GridSectionSizeHalf
			}
			return &PosterGridSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "icon_grid":
			size := GridSectionSize(s.Size)
			if !size.IsValid() {
				size = GridSectionSizeHalf
			}
			return &IconGridSection{
				ID:          id,
				Title:       title,
				Description: description,
				Size:        size,
				Metadata:    metadata,
			}
		case "icons":
			return &IconSection{
				ID:          id,
				Title:       title,
				Description: description,
				Metadata:    metadata,
			}
		case "labels":
			return &LabelSection{
				ID:          id,
				Title:       title,
				Description: description,
				Metadata:    metadata,
			}
		}
	case "message":
		return &MessageSection{
			ID:          id,
			Title:       title,
			Description: description,
		}
	case "embed_web":
		var height *int
		if s.EmbedHeight.Valid {
			val := int(s.EmbedHeight.ValueOrZero())
			height = &val
		}

		var aspectRatio *float64
		if s.EmbedAspectRatio.Valid {
			aspectRatio = &s.EmbedAspectRatio.Float64
		}

		return &WebSection{
			ID:             id,
			Title:          title,
			Description:    description,
			WidthRatio:     s.EmbedAspectRatio.Float64,
			Height:         height,
			AspectRatio:    aspectRatio,
			URL:            s.EmbedUrl.ValueOrZero(),
			Authentication: s.NeedsAuthentication.ValueOrZero(),
		}
	case "achievements":
		return &AchievementSection{
			ID:          id,
			Title:       title,
			Description: description,
		}
	case "page_details":
		return &PageDetailsSection{
			ID:          id,
			Title:       title,
			Description: description,
		}
	}

	return &DefaultSection{
		ID:          id,
		Title:       title,
		Description: description,
		Size:        SectionSizeMedium,
	}
}

// LinkFrom returns link from common.Link
func LinkFrom(ctx context.Context, s *common.Link) *Link {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Link{
		ID:          strconv.Itoa(s.ID),
		URL:         s.URL,
		Title:       s.Title.Get(languages),
		Description: s.Description.GetValueOrNil(languages),
		Type:        LinkType(s.Type),
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
