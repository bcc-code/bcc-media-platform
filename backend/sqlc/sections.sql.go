// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: sections.sql

package sqlc

import (
	"context"
	"database/sql"
	"encoding/json"

	"github.com/google/uuid"
	"github.com/lib/pq"
	"github.com/sqlc-dev/pqtype"
	null_v4 "gopkg.in/guregu/null.v4"
)

const getLinks = `-- name: getLinks :many
WITH ts AS (SELECT links_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM links_translations
            GROUP BY links_id),
     images AS (WITH images AS (SELECT link_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT link_id, json_agg(images) as json
                FROM images
                GROUP BY link_id)
SELECT ls.id,
       ls.url,
       COALESCE(images.json, '[]') as images,
       ls.type,
       ls.computeddatagroup_id,
       ts.title,
       ts.description
FROM links ls
         LEFT JOIN ts ON ls.id = ts.links_id
         LEFT JOIN images ON ls.id = images.link_id
WHERE ls.id = ANY ($1::int[])
  AND ls.status = 'published'
`

type getLinksRow struct {
	ID                  int32                 `db:"id" json:"id"`
	Url                 string                `db:"url" json:"url"`
	Images              json.RawMessage       `db:"images" json:"images"`
	Type                null_v4.String        `db:"type" json:"type"`
	ComputeddatagroupID uuid.NullUUID         `db:"computeddatagroup_id" json:"computeddatagroupId"`
	Title               pqtype.NullRawMessage `db:"title" json:"title"`
	Description         pqtype.NullRawMessage `db:"description" json:"description"`
}

func (q *Queries) getLinks(ctx context.Context, dollar_1 []int32) ([]getLinksRow, error) {
	rows, err := q.db.QueryContext(ctx, getLinks, pq.Array(dollar_1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getLinksRow
	for rows.Next() {
		var i getLinksRow
		if err := rows.Scan(
			&i.ID,
			&i.Url,
			&i.Images,
			&i.Type,
			&i.ComputeddatagroupID,
			&i.Title,
			&i.Description,
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

const getPermissionsForSections = `-- name: getPermissionsForSections :many
SELECT s.id::int              AS id,
       s.status = 'published' AS published,
       roles.roles::varchar[] AS roles
FROM sections s
         JOIN pages p ON p.id = s.page_id
         LEFT JOIN (SELECT su.sections_id, array_agg(DISTINCT (su.usergroups_code)) roles
                    FROM sections_usergroups su
                    GROUP BY su.sections_id) roles ON roles.sections_id = s.id
WHERE p.status = 'published'
  AND s.status = 'published'
  AND s.id = ANY ($1::int[])
`

type getPermissionsForSectionsRow struct {
	ID        int32    `db:"id" json:"id"`
	Published bool     `db:"published" json:"published"`
	Roles     []string `db:"roles" json:"roles"`
}

func (q *Queries) getPermissionsForSections(ctx context.Context, ids []int32) ([]getPermissionsForSectionsRow, error) {
	rows, err := q.db.QueryContext(ctx, getPermissionsForSections, pq.Array(ids))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getPermissionsForSectionsRow
	for rows.Next() {
		var i getPermissionsForSectionsRow
		if err := rows.Scan(&i.ID, &i.Published, pq.Array(&i.Roles)); err != nil {
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

const getSectionIDsForPages = `-- name: getSectionIDsForPages :many
SELECT s.id::int AS id,
       p.id::int AS page_id
FROM sections s
         JOIN pages p ON s.page_id = p.id
WHERE p.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published'
ORDER BY s.sort
`

type getSectionIDsForPagesRow struct {
	ID     int32 `db:"id" json:"id"`
	PageID int32 `db:"page_id" json:"pageId"`
}

func (q *Queries) getSectionIDsForPages(ctx context.Context, dollar_1 []int32) ([]getSectionIDsForPagesRow, error) {
	rows, err := q.db.QueryContext(ctx, getSectionIDsForPages, pq.Array(dollar_1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getSectionIDsForPagesRow
	for rows.Next() {
		var i getSectionIDsForPagesRow
		if err := rows.Scan(&i.ID, &i.PageID); err != nil {
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

const getSectionIDsForPagesWithRoles = `-- name: getSectionIDsForPagesWithRoles :many
WITH roles AS (SELECT s.id,
                      COALESCE((SELECT array_agg(DISTINCT seu.usergroups_code) AS code
                                FROM sections_usergroups seu
                                WHERE seu.sections_id = s.id), ARRAY []::character varying[]) AS roles
               FROM sections s)
SELECT s.id::int AS id,
       p.id::int AS page_id
FROM sections s
         JOIN pages p ON s.page_id = p.id
         JOIN roles r ON r.id = s.id
WHERE p.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published'
  AND r.roles && $2::varchar[]
ORDER BY s.sort
`

type getSectionIDsForPagesWithRolesParams struct {
	Column1 []int32  `db:"column_1" json:"column1"`
	Column2 []string `db:"column_2" json:"column2"`
}

type getSectionIDsForPagesWithRolesRow struct {
	ID     int32 `db:"id" json:"id"`
	PageID int32 `db:"page_id" json:"pageId"`
}

func (q *Queries) getSectionIDsForPagesWithRoles(ctx context.Context, arg getSectionIDsForPagesWithRolesParams) ([]getSectionIDsForPagesWithRolesRow, error) {
	rows, err := q.db.QueryContext(ctx, getSectionIDsForPagesWithRoles, pq.Array(arg.Column1), pq.Array(arg.Column2))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getSectionIDsForPagesWithRolesRow
	for rows.Next() {
		var i getSectionIDsForPagesWithRolesRow
		if err := rows.Scan(&i.ID, &i.PageID); err != nil {
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

const getSections = `-- name: getSections :many
WITH t AS (SELECT ts.sections_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM sections_translations ts
           GROUP BY ts.sections_id)
SELECT s.id,
       p.id::int                                AS page_id,
       s.type,
       s.style,
       s.size,
       s.grid_size,
       s.show_title,
       s.sort,
       s.status::text = 'published'::text       AS published,
       s.collection_id,
       s.message_id,
       s.embed_url,
       s.embed_aspect_ratio,
       s.embed_height,
       s.needs_authentication,
       s.use_context,
       s.prepend_live_element,
       s.limit,
       s.achievements_source,
       c.advanced_type,
       COALESCE(s.secondary_titles, true)::bool as secondary_titles,
       t.title,
       t.description
FROM sections s
         JOIN pages p ON s.page_id = p.id
         LEFT JOIN collections c ON c.id = s.collection_id
         LEFT JOIN t ON s.id = t.sections_id
WHERE s.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published'
`

type getSectionsRow struct {
	ID                  int32                 `db:"id" json:"id"`
	PageID              int32                 `db:"page_id" json:"pageId"`
	Type                null_v4.String        `db:"type" json:"type"`
	Style               null_v4.String        `db:"style" json:"style"`
	Size                null_v4.String        `db:"size" json:"size"`
	GridSize            null_v4.String        `db:"grid_size" json:"gridSize"`
	ShowTitle           sql.NullBool          `db:"show_title" json:"showTitle"`
	Sort                null_v4.Int           `db:"sort" json:"sort"`
	Published           bool                  `db:"published" json:"published"`
	CollectionID        null_v4.Int           `db:"collection_id" json:"collectionId"`
	MessageID           null_v4.Int           `db:"message_id" json:"messageId"`
	EmbedUrl            null_v4.String        `db:"embed_url" json:"embedUrl"`
	EmbedAspectRatio    sql.NullFloat64       `db:"embed_aspect_ratio" json:"embedAspectRatio"`
	EmbedHeight         null_v4.Int           `db:"embed_height" json:"embedHeight"`
	NeedsAuthentication sql.NullBool          `db:"needs_authentication" json:"needsAuthentication"`
	UseContext          sql.NullBool          `db:"use_context" json:"useContext"`
	PrependLiveElement  sql.NullBool          `db:"prepend_live_element" json:"prependLiveElement"`
	Limit               null_v4.Int           `db:"limit" json:"limit"`
	AchievementsSource  null_v4.String        `db:"achievements_source" json:"achievementsSource"`
	AdvancedType        null_v4.String        `db:"advanced_type" json:"advancedType"`
	SecondaryTitles     bool                  `db:"secondary_titles" json:"secondaryTitles"`
	Title               pqtype.NullRawMessage `db:"title" json:"title"`
	Description         pqtype.NullRawMessage `db:"description" json:"description"`
}

func (q *Queries) getSections(ctx context.Context, dollar_1 []int32) ([]getSectionsRow, error) {
	rows, err := q.db.QueryContext(ctx, getSections, pq.Array(dollar_1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getSectionsRow
	for rows.Next() {
		var i getSectionsRow
		if err := rows.Scan(
			&i.ID,
			&i.PageID,
			&i.Type,
			&i.Style,
			&i.Size,
			&i.GridSize,
			&i.ShowTitle,
			&i.Sort,
			&i.Published,
			&i.CollectionID,
			&i.MessageID,
			&i.EmbedUrl,
			&i.EmbedAspectRatio,
			&i.EmbedHeight,
			&i.NeedsAuthentication,
			&i.UseContext,
			&i.PrependLiveElement,
			&i.Limit,
			&i.AchievementsSource,
			&i.AdvancedType,
			&i.SecondaryTitles,
			&i.Title,
			&i.Description,
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
