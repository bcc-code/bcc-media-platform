-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-01T12:13:33.587Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."games_translations" ---

ALTER TABLE IF EXISTS "public"."games_translations" ADD COLUMN IF NOT EXISTS "title" text NULL  ;

COMMENT ON COLUMN "public"."games_translations"."title"  IS NULL;

ALTER TABLE IF EXISTS "public"."games_translations" ADD COLUMN IF NOT EXISTS "description" text NULL  ;

COMMENT ON COLUMN "public"."games_translations"."description"  IS NULL;

--- END ALTER TABLE "public"."games_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1222, 'games_translations', 'description', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1221, 'games_translations', 'title', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-01T12:13:35.422Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."games_translations" ---

ALTER TABLE IF EXISTS "public"."games_translations" DROP COLUMN IF EXISTS "title" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."games_translations" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."games_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1222;

DELETE FROM "public"."directus_fields" WHERE "id" = 1221;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
