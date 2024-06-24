
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
    and c.person_id = ANY (@person_ids::uuid[])
    and m.primary_episode_id is not null
  UNION
  ALL
  SELECT
    tm.id::text as item_id,
    c.type,
    c.person_id,
    'chapter' as item_type,
    m.id as mediaitem_id,
    COALESCE(tm.content_type, m.content_type)
  FROM timedmetadata tm
  INNER JOIN mediaitems m ON
    (m.timedmetadata_from_asset AND tm.asset_id = m.asset_id)
    OR (NOT m.timedmetadata_from_asset AND tm.mediaitem_id = m.id)
  INNER JOIN contributions c ON c.timedmetadata_id = tm.id
  and c.person_id = ANY (@person_ids::uuid[])
  WHERE tm.status = 'published'
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
INSERT INTO "public"."contributions" (person_id, "type", mediaitem_id, timedmetadata_id)
VALUES (@person_id::uuid, @type, sqlc.narg('mediaitem_id')::uuid, sqlc.narg('timedmetadata_id')::uuid);

-- name: GetContributionsForPerson :many
SELECT * FROM "public"."contributions" WHERE person_id = @person_id::uuid;
