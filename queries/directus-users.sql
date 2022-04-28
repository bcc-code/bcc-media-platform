-- name: GetUserIDByEmail :one
SELECT id FROM directus_users WHERE email = $1;
