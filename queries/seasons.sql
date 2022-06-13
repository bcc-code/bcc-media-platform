-- name: GetSeasons :many
SELECT * FROM public.seasons;

-- name: GetSeasonTranslations :many
SELECT * FROM public.seasons_translations;

-- name: GetTranslationsForSeason :many
SELECT * FROM public.seasons_translations WHERE seasons_id = $1;