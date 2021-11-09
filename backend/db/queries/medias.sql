-- name: GetMedia :one
SELECT * FROM admin.media
WHERE id = $1 LIMIT 1;

-- name: GetAsset :one
SELECT * FROM asset
WHERE id = $1 LIMIT 1;


-- name: InsertMedia :one
WITH c AS (
    INSERT INTO collectable (
        type,
        available_from,
        available_to,
        published_time,
        status
    ) VALUES (
        'media',
        $1,
        $2,
        $3,
        $16
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
    c.published_time,
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
        available_from = sqlc.arg(available_from),
        available_to = sqlc.arg(available_to),
        published_time = sqlc.arg(published_time),
        status = sqlc.arg(status)
    WHERE c1.id = sqlc.arg(id)
    RETURNING c1.*
),
m AS (
    UPDATE media m1
    SET
        media_type = sqlc.arg(media_type),
        primary_group_id = sqlc.arg(primary_group_id),
        subclipped_media_id = sqlc.arg(subclipped_media_id),
        reference_media_id = sqlc.arg(reference_media_id),
        sequence_number = sqlc.arg(sequence_number),
        start_time = sqlc.arg(start_time),
        end_time = sqlc.arg(end_time),
        asset_id = sqlc.arg(asset_id),
        agerating = sqlc.arg(agerating)
    WHERE m1.id = sqlc.arg(id)
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
        sqlc.arg(id),
        'no',
        sqlc.arg(title),
        sqlc.arg(description),
        sqlc.arg(long_description)
    ON CONFLICT (media_id, language_code)
        DO UPDATE SET
            title = sqlc.arg(title),
            description = sqlc.arg(description),
            long_description = sqlc.arg(long_description)
    RETURNING *
),
ug_del AS (
    DELETE FROM usergroup_collectable
    where collectable_id=sqlc.arg(id) and usergroup_id not in (select ug.id from unnest(sqlc.arg(usergroups)::text[]) as ug(id))
),
ug_ins AS (
    INSERT INTO usergroup_collectable(usergroup_id, collectable_id)
    select ug.id, sqlc.arg(id)
    from unnest(sqlc.arg(usergroups)::text[]) as ug(id)
    /*
        Add this when constraints exist. They get deleted by mock-data
        ON CONFLICT (usergroup_id, collectable_id) DO NOTHING
    */
),
tg_del AS (
    DELETE FROM tag_collectable
    where collectable_id=sqlc.arg(id) and tag_id not in (select tg.id from unnest(sqlc.arg(tags)::bigint[]) as tg(id))
),
tg_ins AS (
    INSERT INTO tag_collectable(tag_id, collectable_id)
    select tg.id, sqlc.arg(id)
    from unnest(sqlc.arg(tags)::bigint[]) as tg(id)
    /*
        Add this when constraints exist. They get deleted by mock-data
        ON CONFLICT (usergroup_id, collectable_id) DO NOTHING
    */
)
SELECT 
    m.*,
    c.*,
    sqlc.arg(usergroups)::text[] as usergroups,
    sqlc.arg(tags)::bigint[] as tags,
	t.title,
	t.description,
	t.long_description,
	t.image_id
    FROM c,t,m;
