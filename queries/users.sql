-- name: GetRolesByEmail :one
SELECT array_agg(code)::text[] as groups FROM usergroups WHERE $1::text = ANY(string_to_array(emails, E'\n'));

-- name: GetRoles :many
SELECT code, string_to_array(emails, E'\n')::text[] as emails  FROM usergroups;
