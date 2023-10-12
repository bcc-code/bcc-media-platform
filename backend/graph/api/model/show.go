package model

import (
	"context"
	"strconv"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// ShowFrom coverts a common.Show into an GQL episode type
func ShowFrom(ctx context.Context, s *common.Show) *Show {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	var legacyID *string
	if s.LegacyID.Valid {
		strID := strconv.Itoa(int(s.LegacyID.Int64))
		legacyID = &strID
	}

	var image *string
	if s.Image.Valid {
		image = &s.Image.String
	}

	var images []*Image
	for style, img := range s.Images.GetForLanguages(languages) {
		if img == nil {
			continue
		}
		images = append(images, &Image{
			Style: style,
			URL:   *img,
		})
	}

	return &Show{
		ID:          strconv.Itoa(s.ID),
		Status:      statusFrom(s),
		LegacyID:    legacyID,
		Type:        ShowType(s.Type),
		Title:       s.Title.Get(languages),
		Description: s.Description.Get(languages),
		ImageURL:    image,
		Images:      images,
	}
}

// ShowSectionItemFrom returns a SectionItem from a sql row
func ShowSectionItemFrom(ctx context.Context, s *common.Show, sort int, sectionStyle string) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	show := ShowFrom(ctx, s)

	img := s.Images.GetDefault(languages, sectionStyle)
	if img == nil {
		img = show.ImageURL
	}

	return &SectionItem{
		ID:          show.ID,
		Item:        show,
		Title:       show.Title,
		Description: show.Description,
		Image:       img,
		Sort:        sort,
	}
}
