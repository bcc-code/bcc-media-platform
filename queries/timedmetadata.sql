-- name: getTimedMetadata :many
SELECT tm.id,
       tm.type,
       tm.content_type,
       tm.song_id,
       (SELECT array_agg(c.person_id) FROM "contributions" c WHERE c.timedmetadata_id = tm.id)::uuid[] AS person_ids,
       tm.title                                                  AS original_title,
       tm.description                                            AS original_description,
       COALESCE((SELECT json_object_agg(ts.languages_code, ts.title)
                 FROM timedmetadata_translations ts
                 WHERE ts.timedmetadata_id = tm.id), '{}')::json AS title,
       COALESCE((SELECT json_object_agg(ts.languages_code, ts.description)
                 FROM timedmetadata_translations ts
                 WHERE ts.timedmetadata_id = tm.id), '{}')::json AS description,
       tm.seconds,
       tm.highlight,
       tm.mediaitem_id,
       COALESCE(images.images, '{}'::json)            AS images,
       COALESCE((
          -- if there is a next timedmetadata, calculate the duration between the current and the next timedmetadata
          SELECT nextTm.seconds - tm.seconds
          FROM timedmetadata nextTm
          WHERE (nextTm.mediaitem_id = tm.mediaitem_id OR nextTm.asset_id = tm.asset_id)
          AND nextTm.seconds > tm.seconds
          ORDER BY nextTm.seconds
          LIMIT 1
        ), (
          -- if there is no next timedmetadata, calculate the duration of the asset
          SELECT asset.duration - tm.seconds
          FROM assets asset
          WHERE asset.id = tm.asset_id
          OR asset.id = mi.asset_id
          LIMIT 1
        ), 0)::float as duration
FROM timedmetadata tm
LEFT JOIN mediaitems mi ON (mi.id = tm.mediaitem_id)
LEFT JOIN (
    SELECT
    simg.timedmetadata_id,
    json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk', df.filename_disk)) AS images
    FROM timedmetadata_styledimages simg
    JOIN styledimages img ON (img.id = simg.styledimages_id)
    JOIN directus_files df ON (img.file = df.id)
    WHERE simg.timedmetadata_id = ANY(@ids::uuid[])
    GROUP BY simg.timedmetadata_id
) images ON (images.timedmetadata_id = tm.id)
WHERE tm.id = ANY (@ids::uuid[]);

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
  gen_random_uuid(),
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
