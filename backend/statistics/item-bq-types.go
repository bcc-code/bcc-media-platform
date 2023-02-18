package statistics

import (
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/bcc-code/brunstadtv/backend/common"
)

var statsLanguages = []string{"no", "en", "de", "nl"}

func nullStr(s *string) bigquery.NullString {
	str := ""
	if s != nil {
		str = *s
	}

	return bigquery.NullString{
		StringVal: str,
		Valid:     s != nil,
	}
}

// Show is the definition of the Show object
type Show struct {
	ID            int                 `json:"id"`
	Type          string              `json:"type"`
	TagIDs        []int               `json:"tagIds"`
	PublicTitle   bigquery.NullString `json:"publicTitle"`
	Title         bigquery.NullString `json:"title"`
	Description   bigquery.NullString `json:"description"`
	ImageIcon     bigquery.NullString `json:"image_icon"`
	ImageFeatured bigquery.NullString `json:"image_featured"`
	ImagePoster   bigquery.NullString `json:"image_poster"`
	Updated       time.Time
	Deleted       *time.Time
}

func ShowFromCommon(s common.Show, _ int) Show {
	return Show{
		ID:            s.ID,
		Type:          s.Type,
		TagIDs:        s.TagIDs,
		PublicTitle:   nullStr(s.PublicTitle.Ptr()),
		Title:         nullStr(s.Title.GetValueOrNil(statsLanguages)),
		Description:   nullStr(s.Description.GetValueOrNil(statsLanguages)),
		ImageIcon:     nullStr(s.Images.GetDefault(statsLanguages, common.ImageStyleIcon)),
		ImageFeatured: nullStr(s.Images.GetDefault(statsLanguages, common.ImageStyleFeatured)),
		ImagePoster:   nullStr(s.Images.GetDefault(statsLanguages, common.ImageStylePoster)),
		Updated:       time.Now(),
	}
}

// Season is the definition of the Season object
type Season struct {
	ID            int   `json:"id"`
	TagIDs        []int `json:"tagIds"`
	Number        int
	AgeRating     string
	PublicTitle   bigquery.NullString `json:"publicTitle"`
	Title         bigquery.NullString `json:"title"`
	Description   bigquery.NullString `json:"description"`
	ShowID        int
	ImageIcon     bigquery.NullString `json:"image_icon"`
	ImageFeatured bigquery.NullString `json:"image_featured"`
	ImagePoster   bigquery.NullString `json:"image_poster"`
	Updated       time.Time
	Deleted       *time.Time
}

func SeasonFromCommon(s common.Season, _ int) Season {
	return Season{
		ID:            s.ID,
		TagIDs:        s.TagIDs,
		Number:        s.Number,
		AgeRating:     s.AgeRating,
		ShowID:        s.ShowID,
		PublicTitle:   nullStr(s.PublicTitle.Ptr()),
		Title:         nullStr(s.Title.GetValueOrNil(statsLanguages)),
		Description:   nullStr(s.Description.GetValueOrNil(statsLanguages)),
		ImageIcon:     nullStr(s.Images.GetDefault(statsLanguages, common.ImageStyleIcon)),
		ImageFeatured: nullStr(s.Images.GetDefault(statsLanguages, common.ImageStyleFeatured)),
		ImagePoster:   nullStr(s.Images.GetDefault(statsLanguages, common.ImageStylePoster)),
		Updated:       time.Now(),
	}
}
