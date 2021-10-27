-- name: GetMedia :one
SELECT * FROM media_collectable
WHERE id = $1 LIMIT 1;

-- name: GetAllMedias :many
SELECT * FROM media_collectable
ORDER BY name;

-- name: InsertMedia :one
WITH new_collectable AS (
    INSERT INTO collectable (
        type,
        available_from,
        available_to,
        status
    ) VALUES (
        $1,
        $2,
        $3
    ) RETURNING id
)
INSERT INTO media (
    id,
    collectable_type,
    media_type,
    primary_group_id,
    subclipped_media_id,
    reference_media_id,
    sequence_number,
	start_time,
	end_time,
	asset_id,
	agerating
) VALUES (
    new_collectable.id,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13
) RETURNING *;