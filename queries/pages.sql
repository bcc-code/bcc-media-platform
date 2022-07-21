-- name: GetPages :many
SELECT * FROM pages WHERE code = ANY ($1::varchar[]);

-- name: ListPages :many
SELECT * FROM pages;