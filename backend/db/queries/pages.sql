-- name: GetPage :one
SELECT * FROM admin.page
WHERE id = $1 LIMIT 1;

-- name: GetPages :many
SELECT * FROM admin.page;

-- name: GetPageTranslations :many
SELECT * from public.page_t;

-- name: InsertPage :one
WITH c AS (
    INSERT INTO collectable (
        type,
        available_from,
        available_to,
        published_time,
        status
    ) VALUES (
        'page',
        $1,
        $2,
        $3,
        $4
    ) RETURNING *
),
p as (
    INSERT INTO page (
        id,
        collectable_type
    ) SELECT
        c.id,
        c.type
    FROM c RETURNING *
),
t AS (
    INSERT INTO page_t (
        page_id,
        language_code,
        title,
        description
    ) SELECT 
        c.id,
        'no',
        $5,
        $6
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
	t.id as translation_id,
    p.*
    FROM c,t,p;

-- name: UpsertPage :one
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
t AS (
    INSERT INTO page_t (
        page_id,
        language_code,
        title,
        description
    ) SELECT 
        sqlc.arg(id),
        'no',
        sqlc.arg(title),
        sqlc.arg(description)
    ON CONFLICT (page_id, language_code)
        DO UPDATE SET
            title = sqlc.arg(title),
            description = sqlc.arg(description)
    RETURNING *
),
p as (
    SELECT * from page
    WHERE id = sqlc.arg(id)
),
ug_del AS (
    DELETE FROM usergroup_collectable
    where collectable_id=sqlc.arg(id) and usergroup_id not in (select ug.id from unnest(sqlc.arg(usergroups)::text[]) as ug(id))
),
ug_ins AS (
    INSERT INTO usergroup_collectable(usergroup_id, collectable_id)
    select ug.id, sqlc.arg(id)
    from unnest(sqlc.arg(usergroups)::text[]) as ug(id)
        ON CONFLICT (usergroup_id, collectable_id) DO NOTHING
),
tg_del AS (
    DELETE FROM tag_collectable
    where collectable_id=sqlc.arg(id) and tag_id not in (select tg.id from unnest(sqlc.arg(tags)::bigint[]) as tg(id))
),
tg_ins AS (
    INSERT INTO tag_collectable(tag_id, collectable_id)
    select tg.id, sqlc.arg(id)
    from unnest(sqlc.arg(tags)::bigint[]) as tg(id)
    ON CONFLICT (tag_id, collectable_id) DO NOTHING
)
SELECT 
    p.*,
    c.*,
    sqlc.arg(usergroups)::text[] as usergroups,
    sqlc.arg(tags)::bigint[] as tags,
	t.title,
	t.description
    FROM c,t,p;
