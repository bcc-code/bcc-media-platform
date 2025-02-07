package testutils

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
)

var DefaultUser = uuid.MustParse("99999999-9999-4999-9999-999999999999")
var DefaultBCCUser = "999999"

func InsertDefaults(ctx context.Context, q *sqlc.Queries) error {
	err := q.InsertDefaultAgeratings(ctx)
	if err != nil {
		return err
	}

	err = q.InsertDefaultUser(ctx)
	if err != nil {
		return err
	}

	err = q.InsertDefaultLanguages(ctx)
	if err != nil {
		return err
	}

	return nil
}

func CreateAppGroup(t *testing.T, ctx context.Context, q *sqlc.Queries) uuid.UUID {
	appid, err := q.CreateApplicationGroup(ctx, sqlc.CreateApplicationGroupParams{
		UserCreated: DefaultUser,
		Label:       "TEST",
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	return appid
}

func CreateProfile(t *testing.T, ctx context.Context, q *sqlc.Queries, userID string, appGroupID uuid.UUID) {
	t.Helper()

	err := q.ApplicationQueries(appGroupID).SaveProfile(ctx, common.Profile{
		ID:     DefaultUser,
		UserID: userID,
		Name:   "TEST USER",
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}
}
