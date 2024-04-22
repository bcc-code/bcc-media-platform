
-- name: getContributionTypesForPersons :many
SELECT count(*), type, person_id::uuid
FROM contributions
WHERE person_id = ANY (@person_ids::uuid[])
group by type, person_id;

-- name: getContributionIDsForPersons :many
SELECT id, person_id::uuid as parent_id
FROM contributions
WHERE person_id = ANY (@person_ids::uuid[]);

-- name: getContributionItems :many
SELECT
  c.id,
  COALESCE(mc.mediaitems_id, tmc.timedmetadata_id) AS item_id,
  CASE
    WHEN mc.mediaitems_id IS NOT NULL THEN 'mediaitem'
    WHEN tmc.timedmetadata_id IS NOT NULL THEN 'timedmetadata'
    ELSE ''
  END AS item_type,
  c.type,
  c.person_id
FROM contributions c
LEFT JOIN public.mediaitems_contributions mc ON c.id = mc.contributions_id
LEFT JOIN public.timedmetadata_contributions tmc ON c.id = tmc.contributions_id
WHERE c.id = ANY (@ids::int[])
  AND (mc.mediaitems_id IS NOT NULL OR tmc.timedmetadata_id IS NOT NULL);