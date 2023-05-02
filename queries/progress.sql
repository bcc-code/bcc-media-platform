-- name: getProgressForProfile :many
SELECT p.episode_id,
       p.show_id,
       p.progress,
       p.duration,
       p.watched,
       p.updated_at,
       p.watched_at,
       p.context
FROM "users"."progress" p
WHERE p.profile_id = $1::uuid
  AND p.episode_id = ANY ($2::int[])
ORDER BY watched, p.updated_at DESC;

-- name: saveProgress :exec
INSERT INTO "users"."progress" (profile_id, episode_id, show_id, progress, duration, watched, watched_at, updated_at,
                                context)
VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), $8)
ON CONFLICT (profile_id, episode_id) DO UPDATE SET progress   = EXCLUDED.progress,
                                                   show_id    = EXCLUDED.show_id,
                                                   updated_at = NOW(),
                                                   watched    = EXCLUDED.watched,
                                                   watched_at = EXCLUDED.watched_at,
                                                   duration   = EXCLUDED.duration,
                                                   context    = EXCLUDED.context;

-- name: deleteProgress :exec
UPDATE "users"."progress" p
SET progress   = 0,
    updated_at = NOW()
WHERE p.profile_id = $1
  AND p.episode_id = $2;

-- name: getEpisodeIDsWithProgress :many
WITH uniques AS (SELECT DISTINCT ON (p.show_id, p.profile_id) p.show_id, p.profile_id, p.episode_id
                 FROM users.progress p
                 WHERE p.show_id IS NOT NULL
                   AND p.profile_id = ANY (@profile_ids::uuid[])
                 ORDER BY p.show_id, p.profile_id, p.updated_at DESC)
SELECT p.episode_id, p.profile_id, p.show_id, p.progress, p.duration
FROM users.progress p
         LEFT JOIN uniques u ON u.show_id = p.show_id AND u.profile_id = p.profile_id
WHERE p.profile_id = ANY (@profile_ids::uuid[])
  AND (u IS NULL OR u.episode_id = p.episode_id)
  AND p.progress > 10
  AND p.duration > 20
  AND ((p.progress::float / p.duration) > 0.8) != true
ORDER BY p.updated_at DESC;

-- name: getDefaultEpisodeIDForSeasonIDs :many
SELECT DISTINCT ON (ep.season_id) p.episode_id as id, ep.season_id::int as parent_id
FROM users.progress p
         JOIN episodes ep ON ep.id = p.episode_id
WHERE p.profile_id = @profile_id
  AND ep.status = 'published'
  AND ep.season_id = ANY (@season_ids::int[])
ORDER BY ep.season_id, p.updated_at DESC;

-- name: getDefaultEpisodeIDForShowIDs :many
SELECT DISTINCT ON (p.show_id) p.episode_id as id, p.show_id::int as parent_id
FROM users.progress p
         JOIN episodes ep ON ep.id = p.episode_id
WHERE p.profile_id = @profile_id
  AND ep.status = 'published'
  AND p.show_id = ANY (@show_ids::int[])
ORDER BY p.show_id, p.updated_at DESC;
