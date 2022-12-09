-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-09T13:47:17.418Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links" ADD COLUMN IF NOT EXISTS "type" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."links"."type"  IS NULL;

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "link_id" int4 NULL  ;

COMMENT ON COLUMN "public"."tasks"."link_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "link" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."tasks" ADD CONSTRAINT "tasks_link_id_foreign" FOREIGN KEY (link_id) REFERENCES links(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tasks_link_id_foreign" ON "public"."tasks" IS NULL;

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 2, "group" = 'studies' WHERE "collection" = 'lessons';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 855;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 872;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 818;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (898, 'links', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Text","value":"text"},{"text":"Audio","value":"audio"},{"text":"Video","value":"video"},{"text":"Other","value":"other"}]}', 'labels', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (900, 'tasks', 'link_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 11, 'full', NULL, NULL, '[{"name":"show if link","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{"enableCreate":true,"enableSelect":true}}]', false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 807;

DELETE FROM "public"."directus_fields" WHERE "id" = 889;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (273, 'tasks', 'link_id', 'links', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-09T13:47:18.966Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links" DROP COLUMN IF EXISTS "type" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "link" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."tasks"."link"  IS NULL;

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "link_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."tasks" DROP CONSTRAINT IF EXISTS "tasks_link_id_foreign";

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'studytopics' WHERE "collection" = 'lessons';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 855;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 807;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 872;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 818;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (889, 'tasks', 'link', NULL, 'input', NULL, 'raw', NULL, false, true, NULL, 'full', NULL, NULL, '[{"name":"show if link","hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 898;

DELETE FROM "public"."directus_fields" WHERE "id" = 900;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 273;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
