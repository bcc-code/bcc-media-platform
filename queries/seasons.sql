-- name: GetSeasons :many
SELECT * FROM public.seasons;

-- name: GetSeason :one
SELECT * FROM public.seasons WHERE id = $1;

-- name: GetSeasonTranslations :many
SELECT * FROM public.seasons_translations;

-- name: GetTranslationsForSeason :many
SELECT * FROM public.seasons_translations WHERE seasons_id = $1;

-- name: GetRolesForSeason :many
SELECT DISTINCT usergroups_code FROM public.episodes_usergroups WHERE episodes_id IN
    (SELECT id FROM public.episodes WHERE season_id = $1);

-- name: GetVisibilityForSeasons :many
SELECT id, status, publish_date, available_from, available_to, show_id FROM public.seasons;

-- name: GetVisibilityForSeason :one
SELECT id, status, publish_date, available_from, available_to, show_id FROM public.seasons WHERE id = $1;

-- name: GetAccessForSeasons :many
SELECT * FROM seasons_access WHERE id = ANY($1::int[]);

-- name: GetSeasonsWithTranslationsByID :many
WITH t AS (SELECT
       t.seasons_id,
       json_object_agg(t.languages_code, t.title) as title,
       json_object_agg(t.languages_code, t.description) as description
    FROM seasons_translations t
    GROUP BY seasons_id)
SELECT
    se.id, se.season_number, se.image_file_id, se.show_id,
    t.title, t.description,
    access.published::bool published,
    access.available_from::timestamptz available_from, access.available_to::timestamptz available_to,
    access.usergroups::text[] usergroups, access.usergroups_downloads::text[] download_groups, access.usergroups_earlyaccess::text[] early_access_groups
FROM seasons se
JOIN t ON se.id = t.seasons_id
JOIN seasons_access access on access.id = se.id
WHERE se.id = ANY($1::int[]);

-- name: RefreshSeasonAccessView :one
SELECT update_access('seasons_access');