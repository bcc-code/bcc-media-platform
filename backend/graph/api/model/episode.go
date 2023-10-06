package model

import (
	"context"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// EpisodeFrom coverts a common.Episode into an GQL episode type
func EpisodeFrom(ctx context.Context, e *common.Episode) *Episode {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	var season *Season
	if e.SeasonID.Valid {
		season = &Season{
			ID: strconv.Itoa(int(e.SeasonID.Int64)),
		}
	}

	var extraDescription string
	if v := e.ExtraDescription.GetValueOrNil(languages); v != nil {
		extraDescription = *v
	}

	var legacyID *string
	if e.LegacyID.Valid {
		strID := strconv.Itoa(int(e.LegacyID.Int64))
		legacyID = &strID
	}

	var legacyProgramID *string
	if e.LegacyProgramID.Valid {
		strID := strconv.Itoa(int(e.LegacyProgramID.Int64))
		legacyProgramID = &strID
	}

	var image *string
	if e.Image.Valid {
		image = &e.Image.String
	}
	if image == nil {
		image = e.Images.GetDefault(languages, common.ImageStyleDefault)
	}

	var images []*Image
	for style, img := range e.Images.GetForLanguages(languages) {
		if img == nil {
			continue
		}
		images = append(images, &Image{
			Style: style,
			URL:   *img,
		})
	}

	var episodeType EpisodeType
	if e.Type == "episode" {
		episodeType = EpisodeTypeEpisode
	} else {
		episodeType = EpisodeTypeStandalone
	}

	var title = e.Title.Get(languages)
	if e.ProductionDateInTitle {
		title = fmt.Sprintf("%s %s", strings.TrimSpace(title), utils.FormatInLocale(e.ProductionDate, languages))
	}

	episode := &Episode{
		Chapters:              []*Chapter{}, // Currently not supported
		ID:                    strconv.Itoa(e.ID),
		Status:                statusFrom(e),
		UUID:                  e.UUID.String(),
		Type:                  episodeType,
		PublishDate:           e.PublishDate.Format(time.RFC3339),
		LegacyID:              legacyID,
		LegacyProgramID:       legacyProgramID,
		ProductionDate:        e.ProductionDate.Format(time.RFC3339),
		ProductionDateInTitle: e.ProductionDateInTitle,
		AvailableFrom:         e.AvailableFrom.Format(time.RFC3339),
		AvailableTo:           e.AvailableTo.Format(time.RFC3339),
		Title:                 title,
		Description:           e.Description.Get(languages),
		ExtraDescription:      extraDescription,
		Season:                season,
		Duration:              e.Duration,
		AgeRating:             e.AgeRating,
		ImageURL:              image,
		Images:                images,
	}

	if e.Number.Valid {
		num := int(e.Number.Int64)
		episode.Number = &num
	}

	return episode
}

// EpisodeSectionItemFrom returns a SectionItem
func EpisodeSectionItemFrom(ctx context.Context, s *common.Episode, sort int, sectionStyle string, numberInTitle bool) *SectionItem {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	episode := EpisodeFrom(ctx, s)

	img := s.Images.GetDefault(languages, sectionStyle)
	if img == nil {
		img = episode.ImageURL
	}

	title := episode.Title
	if numberInTitle && episode.Number != nil {
		title = fmt.Sprintf("%d. %s", *episode.Number, title)
	}

	return &SectionItem{
		ID:          episode.ID,
		Item:        episode,
		Title:       title,
		Description: episode.Description,
		Image:       img,
		Sort:        sort,
	}
}
