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

-- name: GetPersonIDsByNames :many
SELECT p.id, p.name
FROM persons p
WHERE name = ANY (@names::varchar[]);

-- name: GetCollectionSongID :one
SELECT s.id
FROM "public"."songs" s
         JOIN "public"."songcollections" c ON s.collection_id = c.id
WHERE c.key = @collection_key
  AND s.key = @song_key
LIMIT 1;

-- name: InsertSong :exec
INSERT INTO "public"."songs" (id, key, collection_id, title)
VALUES (@id, @key, @collection_id, @title);

-- name: InsertSongCollection :exec
INSERT INTO "public"."songcollections" (id, key, title)
VALUES (@id, @key, @title);

-- name: InsertPerson :exec
INSERT INTO "public"."persons" (id, name)
VALUES (@id, @name);

-- name: InsertTimedMetadataPerson :exec
INSERT INTO "public"."timedmetadata_persons" (timedmetadata_id, persons_id)
VALUES (@timedmetadata_id::uuid, @persons_id::uuid);

-- name: GetCollectionIDFromKey :one
SELECT id
FROM "public"."songcollections"
WHERE key = @key
LIMIT 1;
