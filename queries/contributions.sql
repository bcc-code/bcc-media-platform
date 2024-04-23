
-- name: getContributionTypes :many
SELECT code,
COALESCE((SELECT json_object_agg(ts.languages_code, ts.title)
                 FROM contributiontypes_translations ts
                 WHERE ts.contributiontypes_code = code), '{}')::json AS title
FROM contributiontypes
where code = ANY (@codes::string[]);

-- name: getContributionTypesForPersons :many
SELECT type, person_id::uuid, count(*) as count
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