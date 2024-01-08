-- name: setDeviceToken :exec
INSERT INTO users.devices (token, languages, profile_id, updated_at, name)
VALUES (@token::varchar, @languages::varchar[], @profile_id, @updated_at, @name)
ON CONFLICT (token, profile_id) DO UPDATE SET updated_at = EXCLUDED.updated_at,
                                              name       = EXCLUDED.name,
                                              languages  = EXCLUDED.languages;

-- name: getDevicesForProfiles :many
SELECT d.token, d.profile_id, d.updated_at, d.name, d.languages::varchar[] as languages
FROM users.devices d
WHERE d.profile_id = ANY ($1::uuid[])
  AND d.updated_at > (NOW() - interval '6 months')
ORDER BY updated_at DESC;

-- name: listDevices :many
SELECT d.token, d.profile_id, d.updated_at, d.name, d.languages::varchar[] as languages
FROM users.devices d
WHERE d.updated_at > (NOW() - interval '6 months')
ORDER BY updated_at DESC;

-- name: ListDevicesInApplicationGroup :many
SELECT d.token, d.profile_id, d.updated_at, d.name, d.languages::varchar[] as languages
FROM users.devices d
         JOIN users.profiles p ON p.id = d.profile_id
WHERE p.applicationgroup_id = @group_id::uuid;

-- name: DeleteDevices :exec
DELETE
FROM users.devices d
WHERE d.token = ANY (@tokens::varchar[]);
