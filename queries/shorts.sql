-- name: ListShortIDsForRoles :many
SELECT s.id
FROM shorts s
         JOIN (SELECT r.shorts_id, array_agg(r.usergroups_code) as roles FROM shorts_usergroups r GROUP BY r.shorts_id) r
              ON s.id = r.shorts_id
WHERE s.status = 'published'
  AND r.roles && @roles::varchar[];

-- name: getShorts :many
SELECT s.id,
       mi.id AS media_id,
       mi.asset_id,
       mi.title,
       mi.description,
       mi.original_title,
       mi.original_description,
       mi.images,
       mi.parent_episode_id,
       mi.parent_starts_at,
       mi.parent_ends_at
FROM shorts s
         JOIN mediaitems_view mi ON mi.id = s.mediaitem_id
WHERE s.id = ANY (@ids::uuid[]);

-- name: getMediaIDForShorts :many
SELECT sh.id, sh.mediaitem_id
FROM "public"."shorts" sh
WHERE sh.id = ANY (@ids::uuid[]);
