-- name: GetRolesByEmail :one
SELECT array_agg(code)::text[] as groups
FROM usergroups
WHERE $1::text = ANY (string_to_array(emails, E'\n'));

-- name: GetRoles :many
SELECT code, string_to_array(emails, E'\n')::text[] as emails
FROM usergroups;

-- name: GetRolesWithCode :many
SELECT code, string_to_array(emails, E'\n')::text[] as emails
FROM usergroups
WHERE code = ANY ($1::varchar[]);

-- name: getUsers :many
SELECT u.id,
       u.email,
       u.display_name,
       u.age,
       u.age_group,
       u.church_ids::int[] as church_ids,
       u.active_bcc,
       u.roles::varchar[]  as roles
FROM users.users u
WHERE u.id = ANY ($1::varchar[]);

-- name: UpsertUser :exec
INSERT INTO users.users (id, email, display_name, age, church_ids, active_bcc, roles, age_group)
VALUES ($1, $2, $3, $4, @church_ids::int[], $5, @roles::varchar[], $6)
ON CONFLICT (id) DO UPDATE SET email        = excluded.email,
                               display_name = excluded.display_name,
                               age          = excluded.age,
                               church_ids   = excluded.church_ids,
                               active_bcc   = excluded.active_bcc,
                               roles        = excluded.roles,
                               age_group    = excluded.age_group;
