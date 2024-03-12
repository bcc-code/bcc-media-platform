-- name: listEpisodes :many
WITH ts AS (SELECT episodes_id,
                   json_object_agg(languages_code, extra_description) AS extra_description
            FROM episodes_translations
            GROUP BY episodes_id)
SELECT e.id,
       e.uuid,
       e.mediaitem_id,
       e.status,
       e.legacy_id,
       e.legacy_program_id,
       fs.filename_disk                                                     as image_file_name,
       e.season_id,
       e.type,
       e.episode_number,
       e.public_title,
       s.episode_number_in_title                                            AS number_in_title,
       COALESCE(e.prevent_public_indexing, false)::bool                     as prevent_public_indexing,
       COALESCE(e.publish_date_in_title, false)::bool                       AS publish_date_in_title,
       ea.available_from::timestamp without time zone                       AS available_from,
       ea.available_to::timestamp without time zone                         AS available_to,
       mi.asset_id,
       mi.assets,
       mi.published_at,
       mi.production_date,
       mi.images,
       mi.original_title,
       mi.original_description,
       mi.title,
       mi.description,
       ts.extra_description,
       mi.tag_ids,
       mi.duration,
       mi.asset_date_updated,
       COALESCE(mi.agerating_code, e.agerating_code, s.agerating_code, 'A') as agerating,
       mi.audience,
       mi.content_type,
       mi.timedmetadata_ids
FROM episodes e
         LEFT JOIN mediaitems_view mi ON mi.id = e.mediaitem_id
         LEFT JOIN ts ON e.id = ts.episodes_id
         LEFT JOIN seasons s ON e.season_id = s.id
         LEFT JOIN shows sh ON s.show_id = sh.id
         LEFT JOIN directus_files fs ON fs.id = COALESCE(e.image_file_id, s.image_file_id, sh.image_file_id)
         LEFT JOIN episode_availability ea on e.id = ea.id;

-- name: getEpisodes :many
WITH ts AS (SELECT episodes_id,
                   json_object_agg(languages_code, extra_description) AS extra_description
            FROM episodes_translations
            GROUP BY episodes_id)
SELECT e.id,
       e.uuid,
       e.mediaitem_id,
       e.status,
       e.legacy_id,
       e.legacy_program_id,
       fs.filename_disk                                                     as image_file_name,
       e.season_id,
       e.type,
       e.episode_number,
       e.public_title,
       s.episode_number_in_title                                            AS number_in_title,
       COALESCE(e.prevent_public_indexing, false)::bool                     as prevent_public_indexing,
       COALESCE(e.publish_date_in_title, false)::bool                       AS publish_date_in_title,
       ea.available_from::timestamp without time zone                       AS available_from,
       ea.available_to::timestamp without time zone                         AS available_to,
       mi.asset_id,
       mi.assets,
       mi.published_at,
       mi.production_date,
       mi.images,
       mi.original_title,
       mi.original_description,
       mi.title,
       mi.description,
       ts.extra_description,
       mi.tag_ids,
       mi.duration,
       mi.asset_date_updated,
       COALESCE(mi.agerating_code, e.agerating_code, s.agerating_code, 'A') as agerating,
       mi.audience,
       mi.content_type,
       mi.timedmetadata_ids
FROM episodes e
         LEFT JOIN mediaitems_view mi ON mi.id = e.mediaitem_id
         LEFT JOIN ts ON e.id = ts.episodes_id
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
