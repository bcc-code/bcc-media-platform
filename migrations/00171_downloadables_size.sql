-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-05-11T13:54:40.498Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."assetfiles" ---

ALTER TABLE IF EXISTS "public"."assetfiles" ADD COLUMN IF NOT EXISTS "size" int4 NOT NULL DEFAULT 0 ;

COMMENT ON COLUMN "public"."assetfiles"."size"  IS NULL;

--- END ALTER TABLE "public"."assetfiles" ---


--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 15;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 1041;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1043, 'assetfiles', 'size', NULL, 'input', '{"min":0,"iconRight":"sd_storage","placeholder":null}', 'formatted-value', '{"format":true,"suffix":"kb","icon":"sd_storage"}', false, false, 13, 'full', NULL, 'in Bytes', NULL, true, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-05-11T13:54:42.154Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."assetfiles" ---

ALTER TABLE IF EXISTS "public"."assetfiles" DROP COLUMN IF EXISTS "size" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."assetfiles" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 15;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1041;

DELETE FROM "public"."directus_fields" WHERE "id" = 1043;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
