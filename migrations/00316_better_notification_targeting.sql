-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-05-15T08:54:37.378Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."targets" ADD COLUMN IF NOT EXISTS "application_minimum_build_number" int4;
ALTER TABLE IF EXISTS "public"."targets" ADD COLUMN IF NOT EXISTS "application_maximum_build_number" int4;
ALTER TABLE IF EXISTS "public"."targets" ADD COLUMN IF NOT EXISTS "inactive_days_max" int4;
ALTER TABLE IF EXISTS "public"."targets" ADD COLUMN IF NOT EXISTS "inactive_days_min" int4;
ALTER TABLE IF EXISTS "public"."targets" ADD COLUMN IF NOT EXISTS "languages" jsonb NULL DEFAULT '[]';
ALTER TABLE IF EXISTS "public"."targets" ADD COLUMN IF NOT EXISTS "device_os" jsonb NULL DEFAULT '[]';

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3049, 'targets', 'application_minimum_build_number', NULL, 'input', '{"min":0,"max":99999999999}', 'raw', NULL, false, false, 5, 'full', NULL, 'Users Build Number =< This value', NULL, true, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3051, 'targets', 'application_maximum_build_number', NULL, 'input', '{"min":0,"max":2147483647}', 'raw', NULL, false, false, 6, 'full', NULL, 'Users Build Number >= This value', NULL, true, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3052, 'targets', 'inactive_days_max', NULL, 'input', '{"min":0,"max":365}', 'raw', NULL, false, false, 8, 'full', NULL, 'Minimum days since user last used the app, including the value.', NULL, true, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3053, 'targets', 'inactive_days_min', NULL, 'input', '{"min":0,"max":365}', 'raw', NULL, false, false, 9, 'full', NULL, 'Maximum days since user last used the app, including the value.', NULL, true, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3058, 'targets', 'languages', 'cast-json', 'select-multiple-checkbox', '{"choices":[{"text":"German","value":"de"},{"text":"English","value":"en"},{"text":"Spanish","value":"es"},{"text":"Finnish","value":"fi"},{"text":"French","value":"fr"},{"text":"Hungarian","value":"hu"},{"text":"Italian","value":"it"},{"text":"Dutch","value":"nl"},{"text":"Norwegian","value":"no"},{"text":"Polish","value":"pl"},{"text":"Portuguese","value":"pt"},{"text":"Romanian","value":"ro"},{"text":"Russian","value":"ru"},{"text":"Slovenian","value":"sl"},{"text":"Turkish","value":"tr"},{"text":"Danish","value":"da"},{"text":"Bulgarian","value":"bg"}],"itemsShown":20}', 'labels', NULL, false, false, 10, 'full', NULL, 'If nothing is selected the message will be sent to all languages', NULL, true, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3059, 'targets', 'device_os', 'cast-json', 'select-multiple-checkbox', '{"choices":[{"text":"iOs","value":"ios"},{"text":"tvOS","value":"tvos"},{"text":"Android","value":"android"}]}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

ALTER TABLE users.devices ADD os TEXT;
ALTER TABLE users.devices ADD app_build_number INTEGER NOT NULl DEFAULT -1;

-- +goose Down

ALTER TABLE IF EXISTS "public"."targets" DROP COLUMN IF EXISTS "application_minimum_build_number" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."targets" DROP COLUMN IF EXISTS "application_maximum_build_number" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."targets" DROP COLUMN IF EXISTS "inactive_days_max" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."targets" DROP COLUMN IF EXISTS "inactive_days_min" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."targets" DROP COLUMN IF EXISTS "languages" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."targets" DROP COLUMN IF EXISTS "device_os" CASCADE; --WARN: Drop column can occure in data loss!


DELETE FROM "public"."directus_fields" WHERE "id" = 3049;
DELETE FROM "public"."directus_fields" WHERE "id" = 3051;
DELETE FROM "public"."directus_fields" WHERE "id" = 3052;
DELETE FROM "public"."directus_fields" WHERE "id" = 3053;
DELETE FROM "public"."directus_fields" WHERE "id" = 3058;
DELETE FROM "public"."directus_fields" WHERE "id" = 3059;

ALTER TABLE users.devices DROP COLUMN IF EXISTS os;
ALTER TABLE users.devices DROP COLUMN IF EXISTS app_build_number;
