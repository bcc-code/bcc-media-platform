package statistics

import (
	"encoding/json"
	"fmt"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
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

func asJsonString[T any](o T) string {
	out, _ := json.Marshal(o)
	return string(out)
}

// Show is the definition of the Show object
type Show struct {
	ID            int                 `json:"id"`
	Type          string              `json:"type"`
	Tags          string              `json:"tags"`
	PublicTitle   bigquery.NullString `json:"publicTitle"`
	Title         bigquery.NullString `json:"title"`
	Description   bigquery.NullString `json:"description"`
	ImageIcon     bigquery.NullString `json:"image_icon"`
	ImageFeatured bigquery.NullString `json:"image_featured"`
	ImagePoster   bigquery.NullString `json:"image_poster"`
	Updated       time.Time
	Deleted       *time.Time
}

func ShowFromCommon(s common.Show, tags []common.Tag) Show {
	return Show{
		ID:            s.ID,
		Type:          s.Type,
		Tags:          tagsToJson(tags),
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
	ID            int    `json:"id"`
	Tags          string `json:"tags"`
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

func SeasonFromCommon(s common.Season, tags []common.Tag) Season {

	return Season{
		ID:            s.ID,
		Tags:          tagsToJson(tags),
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
	Tags                  string              `json:"tags"`
	PublicTitle           bigquery.NullString `json:"publicTitle"`
	Title                 bigquery.NullString `json:"title"`
	Description           bigquery.NullString `json:"description"`
	ExtraDescription      bigquery.NullString `json:"extraDescription"`
	Updated               time.Time
	Deleted               *time.Time
	LegacyEpisodeID       bigquery.NullString
	LegacyProgramID       bigquery.NullString
	Audience              bigquery.NullString `json:"audience"`
	ContentType           bigquery.NullString `json:"contentType"`
}

func EpisodeFromCommon(e common.Episode, tags []common.Tag) Episode {
	legacyEpisodeID := bigquery.NullString{
		Valid:     e.LegacyID.Valid,
		StringVal: fmt.Sprintf("E%d", e.LegacyID.ValueOrZero()),
	}

	legacyProgramID := bigquery.NullString{
		Valid:     e.LegacyProgramID.Valid,
		StringVal: fmt.Sprintf("P%d", e.LegacyProgramID.ValueOrZero()),
	}

	return Episode{
		ID:                    e.ID,
		UUID:                  e.UUID,
		Unlisted:              e.Unlisted(),
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
		Tags:                  tagsToJson(tags),
		PublicTitle:           nullStr(e.PublicTitle.Ptr()),
		Title:                 nullStr(e.Title.GetValueOrNil(statsLanguages)),
		Description:           nullStr(e.Description.GetValueOrNil(statsLanguages)),
		ExtraDescription:      nullStr(e.ExtraDescription.GetValueOrNil(statsLanguages)),
		LegacyEpisodeID:       legacyEpisodeID,
		LegacyProgramID:       legacyProgramID,
		Updated:               time.Now(),
		Audience:              nullStr(e.Audience.Ptr()),
		ContentType:           nullStr(e.ContentType.Ptr()),
	}
}

type TimedMetadata struct {
	ID          string              `json:"id"`
	Type        string              `json:"type"`
	Timestamp   float64             `json:"timestamp"`
	Title       bigquery.NullString `json:"title"`
	Description bigquery.NullString `json:"description"`
	ContentType bigquery.NullString `json:"contentType"`
	PersonIDs   string              `json:"personIds"`
	SongID      uuid.NullUUID       `json:"songId"`
}

func TimedMetadataFromCommon(tm common.TimedMetadata, _ int) TimedMetadata {
	return TimedMetadata{
		ID:          tm.ID.String(),
		Type:        tm.Type,
		Title:       nullStr(tm.Title.GetValueOrNil(statsLanguages)),
		Description: nullStr(tm.Description.GetValueOrNil(statsLanguages)),
		Timestamp:   tm.Timestamp,
		ContentType: nullStr(&tm.ContentType.Value),
		PersonIDs:   asJsonString(tm.PersonIDs),
		SongID:      tm.SongID,
	}
}

type MediaItem struct {
	ID            string               `json:"id"`
	UserCreated   string               `json:"userCreated" bigquery:"user_created"`
	DateCreated   time.Time            `json:"dateCreated" bigquery:"date_created"`
	UserUpdated   string               `json:"userUpdated" bigquery:"user_updated"`
	DateUpdated   time.Time            `json:"dateUpdated" bigquery:"date_updated"`
	Label         string               `json:"label"`
	Title         bigquery.NullString  `json:"title"`
	Description   bigquery.NullString  `json:"description"`
	Type          string               `json:"type"`
	AssetID       string               `json:"assetId" bigquery:"asset_id"`
	ParentEpisode bigquery.NullInt64   `json:"parentEpisode" bigquery:"parent_episode"`
	ParentStarts  bigquery.NullFloat64 `json:"parentStarts" bigquery:"parent_starts"`
	ParentEnds    bigquery.NullFloat64 `json:"parentEnds" bigquery:"parent_ends"`
}

func MediaItemFromDb(mi sqlc.Mediaitem, _ int) MediaItem {
	return MediaItem{
		ID:            mi.ID.String(),
		UserCreated:   mi.UserCreated.UUID.String(),
		DateCreated:   mi.DateCreated.Time,
		UserUpdated:   mi.UserUpdated.UUID.String(),
		DateUpdated:   mi.DateUpdated.Time,
		Label:         mi.Label,
		Title:         nullStr(mi.Title.Ptr()),
		Description:   nullStr(mi.Description.Ptr()),
		Type:          mi.Type,
		AssetID:       fmt.Sprint(mi.AssetID.Int64),
		ParentEpisode: bigquery.NullInt64(mi.ParentEpisodeID.NullInt64),
		ParentStarts:  bigquery.NullFloat64(mi.ParentStartsAt),
		ParentEnds:    bigquery.NullFloat64(mi.ParentEndsAt),
	}
}

type Short struct {
	ID          string               `bigquery:"id"`
	MediaID     string               `bigquery:"media_id"`
	AssetID     string               `bigquery:"asset_id"`
	Label       string               `bigquery:"label"`
	EpisodeID   string               `bigquery:"episode_id"`
	Status      string               `bigquery:"status"`
	StartsAt    bigquery.NullFloat64 `bigquery:"starts_at"`
	EndsAt      bigquery.NullFloat64 `bigquery:"ends_at"`
	Image       bigquery.NullString  `bigquery:"image"`
	DateUpdated time.Time            `bigquery:"date_updated"`
	Tags        string               `bigquery:"tags"`
}

func ShortFromCommon(s common.Short, tags []common.Tag) Short {
	return Short{
		ID:          s.ID.String(),
		MediaID:     s.MediaID.String(),
		AssetID:     fmt.Sprint(s.AssetID.Int64),
		Label:       s.Label,
		EpisodeID:   fmt.Sprint(s.EpisodeID.Int64),
		StartsAt:    bigquery.NullFloat64(s.StartsAt.NullFloat64),
		EndsAt:      bigquery.NullFloat64(s.EndsAt.NullFloat64),
		Image:       nullStr(s.Images.GetDefault([]string{"no"}, common.ImageStyleDefault)),
		DateUpdated: s.DateUpdated,
		Status:      string(s.Status),
		Tags:        tagsToJson(tags),
	}
}

type CalendarEntry struct {
	ID       string              `bigquery:"id"`
	EventID  bigquery.NullString `bigquery:"event_id"`
	Title    string              `bigquery:"title"`
	Start    time.Time           `bigquery:"start"`
	End      time.Time           `bigquery:"end"`
	Type     bigquery.NullString `bigquery:"type"`
	IsReplay bool                `bigquery:"is_replay"`
	ItemID   bigquery.NullString `bigquery:"item_id"`
}

func CalendarEntryFromCommon(c common.CalendarEntry, _ int) CalendarEntry {
	var eventID *string
	if c.EventID.Valid {
		e := fmt.Sprint(c.EventID.Int64)
		eventID = &e
	}

	return CalendarEntry{
		ID:       fmt.Sprint(c.ID),
		EventID:  nullStr(eventID),
		Title:    c.Title.Get(*utils.FallbackLanguages()),
		Start:    c.Start,
		End:      c.End,
		Type:     nullStr(c.Type.Ptr()),
		IsReplay: c.IsReplay,
		ItemID:   nullIntToBQNullString(c.ItemID),
	}
}

func tagsToJson(tags []common.Tag) string {
	return asJsonString(lo.Map(tags, func(t common.Tag, _ int) string {
		return t.Code
	}))
}
