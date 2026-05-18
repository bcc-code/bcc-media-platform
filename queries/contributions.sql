
-- name: getContributionIDsForPersonsWithRoles :many
WITH RelevantContributions AS (
  SELECT
    m.primary_episode_id::text as item_id,
    c.type,
    c.person_id,
    'episode' as item_type,
    m.id as mediaitem_id,
    m.content_type
  FROM
    public.mediaitems m
  INNER JOIN contributions c ON c.mediaitem_id = m.id
    AND c.person_id = ANY (@person_ids::uuid[])
    AND m.primary_episode_id IS NOT NULL

  UNION ALL

  -- timedmetadata_from_asset = true: join timedmetadata on asset_id
  SELECT
    tm.id::text as item_id,
    c.type,
    c.person_id,
    'chapter' as item_type,
    m.id as mediaitem_id,
    COALESCE(tm.content_type, m.content_type)
  FROM timedmetadata tm
  INNER JOIN mediaitems m ON tm.asset_id = m.asset_id
  INNER JOIN contributions c ON c.timedmetadata_id = tm.id
    AND c.person_id = ANY (@person_ids::uuid[])
  WHERE tm.status = 'published' AND m.timedmetadata_from_asset

  UNION ALL

  -- timedmetadata_from_asset = false: join timedmetadata on mediaitem_id
  SELECT
    tm.id::text as item_id,
    c.type,
    c.person_id,
    'chapter' as item_type,
    m.id as mediaitem_id,
    COALESCE(tm.content_type, m.content_type)
  FROM timedmetadata tm
  INNER JOIN mediaitems m ON tm.mediaitem_id = m.id
  INNER JOIN contributions c ON c.timedmetadata_id = tm.id
    AND c.person_id = ANY (@person_ids::uuid[])
  WHERE tm.status = 'published' AND NOT m.timedmetadata_from_asset
)
SELECT
  rc.type,
  rc.person_id,
  rc.item_type,
  rc.item_id,
  rc.mediaitem_id,
  COALESCE(rc.content_type, 'unknown')
FROM
  RelevantContributions rc
  JOIN public.mediaitems m ON rc.mediaitem_id = m.id
  JOIN public.episode_availability access ON access.id = m.primary_episode_id
  JOIN public.episode_roles roles ON roles.id = m.primary_episode_id
WHERE
  access.published
  AND (
    NOT @preferred_languages_only
     OR access.audio && @preferred_audio_languages::varchar[]
     OR access.subtitle && @preferred_subtitle_languages::varchar[]
  )
  AND access.available_to > now()
  AND (
    (
      roles.roles && @roles::varchar[]
      AND access.available_from < now()
    )
    OR (roles.roles_earlyaccess && @roles::varchar[])
  )
ORDER BY
  m.published_at DESC;

-- name: InsertContribution :exec
INSERT INTO "public"."contributions" (person_id, "type", mediaitem_id, timedmetadata_id, song_id)
VALUES (@person_id::uuid, @type, sqlc.narg('mediaitem_id')::uuid, sqlc.narg('timedmetadata_id')::uuid, sqlc.narg('song_id')::uuid);

-- name: getContributionsForSongs :many
SELECT DISTINCT c.song_id, c.person_id, c.type
FROM public.contributions c
WHERE c.song_id = ANY (@song_ids::uuid[]);

-- name: GetContributionsForPerson :many
SELECT * FROM "public"."contributions" WHERE person_id = @person_id::uuid;

-- name: GetContributionsForEpisode :many
-- The OR-join on m.timedmetadata_from_asset cannot use indexes; split into
-- two mutually exclusive UNION branches so each can be index-driven.
SELECT c.person_id, c.type
FROM public.contributions c
INNER JOIN public.mediaitems m ON c.mediaitem_id = m.id
WHERE m.primary_episode_id = @episode_id

UNION

SELECT c.person_id, c.type
FROM public.contributions c
INNER JOIN public.timedmetadata tm ON c.timedmetadata_id = tm.id
INNER JOIN public.mediaitems m ON tm.asset_id = m.asset_id
WHERE m.timedmetadata_from_asset AND m.primary_episode_id = @episode_id

UNION

SELECT c.person_id, c.type
FROM public.contributions c
INNER JOIN public.timedmetadata tm ON c.timedmetadata_id = tm.id
INNER JOIN public.mediaitems m ON tm.mediaitem_id = m.id
WHERE NOT m.timedmetadata_from_asset AND m.primary_episode_id = @episode_id;

-- name: getContributionsForEpisodes :many
-- Batched variant of GetContributionsForEpisode used by EpisodeContributionsLoader
-- to dedupe per-episode resolver calls into a single round trip.
SELECT m.primary_episode_id AS episode_id, c.person_id, c.type
FROM public.contributions c
INNER JOIN public.mediaitems m ON c.mediaitem_id = m.id
WHERE m.primary_episode_id = ANY (@episode_ids::int[])

UNION

SELECT m.primary_episode_id, c.person_id, c.type
FROM public.contributions c
INNER JOIN public.timedmetadata tm ON c.timedmetadata_id = tm.id
INNER JOIN public.mediaitems m ON tm.asset_id = m.asset_id
WHERE m.timedmetadata_from_asset AND m.primary_episode_id = ANY (@episode_ids::int[])

UNION

SELECT m.primary_episode_id, c.person_id, c.type
FROM public.contributions c
INNER JOIN public.timedmetadata tm ON c.timedmetadata_id = tm.id
INNER JOIN public.mediaitems m ON tm.mediaitem_id = m.id
WHERE NOT m.timedmetadata_from_asset AND m.primary_episode_id = ANY (@episode_ids::int[]);
