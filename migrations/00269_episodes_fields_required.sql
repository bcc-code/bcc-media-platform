-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-14T10:45:29.311Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes"
	ALTER COLUMN "publish_date" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."episodes"
	ALTER COLUMN "production_date" DROP NOT NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 1172;

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 782;

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 1173;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-14T10:45:30.961Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

UPDATE "public"."episodes"
    SET "publish_date" = '1970-01-01T00:00:00.000Z'
    WHERE "publish_date" IS NULL;

UPDATE "public"."episodes"
    SET "production_date" = '1970-01-01T00:00:00.000Z'
    WHERE "production_date" IS NULL;

ALTER TABLE IF EXISTS "public"."episodes"
	ALTER COLUMN "publish_date" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."episodes"
	ALTER COLUMN "production_date" SET NOT NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 1172;

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 1173;

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 782;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
