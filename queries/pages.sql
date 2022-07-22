-- name: GetPages :many
SELECT * FROM pages_expanded WHERE id = ANY ($1::int[]);

-- name: ListPages :many
SELECT * FROM pages_expanded;