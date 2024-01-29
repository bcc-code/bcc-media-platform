-- name: GetMediaItemByID :one
SELECT * FROM mediaitems WHERE id = @id::uuid;
