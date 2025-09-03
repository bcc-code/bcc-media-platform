-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-09-03T07:37:31.319Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."assets" ADD COLUMN IF NOT EXISTS "primary_media_type" varchar(255) NULL DEFAULT 'video'::character varying ;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 26;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 32;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 30;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 27;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 31;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 28;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 35;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1237;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 614;

UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 1375;

UPDATE "public"."directus_fields" SET "sort" = 20 WHERE "id" = 1376;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3085, 'assets', 'primary_media_type', NULL, 'select-dropdown', '{"choices":[{"text":"Video","value":"video","icon":"videocam"},{"text":"Audio","value":"audio","icon":"music_note"}]}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 468;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

-- +goose Down

ALTER TABLE IF EXISTS "public"."assets" DROP COLUMN IF EXISTS "primary_media_type" CASCADE; --WARN: Drop column can occure in data loss!

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 30;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 26;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 32;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 27;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 31;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 28;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 35;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 468;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 614;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1237;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 1375;

UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 1376;

DELETE FROM "public"."directus_fields" WHERE "id" = 3085;
