-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-30T10:08:43.319Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "production_date" timestamp NULL  ;

COMMENT ON COLUMN "public"."episodes"."production_date"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 126;

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'full', "group" = 'availability' WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 121;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 127;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 122;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (782, 'episodes', 'production_date', NULL, NULL, NULL, NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 210;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 267;

UPDATE "public"."directus_fields" SET "translations" = '[{"language":"en-US","translation":"Production date in title"}]' WHERE "id" = 612;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-30T10:08:44.646Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "production_date" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 121;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 122;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 126;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 127;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'half', "group" = 'metadata' WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 210;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 267;

UPDATE "public"."directus_fields" SET "translations" = NULL WHERE "id" = 612;

DELETE FROM "public"."directus_fields" WHERE "id" = 782;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
