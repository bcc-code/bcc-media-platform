-- name: getSongs :many
SELECT *
FROM songs
WHERE id = ANY (@ids::uuid[]);

-- name: getPersons :many
SELECT *
FROM persons
WHERE id = ANY (@ids::uuid[]);

-- name: getPhrases :many
SELECT p.key,
       p.value                                   AS original_value,
       COALESCE((SELECT json_object_agg(value, languages_code)
                 FROM phrases_translations
                 WHERE key = p.key), '{}')::json AS value
FROM phrases p
WHERE key = ANY (@ids::varchar[]);
