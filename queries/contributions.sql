
-- name: getContributionIDsForPersonsWithRoles :many
WITH RelevantContributions AS (
  SELECT
    m.primary_episode_id::text as item_id,
    c.type,
    c.person_id,
    'episode' as item_type,
    m.id as mediaitem_id
  FROM
    public.mediaitems m
  INNER JOIN contributions c ON c.mediaitem_id = m.primary_episode_id
    and c.person_id = ANY (@person_ids::uuid[])
    and m.primary_episode_id is not null
  UNION
  ALL
  SELECT
    tm.id::text as item_id,
    c.type,
    c.person_id,
    'chapter' as item_type,
    m.id as mediaitem_id
  FROM timedmetadata tm
  INNER JOIN mediaitems m ON
    (m.timedmetadata_from_asset AND tm.asset_id = m.asset_id)
    OR (NOT m.timedmetadata_from_asset AND tm.mediaitem_id = m.id)
  INNER JOIN contributions c ON c.timedmetadata_id = tm.id
  and c.person_id = ANY (@person_ids::uuid[])
)
SELECT
  rc.type,
  rc.person_id,
  rc.item_type,
  rc.item_id
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