-- name: setDeviceToken :exec
INSERT INTO users.devices (token, languages, profile_id, updated_at, name, application_group_id, os, app_build_number)
VALUES (@token::varchar, @languages::varchar[], @profile_id, @updated_at, @name, @application_group_id, @os, @app_version)
ON CONFLICT (token, application_group_id) DO UPDATE SET updated_at = EXCLUDED.updated_at,
                                              name       = EXCLUDED.name,
                                              languages  = EXCLUDED.languages,
                                              application_group_id = EXCLUDED.application_group_id,
                                              os = EXCLUDED.os,
                                              app_build_number = EXCLUDED.app_build_number;

-- name: getDevicesForProfiles :many
SELECT d.token, d.profile_id, d.updated_at, d.name, d.languages::varchar[] as languages, d.application_group_id, d.os, d.app_build_number
FROM users.devices d
WHERE d.profile_id = ANY ($1::uuid[])
  AND d.updated_at > (NOW() - interval '6 months')
ORDER BY updated_at DESC;

-- name: listDevicesForRoles :many
SELECT
    d.token,
    d.profile_id,
    d.updated_at,
    d.name,
    d.languages::varchar[] AS languages,
    d.application_group_id,
    d.os,
    d.app_build_number
FROM users.devices d
         LEFT JOIN users.profiles p ON d.profile_id = p.id
         LEFT JOIN users.users u ON p.user_id = u.id
WHERE
    d.application_group_id = @appgroupid::uuid
  AND (
    (u.roles && @roles::varchar[] AND d.profile_id IS NOT NULL)
        OR ('public' = ANY(@roles::varchar[]) AND d.profile_id IS NULL)
    )
  AND d.updated_at > (NOW() - INTERVAL '6 months')
ORDER BY d.updated_at DESC;

-- name: listDevices :many
SELECT d.token, d.profile_id,
       d.updated_at, d.name,
       d.languages::varchar[] as languages, d.application_group_id,
       d.os, d.app_build_number
FROM users.devices d
WHERE d.updated_at > (NOW() - interval '6 months')
ORDER BY updated_at DESC;

-- name: ListDevicesInApplicationGroup :many
SELECT d.token,
       d.profile_id,
       d.updated_at,
       d.name,
       d.languages::varchar[] as languages,
       d.application_group_id,
       d.os,
       d.app_build_number
FROM users.devices d
WHERE d.application_group_id = @group_id::uuid;

-- name: DeleteDevices :exec
DELETE
FROM users.devices d
WHERE d.token = ANY (@tokens::varchar[]);
