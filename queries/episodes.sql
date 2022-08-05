-- name: listEpisodes :many
SELECT * FROM public.episodes_expanded;

-- name: getEpisodes :many
SELECT * FROM public.episodes_expanded WHERE id = ANY($1::int[]);

-- name: getEpisodesForSeasons :many
SELECT * FROM public.episodes_expanded WHERE season_id = ANY($1::int[]);

-- name: getFilesForEpisodes :many
SELECT e.id AS episodes_id, f.* FROM episodes e
JOIN assets a ON e.asset_id = a.id
JOIN assetfiles f ON a.id = f.asset_id
WHERE e.id = ANY($1::int[]);

-- name: getStreamsForEpisodes :many
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

-- name: RefreshEpisodeAccessView :one
SELECT update_access('episodes_access');
