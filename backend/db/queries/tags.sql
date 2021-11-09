-- name: GetTag :one
SELECT * FROM tag
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