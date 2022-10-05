package sqlc

import (
	"context"
	"github.com/google/uuid"
)

func (q *Queries) SetDeviceToken(ctx context.Context, profileID uuid.UUID, token string) error {
	err := q.setDeviceToken(ctx, setDeviceTokenParams{
		Column1: token,
		Column2: profileID,
	})

	return err
}
