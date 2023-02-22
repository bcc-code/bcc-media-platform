package statistics

import (
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
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

type Episode struct {
	ID                    int                 `json:"id"`
	UUID                  uuid.UUID           `json:"uuid"`
	Unlisted              bool                `json:"unlisted"`
	Type                  string              `json:"type"`
	PreventPublicIndexing bool                `json:"preventPublicIndexing"`
	SeasonID              bigquery.NullInt64  `json:"seasonId"`
	PublishDate           time.Time           `json:"publishDate"`
	ProductionDate        time.Time           `json:"productionDate"`
	AvailableFrom         time.Time           `json:"availableFrom"`
	AvailableTo           time.Time           `json:"availableTo"`
	Number                int                 `json:"number"`
	ImageIcon             bigquery.NullString `json:"image_icon"`
	ImageFeatured         bigquery.NullString `json:"image_featured"`
	ImagePoster           bigquery.NullString `json:"image_poster"`
	Duration              int                 `json:"duration"`
	AgeRating             string              `json:"ageRating"`
	TagIDs                []int               `json:"tagIds"`
	PublicTitle           bigquery.NullString `json:"publicTitle"`
	Title                 bigquery.NullString `json:"title"`
	Description           bigquery.NullString `json:"description"`
	ExtraDescription      bigquery.NullString `json:"extraDescription"`
	Updated               time.Time
	Deleted               *time.Time
}

func EpisodeFromCommon(e common.Episode, _ int) Episode {
	return Episode{
		ID:                    e.ID,
		UUID:                  e.UUID,
		Unlisted:              e.Unlisted,
		Type:                  e.Type,
		PreventPublicIndexing: e.PreventPublicIndexing,
		SeasonID:              bigquery.NullInt64(e.SeasonID.NullInt64),
		PublishDate:           e.PublishDate,
		ProductionDate:        e.ProductionDate,
		AvailableFrom:         e.AvailableFrom,
		AvailableTo:           e.AvailableTo,
		Number:                int(e.Number.Int64),
		ImageIcon:             nullStr(e.Images.GetDefault(statsLanguages, common.ImageStyleIcon)),
		ImageFeatured:         nullStr(e.Images.GetDefault(statsLanguages, common.ImageStyleFeatured)),
		ImagePoster:           nullStr(e.Images.GetDefault(statsLanguages, common.ImageStylePoster)),
		Duration:              e.Duration,
		AgeRating:             e.AgeRating,
		TagIDs:                e.TagIDs,
		PublicTitle:           nullStr(e.PublicTitle.Ptr()),
		Title:                 nullStr(e.Title.GetValueOrNil(statsLanguages)),
		Description:           nullStr(e.Description.GetValueOrNil(statsLanguages)),
		ExtraDescription:      nullStr(e.ExtraDescription.GetValueOrNil(statsLanguages)),
		Updated:               time.Now(),
	}
}