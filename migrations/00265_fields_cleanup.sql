-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-12T13:01:40.320Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 126;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 119;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 612;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1447;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 127;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true)
FROM "public"."directus_fields";


--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-12T13:01:42.175Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 126;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 612;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 119;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 127;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1447;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
