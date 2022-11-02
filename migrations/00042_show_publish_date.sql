-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-02T09:20:54.644Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" ADD COLUMN IF NOT EXISTS "publish_date_in_title" bool NULL  ;

COMMENT ON COLUMN "public"."shows"."publish_date_in_title"  IS NULL;

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 276;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (689, 'shows', 'publish_date_in_title', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 10, 'full', NULL, 'Should the episode publish date be visible in title', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 566;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-02T09:20:55.926Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" DROP COLUMN IF EXISTS "publish_date_in_title" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 566;

DELETE FROM "public"."directus_fields" WHERE "id" = 689;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
