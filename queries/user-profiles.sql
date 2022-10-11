-- name: getProfiles :many
SELECT *
FROM users.profiles
WHERE user_id = ANY ($1::varchar[]);

-- name: saveProfile :exec
INSERT INTO users.profiles (id, user_id, name)
VALUES ($1::uuid, $2::varchar, $3::varchar)
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name ;
