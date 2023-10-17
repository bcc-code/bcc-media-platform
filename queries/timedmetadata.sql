-- name: getTimedMetadata :many
SELECT md.id,
       md.type,
       md.chapter_type,
       md.song_id,
       (SELECT array_agg(p.persons_id) FROM "timedmetadata_persons" p WHERE p.timedmetadata_id = md.id)::uuid[] AS person_ids,
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
INSERT INTO timedmetadata (id, status, date_created, date_updated, label, type, highlight,
                           title, asset_id, seconds, description, episode_id, chapter_type, song_id)
VALUES (@id, @status, NOW(), NOW(), @label, @type, @highlight, @title::varchar,
        @asset_id, @seconds::real, @description::varchar, @episode_id, @chapter_type, @song_id);

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
       chapter_type,
       song_id,
       (SELECT array_agg(p.persons_id) FROM "timedmetadata_persons" p WHERE p.timedmetadata_id = t.id)::uuid[]  AS person_ids
FROM timedmetadata t
WHERE asset_id = @asset_id
ORDER BY seconds;

-- name: ClearEpisodeTimedMetadata :exec
DELETE FROM timedmetadata WHERE episode_id = @episode_id;
