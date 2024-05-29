-- name: getEpisodeIDsForTimedMetadatas :many
SELECT
tm.id,
m.primary_episode_id
FROM timedmetadata tm
LEFT JOIN mediaitems m on (m.id = tm.mediaitem_id) OR (m.timedmetadata_from_asset AND m.asset_id = tm.asset_id)
WHERE tm.id = ANY ($1::uuid[]);

-- name: getTimedMetadata :many
SELECT md.id,
       md.type,
       md.content_type,
       md.song_id,
       (SELECT array_agg(c.person_id) FROM "contributions" c WHERE c.timedmetadata_id = md.id)::uuid[] AS person_ids,
       md.title                                                  AS original_title,
       md.description                                            AS original_description,
       COALESCE((SELECT json_object_agg(ts.languages_code, ts.title)
                 FROM timedmetadata_translations ts
                 WHERE ts.timedmetadata_id = md.id), '{}')::json AS title,
       COALESCE((SELECT json_object_agg(ts.languages_code, ts.description)
                 FROM timedmetadata_translations ts
                 WHERE ts.timedmetadata_id = md.id), '{}')::json AS description,
       md.seconds,
       md.highlight,
       md.mediaitem_id,
       COALESCE(images.images, '{}'::json)            AS images,
       COALESCE((SELECT nextMd.seconds - md.seconds FROM timedmetadata nextMd
                 WHERE nextMd.mediaitem_id = md.mediaitem_id or nextMd.asset_id = md.asset_id
                   AND nextMd.seconds > md.seconds
                 ORDER BY nextMd.seconds LIMIT 1), 0)::float as duration
FROM timedmetadata md
LEFT JOIN (
    SELECT
    simg.timedmetadata_id,
    json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk', df.filename_disk)) AS images
    FROM timedmetadata_styledimages simg
    JOIN styledimages img ON (img.id = simg.styledimages_id)
    JOIN directus_files df ON (img.file = df.id)
    WHERE simg.timedmetadata_id = ANY(@ids::uuid[])
    GROUP BY simg.timedmetadata_id
) images ON (images.timedmetadata_id = md.id)
WHERE md.id = ANY (@ids::uuid[]);

-- name: InsertTimedMetadata :one
INSERT INTO timedmetadata (
  id,
  status,
  date_created,
  date_updated,
  label,
  type,
  highlight,
  title,
  asset_id,
  seconds,
  description,
  episode_id,
  mediaitem_id,
  content_type,
  song_id
)
VALUES (
  @id,
  @status,
  NOW(),
  NOW(),
  @label,
  @type,
  @highlight,
  @title::varchar,
  @asset_id,
  @seconds::real,
  @description::varchar,
  @episode_id,
  @mediaitem_id,
  @content_type,
  @song_id
)
RETURNING id;

-- name: GetAssetTimedMetadata :many
SELECT t.id,
       status,
       user_created,
       date_created,
       user_updated,
       date_updated,
       label,
       type,
       highlight,
       title,
       asset_id,
       seconds,
       description,
       episode_id,
       mediaitem_id,
       content_type,
       song_id,
       (SELECT array_agg(p.persons_id) FROM "timedmetadata_persons" p WHERE p.timedmetadata_id = t.id)::uuid[]  AS person_ids
FROM timedmetadata t
WHERE asset_id = @asset_id
ORDER BY seconds;

-- name: ClearEpisodeTimedMetadata :exec
DELETE FROM timedmetadata WHERE episode_id = @episode_id;

-- name: ClearMediaItemTimedMetadata :exec
DELETE FROM timedmetadata WHERE mediaitem_id = @mediaitem_id::uuid;

-- name: ClearAssetTimedMetadata :exec
DELETE FROM timedmetadata WHERE asset_id = @asset_id;
