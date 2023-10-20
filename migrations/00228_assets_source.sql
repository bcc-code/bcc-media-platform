-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-10-20T13:16:21.348Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."assets" ---

ALTER TABLE IF EXISTS "public"."assets" ADD COLUMN IF NOT EXISTS "source" text NULL  ;

COMMENT ON COLUMN "public"."assets"."source"  IS NULL;

--- END ALTER TABLE "public"."assets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1375, 'assets', 'source', NULL, 'input', NULL, 'raw', NULL, false, false, 18, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1376, 'assets', 'episodes', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 19, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_field" = 'episodes' WHERE "id" = 39;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-10-20T13:16:23.235Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."assets" ---

ALTER TABLE IF EXISTS "public"."assets" DROP COLUMN IF EXISTS "source" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."assets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1375;

DELETE FROM "public"."directus_fields" WHERE "id" = 1376;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_field" = NULL WHERE "id" = 39;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
