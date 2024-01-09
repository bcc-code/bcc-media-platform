-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-08T13:44:05.870Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applicationgroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups" ADD COLUMN IF NOT EXISTS "firebase_project_id" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."applicationgroups"."firebase_project_id"  IS NULL;

--- END ALTER TABLE "public"."applicationgroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "interface" = 'select-dropdown-m2o', "options" = '{"template":"{{label}}"}' WHERE "id" = 1444;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1446, 'applicationgroups', 'firebase_project_id', NULL, NULL, NULL, 'raw', NULL, true, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1247;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-08T13:44:07.500Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applicationgroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups" DROP COLUMN IF EXISTS "firebase_project_id" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."applicationgroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 1247;

UPDATE "public"."directus_fields" SET "interface" = NULL, "options" = NULL WHERE "id" = 1444;

DELETE FROM "public"."directus_fields" WHERE "id" = 1446;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
