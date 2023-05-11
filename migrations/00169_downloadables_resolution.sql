-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-05-11T13:33:59.472Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."assetfiles" ---

ALTER TABLE IF EXISTS "public"."assetfiles" ADD COLUMN IF NOT EXISTS "resolution" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."assetfiles"."resolution"  IS NULL;

--- END ALTER TABLE "public"."assetfiles" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 12;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 20;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 15;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1041, 'assetfiles', 'resolution', NULL, 'input', '{"iconLeft":"tv","trim":true}', NULL, NULL, false, false, 13, 'full', NULL, 'Resolution in pixels in format 1213x123', NULL, false, NULL, '{"_and":[{"resolution":{"_regex":"[0-9]+x[0-9]+"}}]}', 'Must be in format 123x123');

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-05-11T13:34:01.279Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."assetfiles" ---

ALTER TABLE IF EXISTS "public"."assetfiles" DROP COLUMN IF EXISTS "resolution" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."assetfiles" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 12;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 15;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 20;

DELETE FROM "public"."directus_fields" WHERE "id" = 1041;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
