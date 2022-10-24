-- name: getProgressForProfile :many
SELECT episode_id, progress
FROM "users"."progress"
WHERE profile_id = $1::uuid
  AND episode_id = ANY ($2::int[]);
