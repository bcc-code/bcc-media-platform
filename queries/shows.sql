-- name: GetShows :many
SELECT * FROM public.shows;

-- name: GetShow :one
SELECT * FROM shows WHERE id = $1;

-- name: GetShowTranslations :many
SELECT * FROM public.shows_translations;

-- name: GetTranslationsForShow :many
SELECT * FROM public.shows_translations WHERE shows_id = $1;

-- name: GetRolesForShow :many
SELECT DISTINCT usergroups_code FROM public.episodes_usergroups WHERE episodes_id IN
    (SELECT id FROM episodes WHERE season_id IN
    (SELECT id FROM seasons WHERE show_id = $1));

-- name: GetVisibilityForShows :many
SELECT id, status, publish_date, available_from, available_to FROM public.shows;

-- name: GetVisibilityForShow :one
SELECT id, status, publish_date, available_from, available_to FROM public.shows WHERE id = $1;

-- name: GetAccessForShows :many
SELECT * FROM shows_access WHERE id = ANY($1::int[]);

-- name: GetShowsWithTranslationsByID :many
WITH t AS (SELECT
               t.shows_id,
               json_object_agg(t.languages_code, t.title) as title,
               json_object_agg(t.languages_code, t.description) as description
           FROM shows_translations t
           GROUP BY shows_id)
SELECT
    sh.id, sh.image_file_id,
    t.title, t.description,
    access.published::bool published,
    access.available_from::timestamptz available_from, access.available_to::timestamptz available_to,
    access.usergroups::text[] usergroups, access.usergroups_downloads::text[] download_groups, access.usergroups_earlyaccess::text[] early_access_groups
FROM shows sh
         JOIN t ON sh.id = t.shows_id
         JOIN shows_access access on access.id = sh.id
WHERE sh.id = ANY($1::int[]);