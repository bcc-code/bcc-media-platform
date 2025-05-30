// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: mediaitems.sql

package sqlc

import (
	"context"
	"database/sql"
	"time"

	"github.com/google/uuid"
	"github.com/lib/pq"
	null_v4 "gopkg.in/guregu/null.v4"
)

const getMediaItemByID = `-- name: GetMediaItemByID :one
SELECT id, user_created, date_created, user_updated, date_updated, label, title, description, type, asset_id, parent_episode_id, parent_starts_at, parent_ends_at, published_at, production_date, parent_id, content_type, audience, agerating_code, translations_required, timedmetadata_from_asset, available_from, available_to, primary_episode_id FROM mediaitems WHERE id = $1::uuid
`

func (q *Queries) GetMediaItemByID(ctx context.Context, id uuid.UUID) (Mediaitem, error) {
	row := q.db.QueryRowContext(ctx, getMediaItemByID, id)
	var i Mediaitem
	err := row.Scan(
		&i.ID,
		&i.UserCreated,
		&i.DateCreated,
		&i.UserUpdated,
		&i.DateUpdated,
		&i.Label,
		&i.Title,
		&i.Description,
		&i.Type,
		&i.AssetID,
		&i.ParentEpisodeID,
		&i.ParentStartsAt,
		&i.ParentEndsAt,
		&i.PublishedAt,
		&i.ProductionDate,
		&i.ParentID,
		&i.ContentType,
		&i.Audience,
		&i.AgeratingCode,
		&i.TranslationsRequired,
		&i.TimedmetadataFromAsset,
		&i.AvailableFrom,
		&i.AvailableTo,
		&i.PrimaryEpisodeID,
	)
	return i, err
}

const getMediaItemsTranslatableText = `-- name: GetMediaItemsTranslatableText :many
SELECT id, title, description FROM mediaitems WHERE translations_required
                                                AND (date_updated > $1::timestamp OR date_updated IS NULL)
                                                AND (
        (title != '' AND title is not NULL) OR
        (description != '' AND description is not NULL)
        )
`

type GetMediaItemsTranslatableTextRow struct {
	ID          uuid.UUID      `db:"id" json:"id"`
	Title       null_v4.String `db:"title" json:"title"`
	Description null_v4.String `db:"description" json:"description"`
}

func (q *Queries) GetMediaItemsTranslatableText(ctx context.Context, dateUpdated time.Time) ([]GetMediaItemsTranslatableTextRow, error) {
	rows, err := q.db.QueryContext(ctx, getMediaItemsTranslatableText, dateUpdated)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetMediaItemsTranslatableTextRow
	for rows.Next() {
		var i GetMediaItemsTranslatableTextRow
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

const insertMediaItem = `-- name: InsertMediaItem :one
INSERT INTO mediaitems (
    id,
    label,
    title,
    description,
    type,
    asset_id,
    parent_episode_id,
    parent_starts_at,
    parent_ends_at,
    published_at,
    production_date,
    parent_id,
    content_type,
    audience,
    agerating_code,
    translations_required,
    timedmetadata_from_asset,
    available_from,
    available_to,
    primary_episode_id
)
VALUES (
    gen_random_uuid(),
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19
)
RETURNING id
`

type InsertMediaItemParams struct {
	Label                  string          `db:"label" json:"label"`
	Title                  null_v4.String  `db:"title" json:"title"`
	Description            null_v4.String  `db:"description" json:"description"`
	Type                   string          `db:"type" json:"type"`
	AssetID                null_v4.Int     `db:"asset_id" json:"assetId"`
	ParentEpisodeID        null_v4.Int     `db:"parent_episode_id" json:"parentEpisodeId"`
	ParentStartsAt         sql.NullFloat64 `db:"parent_starts_at" json:"parentStartsAt"`
	ParentEndsAt           sql.NullFloat64 `db:"parent_ends_at" json:"parentEndsAt"`
	PublishedAt            null_v4.Time    `db:"published_at" json:"publishedAt"`
	ProductionDate         null_v4.Time    `db:"production_date" json:"productionDate"`
	ParentID               uuid.NullUUID   `db:"parent_id" json:"parentId"`
	ContentType            null_v4.String  `db:"content_type" json:"contentType"`
	Audience               null_v4.String  `db:"audience" json:"audience"`
	AgeratingCode          null_v4.String  `db:"agerating_code" json:"ageratingCode"`
	TranslationsRequired   bool            `db:"translations_required" json:"translationsRequired"`
	TimedmetadataFromAsset bool            `db:"timedmetadata_from_asset" json:"timedmetadataFromAsset"`
	AvailableFrom          null_v4.Time    `db:"available_from" json:"availableFrom"`
	AvailableTo            null_v4.Time    `db:"available_to" json:"availableTo"`
	PrimaryEpisodeID       null_v4.Int     `db:"primary_episode_id" json:"primaryEpisodeId"`
}

func (q *Queries) InsertMediaItem(ctx context.Context, arg InsertMediaItemParams) (uuid.UUID, error) {
	row := q.db.QueryRowContext(ctx, insertMediaItem,
		arg.Label,
		arg.Title,
		arg.Description,
		arg.Type,
		arg.AssetID,
		arg.ParentEpisodeID,
		arg.ParentStartsAt,
		arg.ParentEndsAt,
		arg.PublishedAt,
		arg.ProductionDate,
		arg.ParentID,
		arg.ContentType,
		arg.Audience,
		arg.AgeratingCode,
		arg.TranslationsRequired,
		arg.TimedmetadataFromAsset,
		arg.AvailableFrom,
		arg.AvailableTo,
		arg.PrimaryEpisodeID,
	)
	var id uuid.UUID
	err := row.Scan(&id)
	return id, err
}

const getPrimaryEpisodeIDForMediaItems = `-- name: getPrimaryEpisodeIDForMediaItems :many
SELECT id, primary_episode_id
FROM mediaitems
WHERE id = ANY($1::uuid[])
`

type getPrimaryEpisodeIDForMediaItemsRow struct {
	ID               uuid.UUID   `db:"id" json:"id"`
	PrimaryEpisodeID null_v4.Int `db:"primary_episode_id" json:"primaryEpisodeId"`
}

func (q *Queries) getPrimaryEpisodeIDForMediaItems(ctx context.Context, ids []uuid.UUID) ([]getPrimaryEpisodeIDForMediaItemsRow, error) {
	rows, err := q.db.QueryContext(ctx, getPrimaryEpisodeIDForMediaItems, pq.Array(ids))
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []getPrimaryEpisodeIDForMediaItemsRow
	for rows.Next() {
		var i getPrimaryEpisodeIDForMediaItemsRow
		if err := rows.Scan(&i.ID, &i.PrimaryEpisodeID); err != nil {
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
