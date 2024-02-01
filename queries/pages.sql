-- name: getPages :many
WITH t AS (SELECT ts.pages_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM pages_translations ts
           GROUP BY ts.pages_id),
     images AS (WITH images AS (SELECT page_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT page_id, json_agg(images) as json
                FROM images
                GROUP BY page_id)
SELECT p.id::int                AS id,
       p.code::varchar          AS code,
       p.status = 'published'   AS published,
       COALESCE(img.json, '[]') as images,
       t.title,
       t.description
FROM pages p
         LEFT JOIN t ON t.pages_id = p.id
         LEFT JOIN images img ON img.page_id = p.id
WHERE p.id = ANY ($1::int[])
  AND p.status = 'published';

-- name: listPages :many
WITH t AS (SELECT ts.pages_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM pages_translations ts
           GROUP BY ts.pages_id),
     images AS (WITH images AS (SELECT page_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT page_id, json_agg(images) as json
                FROM images
                GROUP BY page_id)
SELECT p.id::int                AS id,
       p.code::varchar          AS code,
       p.status = 'published'   AS published,
       COALESCE(img.json, '[]') as images,
       t.title,
       t.description
FROM pages p
         LEFT JOIN t ON t.pages_id = p.id
         LEFT JOIN images img ON img.page_id = p.id
WHERE p.status = 'published';

-- name: getPermissionsForPages :many
SELECT p.id::int              AS id,
       p.status = 'published' AS published,
       roles.roles::varchar[] AS roles
FROM pages p
         LEFT JOIN (SELECT s.page_id, array_agg(DISTINCT (su.usergroups_code)) roles
                    FROM sections_usergroups su
                             JOIN sections s ON s.id = su.sections_id
                    GROUP BY s.page_id) roles ON roles.page_id = p.id
WHERE p.status = 'published'
  AND p.id = ANY (@ids::int[]);

-- name: getPageIDsForCodes :many
SELECT p.id, p.code
FROM pages p
WHERE p.code = ANY ($1::varchar[]);
