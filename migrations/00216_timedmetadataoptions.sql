-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-30T11:32:52.607Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "timedmetadata_from_asset" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."episodes"."timedmetadata_from_asset"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 2, "group" = 'timedmetadata_details' WHERE "id" = 1298;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1314, 'episodes', 'timedmetadata_details', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1316, 'episodes', 'timedmetadata_from_asset', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'timedmetadata_details', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-30T11:32:54.382Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "timedmetadata_from_asset" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9, "group" = NULL WHERE "id" = 1298;

DELETE FROM "public"."directus_fields" WHERE "id" = 1314;

DELETE FROM "public"."directus_fields" WHERE "id" = 1316;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
