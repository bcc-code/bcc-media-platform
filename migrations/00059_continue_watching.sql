-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-15T09:00:38.874Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections" ADD COLUMN IF NOT EXISTS "advanced_type" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."collections"."advanced_type"  IS NULL;

--- END ALTER TABLE "public"."collections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 97;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (705, 'collections', 'advanced_type', NULL, 'select-dropdown', '{"choices":[{"text":"Continue Watching","value":"continue_watching"}],"allowNone":true}', 'labels', NULL, false, false, 4, 'full', NULL, 'Start with the continue watching dataset, add filters after. The order will not be changed.', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 85;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-15T09:00:40.141Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections" DROP COLUMN IF EXISTS "advanced_type" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."collections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 85;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 97;

DELETE FROM "public"."directus_fields" WHERE "id" = 705;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
