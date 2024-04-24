
-- name: getContributionCountByType :many
SELECT type, count(*) as count
FROM contributions
WHERE id = ANY (@ids::int[])
group by type;


-- name: getContributionIDsForPersonsWithRoles :many
-- name: getContributionIDsForPersonsWithRoles :many
WITH RelevantContributions AS (
  SELECT
    c.id,
    c.person_id::uuid AS parent_id,
    COALESCE(mc.mediaitems_id, tm.mediaitem_id) AS mediaitem_id
  FROM 
    public.contributions c
    LEFT JOIN public.mediaitems_contributions mc ON c.id = mc.contributions_id
    LEFT JOIN public.timedmetadata_contributions tmc ON c.id = tmc.contributions_id
    LEFT JOIN public.timedmetadata tm ON tm.id = tmc.timedmetadata_id
  WHERE 
    c.person_id = ANY (@person_ids::uuid[])
)
SELECT
  rc.id,
  rc.parent_id
FROM 
  RelevantContributions rc
  JOIN public.mediaitems m ON rc.mediaitem_id = m.id
  JOIN public.episode_availability access ON access.id = m.primary_episode_id
  JOIN public.episode_roles roles ON roles.id = m.primary_episode_id
WHERE 
  access.published
  AND access.available_to > now()
  AND (
    (roles.roles && @roles::varchar[] AND access.available_from < now()) OR
    (roles.roles_earlyaccess && @roles::varchar[])
  )
ORDER BY 
  m.published_at DESC;


-- name: getContributionItems :many
SELECT
  c.id,
  COALESCE(tmc.timedmetadata_id::text, m.primary_episode_id::text, '')::text AS item_id,
  CASE
    WHEN tmc.timedmetadata_id IS NOT NULL THEN 'chapter'
    WHEN m.primary_episode_id IS NOT NULL THEN 'episode'
    ELSE ''
  END AS item_type,
  c.type,
  c.person_id
FROM contributions c
LEFT JOIN public.mediaitems_contributions mc ON c.id = mc.contributions_id
LEFT JOIN public.timedmetadata_contributions tmc ON c.id = tmc.contributions_id
LEFT JOIN public.timedmetadata tm ON tmc.timedmetadata_id = tm.id
LEFT JOIN public.mediaitems m ON mc.mediaitems_id = m.id OR tm.mediaitem_id = m.id
WHERE c.id = ANY (@ids::int[])
  AND (mc.mediaitems_id IS NOT NULL OR tmc.timedmetadata_id IS NOT NULL)
order by m.published_at desc;