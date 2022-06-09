-- name: GetSeasons :many
SELECT * FROM public.seasons;

-- name: GetSeasonTranslations :many
SELECT * FROM public.seasons_translations;