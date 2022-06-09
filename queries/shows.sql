-- name: GetShows :many
SELECT * FROM public.shows;

-- name: GetShowTranslations :many
SELECT * FROM public.shows_translations;