-- name: GetPages :many
SELECT * FROM pages WHERE id = ANY ($1::int[]);
