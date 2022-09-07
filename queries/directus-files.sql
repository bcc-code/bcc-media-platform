-- name: getFiles :many
SELECT * FROM directus_files WHERE id = ANY($1::uuid[]);
