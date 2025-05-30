// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: answers.sql

package sqlc

import (
	"context"
	"time"

	"github.com/google/uuid"
	null_v4 "gopkg.in/guregu/null.v4"
)

const getAnswersSince = `-- name: GetAnswersSince :many
SELECT
	message,
	item_id,
	COALESCE(metadata->>'rating', '-1')::int + 1 as rating,
	age_group,
	org_id,
	updated_at as updated
FROM users.messages
WHERE created_at > $1::TIMESTAMP
`

type GetAnswersSinceRow struct {
	Message  string         `db:"message" json:"message"`
	ItemID   uuid.UUID      `db:"item_id" json:"itemId"`
	Rating   int32          `db:"rating" json:"rating"`
	AgeGroup null_v4.String `db:"age_group" json:"ageGroup"`
	OrgID    null_v4.Int    `db:"org_id" json:"orgId"`
	Updated  null_v4.Time   `db:"updated" json:"updated"`
}

func (q *Queries) GetAnswersSince(ctx context.Context, createdAt time.Time) ([]GetAnswersSinceRow, error) {
	rows, err := q.db.QueryContext(ctx, getAnswersSince, createdAt)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAnswersSinceRow
	for rows.Next() {
		var i GetAnswersSinceRow
		if err := rows.Scan(
			&i.Message,
			&i.ItemID,
			&i.Rating,
			&i.AgeGroup,
			&i.OrgID,
			&i.Updated,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
