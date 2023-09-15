-- name: getTimedMetadata :many
SELECT md.id,
       md.type,
       md.chapter_type,
       md.song_id,
       md.person_id,
       md.title                                                  AS original_title,
       md.description                                            AS original_description,
       COALESCE((SELECT json_object_agg(ts.languages_code, ts.title)
                 FROM timedmetadata_translations ts
                 WHERE ts.timedmetadata_id = md.id), '{}')::json AS title,
       COALESCE((SELECT json_object_agg(ts.languages_code, ts.description)
                 FROM timedmetadata_translations ts
                 WHERE ts.timedmetadata_id = md.id), '{}')::json AS description,
       md.seconds,
       md.highlight
FROM timedmetadata md
WHERE md.id = ANY (@ids::uuid[]);

-- name: InsertTimedMetadata :exec
INSERT INTO timedmetadata (id, status, user_created, date_created, user_updated, date_updated, label, type, highlight,
                           title, asset_id, seconds, description, episode_id, chapter_type, song_id, person_id)
VALUES (@id, @status, @user_created, @date_created, @user_updated, @date_updated, @label, @type, @highlight, @title,
        @asset_id, @seconds, @description, @episode_id, @chapter_type, @song_id, @person_id);

-- name: GetAssetTimedMetadata :many
SELECT id,
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
       chapter_type,
       song_id,
       person_id
FROM timedmetadata
WHERE asset_id = @asset_id;

-- name: ClearEpisodeTimedMetadata :exec
DELETE FROM timedmetadata WHERE episode_id = @episode_id;
