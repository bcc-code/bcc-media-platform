-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-12T09:15:05.887Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."messages" ---

ALTER TABLE IF EXISTS "users"."messages" ADD COLUMN IF NOT EXISTS "metadata" json NULL  ;

COMMENT ON COLUMN "users"."messages"."metadata"  IS NULL;

--- END ALTER TABLE "users"."messages" ---

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "uuid" uuid NULL  ;

COMMENT ON COLUMN "public"."episodes"."uuid"  IS NULL;

UPDATE "public"."episodes" SET uuid = gen_random_uuid() WHERE uuid IS NULL;

ALTER TABLE IF EXISTS "public"."episodes"
    ALTER COLUMN "uuid" SET NOT NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "hidden" = false, "width" = 'half' WHERE "id" = 129;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 144;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 137;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 147;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (901, 'episodes', 'uuid', 'uuid', 'input', NULL, 'raw', NULL, true, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 787;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 698;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 141;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-12T09:15:07.242Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "uuid" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "users"."messages" ---

ALTER TABLE IF EXISTS "users"."messages" DROP COLUMN IF EXISTS "metadata" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."messages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "hidden" = true, "width" = 'full' WHERE "id" = 129;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 137;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 144;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 698;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 787;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 141;

DELETE FROM "public"."directus_fields" WHERE "id" = 901;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
