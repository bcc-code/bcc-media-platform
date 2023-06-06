-- name: setDeviceToken :exec
INSERT INTO users.devices (token, languages, profile_id, updated_at, name)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (token, profile_id) DO UPDATE SET updated_at = EXCLUDED.updated_at,
                                              name       = EXCLUDED.name,
                                              languages  = EXCLUDED.languages;

-- name: getDevicesForProfiles :many
SELECT *
FROM users.devices d
WHERE d.profile_id = ANY ($1::uuid[])
  AND d.updated_at > (NOW() - interval '2 month')
ORDER BY updated_at DESC;

-- name: listDevices :many
SELECT *
FROM users.devices d
WHERE d.updated_at > (NOW() - interval '2 month')
ORDER BY updated_at DESC;

-- name: DeleteDevices :exec
DELETE
FROM users.devices d
WHERE d.token = ANY (@tokens::varchar[]);
