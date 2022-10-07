-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-07T08:37:35.029Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "publish_date_in_title" bool NULL  ;

COMMENT ON COLUMN "public"."episodes"."publish_date_in_title"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" ADD COLUMN IF NOT EXISTS "default_episode_behaviour" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."shows"."default_episode_behaviour"  IS NULL;

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 123;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (612, 'episodes', 'publish_date_in_title', 'cast-boolean', NULL, NULL, NULL, NULL, false, false, 5, 'half', NULL, 'Defaults to true if show type is event', NULL, false, 'metadata', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 565;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (613, 'shows', 'default_episode_behaviour', NULL, 'select-dropdown', '{"choices":[{"text":"First of first season","value":"first-of-first"},{"text":"First of last season","value":"first-of-last"},{"text":"Last of last season","value":"last-of-last"}]}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 118;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-07T08:37:36.225Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "publish_date_in_title" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" DROP COLUMN IF EXISTS "default_episode_behaviour" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 565;

DELETE FROM "public"."directus_fields" WHERE "id" = 612;

DELETE FROM "public"."directus_fields" WHERE "id" = 613;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
