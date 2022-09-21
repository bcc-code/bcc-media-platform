-- name: listSeasons :many
WITH ts AS (SELECT seasons_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM seasons_translations
            GROUP BY seasons_id)
SELECT s.id,
       s.legacy_id,
       s.season_number,
       COALESCE(s.image_file_id, sh.image_file_id)::uuid as image_file_id,
       s.show_id,
       COALESCE(s.agerating_code, 'A') as agerating,
       ts.title,
       ts.description
FROM seasons s
         JOIN ts ON s.id = ts.seasons_id
         JOIN shows sh ON s.show_id = sh.id;

-- name: getSeasons :many
WITH ts AS (SELECT seasons_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM seasons_translations
            GROUP BY seasons_id)
SELECT s.id,
       s.legacy_id,
       s.season_number,
       COALESCE(s.image_file_id, sh.image_file_id)::uuid as image_file_id,
       s.show_id,
       COALESCE(s.agerating_code, 'A') as agerating,
       ts.title,
       ts.description
FROM seasons s
         JOIN ts ON s.id = ts.seasons_id
         JOIN shows sh ON s.show_id = sh.id
WHERE s.id = ANY ($1::int[]);

-- name: getSeasonIDsForShows :many
SELECT s.id, s.show_id
FROM seasons s
WHERE s.show_id = ANY ($1::int[])
ORDER BY s.season_number;

-- name: getPermissionsForSeasons :many
WITH sa AS (SELECT se.id,
                   se.status::text = 'published'::text AND
                   s.status::text = 'published'::text                           AS published,
                   COALESCE(GREATEST(se.available_from, s.available_from),
                            '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
                   COALESCE(LEAST(se.available_to, s.available_to),
                            '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
            FROM seasons se
                     LEFT JOIN shows s ON se.show_id = s.id),
     sr AS (SELECT se.id,
                   COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                             FROM episodes_usergroups eu
                             WHERE (eu.episodes_id IN (SELECT e.id
                                                       FROM episodes e
                                                       WHERE e.season_id = se.id))),
                            ARRAY []::character varying[]) AS roles,
                   COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                             FROM episodes_usergroups_download eu
                             WHERE (eu.episodes_id IN (SELECT e.id
                                                       FROM episodes e
                                                       WHERE e.season_id = se.id))),
                            ARRAY []::character varying[]) AS roles_download,
                   COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                             FROM episodes_usergroups_earlyaccess eu
                             WHERE (eu.episodes_id IN (SELECT e.id
                                                       FROM episodes e
                                                       WHERE e.season_id = se.id))),
                            ARRAY []::character varying[]) AS roles_earlyaccess
            FROM seasons se)
SELECT se.id,
       access.published::bool             AS published,
       access.available_from::timestamp   AS available_from,
       access.available_to::timestamp     AS available_to,
       roles.roles::varchar[]             AS usergroups,
       roles.roles_download::varchar[]    AS usergroups_downloads,
       roles.roles_earlyaccess::varchar[] AS usergroups_earlyaccess
FROM seasons se
         LEFT JOIN sa access ON access.id = se.id
         LEFT JOIN sr roles ON roles.id = se.id
WHERE se.id = ANY ($1::int[]);

-- name: RefreshSeasonAccessView :one
SELECT update_access('seasons_access');
