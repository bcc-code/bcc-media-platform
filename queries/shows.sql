-- name: GetShows :many
SELECT * FROM public.shows;

-- name: GetShow :one
SELECT * FROM shows WHERE id = $1;

-- name: GetShowTranslations :many
SELECT * FROM public.shows_translations;

-- name: GetTranslationsForShow :many
SELECT * FROM public.shows_translations WHERE shows_id = $1;