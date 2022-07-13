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
SELECT * FROM shows_expanded WHERE id = ANY($1::int[]);

-- name: RefreshShowAccessView :one
SELECT update_access('shows_access');
