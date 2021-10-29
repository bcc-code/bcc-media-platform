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

-- name: UpsertMedia :one
WITH c AS (
    UPDATE collectable c1
    SET
        available_from = $1,
        available_to = $2,
        status = $3
    WHERE c1.id = $4
    RETURNING c1.*
),
m AS (
    UPDATE media m1
    SET
        media_type = $5,
        primary_group_id = $6,
        subclipped_media_id = $7,
        reference_media_id = $8,
        sequence_number = $9,
        start_time = $10,
        end_time = $11,
        asset_id = $12,
        agerating = $13
    FROM c
    WHERE m1.id = c.id
    RETURNING m1.*
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
        $14,
        $15,
        $16
    FROM c
    ON CONFLICT (media_id, language_code)
        DO UPDATE SET
            title = $14,
            description = $15,
            long_description = $16
    RETURNING *
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
    m.*
    FROM c,t,m;

-- name: UpdateMedia :one
WITH c AS (
    UPDATE collectable c1
    SET
        available_from = $1,
        available_to = $2,
        status = $3
    WHERE c1.id = $4
    RETURNING c1.*
),
m AS (
    UPDATE media m1
    SET
        media_type = $5,
        primary_group_id = $6,
        subclipped_media_id = $7,
        reference_media_id = $8,
        sequence_number = $9,
        start_time = $10,
        end_time = $11,
        asset_id = $12,
        agerating = $13
    FROM c
    WHERE m1.id = c.id
    RETURNING m1.*
),
t AS (
    UPDATE media_t t1
    SET
        title = $14,
        description = $15,
        long_description = $16
    FROM c
    WHERE t1.media_id = c.id AND t1.language_code = 'no'
    RETURNING t1.*
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
    m.*
    FROM c,t,m;