-- name: GetUserIDByEmail :one
SELECT id FROM directus_users WHERE email = $1;

-- name: GetDirectusUserByID :one
SELECT u.id, u.email, u.first_name, u.last_name, u.role, u.status, u.avatar,
       r.name AS role_name
FROM directus_users u
         LEFT JOIN directus_roles r ON r.id = u.role
WHERE u.id = $1;
