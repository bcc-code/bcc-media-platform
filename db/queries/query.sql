-- name: GetMedia :one
SELECT * FROM media
WHERE id = $1 LIMIT 1;

-- name: GetAllMedias :many
SELECT * FROM media
ORDER BY name;

-- name: GetMediasWithFilter :many
SELECT * FROM media

ORDER BY name;