-- name: getProgressForProfile :many
SELECT p.episode_id, p.show_id, p.progress, p.duration, p.watched, p.updated_at, p.watched_at
FROM "users"."progress" p
WHERE p.profile_id = $1::uuid
  AND p.episode_id = ANY ($2::int[])
ORDER BY watched, p.updated_at DESC;

-- name: saveProgress :exec
INSERT INTO "users"."progress" (profile_id, episode_id, show_id, progress, duration, watched, watched_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
ON CONFLICT (profile_id, episode_id) DO UPDATE SET progress   = EXCLUDED.progress,
                                                   show_id    = EXCLUDED.show_id,
                                                   updated_at = NOW(),
                                                   watched    = EXCLUDED.watched,
                                                   watched_at = EXCLUDED.watched_at,
                                                   duration   = EXCLUDED.duration;

-- name: deleteProgress :exec
UPDATE "users"."progress" p
SET progress   = 0,
    updated_at = NOW()
WHERE p.profile_id = $1
  AND p.episode_id = $2;

-- name: getEpisodeIDsWithProgress :many
SELECT p.episode_id, p.profile_id
FROM "users"."progress" p
WHERE p.profile_id = ANY ($1::uuid[])
  AND COALESCE((p.progress::float / COALESCE(NULLIF(p.duration, 0), 1)) > 0.8, false) != true
ORDER BY p.updated_at DESC;
