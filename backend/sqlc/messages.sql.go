// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: messages.sql

package sqlc

import (
	"context"
	"database/sql"
	"encoding/json"

	"github.com/lib/pq"
)

const getSectionIDsWithMessageIDs = `-- name: GetSectionIDsWithMessageIDs :many
SELECT s.id
FROM sections s
         JOIN messages m ON m.id = s.message_id
WHERE m.id = ANY ($1::int[])
`

func (q *Queries) GetSectionIDsWithMessageIDs(ctx context.Context, dollar_1 []int32) ([]int32, error) {
	rows, err := q.db.QueryContext(ctx, getSectionIDsWithMessageIDs, pq.Array(dollar_1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []int32
	for rows.Next() {
		var id int32
		if err := rows.Scan(&id); err != nil {
			return nil, err
		}
		items = append(items, id)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getMessageGroups = `-- name: getMessageGroups :many
WITH ts AS (SELECT messagetemplates_id,
                   json_object_agg(languages_code, message) AS message,
                   json_object_agg(languages_code, details) AS details
            FROM messagetemplates_translations
            GROUP BY messagetemplates_id),
     msg AS (SELECT mt.id, mt.status, mt.style, mm.messages_id, ts.message, ts.details
             FROM messagetemplates mt
                      JOIN messages_messagetemplates mm on mt.id = mm.messagetemplates_id
                      JOIN ts ON ts.messagetemplates_id = mt.id
             WHERE mt.status = 'published')
SELECT groups.id, groups.enabled, json_agg(msg) as messages
FROM messages groups
         JOIN msg ON msg.messages_id = groups.id
WHERE groups.status = 'published'
  AND groups.id = ANY ($1::int[])
GROUP BY groups.id, groups.enabled
`

type getMessageGroupsRow struct {
	ID       int32           `db:"id" json:"id"`
	Enabled  sql.NullBool    `db:"enabled" json:"enabled"`
	Messages json.RawMessage `db:"messages" json:"messages"`
}

func (q *Queries) getMessageGroups(ctx context.Context, dollar_1 []int32) ([]getMessageGroupsRow, error) {
	rows, err := q.db.QueryContext(ctx, getMessageGroups, pq.Array(dollar_1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getMessageGroupsRow
	for rows.Next() {
		var i getMessageGroupsRow
		if err := rows.Scan(&i.ID, &i.Enabled, &i.Messages); err != nil {
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
