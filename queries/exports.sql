-- name: InsertExport :one
INSERT INTO users.exports (
    id,
    profile_id,
    user_groups,
    status,
    created_date,
    expiry_date,
    url
) VALUES (
    DEFAULT,
    @profile_id,
    @user_groups,
    DEFAULT,
    DEFAULT,
    NULL,
    DEFAULT
)
RETURNING *;

-- name: GetExportById :one
SELECT * FROM users.exports WHERE id = @id::uuid;

-- name: UpdateExportURL :exec
UPDATE users.exports
SET url = @url
WHERE id = @id::uuid;

-- name: UpdateExportStatus :exec
UPDATE users.exports
SET status = @status
WHERE id = @id::uuid;
