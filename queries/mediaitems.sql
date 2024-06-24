-- name: GetMediaItemByID :one
SELECT * FROM mediaitems WHERE id = @id::uuid;

-- name: getPrimaryEpisodeIDForMediaItems :many
SELECT id, primary_episode_id
FROM mediaitems
WHERE id = ANY(@ids::uuid[]);

-- name: InsertMediaItem :one
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
    @label,
    @title,
    @description,
    @type,
    @asset_id,
    @parent_episode_id,
    @parent_starts_at,
    @parent_ends_at,
    @published_at,
    @production_date,
    @parent_id,
    @content_type,
    @audience,
    @agerating_code,
    @translations_required,
    @timedmetadata_from_asset,
    @available_from,
    @available_to,
    @primary_episode_id
)
RETURNING id;