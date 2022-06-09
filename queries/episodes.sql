-- name: GetEpisodes :many
SELECT * FROM public.episodes;

-- name: GetEpisodeTranslations :many
SELECT * FROM public.episodes_translations;