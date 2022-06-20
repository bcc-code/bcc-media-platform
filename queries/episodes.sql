-- name: GetEpisodes :many
SELECT * FROM public.episodes;

-- name: GetEpisode :one
SELECT * FROM public.episodes WHERE id = $1;

-- name: GetEpisodeTranslations :many
SELECT * FROM public.episodes_translations;

-- name: GetTranslationsForEpisode :many
SELECT * FROM public.episodes_translations WHERE episodes_id = $1;

-- name: GetEpisodeRoles :many
SELECT * FROM public.episodes_usergroups;

-- name: GetRolesForEpisode :many
SELECT usergroups_code FROM public.episodes_usergroups WHERE episodes_id = $1;

-- name: GetVisibilityForEpisodes :one
SELECT id, status, publish_date, available_from, available_to, season_id FROM public.episodes;

-- name: GetVisibilityForEpisode :one
SELECT id, status, publish_date, available_from, available_to, season_id FROM public.episodes WHERE id = $1;