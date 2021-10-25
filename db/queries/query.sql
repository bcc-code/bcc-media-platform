-- name: GetMedia :one
SELECT * FROM media
WHERE id = $1 LIMIT 1;

-- name: GetMedias :many
SELECT * FROM media
ORDER BY name;