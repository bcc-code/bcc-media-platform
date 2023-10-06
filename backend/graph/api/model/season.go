package model

import (
	"context"
	"strconv"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// SeasonFrom coverts a common.Season into an GQL episode type
func SeasonFrom(ctx context.Context, s *common.Season) *Season {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	show := Show{
		ID: strconv.Itoa(s.ShowID),
	}

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

	return &Season{
		ID:          strconv.Itoa(s.ID),
		Status:      statusFrom(s),
		LegacyID:    legacyID,
		Title:       s.Title.Get(languages),
		Description: s.Description.Get(languages),
		Number:      s.Number,
		Show:        &show,
		AgeRating:   s.AgeRating,
		ImageURL:    image,
		Images:      images,
	}
}

// SeasonSectionItemFrom returns a SeasonItem from a common.Season
func SeasonSectionItemFrom(ctx context.Context, s *common.Season, sort int, sectionStyle string) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	season := SeasonFrom(ctx, s)

	img := s.Images.GetDefault(languages, sectionStyle)
	if img == nil {
		img = season.ImageURL
	}

	return &SectionItem{
		ID:          season.ID,
		Item:        season,
		Title:       season.Title,
		Description: season.Description,
		Image:       img,
		Sort:        sort,
	}
}
