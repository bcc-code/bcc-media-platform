-- name: setDeviceToken :exec
INSERT INTO users.devices (token, languages, profile_id, updated_at, name)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (token, profile_id) DO UPDATE SET updated_at = EXCLUDED.updated_at, name = EXCLUDED.name, languages = EXCLUDED.languages;

-- name: getDevicesForProfiles :many
SELECT * FROM users.devices WHERE profile_id = ANY($1::uuid[]);

-- name: listDevices :many
SELECT * FROM users.devices;
