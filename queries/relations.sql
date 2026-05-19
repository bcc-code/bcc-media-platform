-- name: getSongs :many
SELECT *
FROM songs
WHERE id = ANY (@ids::uuid[]);

-- name: getSongCollections :many
SELECT *
FROM songcollections
WHERE id = ANY (@ids::uuid[]);

-- name: getPhrases :many
SELECT p.key,
       p.value                                   AS original_value,
       COALESCE((SELECT json_object_agg(languages_code, value)
                 FROM phrases_translations
                 WHERE key = p.key), '{}')::json AS value
FROM phrases p
WHERE key = ANY (@ids::varchar[]);

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

-- name: getSongIDsForMediaItems :many
SELECT ms.songs_id      AS id,
       ms.mediaitems_id AS parent_id
FROM "public"."mediaitems_songs" ms
WHERE ms.mediaitems_id = ANY (@ids::uuid[]);

-- name: InsertSongCollection :exec
INSERT INTO "public"."songcollections" (id, key, title)
VALUES (@id, @key, @title);

-- name: GetCollectionIDFromKey :one
SELECT id
FROM "public"."songcollections"
WHERE key = @key
LIMIT 1;
