-- name: GetFile :one
SELECT * FROM directus_files WHERE ID = $1;

-- name: GetFilesByIds :many
SELECT * FROM directus_files WHERE id = ANY($1::uuid[]);