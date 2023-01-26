// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.15.0
// source: statistician.sql

package sqlc

import (
	"context"
)

const getAllMemberIDs = `-- name: GetAllMemberIDs :many
SELECT user_id FROM users.profiles GROUP BY user_id
`

func (q *Queries) GetAllMemberIDs(ctx context.Context) ([]string, error) {
	rows, err := q.db.QueryContext(ctx, getAllMemberIDs)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []string
	for rows.Next() {
		var user_id string
		if err := rows.Scan(&user_id); err != nil {
			return nil, err
		}
		items = append(items, user_id)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const insertMember = `-- name: InsertMember :exec
INSERT INTO stats.members_data (id, age_group, org_id) VALUES ($1, $2, $3)
`

type InsertMemberParams struct {
	ID       int32  `db:"id" json:"id"`
	AgeGroup string `db:"age_group" json:"ageGroup"`
	Org      int32  `db:"org" json:"org"`
}

func (q *Queries) InsertMember(ctx context.Context, arg InsertMemberParams) error {
	_, err := q.db.ExecContext(ctx, insertMember, arg.ID, arg.AgeGroup, arg.Org)
	return err
}