-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-06T14:20:45.541Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections_links" ---

ALTER TABLE IF EXISTS "public"."sections_links" ADD COLUMN IF NOT EXISTS "title" varchar(255); --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

UPDATE "public"."sections_links" SET title = '';

ALTER TABLE IF EXISTS "public"."sections_links" ALTER COLUMN "title" SET NOT NULL;

COMMENT ON COLUMN "public"."sections_links"."title"  IS NULL;

--- END ALTER TABLE "public"."sections_links" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "hidden" = true WHERE "collection" = 'images';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (609, 'sections_links', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-06T14:20:46.731Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections_links" ---

ALTER TABLE IF EXISTS "public"."sections_links" DROP COLUMN IF EXISTS "title" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections_links" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "hidden" = false WHERE "collection" = 'images';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 609;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
