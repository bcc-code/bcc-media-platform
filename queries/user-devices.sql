-- name: setDeviceToken :exec
INSERT INTO users.devices (token, profile_id, updated_at, name)
VALUES ($1::varchar, $2::uuid, $3::timestamp, $4::varchar)
ON CONFLICT (token, profile_id) DO UPDATE SET updated_at = EXCLUDED.updated_at, name = EXCLUDED.name;

-- name: getDevicesForProfiles :many
SELECT * FROM users.devices WHERE profile_id = ANY($1::uuid[]);
