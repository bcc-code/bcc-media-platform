-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-17T11:18:21.375Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "secondary_titles" bool NULL  ;

COMMENT ON COLUMN "public"."sections"."secondary_titles"  IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (734, 'sections', 'secondary_titles', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'options', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (733, 'sections', 'options', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 236;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 246;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 686;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-17T11:18:22.735Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "secondary_titles" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 236;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 246;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 686;

DELETE FROM "public"."directus_fields" WHERE "id" = 734;

DELETE FROM "public"."directus_fields" WHERE "id" = 733;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
