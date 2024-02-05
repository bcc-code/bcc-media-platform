-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-05T09:59:29.477Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."assetstreams" ---

ALTER TABLE IF EXISTS "public"."assetstreams" ADD COLUMN IF NOT EXISTS "configuration_id" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."assetstreams"."configuration_id"  IS NULL;

--- END ALTER TABLE "public"."assetstreams" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 52;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 53;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 43;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 39;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 49;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 38;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 42;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 45;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 40;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 41;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Continue Watching","value":"continue_watching"},{"text":"My List","value":"my_list"},{"text":"Shorts","value":"shorts"}],"allowNone":true}' WHERE "id" = 705;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1452, 'assetstreams', 'configuration_id', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-05T09:59:31.231Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."assetstreams" ---

ALTER TABLE IF EXISTS "public"."assetstreams" DROP COLUMN IF EXISTS "configuration_id" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."assetstreams" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 38;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 39;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 42;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 43;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 45;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 49;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 52;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 53;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 41;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 40;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Continue Watching","value":"continue_watching"},{"text":"My List","value":"my_list"}],"allowNone":true}' WHERE "id" = 705;

DELETE FROM "public"."directus_fields" WHERE "id" = 1452;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
