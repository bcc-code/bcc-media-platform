-- name: GetMedia :one
SELECT * FROM media_collectable
WHERE id = $1 LIMIT 1;

-- name: GetAllMedias :many
SELECT * FROM media_collectable
ORDER BY name;

-- name: InsertMedia :one
WITH c AS (
    INSERT INTO collectable (
        type,
        available_from,
        available_to,
        status
    ) VALUES (
        'media',
        $1,
        $2,
        $3
    ) RETURNING *
),
m AS (
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
    ) SELECT
        c.id,
        c.type,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12
    FROM c RETURNING *
),
t AS (
    INSERT INTO media_t (
        media_id,
        language_code,
        title,
        description,
        long_description
    ) SELECT 
        c.id,
        'no',
        $13,
        $14,
        $15
    FROM c RETURNING *
)
SELECT 
    c.status,
    c.type,
    c.available_from,
    c.available_to,
	t.title,
	t.description,
	t.long_description,
	t.image_id,
	t.id as translation_id,
    m.*
    FROM c,t,m;