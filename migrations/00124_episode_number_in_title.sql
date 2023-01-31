-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-31T13:38:14.199Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons" ADD COLUMN IF NOT EXISTS "episode_number_in_title" bool NULL  ;

COMMENT ON COLUMN "public"."seasons"."episode_number_in_title"  IS NULL;

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 202;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 215;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Readonly if sent","rule":{"_and":[{"send_started":{"_nnull":true}}]},"readonly":true,"options":{}}]' WHERE "id" = 743;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Clear Cache","value":"clear_cache"},{"text":"Deep Link","value":"deep_link"}],"allowNone":true}' WHERE "id" = 747;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1042, 'seasons', 'episode_number_in_title', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, 'I.e: "21. For min skyld"', NULL, false, 'metadata', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-31T13:38:15.884Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons" DROP COLUMN IF EXISTS "episode_number_in_title" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 202;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 215;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Clear Cache","value":"clear_cache"},{"text":"Deep Link","value":"deep_link"}]}' WHERE "id" = 747;

UPDATE "public"."directus_fields" SET "conditions" = NULL WHERE "id" = 743;

DELETE FROM "public"."directus_fields" WHERE "id" = 1042;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
