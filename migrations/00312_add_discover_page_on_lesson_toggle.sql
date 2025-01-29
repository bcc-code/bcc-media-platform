-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-01-29T09:36:56.192Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."lessons" ADD COLUMN IF NOT EXISTS "show_discover_page" bool NOT NULL DEFAULT true ;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 859;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3046, 'lessons', 'show_discover_page', 'cast-boolean', 'boolean', '{"label":"Show discover page"}', NULL, NULL, false, false, 14, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 999;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-01-29T09:36:57.347Z            ***/
/**********************************************************/


ALTER TABLE IF EXISTS "public"."lessons" DROP COLUMN IF EXISTS "show_discover_page" CASCADE; --WARN: Drop column can occure in data loss!

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 999;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 859;

DELETE FROM "public"."directus_fields" WHERE "id" = 3046;

