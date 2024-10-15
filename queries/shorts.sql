-- name: ListSegmentedShortIDsForRoles :many
SELECT concat(date_part('year', mi.published_at), '-', date_part('week', mi.published_at))::varchar as week,
       array_agg(s.id)::uuid[]                                                                      as ids
FROM shorts s
         JOIN mediaitems mi ON s.mediaitem_id = mi.id
         JOIN (SELECT r.shorts_id, array_agg(r.usergroups_code) as roles
               FROM shorts_usergroups r
               GROUP BY r.shorts_id) r
              ON s.id = r.shorts_id
WHERE s.status = 'published'
  AND r.roles && @roles::varchar[]
GROUP BY week
ORDER BY week DESC;

-- name: ListSegmentedShortIDsForRolesWithScores :many
SELECT s.id,
       -- We need a date and if we do not have a published_at date, we need to assume that the created date is when it was published
       EXTRACT(DAY FROM current_date - COALESCE(mi.published_at, mi.date_created))::int age_in_days,

       mi.parent_episode_id,

       -- For 10 days the shorts is boosted. It starts with a 5 points boost, and the boost "degrades" by 0.5
       -- points per day, reaching 0 boost on day 10. It stops there
    (((10 - LEAST(10, EXTRACT(DAY FROM current_date - COALESCE(mi.published_at, mi.date_created)))) * 0.5) + score)::float8 as final_score

FROM shorts s
         JOIN mediaitems mi ON s.mediaitem_id = mi.id
         JOIN (SELECT r.shorts_id, array_agg(r.usergroups_code) as roles
               FROM shorts_usergroups r
               GROUP BY r.shorts_id) r
              ON s.id = r.shorts_id
WHERE s.status = 'published'
  AND r.roles && @roles::varchar[]
ORDER BY final_score DESC;

-- name: getShorts :many
SELECT s.id,
       s.status,
       mi.id                                                AS media_id,
       mi.asset_id,
       mi.title,
       mi.description,
       mi.original_title,
       mi.original_description,
       mi.images,
       mi.parent_episode_id,
       mi.parent_starts_at,
       mi.parent_ends_at,
       mi.label,
       mi.tag_ids,
       GREATEST(s.date_updated, mi.date_updated)::timestamp AS date_updated
FROM shorts s
         JOIN mediaitems_view_v2 mi ON mi.id = s.mediaitem_id
WHERE s.id = ANY (@ids::uuid[]);

-- name: getMediaIDForShorts :many
SELECT sh.id, sh.mediaitem_id
FROM "public"."shorts" sh
WHERE sh.id = ANY (@ids::uuid[]);

-- name: getShortsByMediaItemID :many
SELECT s.id,
       s.status,
       mi.id                                                AS media_id,
       mi.asset_id,
       mi.title,
       mi.description,
       mi.original_title,
       mi.original_description,
       mi.images,
       mi.parent_episode_id,
       mi.parent_starts_at,
       mi.parent_ends_at,
       mi.label,
       GREATEST(s.date_updated, mi.date_updated)::timestamp AS date_updated
FROM shorts s
         JOIN mediaitems_view_v2 mi ON mi.id = s.mediaitem_id
WHERE s.mediaitem_id = @id::uuid;

-- name: UpdateShortsScore :exec
UPDATE shorts
SET score = @score::float8
WHERE id = @id::uuid;
