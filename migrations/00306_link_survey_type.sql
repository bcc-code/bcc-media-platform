-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2024-11-11T09:33:10.307Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."surveyquestions" ADD COLUMN IF NOT EXISTS "url" varchar(255) NULL  ;
ALTER TABLE IF EXISTS "public"."surveyquestions" ADD COLUMN IF NOT EXISTS "action_button_text" varchar(255) NULL DEFAULT NULL::character varying ;
ALTER TABLE IF EXISTS "public"."surveyquestions" ADD COLUMN IF NOT EXISTS "cancel_button_text" varchar(255) NULL DEFAULT NULL::character varying ;

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" ADD COLUMN IF NOT EXISTS "action_button_text" text NULL  ;
ALTER TABLE IF EXISTS "public"."surveyquestions_translations" ADD COLUMN IF NOT EXISTS "cancel_button_text" text NULL  ;

UPDATE "public"."directus_fields" SET "options" = '{"layout":"table","fields":["label","seconds","title"],"enableSelect":false}' WHERE "id" = 1298;
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3043, 'surveyquestions', 'cancel_button_text', NULL, 'input', '{"softLength":30,"trim":true}', 'raw', NULL, false, true, 15, 'full', NULL, 'Helper text.', '[{"name":"type == link","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3042, 'surveyquestions', 'action_button_text', NULL, 'input', '{"softLength":30}', 'raw', NULL, false, true, 14, 'full', NULL, 'Text that appears on the "Call to action" button.', '[{"name":"type == link","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3041, 'surveyquestions', 'url', NULL, 'input', '{"placeholder":"https://www.example.com/","trim":true}', NULL, NULL, false, true, 13, 'full', NULL, NULL, '[{"name":"if Type=Link","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', true, NULL, '{"_and":[{"_or":[{"_and":[{"type":{"_in":["link"]}},{"url":{"_nnull":true}}]},{"type":{"_nin":["link"]}}]}]}', NULL);
UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"text","value":"text"},{"text":"rating","value":"rating"},{"text":"link","value":"link","icon":"dataset_linked"}]}' WHERE "id" = 1064;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2024-11-11T09:33:11.433Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"text","value":"text"},{"text":"rating","value":"rating"}]}' WHERE "id" = 1064;
UPDATE "public"."directus_fields" SET "options" = '{"layout":"table","fields":["label","timestamp","title"],"enableSelect":false}' WHERE "id" = 1298;
DELETE FROM "public"."directus_fields" WHERE "id" = 3043;
DELETE FROM "public"."directus_fields" WHERE "id" = 3042;
DELETE FROM "public"."directus_fields" WHERE "id" = 3041;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

ALTER TABLE IF EXISTS "public"."surveyquestions" DROP COLUMN IF EXISTS "url";
ALTER TABLE IF EXISTS "public"."surveyquestions" DROP COLUMN IF EXISTS "action_button_text";
ALTER TABLE IF EXISTS "public"."surveyquestions" DROP COLUMN IF EXISTS "cancel_button_text";

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" DROP COLUMN IF EXISTS "action_button_text";
ALTER TABLE IF EXISTS "public"."surveyquestions_translations" DROP COLUMN IF EXISTS "cancel_button_text";
