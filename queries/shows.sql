-- name: GetShows :many
SELECT * FROM public.shows;

-- name: GetShow :one
SELECT * FROM shows WHERE id = $1;

-- name: GetShowTranslations :many
SELECT * FROM public.shows_translations;

-- name: GetTranslationsForShow :many
SELECT * FROM public.shows_translations WHERE shows_id = $1;

-- name: GetRolesForShow :many
SELECT DISTINCT usergroups_code FROM episodes_usergroups WHERE episodes_id IN
    (SELECT id FROM episodes WHERE season_id IN
    (SELECT id FROM seasons WHERE show_id = $1));