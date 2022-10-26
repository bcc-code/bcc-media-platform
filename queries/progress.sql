-- name: getProgressForProfile :many
SELECT p.episode_id, p.show_id, p.progress, p.duration, COALESCE((p.progress::float / NULLIF(p.duration,0)) > 0.8, false)::bool AS watched
FROM "users"."progress" p
WHERE p.profile_id = $1::uuid
  AND p.episode_id = ANY ($2::int[])
ORDER BY watched, p.updated_at DESC;

-- name: saveProgress :exec
INSERT INTO "users"."progress" (profile_id, episode_id, show_id, progress, duration, updated_at)
VALUES ($1, $2, $3, $4, $5, NOW())
ON CONFLICT (profile_id, episode_id) DO UPDATE SET progress = EXCLUDED.progress,
                                                   duration = EXCLUDED.duration;

-- name: deleteProgress :exec
DELETE
FROM "users"."progress"
WHERE profile_id = $1::uuid
  AND episode_id = $2::int;
