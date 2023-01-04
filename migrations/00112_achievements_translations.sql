-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-04T13:11:12.456Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."achievements" ---

ALTER TABLE IF EXISTS "public"."achievements"
	ALTER COLUMN "title" SET NOT NULL,
	ALTER COLUMN "title" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."achievements" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."achievements"."description"  IS NULL;

--- END ALTER TABLE "public"."achievements" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."achievementgroups_translations"."description"  IS NULL;

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."achievements_translations"."description"  IS NULL;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1005, 'achievements_translations', 'description', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 946;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1003, 'achievements', 'description', NULL, NULL, NULL, NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 917;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 935;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1004, 'achievementgroups_translations', 'description', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-04T13:11:13.942Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."achievements" ---

ALTER TABLE IF EXISTS "public"."achievements"
	ALTER COLUMN "title" DROP NOT NULL,
	ALTER COLUMN "title" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."achievements" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."achievements" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 917;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 935;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 946;

DELETE FROM "public"."directus_fields" WHERE "id" = 1005;

DELETE FROM "public"."directus_fields" WHERE "id" = 1003;

DELETE FROM "public"."directus_fields" WHERE "id" = 1004;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
