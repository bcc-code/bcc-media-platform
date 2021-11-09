-- name: GetTag :one
SELECT * FROM admin.tag
WHERE id = $1 LIMIT 1;

-- name: InsertTag :one
WITH t AS (
    INSERT INTO tag (
        type
    ) VALUES (
        @type
    ) RETURNING *
),
tt AS (
    INSERT INTO tag_t (
        tag_id,
        language_code,
        title
    ) SELECT
        t.id,
        @language_code,
        @title
    FROM t RETURNING *
)
SELECT 
    t.id,
    t.type,
    tt.title
    FROM t,tt;

-- name: UpsertTag :one
WITH t AS (
    INSERT INTO tag (
        type
    ) VALUES (
        @type
    )
    ON CONFLICT (id)
    DO UPDATE SET type = @type
    RETURNING *
),
tt AS (
    INSERT INTO tag_t (
        tag_id,
        language_code,
        title
    ) SELECT
        t.id,
        'no',
        @title
    FROM t
    ON CONFLICT (tag_id,language_code)
    DO UPDATE SET title = @title
    RETURNING *
)
SELECT 
    t.id,
    t.type,
    tt.title
    FROM t,tt;