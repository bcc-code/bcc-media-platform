-- name: listTags :many
WITH ts AS (SELECT ts.tags_id,
                  json_object_agg(ts.languages_code, ts.name)       AS name
           FROM tags_translations ts
           GROUP BY ts.tags_id)
SELECT
    t.id,
    t.name as code,
    ts.name
FROM tags t
         LEFT JOIN ts ON ts.tags_id = t.id;

-- name: getTags :many
WITH ts AS (SELECT ts.tags_id,
                   json_object_agg(ts.languages_code, ts.name)       AS name
            FROM tags_translations ts
            GROUP BY ts.tags_id)
SELECT
    t.id,
    t.name as code,
    ts.name
FROM tags t
         LEFT JOIN ts ON ts.tags_id = t.id
WHERE id = ANY($1::int[]);
