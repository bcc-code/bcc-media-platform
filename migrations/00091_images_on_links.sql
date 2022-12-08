-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-08T14:46:21.105Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "secondary_title" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."tasks"."secondary_title"  IS NULL;

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."tasks"."description"  IS NULL;

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

ALTER TABLE IF EXISTS "public"."tasks_translations" ADD COLUMN IF NOT EXISTS "secondary_title" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."tasks_translations"."secondary_title"  IS NULL;

ALTER TABLE IF EXISTS "public"."tasks_translations" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."tasks_translations"."description"  IS NULL;

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (892, 'tasks_translations', 'secondary_title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (893, 'tasks_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (894, 'tasks', 'secondary_title', NULL, 'input', NULL, 'raw', NULL, false, true, 19, 'full', NULL, NULL, '[{"name":"shown if video or link","rule":{"_and":[{"type":{"_in":["video","link"]}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (895, 'tasks', 'description', NULL, 'input', NULL, 'raw', NULL, false, true, 20, 'full', NULL, NULL, '[{"name":"shown if video or link","rule":{"_and":[{"type":{"_in":["video","link"]}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if image or link","rule":{"_and":[{"type":{"_in":["image","link"]}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 887;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-08T14:46:22.692Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

ALTER TABLE IF EXISTS "public"."tasks_translations" DROP COLUMN IF EXISTS "secondary_title" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."tasks_translations" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "secondary_title" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if image","rule":{"_and":[{"type":{"_eq":"image"}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 887;

DELETE FROM "public"."directus_fields" WHERE "id" = 892;

DELETE FROM "public"."directus_fields" WHERE "id" = 893;

DELETE FROM "public"."directus_fields" WHERE "id" = 894;

DELETE FROM "public"."directus_fields" WHERE "id" = 895;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
