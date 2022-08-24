-- name: listShows :many
WITH ts AS (SELECT shows_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM shows_translations
            GROUP BY shows_id)
SELECT sh.id,
       sh.legacy_id,
       sh.image_file_id,
       ts.title,
       ts.description
FROM shows sh
         LEFT JOIN ts ON sh.id = ts.shows_id;


-- name: getShows :many
WITH ts AS (SELECT shows_id,
                  json_object_agg(languages_code, title)       AS title,
                  json_object_agg(languages_code, description) AS description
           FROM shows_translations
           GROUP BY shows_id)
SELECT sh.id,
       sh.legacy_id,
       sh.image_file_id,
       ts.title,
       ts.description
FROM shows sh
         LEFT JOIN ts ON sh.id = ts.shows_id
WHERE sh.id = ANY ($1::int[]);

-- name: getPermissionsForShows :many
WITH sa AS (SELECT sh.id,
                   sh.status::text = 'published'::text                          AS published,
                   COALESCE(sh.available_from,
                            '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
                   COALESCE(sh.available_to,
                            '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
            FROM shows sh),
     sr AS (SELECT sh.id,
                   COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                             FROM episodes_usergroups eu
                             WHERE (eu.episodes_id IN (SELECT e.id
                                                       FROM episodes e
                                                       WHERE (e.season_id IN (SELECT se.id
                                                                              FROM seasons se
                                                                              WHERE se.show_id = sh.id))))),
                            ARRAY []::character varying[]) AS roles,
                   COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                             FROM episodes_usergroups_download eu
                             WHERE (eu.episodes_id IN (SELECT e.id
                                                       FROM episodes e
                                                       WHERE (e.season_id IN (SELECT se.id
                                                                              FROM seasons se
                                                                              WHERE se.show_id = sh.id))))),
                            ARRAY []::character varying[]) AS roles_download,
                   COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                             FROM episodes_usergroups_earlyaccess eu
                             WHERE (eu.episodes_id IN (SELECT e.id
                                                       FROM episodes e
                                                       WHERE (e.season_id IN (SELECT se.id
                                                                              FROM seasons se
                                                                              WHERE se.show_id = sh.id))))),
                            ARRAY []::character varying[]) AS roles_earlyaccess
            FROM shows sh)
SELECT sh.id,
       access.published::boolean          AS published,
       access.available_from::timestamp   AS available_from,
       access.available_to::timestamp     AS available_to,
       roles.roles::varchar[]             AS usergroups,
       roles.roles_download::varchar[]    AS usergroups_downloads,
       roles.roles_earlyaccess::varchar[] AS usergroups_earlyaccess
FROM shows sh
         LEFT JOIN sa access ON access.id = sh.id
         LEFT JOIN sr roles ON roles.id = sh.id
WHERE sh.id = ANY ($1::int[]);

-- name: RefreshShowAccessView :one
SELECT update_access('shows_access');
