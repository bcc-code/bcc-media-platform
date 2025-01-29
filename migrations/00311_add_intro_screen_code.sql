-- +goose Up

ALTER TABLE IF EXISTS "public"."lessons" ADD COLUMN IF NOT EXISTS "intro_screen_code" varchar(255) NULL DEFAULT NULL::character varying ;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 831;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 859;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3045, 'lessons', 'intro_screen_code', NULL, 'select-dropdown', '{"choices":[{"text":"Double Your Chances","value":"double_your_chances","icon":"exposure_plus_1","color":"#2ECDA7"},{"text":"Quiz Intro","value":"quiz_intro","icon":"question_mark","color":"#3399FF"}],"allowNone":true}', NULL, NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 999;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

-- +goose Down

ALTER TABLE IF EXISTS "public"."lessons" DROP COLUMN IF EXISTS "intro_screen_code" CASCADE; --WARN: Drop column can occure in data loss!

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 999;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 859;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 831;

DELETE FROM "public"."directus_fields" WHERE "id" = 3045;

