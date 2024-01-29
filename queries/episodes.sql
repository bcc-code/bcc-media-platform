-- name: listEpisodes :many
WITH ts AS (SELECT episodes_id,
                   json_object_agg(languages_code, title)             AS title,
                   json_object_agg(languages_code, description)       AS description,
                   json_object_agg(languages_code, extra_description) AS extra_description
            FROM episodes_translations
            GROUP BY episodes_id),
     tags AS (SELECT episodes_id,
                     array_agg(tags_id) AS tags
              FROM episodes_tags
              GROUP BY episodes_id),
     asset_ids AS (SELECT episodes_id,
                          json_object_agg(language, assets_id) AS ids
                   FROM episodes_assets
                   GROUP BY episodes_id),
     images AS (WITH images AS (SELECT episode_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id)
                SELECT episode_id, json_agg(images) as json
                FROM images
                GROUP BY episode_id)
SELECT e.id,
       e.uuid,
       e.status,
       e.legacy_id,
       e.legacy_program_id,
       e.asset_id,
       asset_ids.ids                                                           AS assets,
       e.episode_number,
       e.publish_date,
       e.production_date,
       e.public_title,
       s.episode_number_in_title                                               AS number_in_title,
       COALESCE(e.prevent_public_indexing, false)::bool                        as prevent_public_indexing,
       ea.available_from::timestamp without time zone                          AS available_from,
       ea.available_to::timestamp without time zone                            AS available_to,
       COALESCE(e.publish_date_in_title, false)::bool                          AS publish_date_in_title,
       fs.filename_disk                                                        as image_file_name,
       e.season_id,
       e.type,
       COALESCE(img.json, '[]')                                                as images,
       ts.title,
       ts.description,
       ts.extra_description,
       tags.tags::int[]                                                        AS tag_ids,
       assets.duration                                                         as duration,
       COALESCE(e.agerating_code, s.agerating_code, 'A')                       as agerating,
       audience,
       content_type,
       timedmetadata_from_asset,
       (SELECT array_agg(id ORDER BY seconds)
        FROM timedmetadata md
        WHERE (timedmetadata_from_asset AND md.asset_id = e.asset_id)
           OR (NOT timedmetadata_from_asset AND md.episode_id = e.id))::uuid[] AS timedmetadata_ids
FROM episodes e
         LEFT JOIN ts ON e.id = ts.episodes_id
         LEFT JOIN tags ON tags.episodes_id = e.id
         LEFT JOIN images img ON img.episode_id = e.id
         LEFT JOIN asset_ids ON asset_ids.episodes_id = e.id
         LEFT JOIN assets ON e.asset_id = assets.id
         LEFT JOIN seasons s ON e.season_id = s.id
         LEFT JOIN shows sh ON s.show_id = sh.id
         LEFT JOIN directus_files fs ON fs.id = COALESCE(e.image_file_id, s.image_file_id, sh.image_file_id)
         LEFT JOIN episode_availability ea on e.id = ea.id;

-- name: getEpisodes :many
WITH ts AS (SELECT episodes_id,
                   json_object_agg(languages_code, title)             AS title,
                   json_object_agg(languages_code, description)       AS description,
                   json_object_agg(languages_code, extra_description) AS extra_description
            FROM episodes_translations
            WHERE episodes_id = ANY ($1::int[])
            GROUP BY episodes_id),
     tags AS (SELECT episodes_id,
                     array_agg(tags_id) AS tags
              FROM episodes_tags
              GROUP BY episodes_id),
     asset_ids AS (SELECT episodes_id,
                          json_object_agg(language, assets_id) AS ids
                   FROM episodes_assets
                   GROUP BY episodes_id),
     images AS (WITH images AS (SELECT episode_id, style, language, filename_disk
                                FROM images img
                                         JOIN directus_files df on img.file = df.id
                                WHERE episode_id = ANY ($1::int[]))
                SELECT episode_id, json_agg(images) as json
                FROM images
                GROUP BY episode_id)
SELECT e.id,
       e.uuid,
       e.status,
       e.legacy_id,
       e.legacy_program_id,
       e.asset_id,
       asset_ids.ids                                                           AS assets,
       e.episode_number,
       e.publish_date,
       e.production_date,
       e.public_title,
       s.episode_number_in_title                                               AS number_in_title,
       COALESCE(e.prevent_public_indexing, false)::bool                        as prevent_public_indexing,
       ea.available_from::timestamp without time zone                          AS available_from,
       ea.available_to::timestamp without time zone                            AS available_to,
       COALESCE(e.publish_date_in_title, false)::bool                          AS publish_date_in_title,
       fs.filename_disk                                                        as image_file_name,
       e.season_id,
       e.type,
       COALESCE(img.json, '[]')                                                as images,
       ts.title,
       ts.description,
       ts.extra_description,
       tags.tags::int[]                                                        AS tag_ids,
       assets.duration                                                         as duration,
       COALESCE(e.agerating_code, s.agerating_code, 'A')                       as agerating,
       audience,
       content_type,
       timedmetadata_from_asset,
       (SELECT array_agg(id ORDER BY seconds)
        FROM timedmetadata md
        WHERE (timedmetadata_from_asset AND md.asset_id = e.asset_id)
           OR (NOT timedmetadata_from_asset AND md.episode_id = e.id))::uuid[] AS timedmetadata_ids
FROM episodes e
         LEFT JOIN ts ON e.id = ts.episodes_id
         LEFT JOIN tags ON tags.episodes_id = e.id
         LEFT JOIN images img ON img.episode_id = e.id
         LEFT JOIN asset_ids ON asset_ids.episodes_id = e.id
         LEFT JOIN assets ON e.asset_id = assets.id
         LEFT JOIN seasons s ON e.season_id = s.id
         LEFT JOIN shows sh ON s.show_id = sh.id
         LEFT JOIN directus_files fs ON fs.id = COALESCE(e.image_file_id, s.image_file_id, sh.image_file_id)
         LEFT JOIN episode_availability ea on e.id = ea.id
WHERE e.id = ANY ($1::int[])
ORDER BY e.episode_number;

-- name: getEpisodeIDsForSeasons :many
SELECT e.id,
       e.season_id
FROM episodes e
WHERE e.season_id = ANY ($1::int[])
ORDER BY e.episode_number;

-- name: getEpisodeIDsForSeasonsWithRoles :many
SELECT e.id,
       e.season_id
FROM episodes e
         LEFT JOIN episode_availability access ON access.id = e.id
         LEFT JOIN episode_roles roles ON roles.id = e.id
WHERE season_id = ANY ($1::int[])
  AND access.published
  AND access.available_to > now()
  AND (
    (roles.roles && $2::varchar[] AND access.available_from < now()) OR
    (roles.roles_earlyaccess && $2::varchar[])
    )
ORDER BY e.episode_number;

-- name: getEpisodeIDsWithRoles :many
SELECT e.id
FROM episodes e
         LEFT JOIN episode_availability access ON access.id = e.id
         LEFT JOIN episode_roles roles ON roles.id = e.id
WHERE e.id = ANY ($1::int[])
  AND access.published
  AND access.available_to > now()
  AND (
    (roles.roles && $2::varchar[] AND access.available_from < now()) OR
    (roles.roles_earlyaccess && $2::varchar[])
    );

-- name: getEpisodeUUIDsWithRoles :many
SELECT e.uuid
FROM episodes e
         LEFT JOIN episode_availability access ON access.id = e.id
         LEFT JOIN episode_roles roles ON roles.id = e.id
WHERE e.uuid = ANY ($1::uuid[])
  AND access.published
  AND access.available_to > now()
  AND (
    (roles.roles && $2::varchar[] AND access.available_from < now()) OR
    (roles.roles_earlyaccess && $2::varchar[])
    );

-- name: getEpisodeIDsForLegacyProgramIDs :many
SELECT e.id, e.legacy_program_id as legacy_id
FROM episodes e
WHERE e.legacy_program_id = ANY ($1::int[]);

-- name: getEpisodeIDsForLegacyIDs :many
SELECT e.id, e.legacy_id as legacy_id
FROM episodes e
WHERE e.legacy_id = ANY ($1::int[]);

-- name: getPermissionsForEpisodes :many
SELECT e.id,
       e.status = 'unlisted'              AS unlisted,
       access.published::bool             AS published,
       access.available_from::timestamp   AS available_from,
       access.available_to::timestamp     AS available_to,
       access.published_on::timestamp     AS published_on,
       roles.roles::varchar[]             AS usergroups,
       roles.roles_download::varchar[]    AS usergroups_downloads,
       roles.roles_earlyaccess::varchar[] AS usergroups_earlyaccess
FROM episodes e
         LEFT JOIN episode_availability access ON access.id = e.id
         LEFT JOIN episode_roles roles ON roles.id = e.id
WHERE e.id = ANY ($1::int[]);

-- name: getEpisodeIDsForUuids :many
SELECT e.id as result, e.uuid as original
FROM episodes e
WHERE e.uuid = ANY (@ids::uuid[]);

-- name: getEpisodeIDsWithTagIDs :many
SELECT t.episodes_id AS id, t.tags_id AS parent_id
FROM episodes_tags t
         LEFT JOIN episode_availability access ON access.id = t.episodes_id
         LEFT JOIN episode_roles roles ON roles.id = t.episodes_id
WHERE t.tags_id = ANY (@tag_ids::int[])
  AND access.published
  AND access.available_to > now()
  AND (
    (roles.roles && @roles::varchar[] AND access.available_from < now()) OR
    (roles.roles_earlyaccess && @roles::varchar[])
    );
