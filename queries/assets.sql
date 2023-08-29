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
       md.title                                                  AS original_title,
       md.description                                            AS original_description,
       COALESCE((SELECT json_object_agg(ts.languages_code, ts.title)
                 FROM timedmetadata_translations ts
                 WHERE ts.timedmetadata_id = md.id), '{}')::json AS title,
       COALESCE((SELECT json_object_agg(ts.languages_code, ts.description)
                 FROM timedmetadata_translations ts
                 WHERE ts.timedmetadata_id = md.id), '{}')::json AS description,
       md.timestamp,
       md.highlight,
       md.datasource_id                                          AS datasource_id,
       ds.has_translations                                       AS datasource_has_translations,
       COALESCE(ds.title, '')                                    AS datasource_original_title,
       ds.description                                            AS datasource_original_description,
       COALESCE((SELECT json_object_agg(dsts.languages_code, dsts.title)
                 FROM datasources_translations dsts
                 WHERE ds.has_translations
                   AND dsts.datasources_id = ds.id), '{}')::json AS datasource_title,
       COALESCE((SELECT json_object_agg(dsts.languages_code, dsts.description)
                 FROM datasources_translations dsts
                 WHERE ds.has_translations
                   AND dsts.datasources_id = ds.id), '{}')::json AS datasource_description
FROM timedmetadata md
         LEFT JOIN datasources ds ON ds.id = md.datasource_id
WHERE md.status = 'published'
  AND md.asset_id = ANY (@asset_ids::int[]);

-- name: ListAssets :many
SELECT *
FROM assets;

-- name: DeletePath :exec
DELETE
FROM assets
WHERE main_storage_path = @path;

-- name: AssetIDByARN :one
SELECT id
FROM assets
WHERE aws_arn = @aws_arn::varchar
LIMIT 1;

-- name: InsertAsset :one
INSERT INTO assets (duration, encoding_version, legacy_id, main_storage_path,
                    mediabanken_id, name, status, aws_arn, date_updated, date_created)
VALUES (@duration, @encoding_version, @legacy_id, @main_storage_path, @mediabanken_id, @name, @status, @aws_arn, NOW(),
        NOW())
RETURNING id;

-- name: NewestPreviousAssetByMediabankenID :one
SELECT *
FROM assets
WHERE mediabanken_id = @mediabanken_id::varchar
ORDER BY date_created DESC
LIMIT 1;

-- name: UpdateAssetStatus :exec
UPDATE assets
SET status = @status::varchar
WHERE id = @id;

-- name: UpdateAssetArn :exec
UPDATE assets
SET aws_arn = @aws_arn
WHERE id = @id;

-- name: InsertAssetFile :one
INSERT INTO assetfiles (asset_id, audio_language_id, subtitle_language_id, size, path, resolution, mime_type, type,
                        storage, date_updated, date_created)
VALUES (@asset_id, @audio_language_id, @subtitle_language_id, @size, @path, @resolution, @mime_type, @type, @storage,
        NOW(), NOW())
RETURNING id;

-- name: InsertAssetStream :one
INSERT INTO assetstreams (asset_id, encryption_key_id, extra_metadata, legacy_videourl_id, path, service, status, type,
                          url, date_updated, date_created)
VALUES (@asset_id, @encryption_key_id, @extra_metadata, @legacy_videourl_id, @path, @service, @status, @type, @url,
        NOW(), NOW())
RETURNING id;

-- name: InsertAssetStreamAudioLanguage :one
INSERT INTO assetstreams_audio_languages (assetstreams_id, languages_code)
VALUES (@assetstreams_id, @languages_code)
RETURNING id;


-- name: InsertAssetStreamSubtitleLanguage :one
INSERT INTO assetstreams_subtitle_languages (assetstreams_id, languages_code)
VALUES (@assetstreams_id, @languages_code)
RETURNING id;

