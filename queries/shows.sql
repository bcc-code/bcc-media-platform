-- name: listShows :many
WITH ts AS (SELECT shows_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM shows_translations
            GROUP BY shows_id),
     tags AS (SELECT shows_id,
                     array_agg(tags_id) AS tags
              FROM shows_tags
              GROUP BY shows_id),
     images AS (WITH images AS (SELECT show_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT show_id, json_agg(images) as json
                FROM images
                GROUP BY show_id)
SELECT sh.id,
       sh.legacy_id,
       sh.type,
       fs.filename_disk            as image_file_name,
       tags.tags::int[]            AS tag_ids,
       COALESCE(images.json, '[]') as images,
       ts.title,
       ts.description
FROM shows sh
         LEFT JOIN tags ON tags.shows_id = sh.id
         LEFT JOIN ts ON sh.id = ts.shows_id
         LEFT JOIN images ON sh.id = images.show_id
         LEFT JOIN directus_files fs ON fs.id = sh.image_file_id;


-- name: getShows :many
WITH ts AS (SELECT shows_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM shows_translations
            GROUP BY shows_id),
     tags AS (SELECT shows_id,
                     array_agg(tags_id) AS tags
              FROM shows_tags
              GROUP BY shows_id),
     images AS (WITH images AS (SELECT show_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT show_id, json_agg(images) as json
                FROM images
                GROUP BY show_id)
SELECT sh.id,
       sh.legacy_id,
       sh.type,
       fs.filename_disk            as image_file_name,
       tags.tags::int[]            AS tag_ids,
       COALESCE(images.json, '[]') as images,
       ts.title,
       ts.description
FROM shows sh
         LEFT JOIN tags ON tags.shows_id = sh.id
         LEFT JOIN ts ON sh.id = ts.shows_id
         LEFT JOIN images ON sh.id = images.show_id
         LEFT JOIN directus_files fs ON fs.id = sh.image_file_id
WHERE sh.id = ANY ($1::int[]);

-- name: getShowIDsWithRoles :many
SELECT sh.id
FROM shows sh
         LEFT JOIN show_availability access ON access.id = sh.id
         LEFT JOIN show_roles roles ON roles.id = sh.id
WHERE sh.id = ANY ($1::int[])
  AND access.published
  AND access.available_to > now()
  AND (
        (roles.roles && $2::varchar[] AND access.available_from < now()) OR
        (roles.roles_earlyaccess && $2::varchar[])
    );

-- name: getPermissionsForShows :many
SELECT sh.id,
       access.published::boolean          AS published,
       access.available_from::timestamp   AS available_from,
       access.available_to::timestamp     AS available_to,
       roles.roles::varchar[]             AS usergroups,
       roles.roles_download::varchar[]    AS usergroups_downloads,
       roles.roles_earlyaccess::varchar[] AS usergroups_earlyaccess
FROM shows sh
         LEFT JOIN show_availability access ON access.id = sh.id
         LEFT JOIN show_roles roles ON roles.id = sh.id
WHERE sh.id = ANY ($1::int[]);
