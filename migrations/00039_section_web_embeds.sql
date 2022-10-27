-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-27T12:42:56.731Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "embed_size" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."sections"."embed_size"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "needs_authentication" bool NULL  ;

COMMENT ON COLUMN "public"."sections"."needs_authentication"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "embed_url" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."sections"."embed_url"  IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 236;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (685, 'sections', 'embed_size', NULL, 'select-dropdown', '{"choices":[{"text":"16:9","value":"16:9"},{"text":"4:3","value":"4:3"},{"text":"9:16","value":"9:16"},{"text":"1:1","value":"1:1"}]}', 'raw', NULL, false, false, 2, 'half', NULL, NULL, '[]', false, 'embed_config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (687, 'sections', 'needs_authentication', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 3, 'half', NULL, 'Must an authentication token be passed on to the embed?', NULL, false, 'embed_config', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 246;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (686, 'sections', 'embed_config', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, true, 6, 'full', NULL, NULL, '[{"name":"show if embed","rule":{"_and":[{"type":{"_eq":"embed_web"}}]},"hidden":false,"options":{"accordionMode":true,"start":"closed"}}]', false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Item","value":"item"},{"text":"Message","value":"message"},{"text":"Embed (Web)","value":"embed_web"}]}' WHERE "id" = 536;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (688, 'sections', 'embed_url', NULL, 'input', NULL, 'raw', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'embed_config', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-27T12:42:58.028Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "embed_size" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "needs_authentication" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "embed_url" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 236;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 246;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Item","value":"item"},{"text":"Message","value":"message"}]}' WHERE "id" = 536;

DELETE FROM "public"."directus_fields" WHERE "id" = 685;

DELETE FROM "public"."directus_fields" WHERE "id" = 687;

DELETE FROM "public"."directus_fields" WHERE "id" = 686;

DELETE FROM "public"."directus_fields" WHERE "id" = 688;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
