-- name: GetEpisodes :many
SELECT * FROM public.episodes;

-- name: GetEpisodeTranslations :many
SELECT * FROM public.episodes_translations;

-- name: GetTranslationsForEpisode :many
SELECT * FROM public.episodes_translations WHERE episodes_id = $1;