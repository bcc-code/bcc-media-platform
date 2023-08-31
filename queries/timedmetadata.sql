-- name: getTimedMetadata :many
SELECT md.id,
       COALESCE(md.asset_id, md.episode_id)::int                 AS parent_id,
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
       md.timestamp,
       md.highlight
FROM timedmetadata md
WHERE md.id = ANY (@ids::uuid[]);
