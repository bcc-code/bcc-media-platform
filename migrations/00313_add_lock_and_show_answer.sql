-- +goose Up

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "show_answer" bool NOT NULL DEFAULT true ;
ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "lock_answer" bool NOT NULL DEFAULT false ;

UPDATE "public"."directus_fields" SET "sort" = 24 WHERE "id" = 895;
UPDATE "public"."directus_fields" SET "sort" = 23 WHERE "id" = 894;
UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 855;
UPDATE "public"."directus_fields" SET "sort" = 20 WHERE "id" = 879;
UPDATE "public"."directus_fields" SET "sort" = 22 WHERE "id" = 887;
UPDATE "public"."directus_fields" SET "sort" = 18, "width" = 'half', "conditions" = NULL WHERE "id" = 1040;
UPDATE "public"."directus_fields" SET "sort" = 21 WHERE "id" = 891;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3047, 'tasks', 'show_answer', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, true, 16, 'half', NULL, NULL, '[{"rule":{"_and":[{"type":{"_eq":"question"}},{"question_type":{"_eq":"alternatives"}}]},"hidden":false,"options":{"iconOn":"check_box","iconOff":"check_box_outline_blank","label":"Enabled"}}]', true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3048, 'tasks', 'lock_answer', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, true, 17, 'half', NULL, NULL, '[{"rule":{"_and":[{"type":{"_eq":"question"}},{"question_type":{"_eq":"alternatives"}}]},"hidden":false,"options":{"iconOn":"check_box","iconOff":"check_box_outline_blank","label":"Enabled"}}]', true, NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

-- +goose Down

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "show_answer" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "lock_answer" CASCADE; --WARN: Drop column can occure in data loss!

UPDATE "public"."directus_fields" SET "sort" = 21 WHERE "id" = 894;
UPDATE "public"."directus_fields" SET "sort" = 22 WHERE "id" = 895;
UPDATE "public"."directus_fields" SET "sort" = 16, "width" = 'full', "conditions" = '[{"name":"visible if alternatives","rule":{"_and":[{"_and":[{"question_type":{"_eq":"alternatives"}},{"type":{"_eq":"question"}}]}]},"options":{"iconOn":"check_box","iconOff":"check_box_outline_blank","label":"Enabled"},"hidden":false}]' WHERE "id" = 1040;
UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 855;
UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 879;
UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 891;
UPDATE "public"."directus_fields" SET "sort" = 20 WHERE "id" = 887;

DELETE FROM "public"."directus_fields" WHERE "id" = 3047;
DELETE FROM "public"."directus_fields" WHERE "id" = 3048;

