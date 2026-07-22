-- name: GetUserIDByEmail :one
SELECT id FROM directus_users WHERE email = $1;

-- name: GetDirectusUserByID :one
SELECT id, email, first_name, last_name, role, status
FROM directus_users
WHERE id = $1;
