package testutils

import (
	"context"
	"database/sql"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"

	"testing"
)

func CreateRandomShow(t *testing.T, ctx context.Context, q *sqlc.Queries) *common.Show {
	t.Helper()
	s, err := q.AddShow(ctx, sqlc.AddShowParams{
		Uuid:                    uuid.New(),
		AgeratingCode:           "A",
		AvailableFrom:           null.Time{},
		AvailableTo:             null.Time{},
		DateCreated:             time.Now(),
		DateUpdated:             time.Now(),
		PublishDate:             time.Now(),
		Status:                  "published",
		Type:                    "type",
		UserCreated:             DefaultUser,
		UserUpdated:             DefaultUser,
		DefaultEpisodeBehaviour: null.NewString("behaviour", true),
		PublishDateInTitle:      sql.NullBool{Bool: true, Valid: true},
		Label:                   null.NewString("label", true),
		PublicTitle:             null.NewString("title", true),
		TranslationsRequired:    true,
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	err = q.UpdateShowTranslation(ctx, sqlc.UpdateShowTranslationParams{
		Description: null.NewString("description", true),
		Title:       null.NewString("title", true),
		ItemID:      s.ID,
		Language:    "no",
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	shows, err := q.GetShows(ctx, []int{int(s.ID)})
	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	return &shows[0]
}

func CreateRandomSeason(t *testing.T, ctx context.Context, q *sqlc.Queries, showID int) *common.Season {
	t.Helper()
	s, err := q.AddSeason(ctx, sqlc.AddSeasonParams{
		AgeratingCode:        null.StringFrom("A"),
		AvailableFrom:        null.TimeFrom(time.Now().Add(-time.Hour * 24)),
		AvailableTo:          null.TimeFrom(time.Now().Add(time.Hour * 24)),
		DateCreated:          time.Now(),
		DateUpdated:          time.Now(),
		PublishDate:          time.Now(),
		SeasonNumber:         2,
		ShowID:               int32(showID),
		Status:               "published",
		UserCreated:          DefaultUser,
		UserUpdated:          DefaultUser,
		Label:                null.StringFrom("Label"),
		PublicTitle:          null.StringFrom("Public title"),
		EpisodeNumberInTitle: false,
		Uuid:                 uuid.New(),
		TranslationsRequired: true,
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	err = q.UpdateSeasonTranslation(ctx, sqlc.UpdateSeasonTranslationParams{
		Description: null.NewString("description", true),
		Title:       null.NewString("title", true),
		ItemID:      s.ID,
		Language:    "no",
	})

	seasons, err := q.GetSeasons(ctx, []int{int(s.ID)})
	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	return &seasons[0]
}

func CreateRandomEpisode(t *testing.T, ctx context.Context, q *sqlc.Queries, seasonID int) *common.Episode {
	t.Helper()

	mID := CreateMediaItem(t, ctx, q)

	e, err := q.AddEpisode(ctx, sqlc.AddEpisodeParams{
		AssetID:               null.Int{},
		AvailableFrom:         time.Now().Add(-time.Hour * 24),
		AvailableTo:           time.Now().Add(time.Hour * 24),
		EpisodeNumber:         null.NewInt(1, true),
		PublishDate:           time.Now(),
		SeasonID:              null.NewInt(int64(seasonID), true),
		UserCreated:           DefaultUser,
		UserUpdated:           DefaultUser,
		PublishDateInTitle:    sql.NullBool{},
		Label:                 null.NewString("Label", true),
		ProductionDate:        null.TimeFrom(time.Now()),
		PublicTitle:           null.NewString("Public title", true),
		PreventPublicIndexing: false,
		Uuid:                  uuid.New(),
		ContentType:           null.String{},
		Audience:              null.String{},
		Status:                "published",
		MediaitemID:           mID,
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	err = q.UpdateEpisodeTranslation(ctx, sqlc.UpdateEpisodeTranslationParams{
		Description: null.NewString("description", true),
		Title:       null.NewString("title", true),
		ItemID:      e.ID,
		Language:    "no",
	})
	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	episode, err := q.GetEpisodes(ctx, []int{int(e.ID)})
	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	return &episode[0]
}

func CreateMediaItem(t *testing.T, ctx context.Context, q *sqlc.Queries) uuid.UUID {
	t.Helper()

	id := uuid.New()
	_, err := q.AddMediaItem(ctx, sqlc.AddMediaItemParams{
		ID:               id,
		UserCreated:      DefaultUser,
		DateCreated:      null.Time{},
		UserUpdated:      DefaultUser,
		DateUpdated:      null.Time{},
		Label:            "Label",
		Title:            null.String{},
		Description:      null.String{},
		AssetID:          null.Int{},
		ParentEpisodeID:  null.Int{},
		ParentStartsAt:   sql.NullFloat64{},
		ParentEndsAt:     sql.NullFloat64{},
		PublishedAt:      null.Time{},
		ProductionDate:   null.Time{},
		ParentID:         uuid.NullUUID{},
		ContentType:      null.String{},
		Audience:         null.String{},
		AgeratingCode:    null.String{},
		AvailableFrom:    null.Time{},
		AvailableTo:      null.Time{},
		PrimaryEpisodeID: null.Int{},
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	return id
}
