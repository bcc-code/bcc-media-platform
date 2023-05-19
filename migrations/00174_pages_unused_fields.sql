-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-19T07:20:03.592Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."pages" ---

ALTER TABLE IF EXISTS "public"."pages" DROP COLUMN IF EXISTS "collection" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."pages" DROP COLUMN IF EXISTS "episode_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."pages" DROP COLUMN IF EXISTS "season_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."pages" DROP COLUMN IF EXISTS "show_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."pages" DROP COLUMN IF EXISTS "type" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."pages" DROP CONSTRAINT IF EXISTS "pages_collection_unique";

ALTER TABLE IF EXISTS "public"."pages" DROP CONSTRAINT IF EXISTS "pages_episode_id_foreign";

ALTER TABLE IF EXISTS "public"."pages" DROP CONSTRAINT IF EXISTS "pages_season_id_foreign";

ALTER TABLE IF EXISTS "public"."pages" DROP CONSTRAINT IF EXISTS "pages_show_id_foreign";

DROP INDEX IF EXISTS pages_collection_unique;

--- END ALTER TABLE "public"."pages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 393;

DELETE FROM "public"."directus_fields" WHERE "id" = 394;

DELETE FROM "public"."directus_fields" WHERE "id" = 397;

DELETE FROM "public"."directus_fields" WHERE "id" = 398;

DELETE FROM "public"."directus_fields" WHERE "id" = 401;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 113;

DELETE FROM "public"."directus_relations" WHERE "id" = 114;

DELETE FROM "public"."directus_relations" WHERE "id" = 115;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-19T07:20:05.469Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."pages" ---

ALTER TABLE IF EXISTS "public"."pages" ADD COLUMN IF NOT EXISTS "collection" varchar(255) NULL DEFAULT NULL::character varying ;

COMMENT ON COLUMN "public"."pages"."collection"  IS NULL;

ALTER TABLE IF EXISTS "public"."pages" ADD COLUMN IF NOT EXISTS "episode_id" int4 NULL  ;

COMMENT ON COLUMN "public"."pages"."episode_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."pages" ADD COLUMN IF NOT EXISTS "season_id" int4 NULL  ;

COMMENT ON COLUMN "public"."pages"."season_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."pages" ADD COLUMN IF NOT EXISTS "show_id" int4 NULL  ;

COMMENT ON COLUMN "public"."pages"."show_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."pages" ADD COLUMN IF NOT EXISTS "type" varchar(255) NULL DEFAULT 'custom'::character varying ;

COMMENT ON COLUMN "public"."pages"."type"  IS NULL;

ALTER TABLE IF EXISTS "public"."pages" ADD CONSTRAINT "pages_collection_unique" UNIQUE (collection);

COMMENT ON CONSTRAINT "pages_collection_unique" ON "public"."pages" IS NULL;

ALTER TABLE IF EXISTS "public"."pages" ADD CONSTRAINT "pages_episode_id_foreign" FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_episode_id_foreign" ON "public"."pages" IS NULL;

ALTER TABLE IF EXISTS "public"."pages" ADD CONSTRAINT "pages_season_id_foreign" FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_season_id_foreign" ON "public"."pages" IS NULL;

ALTER TABLE IF EXISTS "public"."pages" ADD CONSTRAINT "pages_show_id_foreign" FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_show_id_foreign" ON "public"."pages" IS NULL;

COMMENT ON INDEX "public"."pages_collection_unique"  IS NULL;

--- END ALTER TABLE "public"."pages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (393, 'pages', 'collection', NULL, 'select-dropdown', '{"choices":[{"text":"Shows","value":"shows"},{"text":"Seasons","value":"seasons"},{"text":"Episodes","value":"episodes"}]}', NULL, NULL, false, false, 5, 'half', NULL, NULL, '[{"name":"Hidden when not Default","rule":{"_and":[{"type":{"_neq":"default"}}]},"hidden":true,"options":{"allowOther":false,"allowNone":false}},{"name":"Required when Default","rule":{"_and":[{"type":{"_eq":"default"}}]},"readonly":false,"required":true,"options":{"allowOther":false,"allowNone":false}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (394, 'pages', 'episode_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', 'related-values', '{"template":"{{translations}}"}', false, false, 3, 'half', '[{"language":"en-US","translation":"Episode"}]', NULL, '[{"name":"Hide when not Episode","rule":{"_and":[{"type":{"_neq":"episode"}}]},"hidden":true,"options":{}},{"name":"Required when Episode","rule":{"_and":[{"type":{"_eq":"episode"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (397, 'pages', 'season_id', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, false, 4, 'half', '[{"language":"en-US","translation":"Season"}]', NULL, '[{"name":"Hidden if not Season","rule":{"_and":[{"type":{"_neq":"season"}}]},"hidden":true,"options":{}},{"name":"Required if Season","rule":{"_and":[{"type":{"_eq":"season"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (398, 'pages', 'show_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', 'related-values', '{"template":"{{translations}}"}', false, false, 2, 'half', '[{"language":"en-US","translation":"Show"}]', NULL, '[{"name":"Hide when not Show","rule":{"_and":[{"type":{"_neq":"show"}}]},"hidden":true,"options":{}},{"name":"Required when Show","rule":{"_and":[{"type":{"_eq":"show"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (401, 'pages', 'type', NULL, 'select-dropdown', '{"allowNone":true,"choices":[{"text":"Custom","value":"custom"},{"text":"Default","value":"default"},{"text":"Show","value":"show"},{"text":"Season","value":"season"},{"text":"Episode","value":"episode"}],"icon":"abc"}', 'formatted-value', NULL, false, true, 1, 'half', NULL, NULL, NULL, false, 'relations', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (113, 'pages', 'episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (114, 'pages', 'season_id', 'seasons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (115, 'pages', 'show_id', 'shows', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
