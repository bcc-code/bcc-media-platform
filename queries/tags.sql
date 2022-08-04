-- name: ListTags :many
SELECT * FROM tags;

-- name: GetTags :many
SELECT * FROM tags WHERE id = ANY($1::int[]);
