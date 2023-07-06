-- name: getFilesForEpisodes :many
SELECT e.id AS episodes_id, f.*
FROM episodes e
         JOIN assets a ON e.asset_id = a.id
         JOIN assetfiles f ON a.id = f.asset_id
WHERE e.id = ANY ($1::int[]);

-- name: getFilesForAssets :many
SELECT 0::int as episodes_id, f.*
FROM assets a
         JOIN assetfiles f ON a.id = f.asset_id
WHERE a.id = ANY ($1::int[]);


-- name: getStreamsForEpisodes :many
WITH audiolang AS (SELECT s.id, array_agg(al.languages_code) langs
                   FROM episodes e
                            JOIN assets a ON e.asset_id = a.id
                            LEFT JOIN assetstreams s ON a.id = s.asset_id
                            LEFT JOIN assetstreams_audio_languages al ON al.assetstreams_id = s.id
                   WHERE al.languages_code IS NOT NULL
                   GROUP BY s.id),
     sublang AS (SELECT s.id, array_agg(al.languages_code) langs
                 FROM episodes e
                          JOIN assets a ON e.asset_id = a.id
                          LEFT JOIN assetstreams s ON a.id = s.asset_id
                          LEFT JOIN assetstreams_subtitle_languages al ON al.assetstreams_id = s.id
                 WHERE al.languages_code IS NOT NULL
                 GROUP BY s.id)
SELECT e.id AS                          episodes_id,
       s.*,
       COALESCE(al.langs, '{}')::text[] audio_languages,
       COALESCE(sl.langs, '{}')::text[] subtitle_languages
FROM episodes e
         JOIN assets a ON e.asset_id = a.id
         JOIN assetstreams s ON a.id = s.asset_id
         LEFT JOIN audiolang al ON al.id = s.id
         LEFT JOIN sublang sl ON sl.id = s.id
WHERE e.id = ANY ($1::int[]);

-- name: getStreamsForAssets :many
WITH audiolang AS (SELECT s.id, array_agg(al.languages_code) langs
                   FROM assets a
                            LEFT JOIN assetstreams s ON a.id = s.asset_id
                            LEFT JOIN assetstreams_audio_languages al ON al.assetstreams_id = s.id
                   WHERE al.languages_code IS NOT NULL
                   GROUP BY s.id),
     sublang AS (SELECT s.id, array_agg(al.languages_code) langs
                 FROM assets a
                          LEFT JOIN assetstreams s ON a.id = s.asset_id
                          LEFT JOIN assetstreams_subtitle_languages al ON al.assetstreams_id = s.id
                 WHERE al.languages_code IS NOT NULL
                 GROUP BY s.id)
SELECT 0::int as                        episodes_id,
       s.*,
       COALESCE(al.langs, '{}')::text[] audio_languages,
       COALESCE(sl.langs, '{}')::text[] subtitle_languages
FROM assets a
         JOIN assetstreams s ON a.id = s.asset_id
         LEFT JOIN audiolang al ON al.id = s.id
         LEFT JOIN sublang sl ON sl.id = s.id
WHERE a.id = ANY ($1::int[]);

-- name: getTimedMetadataForAssets :many
SELECT md.id,
       md.asset_id,
       md.type,
       md.title                            AS original_title,
       md.description                      AS original_description,
       (SELECT json_object_agg(ts.languages_code, ts.title)
        FROM timedmetadata_translations ts
        WHERE ts.timedmetadata_id = md.id) AS title,
       (SELECT json_object_agg(ts.languages_code, ts.description)
        FROM timedmetadata_translations ts
        WHERE ts.timedmetadata_id = md.id) AS description,
       md.timestamp,
       md.highlight
FROM timedmetadata md
WHERE md.asset_id = ANY (@asset_ids::int[]);

-- name: ListAssets :many
SELECT * FROM assets;

-- name: DeletePath :exec
DELETE FROM assets WHERE main_storage_path = @path;
