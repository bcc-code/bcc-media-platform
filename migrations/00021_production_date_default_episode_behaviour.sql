-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-07T07:40:59.188Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "production_date" date NULL  ;

COMMENT ON COLUMN "public"."episodes"."production_date"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" ADD COLUMN IF NOT EXISTS "default_episode_behaviour" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."shows"."default_episode_behaviour"  IS NULL;

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 273;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (608, 'shows', 'default_episode_behaviour', NULL, 'select-dropdown', '{"choices":[{"text":"First of first season","value":"first-of-first"},{"text":"First of last season","value":"first-of-last"},{"text":"Last of last season","value":"last-of-last"}]}', NULL, NULL, false, false, 11, 'full', NULL, 'What should the primary episode be?', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 118;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (611, 'episodes', 'production_date', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 4, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 566;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-07T07:41:00.530Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "production_date" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" DROP COLUMN IF EXISTS "default_episode_behaviour" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 565;

DELETE FROM "public"."directus_fields" WHERE "id" = 608;

DELETE FROM "public"."directus_fields" WHERE "id" = 611;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
