-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-31T07:26:41.178Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata"
	ALTER COLUMN "title" DROP DEFAULT ;

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN ALTER TABLE "public"."songs" ---

ALTER TABLE IF EXISTS "public"."songs" ADD COLUMN IF NOT EXISTS "title" text NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."songs"."title"  IS NULL;

--- END ALTER TABLE "public"."songs" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"hide if not person","rule":{"_and":[{"chapter_type":{"_nin":["speech","testimony"]}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]' WHERE "id" = 1312;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1317, 'songs', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-31T07:26:43.166Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata"
	ALTER COLUMN "title" DROP NOT NULL,
	ALTER COLUMN "title" SET DEFAULT ' '::text;

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN ALTER TABLE "public"."songs" ---

ALTER TABLE IF EXISTS "public"."songs" DROP COLUMN IF EXISTS "title" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."songs" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"hide if not person","rule":{"_and":[{"chapter_type":{"_in":["speech","testimony"]}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]' WHERE "id" = 1312;

DELETE FROM "public"."directus_fields" WHERE "id" = 1317;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
