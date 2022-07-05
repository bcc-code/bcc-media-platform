-- name: GetEpisodes :many
SELECT * FROM public.episodes;

-- name: GetEpisode :one
SELECT * FROM public.episodes WHERE id = $1;

-- name: GetEpisodesWithTranslationsByID :many
WITH t AS (
SELECT episodes_id, json_object_agg( languages_code, to_jsonb(t.*)) translations FROM episodes_translations t
WHERE t.episodes_id = ANY($1::int[])
GROUP BY t.episodes_id)
SELECT * FROM episodes e
JOIN t ON e.id = t.episodes_id
WHERE t.episodes_id = ANY($1::int[]);

-- name: GetEpisodeTranslations :many
SELECT * FROM public.episodes_translations;

-- name: GetTranslationsForEpisode :many
SELECT * FROM public.episodes_translations WHERE episodes_id = $1;

-- name: GetEpisodeRoles :many
SELECT * FROM public.episodes_usergroups;

-- name: GetRolesForEpisode :many
SELECT usergroups_code FROM public.episodes_usergroups WHERE episodes_id = $1;

-- name: GetVisibilityForEpisodes :many
SELECT id, status, publish_date, available_from, available_to, season_id FROM public.episodes;

-- name: GetVisibilityForEpisode :one
SELECT id, status, publish_date, available_from, available_to, season_id FROM public.episodes WHERE id = $1;

-- name: RefreshAccessView :one
SELECT update_episodes_access();
