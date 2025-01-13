package testutils

import (
	"context"
	"database/sql"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
)

func CreateRandomShow(ctx context.Context, q *sqlc.Queries) (*common.Show, error) {
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
		return nil, err
	}

	err = q.UpdateShowTranslation(ctx, sqlc.UpdateShowTranslationParams{
		Description: null.NewString("description", true),
		Title:       null.NewString("title", true),
		ItemID:      s.ID,
		Language:    "no",
	})

	if err != nil {
		return nil, err
	}

	shows, err := q.GetShows(ctx, []int{int(s.ID)})
	if err != nil {
		return nil, err
	}

	return &shows[0], nil
}
