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
         JOIN mediaitems_view mi ON mi.id = s.mediaitem_id
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
         JOIN mediaitems_view mi ON mi.id = s.mediaitem_id
WHERE s.mediaitem_id = @id::uuid;
