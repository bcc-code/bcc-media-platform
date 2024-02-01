-- name: getSections :many
WITH t AS (SELECT ts.sections_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM sections_translations ts
           GROUP BY ts.sections_id)
SELECT s.id,
       p.id::int                                AS page_id,
       s.type,
       s.style,
       s.size,
       s.grid_size,
       s.show_title,
       s.sort,
       s.status::text = 'published'::text       AS published,
       s.collection_id,
       s.message_id,
       s.embed_url,
       s.embed_aspect_ratio,
       s.embed_height,
       s.needs_authentication,
       s.use_context,
       s.prepend_live_element,
       c.advanced_type,
       COALESCE(s.secondary_titles, true)::bool as secondary_titles,
       t.title,
       t.description
FROM sections s
         JOIN pages p ON s.page_id = p.id
         LEFT JOIN collections c ON c.id = s.collection_id
         LEFT JOIN t ON s.id = t.sections_id
WHERE s.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published';

-- name: getSectionIDsForPages :many
SELECT s.id::int AS id,
       p.id::int AS page_id
FROM sections s
         JOIN pages p ON s.page_id = p.id
WHERE p.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published'
ORDER BY s.sort;

-- name: getSectionIDsForPagesWithRoles :many
WITH roles AS (SELECT s.id,
                      COALESCE((SELECT array_agg(DISTINCT seu.usergroups_code) AS code
                                FROM sections_usergroups seu
                                WHERE seu.sections_id = s.id), ARRAY []::character varying[]) AS roles
               FROM sections s)
SELECT s.id::int AS id,
       p.id::int AS page_id
FROM sections s
         JOIN pages p ON s.page_id = p.id
         JOIN roles r ON r.id = s.id
WHERE p.id = ANY ($1::int[])
  AND s.status = 'published'
  AND p.status = 'published'
  AND r.roles && $2::varchar[]
ORDER BY s.sort;

-- name: getPermissionsForSections :many
SELECT s.id::int              AS id,
       s.status = 'published' AS published,
       roles.roles::varchar[] AS roles
FROM sections s
         JOIN pages p ON p.id = s.page_id
         LEFT JOIN (SELECT su.sections_id, array_agg(DISTINCT (su.usergroups_code)) roles
                    FROM sections_usergroups su
                    GROUP BY su.sections_id) roles ON roles.sections_id = s.id
WHERE p.status = 'published'
  AND s.status = 'published'
  AND s.id = ANY (@ids::int[]);

-- name: getLinks :many
WITH ts AS (SELECT links_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM links_translations
            GROUP BY links_id),
     images AS (WITH images AS (SELECT link_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT link_id, json_agg(images) as json
                FROM images
                GROUP BY link_id)
SELECT ls.id,
       ls.url,
       COALESCE(images.json, '[]') as images,
       ls.type,
       ls.computeddatagroup_id,
       ts.title,
       ts.description
FROM links ls
         LEFT JOIN ts ON ls.id = ts.links_id
         LEFT JOIN images ON ls.id = images.link_id
WHERE ls.id = ANY ($1::int[])
  AND ls.status = 'published';
