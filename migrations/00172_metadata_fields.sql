-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-16T13:34:05.458Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "content_type" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."episodes"."content_type"  IS NULL;

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "audience" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."episodes"."audience"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 124;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1172, 'episodes', 'content_type', NULL, 'select-dropdown', '{"choices":[{"text":"Other transmission","value":"other_transmission"},{"text":"Event transmission","value":"event_transmission"},{"text":"Individual film","value":"individual_film"},{"text":"Series film","value":"series_film"}]}', 'labels', NULL, false, false, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 143;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1173, 'episodes', 'audience', NULL, 'select-dropdown', '{"choices":[{"text":"Kids","value":"kids"},{"text":"Youth","value":"youth"},{"text":"General","value":"general"}]}', 'labels', NULL, false, false, 10, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 147;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-16T13:34:07.028Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "content_type" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "audience" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 125;

DELETE FROM "public"."directus_fields" WHERE "id" = 1172;

DELETE FROM "public"."directus_fields" WHERE "id" = 1173;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
