-- name: GetEpisodes :many
SELECT * FROM public.episodes;

-- name: GetEpisode :one
SELECT * FROM public.episodes WHERE id = $1;

-- name: GetEpisodesWithTranslationsByID :many
WITH t AS (SELECT
	t.episodes_id,
	json_object_agg(t.languages_code, t.title) as title,
	json_object_agg(t.languages_code, t.description) as description,
	json_object_agg(t.languages_code, t.extra_description) as extra_description
FROM episodes_translations t
WHERE t.episodes_id = ANY($1::int[])
GROUP BY episodes_id)
SELECT * FROM episodes e
JOIN t ON e.id = t.episodes_id;

-- name: GetFilesForEpisodes :many
SELECT e.id AS episodes_id, f.* FROM episodes e
JOIN assets a ON e.asset_id = a.id
JOIN assetfiles f ON a.id = f.asset_id
WHERE e.id = ANY($1::int[]);

-- name: GetStreamsForEpisodes :many
WITH audiolang AS (SELECT s.id, array_agg(al.languages_code) langs FROM episodes e
	JOIN assets a ON e.asset_id = a.id
	LEFT JOIN assetstreams s ON a.id = s.asset_id
	LEFT JOIN assetstreams_audio_languages al ON al.assetstreams_id = s.id
	WHERE e.id = 1
	GROUP BY s.id),
sublang AS (SELECT s.id, array_agg(al.languages_code) langs FROM episodes e
	JOIN assets a ON e.asset_id = a.id
	LEFT JOIN assetstreams s ON a.id = s.asset_id
	LEFT JOIN assetstreams_subtitle_languages al ON al.assetstreams_id = s.id
	WHERE e.id = 1
	GROUP BY s.id)
SELECT e.id AS episodes_id, s.*, al.langs::text[] audio_languages, sl.langs::text[] subtitle_languages FROM episodes e
JOIN assets a ON e.asset_id = a.id
JOIN assetstreams s ON a.id = s.asset_id
LEFT JOIN audiolang al ON al.id = s.id
LEFT JOIN sublang sl ON sl.id = s.id
WHERE e.id = ANY($1::int[]);

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
