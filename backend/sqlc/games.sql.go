// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: games.sql

package sqlc

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/lib/pq"
	"github.com/sqlc-dev/pqtype"
	null_v4 "gopkg.in/guregu/null.v4"
)

const getGameTranslatableTexts = `-- name: GetGameTranslatableTexts :many

SELECT id, title, description FROM games WHERE status = ANY ('{published,unlisted}')
                                          AND (date_updated > $1::timestamp OR date_updated IS NULL)
`

type GetGameTranslatableTextsRow struct {
	ID          uuid.UUID      `db:"id" json:"id"`
	Title       string         `db:"title" json:"title"`
	Description null_v4.String `db:"description" json:"description"`
}

func (q *Queries) GetGameTranslatableTexts(ctx context.Context, dateUpdated time.Time) ([]GetGameTranslatableTextsRow, error) {
	rows, err := q.db.QueryContext(ctx, getGameTranslatableTexts, dateUpdated)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetGameTranslatableTextsRow
	for rows.Next() {
		var i GetGameTranslatableTextsRow
		if err := rows.Scan(&i.ID, &i.Title, &i.Description); err != nil {
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

const getGames = `-- name: getGames :many
WITH ts AS (SELECT games_id,
                   json_object_agg(languages_code, title)       as title,
                   json_object_agg(languages_code, description) as description
            FROM games_translations
            GROUP BY games_id),
     imgs AS (SELECT images.games_id, json_agg(images) as json
              FROM (SELECT simg.games_id, img.style, img.language, df.filename_disk
                    FROM games_styledimages simg
                             JOIN styledimages img ON img.id = simg.styledimages_id
                             JOIN directus_files df on img.file = df.id) images
              GROUP BY images.games_id)
SELECT i.id,
       i.title       as original_title,
       i.description as original_description,
       ts.title,
       ts.description,
       l.url,
       l.requires_authentication,
       img.json      as images
FROM games i
         LEFT JOIN ts ON ts.games_id = i.id
         LEFT JOIN imgs img ON img.games_id = i.id
         JOIN links l ON i.link_id = l.id
WHERE i.id = ANY ($1::uuid[])
`

type getGamesRow struct {
	ID                     uuid.UUID             `db:"id" json:"id"`
	OriginalTitle          string                `db:"original_title" json:"originalTitle"`
	OriginalDescription    null_v4.String        `db:"original_description" json:"originalDescription"`
	Title                  pqtype.NullRawMessage `db:"title" json:"title"`
	Description            pqtype.NullRawMessage `db:"description" json:"description"`
	Url                    string                `db:"url" json:"url"`
	RequiresAuthentication bool                  `db:"requires_authentication" json:"requiresAuthentication"`
	Images                 pqtype.NullRawMessage `db:"images" json:"images"`
}

func (q *Queries) getGames(ctx context.Context, ids []uuid.UUID) ([]getGamesRow, error) {
	rows, err := q.db.QueryContext(ctx, getGames, pq.Array(ids))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getGamesRow
	for rows.Next() {
		var i getGamesRow
		if err := rows.Scan(
			&i.ID,
			&i.OriginalTitle,
			&i.OriginalDescription,
			&i.Title,
			&i.Description,
			&i.Url,
			&i.RequiresAuthentication,
			&i.Images,
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
