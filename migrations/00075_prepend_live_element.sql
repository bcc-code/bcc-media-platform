-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-22T13:23:47.375Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "prepend_live_element" bool NULL  ;

COMMENT ON COLUMN "public"."sections"."prepend_live_element"  IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"hidden if not item","rule":{"_and":[{"type":{"_neq":"item"}}]},"hidden":true,"options":{"start":"open"}}]' WHERE "id" = 733;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (781, 'sections', 'prepend_live_element', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 3, 'half', NULL, NULL, NULL, false, 'options', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-22T13:23:48.782Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "prepend_live_element" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = NULL WHERE "id" = 733;

DELETE FROM "public"."directus_fields" WHERE "id" = 781;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
