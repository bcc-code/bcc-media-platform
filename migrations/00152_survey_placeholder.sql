-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-07T11:18:35.484Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."surveyquestions" ---

ALTER TABLE IF EXISTS "public"."surveyquestions" ADD COLUMN IF NOT EXISTS "placeholder" text NULL  ;

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" ADD COLUMN IF NOT EXISTS "placeholder" text NULL  ;

COMMENT ON COLUMN "public"."surveyquestions"."placeholder"  IS NULL;
COMMENT ON COLUMN "public"."surveyquestions_translations"."placeholder"  IS NULL;

--- END ALTER TABLE "public"."surveyquestions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1095, 'surveyquestions', 'placeholder', NULL, 'input', NULL, 'raw', NULL, false, false, 10, 'full', NULL, 'Placeholder to describe what is expected to be written here', '[{"name":"if text","rule":{"_and":[{"type":{"_neq":"text"}}]},"hidden":true,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-07T11:18:37.057Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."surveyquestions" ---

ALTER TABLE IF EXISTS "public"."surveyquestions" DROP COLUMN IF EXISTS "placeholder" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."surveyquestions_translations" DROP COLUMN IF EXISTS "placeholder" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."surveyquestions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1095;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
