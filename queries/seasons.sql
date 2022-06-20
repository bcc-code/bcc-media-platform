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