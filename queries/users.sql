-- name: GetRolesByEmail :one
SELECT array_agg(code)::text[] as groups
FROM usergroups
WHERE $1::text = ANY (string_to_array(emails, E'\n'));

-- name: GetRoles :many
SELECT code, explicitly_available, string_to_array(emails, E'\n')::text[] as emails
FROM usergroups;

-- name: GetRolesWithCode :many
SELECT code, explicitly_available, string_to_array(emails, E'\n')::text[] as emails
FROM usergroups
WHERE code = ANY ($1::varchar[]);

-- name: getUsers :many
SELECT u.id,
       u.email,
       u.email_verified,
       u.display_name,
       u.age,
       u.age_group,
       u.church_ids::int[] as church_ids,
       u.active_bcc,
       u.first_name,
       u.gender,
       u.roles::varchar[]  as roles
FROM users.users u
WHERE u.id = ANY ($1::varchar[]);

-- name: UpsertUser :exec
INSERT INTO users.users (id, email, email_verified, first_name, display_name, age, church_ids, active_bcc, roles,
                         age_group, gender, updated_at)
VALUES (@id, @email, @email_verified, @first_name, @display_name, @age, @church_ids::int[], @active_bcc,
        @roles::varchar[],
        @age_group, @gender, NOW())
ON CONFLICT (id) DO UPDATE SET email          = excluded.email,
                               email_verified = excluded.email_verified,
                               display_name   = excluded.display_name,
                               age            = excluded.age,
                               church_ids     = excluded.church_ids,
                               active_bcc     = excluded.active_bcc,
                               roles          = excluded.roles,
                               age_group      = excluded.age_group,
                               gender         = excluded.gender,
                               updated_at     = NOW();

-- name: GetUserIDsWithRoles :many
SELECT id FROM users.users WHERE roles && @roles::varchar[];
