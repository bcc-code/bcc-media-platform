-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-11T12:49:39.441Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 139;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 121;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 119;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 1447;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 122;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true)
FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

WITH data AS (SELECT gen_random_uuid() as new_id,
                     i.user_created,
                     i.date_created,
                     i.user_updated,
                     i.date_updated,
                     i.file,
                     i.language,
                     i.style,
                     i.episode_id
              FROM images i
              WHERE i.file IS NOT NULL),
     inserts AS (INSERT INTO styledimages (id, user_created, date_created, user_updated, date_updated, file, language,
                                           style)
         SELECT i.new_id,
                i.user_created,
                i.date_created,
                i.user_updated,
                i.date_updated,
                i.file,
                i.language,
                i.style
         FROM data i
         WHERE episode_id IS NOT NULL RETURNING styledimages.id)
INSERT
INTO mediaitems_styledimages (mediaitems_id, styledimages_id)
SELECT e.uuid, ins.id
FROM inserts ins
         JOIN data d ON d.new_id = ins.id
         JOIN episodes e ON e.id = d.episode_id;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-11T12:49:41.027Z             ***/
/***********************************************************/

DELETE
FROM styledimages i
WHERE id IN (SELECT styledimages_id
             FROM mediaitems_styledimages
                      JOIN episodes e ON e.uuid = mediaitems_id);

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 139;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 121;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 119;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 122;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 1447;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
