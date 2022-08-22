-- name: getPages :many
WITH t AS (SELECT ts.pages_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM pages_translations ts
           GROUP BY ts.pages_id)
SELECT p.id::int                 AS id,
       p.code::varchar           AS code,
       p.status = 'published'    AS published,
       t.title,
       t.description
FROM pages p
         LEFT JOIN t ON t.pages_id = p.id
WHERE p.id = ANY ($1::int[])
  AND p.status = 'published';

-- name: listPages :many
WITH t AS (SELECT ts.pages_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM pages_translations ts
           GROUP BY ts.pages_id)
SELECT p.id::int                 AS id,
       p.code::varchar           AS code,
       p.status = 'published'    AS published,
       t.title,
       t.description
FROM pages p
         LEFT JOIN t ON t.pages_id = p.id
WHERE p.status = 'published';

-- name: getPermissionsForPages :many
WITH r AS (SELECT id                                                   AS page_id,
                  (SELECT array_agg(DISTINCT eu.usergroups_code) AS array_agg
                   FROM sections_usergroups eu
                   WHERE (eu.sections_id IN (SELECT e.id
                                             FROM episodes e
                                             WHERE e.season_id = id))) AS roles
           FROM pages)
SELECT p.id::int              AS id,
       p.status = 'published' AS published,
       roles.roles::varchar[] AS roles
FROM pages p
         LEFT JOIN r roles ON roles.page_id = p.id
WHERE p.id = ANY ($1::int[])
  AND p.status = 'published';

-- name: getPageIDsForCodes :many
SELECT p.id, p.code
FROM pages p
WHERE p.code = ANY ($1::varchar[]);
