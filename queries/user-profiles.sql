-- name: getProfiles :many
SELECT p.id,
       p.user_id,
       p.name,
       p.applicationgroup_id AS application_group_id
FROM users.profiles p
WHERE applicationgroup_id = @applicationgroup_id::uuid
  AND user_id = ANY (@user_id::varchar[]);

-- name: saveProfile :exec
INSERT INTO users.profiles (id, user_id, name, applicationgroup_id)
VALUES (@id::uuid, @user_id::varchar, @name::varchar, @applicationgroup_id::uuid)
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
