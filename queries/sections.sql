-- name: getSections :many
WITH t AS (SELECT ts.sections_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM sections_translations ts
           GROUP BY ts.sections_id)
SELECT s.id,
       p.id::int                    AS page_id,
       s.style,
       s.size,
       s.grid_size,
       s.sort,
       s.status::text = 'published'::text AS published,
       s.collection_id,
       t.title,
       t.description
FROM sections s
         JOIN pages p ON s.page_id = p.id
         LEFT JOIN t ON s.id = t.sections_id
WHERE s.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published';

-- name: getSectionIDsForPages :many
SELECT s.id::int       AS id,
       p.id::int AS page_id
FROM sections s
         JOIN pages p ON s.page_id = p.id
WHERE p.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published'
ORDER BY s.sort;

-- name: getPermissionsForSections :many
WITH u AS (SELECT ug.sections_id,
                  array_agg(ug.usergroups_code) AS roles
           FROM sections_usergroups ug
           GROUP BY ug.sections_id)
SELECT s.id,
       u.roles::varchar[] AS roles
FROM sections s
         JOIN pages p ON s.page_id = p.id
         LEFT JOIN u ON u.sections_id = s.id
WHERE s.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published';

