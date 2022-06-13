-- name: GetSeasons :many
SELECT * FROM public.seasons;

-- name: GetSeason :one
SELECT * FROM public.seasons WHERE id = $1;

-- name: GetSeasonTranslations :many
SELECT * FROM public.seasons_translations;

-- name: GetTranslationsForSeason :many
SELECT * FROM public.seasons_translations WHERE seasons_id = $1;