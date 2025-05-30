// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: sections.sql

package sqlexport

import (
	"context"
	"database/sql"
)

const insertSection = `-- name: InsertSection :exec
INSERT INTO sections (id, sort, page_id, type, show_title, title, description, style, size, collection_id)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
`

type InsertSectionParams struct {
	ID           int64         `db:"id" json:"id"`
	Sort         int64         `db:"sort" json:"sort"`
	PageID       int64         `db:"page_id" json:"pageId"`
	Type         string        `db:"type" json:"type"`
	ShowTitle    bool          `db:"show_title" json:"showTitle"`
	Title        string        `db:"title" json:"title"`
	Description  string        `db:"description" json:"description"`
	Style        string        `db:"style" json:"style"`
	Size         string        `db:"size" json:"size"`
	CollectionID sql.NullInt64 `db:"collection_id" json:"collectionId"`
}

func (q *Queries) InsertSection(ctx context.Context, arg InsertSectionParams) error {
	_, err := q.db.ExecContext(ctx, insertSection,
		arg.ID,
		arg.Sort,
		arg.PageID,
		arg.Type,
		arg.ShowTitle,
		arg.Title,
		arg.Description,
		arg.Style,
		arg.Size,
		arg.CollectionID,
	)
	return err
}
