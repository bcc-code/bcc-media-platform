// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: seasons.sql

package sqlc

import (
	"context"
	"encoding/json"
	"time"

	"github.com/lib/pq"
	"github.com/sqlc-dev/pqtype"
	null_v4 "gopkg.in/guregu/null.v4"
)

const getPermissionsForSeasons = `-- name: getPermissionsForSeasons :many
SELECT se.id,
       se.status = 'unlisted'             AS unlisted,
       access.published::bool             AS published,
       access.available_from::timestamp   AS available_from,
       access.available_to::timestamp     AS available_to,
       roles.roles::varchar[]             AS usergroups,
       roles.roles_download::varchar[]    AS usergroups_downloads,
       roles.roles_earlyaccess::varchar[] AS usergroups_earlyaccess
FROM seasons se
         LEFT JOIN season_availability access ON access.id = se.id
         LEFT JOIN season_roles roles ON roles.id = se.id
WHERE se.id = ANY ($1::int[])
`

type getPermissionsForSeasonsRow struct {
	ID                    int32     `db:"id" json:"id"`
	Unlisted              bool      `db:"unlisted" json:"unlisted"`
	Published             bool      `db:"published" json:"published"`
	AvailableFrom         time.Time `db:"available_from" json:"availableFrom"`
	AvailableTo           time.Time `db:"available_to" json:"availableTo"`
	Usergroups            []string  `db:"usergroups" json:"usergroups"`
	UsergroupsDownloads   []string  `db:"usergroups_downloads" json:"usergroupsDownloads"`
	UsergroupsEarlyaccess []string  `db:"usergroups_earlyaccess" json:"usergroupsEarlyaccess"`
}

func (q *Queries) getPermissionsForSeasons(ctx context.Context, dollar_1 []int32) ([]getPermissionsForSeasonsRow, error) {
	rows, err := q.db.QueryContext(ctx, getPermissionsForSeasons, pq.Array(dollar_1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getPermissionsForSeasonsRow
	for rows.Next() {
		var i getPermissionsForSeasonsRow
		if err := rows.Scan(
			&i.ID,
			&i.Unlisted,
			&i.Published,
			&i.AvailableFrom,
			&i.AvailableTo,
			pq.Array(&i.Usergroups),
			pq.Array(&i.UsergroupsDownloads),
			pq.Array(&i.UsergroupsEarlyaccess),
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

const getSeasonIDsForShows = `-- name: getSeasonIDsForShows :many
SELECT s.id, s.show_id
FROM seasons s
WHERE s.show_id = ANY ($1::int[])
ORDER BY s.season_number
`

type getSeasonIDsForShowsRow struct {
	ID     int32 `db:"id" json:"id"`
	ShowID int32 `db:"show_id" json:"showId"`
}

func (q *Queries) getSeasonIDsForShows(ctx context.Context, dollar_1 []int32) ([]getSeasonIDsForShowsRow, error) {
	rows, err := q.db.QueryContext(ctx, getSeasonIDsForShows, pq.Array(dollar_1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getSeasonIDsForShowsRow
	for rows.Next() {
		var i getSeasonIDsForShowsRow
		if err := rows.Scan(&i.ID, &i.ShowID); err != nil {
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

const getSeasonIDsForShowsWithRoles = `-- name: getSeasonIDsForShowsWithRoles :many
SELECT se.id,
       se.show_id
FROM seasons se
         LEFT JOIN season_availability access ON access.id = se.id
         LEFT JOIN season_roles roles ON roles.id = se.id
WHERE se.show_id = ANY ($1::int[])
  AND access.published
  AND access.available_to > now()
  AND (
        (roles.roles && $2::varchar[] AND access.available_from < now()) OR
        (roles.roles_earlyaccess && $2::varchar[])
    )
ORDER BY se.season_number
`

type getSeasonIDsForShowsWithRolesParams struct {
	Column1 []int32  `db:"column_1" json:"column1"`
	Column2 []string `db:"column_2" json:"column2"`
}

type getSeasonIDsForShowsWithRolesRow struct {
	ID     int32 `db:"id" json:"id"`
	ShowID int32 `db:"show_id" json:"showId"`
}

func (q *Queries) getSeasonIDsForShowsWithRoles(ctx context.Context, arg getSeasonIDsForShowsWithRolesParams) ([]getSeasonIDsForShowsWithRolesRow, error) {
	rows, err := q.db.QueryContext(ctx, getSeasonIDsForShowsWithRoles, pq.Array(arg.Column1), pq.Array(arg.Column2))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getSeasonIDsForShowsWithRolesRow
	for rows.Next() {
		var i getSeasonIDsForShowsWithRolesRow
		if err := rows.Scan(&i.ID, &i.ShowID); err != nil {
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

const getSeasonIDsWithRoles = `-- name: getSeasonIDsWithRoles :many
SELECT se.id
FROM seasons se
         LEFT JOIN season_availability access ON access.id = se.id
         LEFT JOIN season_roles roles ON roles.id = se.id
WHERE se.id = ANY ($1::int[])
  AND access.published
  AND access.available_to > now()
  AND (
        (roles.roles && $2::varchar[] AND access.available_from < now()) OR
        (roles.roles_earlyaccess && $2::varchar[])
    )
`

type getSeasonIDsWithRolesParams struct {
	Column1 []int32  `db:"column_1" json:"column1"`
	Column2 []string `db:"column_2" json:"column2"`
}

func (q *Queries) getSeasonIDsWithRoles(ctx context.Context, arg getSeasonIDsWithRolesParams) ([]int32, error) {
	rows, err := q.db.QueryContext(ctx, getSeasonIDsWithRoles, pq.Array(arg.Column1), pq.Array(arg.Column2))
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

const getSeasons = `-- name: getSeasons :many
WITH ts AS (SELECT seasons_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM seasons_translations
            GROUP BY seasons_id),
     tags AS (SELECT seasons_id,
                     array_agg(tags_id) AS tags
              FROM seasons_tags
              GROUP BY seasons_id),

     images AS (WITH images AS (SELECT season_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT season_id, json_agg(images) as json
                FROM images
                GROUP BY season_id)
SELECT s.id,
       s.legacy_id,
       s.status,
       s.season_number,
       fs.filename_disk                as image_file_name,
       s.show_id,
       s.public_title,
       COALESCE(s.agerating_code, 'A') as agerating,
       tags.tags::int[]                AS tag_ids,
       COALESCE(img.json, '[]')        as images,
       ts.title,
       ts.description
FROM seasons s
         LEFT JOIN ts ON s.id = ts.seasons_id
         LEFT JOIN tags ON tags.seasons_id = s.id
         LEFT JOIN images img ON img.season_id = s.id
         JOIN shows sh ON s.show_id = sh.id
         LEFT JOIN directus_files fs ON fs.id = COALESCE(s.image_file_id, sh.image_file_id)
WHERE s.id = ANY ($1::int[])
`

type getSeasonsRow struct {
	ID            int32                 `db:"id" json:"id"`
	LegacyID      null_v4.Int           `db:"legacy_id" json:"legacyId"`
	Status        string                `db:"status" json:"status"`
	SeasonNumber  int32                 `db:"season_number" json:"seasonNumber"`
	ImageFileName null_v4.String        `db:"image_file_name" json:"imageFileName"`
	ShowID        int32                 `db:"show_id" json:"showId"`
	PublicTitle   null_v4.String        `db:"public_title" json:"publicTitle"`
	Agerating     string                `db:"agerating" json:"agerating"`
	TagIds        []int32               `db:"tag_ids" json:"tagIds"`
	Images        json.RawMessage       `db:"images" json:"images"`
	Title         pqtype.NullRawMessage `db:"title" json:"title"`
	Description   pqtype.NullRawMessage `db:"description" json:"description"`
}

func (q *Queries) getSeasons(ctx context.Context, dollar_1 []int32) ([]getSeasonsRow, error) {
	rows, err := q.db.QueryContext(ctx, getSeasons, pq.Array(dollar_1))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getSeasonsRow
	for rows.Next() {
		var i getSeasonsRow
		if err := rows.Scan(
			&i.ID,
			&i.LegacyID,
			&i.Status,
			&i.SeasonNumber,
			&i.ImageFileName,
			&i.ShowID,
			&i.PublicTitle,
			&i.Agerating,
			pq.Array(&i.TagIds),
			&i.Images,
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

const listSeasons = `-- name: listSeasons :many
WITH ts AS (SELECT seasons_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM seasons_translations
            GROUP BY seasons_id),
     tags AS (SELECT seasons_id,
                     array_agg(tags_id) AS tags
              FROM seasons_tags
              GROUP BY seasons_id),

     images AS (WITH images AS (SELECT season_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT season_id, json_agg(images) as json
                FROM images
                GROUP BY season_id)
SELECT s.id,
       s.legacy_id,
       s.status,
       s.season_number,
       fs.filename_disk                as image_file_name,
       s.show_id,
       s.public_title,
       COALESCE(s.agerating_code, 'A') as agerating,
       tags.tags::int[]                AS tag_ids,
       COALESCE(img.json, '[]')        as images,
       ts.title,
       ts.description
FROM seasons s
         LEFT JOIN ts ON s.id = ts.seasons_id
         LEFT JOIN tags ON tags.seasons_id = s.id
         LEFT JOIN images img ON img.season_id = s.id
         JOIN shows sh ON s.show_id = sh.id
         LEFT JOIN directus_files fs ON fs.id = COALESCE(s.image_file_id, sh.image_file_id)
`

type listSeasonsRow struct {
	ID            int32                 `db:"id" json:"id"`
	LegacyID      null_v4.Int           `db:"legacy_id" json:"legacyId"`
	Status        string                `db:"status" json:"status"`
	SeasonNumber  int32                 `db:"season_number" json:"seasonNumber"`
	ImageFileName null_v4.String        `db:"image_file_name" json:"imageFileName"`
	ShowID        int32                 `db:"show_id" json:"showId"`
	PublicTitle   null_v4.String        `db:"public_title" json:"publicTitle"`
	Agerating     string                `db:"agerating" json:"agerating"`
	TagIds        []int32               `db:"tag_ids" json:"tagIds"`
	Images        json.RawMessage       `db:"images" json:"images"`
	Title         pqtype.NullRawMessage `db:"title" json:"title"`
	Description   pqtype.NullRawMessage `db:"description" json:"description"`
}

func (q *Queries) listSeasons(ctx context.Context) ([]listSeasonsRow, error) {
	rows, err := q.db.QueryContext(ctx, listSeasons)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []listSeasonsRow
	for rows.Next() {
		var i listSeasonsRow
		if err := rows.Scan(
			&i.ID,
			&i.LegacyID,
			&i.Status,
			&i.SeasonNumber,
			&i.ImageFileName,
			&i.ShowID,
			&i.PublicTitle,
			&i.Agerating,
			pq.Array(&i.TagIds),
			&i.Images,
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
