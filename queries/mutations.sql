-- name: setDeviceToken :exec
INSERT INTO users.devices (token, profile_id, updated_at)
VALUES ($1::varchar, $2::uuid, now())
ON CONFLICT (token) DO UPDATE SET updated_at = EXCLUDED.updated_at;
