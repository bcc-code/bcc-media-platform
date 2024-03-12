-- name: listSeasons :many
WITH ts AS (SELECT seasons_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM seasons_translations
            GROUP BY seasons_id),
     tags AS (SELECT seasons_id,
                     array_agg(tags_id) AS tags
              FROM seasons_tags
              GROUP BY seasons_id),

     images AS (WITH images AS (SELECT season_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT season_id, json_agg(images) as json
                FROM images
                GROUP BY season_id)
SELECT s.id,
       s.legacy_id,
       s.status,
       s.season_number,
       fs.filename_disk                as image_file_name,
       s.show_id,
       s.public_title,
       COALESCE(s.agerating_code, 'A') as agerating,
       tags.tags::int[]                AS tag_ids,
       COALESCE(img.json, '[]')        as images,
       ts.title,
       ts.description
FROM seasons s
         LEFT JOIN ts ON s.id = ts.seasons_id
         LEFT JOIN tags ON tags.seasons_id = s.id
         LEFT JOIN images img ON img.season_id = s.id
         JOIN shows sh ON s.show_id = sh.id
         LEFT JOIN directus_files fs ON fs.id = COALESCE(s.image_file_id, sh.image_file_id);

-- name: getSeasons :many
WITH ts AS (SELECT seasons_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM seasons_translations
            GROUP BY seasons_id),
     tags AS (SELECT seasons_id,
                     array_agg(tags_id) AS tags
              FROM seasons_tags
              GROUP BY seasons_id),

     images AS (WITH images AS (SELECT season_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT season_id, json_agg(images) as json
                FROM images
                GROUP BY season_id)
SELECT s.id,
       s.legacy_id,
       s.status,
       s.season_number,
       fs.filename_disk                as image_file_name,
       s.show_id,
       s.public_title,
       COALESCE(s.agerating_code, 'A') as agerating,
       tags.tags::int[]                AS tag_ids,
       COALESCE(img.json, '[]')        as images,
       ts.title,
       ts.description
FROM seasons s
         LEFT JOIN ts ON s.id = ts.seasons_id
         LEFT JOIN tags ON tags.seasons_id = s.id
         LEFT JOIN images img ON img.season_id = s.id
         JOIN shows sh ON s.show_id = sh.id
         LEFT JOIN directus_files fs ON fs.id = COALESCE(s.image_file_id, sh.image_file_id)
WHERE s.id = ANY ($1::int[]);

-- name: getSeasonIDsForShows :many
SELECT s.id, s.show_id
FROM seasons s
WHERE s.show_id = ANY ($1::int[])
ORDER BY s.season_number;

-- name: getSeasonIDsForShowsWithRoles :many
SELECT se.id,
       se.show_id
FROM seasons se
         LEFT JOIN season_availability access ON access.id = se.id
         LEFT JOIN season_roles roles ON roles.id = se.id
WHERE se.show_id = ANY ($1::int[])
  AND access.published
  AND access.available_to > now()
  AND (
        (roles.roles && $2::varchar[] AND access.available_from < now()) OR
        (roles.roles_earlyaccess && $2::varchar[])
    )
ORDER BY se.season_number;

-- name: getSeasonIDsWithRoles :many
SELECT se.id
FROM seasons se
         LEFT JOIN season_availability access ON access.id = se.id
         LEFT JOIN season_roles roles ON roles.id = se.id
WHERE se.id = ANY ($1::int[])
  AND access.published
  AND access.available_to > now()
  AND (
        (roles.roles && $2::varchar[] AND access.available_from < now()) OR
        (roles.roles_earlyaccess && $2::varchar[])
    );

-- name: getPermissionsForSeasons :many
SELECT se.id,
       se.status = 'unlisted'             AS unlisted,
       access.published::bool             AS published,
       access.available_from::timestamp   AS available_from,
       access.available_to::timestamp     AS available_to,
       roles.roles::varchar[]             AS usergroups,
       roles.roles_download::varchar[]    AS usergroups_downloads,
       roles.roles_earlyaccess::varchar[] AS usergroups_earlyaccess
FROM seasons se
         LEFT JOIN season_availability access ON access.id = se.id
         LEFT JOIN season_roles roles ON roles.id = se.id
WHERE se.id = ANY ($1::int[]);
