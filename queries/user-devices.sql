-- name: setDeviceToken :exec
INSERT INTO users.devices (token, languages, profile_id, updated_at, name, application_group_id, os, app_build_number)
VALUES (@token::varchar, @languages::varchar[], @profile_id, @updated_at, @name, @application_group_id, @os, @app_build_number)
ON CONFLICT (token, application_group_id) DO UPDATE SET updated_at = EXCLUDED.updated_at,
                                              name       = EXCLUDED.name,
                                              languages  = EXCLUDED.languages,
                                              application_group_id = EXCLUDED.application_group_id,
                                              profile_id = EXCLUDED.profile_id,
                                              os = EXCLUDED.os,
                                              app_build_number = EXCLUDED.app_build_number;

-- name: getDevicesForProfiles :many
SELECT d.*
FROM users.devices d
WHERE d.profile_id = ANY ($1::uuid[])
  AND d.updated_at > (NOW() - interval '6 months')
ORDER BY updated_at DESC;

-- name: listDevicesForRoles :many
SELECT d.*
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
SELECT d.*
FROM users.devices d
WHERE d.updated_at > (NOW() - interval '6 months')
ORDER BY updated_at DESC;

-- name: ListDevicesInApplicationGroup :many
SELECT d.*
FROM users.devices d
WHERE d.application_group_id = @group_id::uuid;

-- name: DeleteDevices :exec
DELETE
FROM users.devices d
WHERE d.token = ANY (@tokens::varchar[]);

-- name: GetSegmentedDevicesForTarget :many
WITH t as (SELECT
               int4range(application_minimum_build_number, application_maximum_build_number, '[]') AS build_range,
               int4range(inactive_days_min, inactive_days_max, '[]') as inactive_range,
               device_os, languages, (SELECT array_agg(usergroups_code) FROM targets_usergroups WHERE targets_id = @target_id) usergroups
           FROM targets t
           WHERE t.id = @target_id)
SELECT d.* FROM users.devices d
                  CROSS JOIN t
                  LEFT JOIN users.profiles p ON d.profile_id = p.id
                  LEFT JOIN users.users u ON p.user_id = u.id
WHERE
    (
        (
            -- Filter by roles. If profile is not available, filter by public role
               u.roles && t.usergroups AND d.profile_id IS NOT NULL)
            OR ('public' = ANY(t.usergroups) AND d.profile_id IS NULL)
            OR t.usergroups IS NULL -- If no usergroups are specified, we send to everyone
        ) AND (
            -- Filter out stuff that has not been updated in the last 6 months
            d.updated_at > (NOW() - INTERVAL '6 months')

        -- OS filter. If no OS is specified, we don't filter
        AND (to_jsonb(d.os) <@ t.device_os OR jsonb_array_length(t.device_os) = 0)

        -- Build number filter. If the min and max are NULL then the filter == (-INF, +INF)
        AND (d.app_build_number <@ t.build_range OR t.build_range IS NULL)

        -- Inactive days. If the min and max are NULL then the filter == (-INF, +INF)
        AND (date_part('day', now() - d.updated_at)::int <@ t.inactive_range OR t.inactive_range IS NULL)

        -- Language filter. If languages are not specified, we don't filter
        AND (to_jsonb(d.languages) <@ t.languages OR jsonb_array_length(t.languages) = 0)

        -- Filter by application group, otherwise we sent all notifications to all apps
        AND d.application_group_id = @applicationgroup_id
    );
