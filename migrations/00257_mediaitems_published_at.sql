-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-23T11:09:58.131Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems" ADD COLUMN IF NOT EXISTS "published_at" timestamp NULL  ;

COMMENT ON COLUMN "public"."mediaitems"."published_at"  IS NULL;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1400;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1406;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1435;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1427;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1422;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1402;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1403;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1431;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1401;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1414;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1407;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1404;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1405;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1441;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1442;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1458, 'mediaitems', 'published_at', 'date-created', 'custom-datepicker', NULL, 'datetime', NULL, false, false, 1, 'full', NULL, 'Define when this mediaitem was published. Mostly used for analytics or in algorithms.', NULL, false, 'details', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-23T11:09:59.752Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems" DROP COLUMN IF EXISTS "published_at" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1407;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1404;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1405;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1400;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1402;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1403;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1401;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1422;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1427;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1406;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1431;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1414;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1441;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1442;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1435;

DELETE FROM "public"."directus_fields" WHERE "id" = 1458;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
