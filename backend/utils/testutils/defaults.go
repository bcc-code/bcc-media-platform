package testutils

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
)

var DefaultUser = uuid.MustParse("99999999-9999-4999-9999-999999999999")

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
