-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-01T07:24:12.611Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "public_title" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."episodes"."public_title"  IS NULL;

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "prevent_public_indexing" bool NULL  ;

COMMENT ON COLUMN "public"."episodes"."prevent_public_indexing"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" ADD COLUMN IF NOT EXISTS "public_title" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."shows"."public_title"  IS NULL;

--- END ALTER TABLE "public"."shows" ---

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons" ADD COLUMN IF NOT EXISTS "public_title" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."seasons"."public_title"  IS NULL;

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 137;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 144;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (784, 'shows', 'public_title', NULL, 'input', NULL, 'raw', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (783, 'episodes', 'public_title', NULL, 'input', NULL, 'raw', NULL, false, false, 2, 'full', NULL, NULL, NULL, false, 'visibility', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 279;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 261;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 271;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (785, 'seasons', 'public_title', NULL, NULL, NULL, NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (786, 'episodes', 'prevent_public_indexing', 'cast-boolean', NULL, NULL, NULL, NULL, false, false, 1, 'full', NULL, 'Tell Google to avoid indexing episode', NULL, false, 'visibility', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 265;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 264;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (787, 'episodes', 'visibility', 'alias,no-data,group', 'group-detail', '{"start":"closed"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 280;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 214;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 203;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 216;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 689;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 220;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 221;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-01T07:24:13.959Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons" DROP COLUMN IF EXISTS "public_title" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" DROP COLUMN IF EXISTS "public_title" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."shows" ---

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "public_title" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "prevent_public_indexing" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 137;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 144;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 203;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 216;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 261;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 271;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 279;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 264;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 265;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 214;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 220;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 280;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 221;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 689;

DELETE FROM "public"."directus_fields" WHERE "id" = 784;

DELETE FROM "public"."directus_fields" WHERE "id" = 783;

DELETE FROM "public"."directus_fields" WHERE "id" = 785;

DELETE FROM "public"."directus_fields" WHERE "id" = 786;

DELETE FROM "public"."directus_fields" WHERE "id" = 787;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
