-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-01-15T10:37:24.684Z            ***/
/**********************************************************/


ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "achievements_source" varchar(255) NULL  ;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 246;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3044, 'sections', 'achievements_source', NULL, 'select-dropdown', '{"allowNone":true,"icon":"brightness_high","choices":[{"text":"Internal","value":"internal","icon":"branding_watermark","color":"#6644FF"},{"text":"BMM","value":"bmm","icon":"music_note","color":"#2ECDA7"}]}', NULL, NULL, false, true, 6, 'half', NULL, NULL, '[{"name":"Show on Achievements","rule":{"_and":[{"type":{"_eq":"achievements"}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}}]', false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 733;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 686;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 236;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-01-15T10:37:25.738Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 236;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 246;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 733;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 686;

DELETE FROM "public"."directus_fields" WHERE "id" = 3044;

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "achievements_source";
