-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-11T11:15:44.449Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."collections_entries_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."collections_entries_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."collections_entries_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."collections_entries_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."collections_entries_id_seq" ---

--- BEGIN CREATE TABLE "public"."collections_entries" ---

CREATE TABLE IF NOT EXISTS "public"."collections_entries" (
	"id" int4 NOT NULL DEFAULT nextval('collections_entries_id_seq'::regclass) ,
	"collections_id" int4 NULL  ,
	"item" varchar(255) NULL  ,
	"collection" varchar(255) NULL  ,
	"sort" int4 NULL  ,
	CONSTRAINT "collections_entries_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "collections_entries_collections_id_foreign" FOREIGN KEY (collections_id) REFERENCES collections(id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."collections_entries" TO api, background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT, UPDATE, DELETE ON TABLE "public"."collections_entries" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."collections_entries"."id"  IS NULL;


COMMENT ON COLUMN "public"."collections_entries"."collections_id"  IS NULL;


COMMENT ON COLUMN "public"."collections_entries"."item"  IS NULL;


COMMENT ON COLUMN "public"."collections_entries"."collection"  IS NULL;


COMMENT ON COLUMN "public"."collections_entries"."sort"  IS NULL;

COMMENT ON TABLE "public"."collections_entries"  IS NULL;

--- END CREATE TABLE "public"."collections_entries" ---

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "label" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."episodes"."label"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons" ADD COLUMN IF NOT EXISTS "label" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."seasons"."label"  IS NULL;

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" ADD COLUMN IF NOT EXISTS "label" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."shows"."label"  IS NULL;

--- END ALTER TABLE "public"."shows" ---

--- BEGIN ALTER TABLE "public"."pages" ---

ALTER TABLE IF EXISTS "public"."pages" ADD COLUMN IF NOT EXISTS "label" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."pages"."label"  IS NULL;

--- END ALTER TABLE "public"."pages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}} | {{translations}}' WHERE "collection" = 'episodes';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}} | {{translations}}' WHERE "collection" = 'seasons';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}} | {{translations}}' WHERE "collection" = 'shows';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('collections_entries', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 137;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 144;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 203;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 216;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 214;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 220;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 191;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 261;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 271;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 279;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 280;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 264;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 265;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 613;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 399;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (702, 'collections_entries', 'sort', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (698, 'episodes', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 3, 'full', NULL, 'For internal use only', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 221;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 198;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (700, 'shows', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL, 'For internal use only', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 11, "width" = 'half' WHERE "id" = 689;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (693, 'collections', 'entries', 'm2a', 'list-m2a', '{"limit":100}', 'related-values', NULL, false, false, 8, 'full', NULL, NULL, '[{"label":"Hidden if not select","rule":{"_and":[{"filter_type":{"_neq":"select"}}]},"hidden":true,"options":{"enableSelect":true,"enableCreate":true,"limit":15,"allowDuplicates":false}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (696, 'collections_entries', 'item', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (699, 'seasons', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, 'For internal use only', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (694, 'collections_entries', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (695, 'collections_entries', 'collections_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (697, 'collections_entries', 'collection', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 684;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 566;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (701, 'pages', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 3, 'full', NULL, 'For internal use only', NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (214, 'collections_entries', 'item', NULL, NULL, 'collection', 'episodes,links,pages,seasons,shows', 'collections_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (215, 'collections_entries', 'collections_id', 'collections', 'entries', NULL, NULL, 'item', 'sort', 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- DATA MIGRATIONS

INSERT INTO collections_entries (collections_id, collection, item, sort)
SELECT
    ci.collection_id,
    'episodes',
    ci.episode_id,
    ci.sort
FROM collections_items ci
WHERE ci.episode_id IS NOT NULL AND ci.collection_id IS NOT NULL;

INSERT INTO collections_entries (collections_id, collection, item, sort)
SELECT
    ci.collection_id,
    'seasons',
    ci.season_id,
    ci.sort
FROM collections_items ci
WHERE ci.season_id IS NOT NULL AND ci.collection_id IS NOT NULL;

INSERT INTO collections_entries (collections_id, collection, item, sort)
SELECT
    ci.collection_id,
    'shows',
    ci.show_id,
    ci.sort
FROM collections_items ci
WHERE ci.show_id IS NOT NULL AND ci.collection_id IS NOT NULL;

UPDATE episodes t
SET label = (SELECT title
             FROM episodes_translations ts
             WHERE ts.episodes_id = t.id
               AND ts.languages_code = 'no'
               AND ts.title IS NOT NULL
             LIMIT 1);

UPDATE seasons t
SET label = (SELECT title
             FROM seasons_translations ts
             WHERE ts.seasons_id = t.id
               AND ts.languages_code = 'no'
               AND ts.title IS NOT NULL
             LIMIT 1);

UPDATE shows t
SET label = (SELECT title
             FROM shows_translations ts
             WHERE ts.shows_id = t.id
               AND ts.languages_code = 'no'
               AND ts.title IS NOT NULL
             LIMIT 1);

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-11T11:15:45.816Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."pages" ---

ALTER TABLE IF EXISTS "public"."pages" DROP COLUMN IF EXISTS "label" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."pages" ---

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons" DROP COLUMN IF EXISTS "label" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" DROP COLUMN IF EXISTS "label" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."shows" ---

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "label" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN DROP TABLE "public"."collections_entries" ---

DROP TABLE IF EXISTS "public"."collections_entries";

--- END DROP TABLE "public"."collections_entries" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{season_id.show_id.translations}} - {{translations}}' WHERE "collection" = 'episodes';

UPDATE "public"."directus_collections" SET "display_template" = '{{translations}}' WHERE "collection" = 'seasons';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}}' WHERE "collection" = 'shows';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'collections_entries';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 137;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 144;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 203;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 214;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 216;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 220;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 221;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 191;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 261;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 271;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 279;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 280;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 264;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 265;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 198;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 399;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 613;

UPDATE "public"."directus_fields" SET "sort" = 10, "width" = 'full' WHERE "id" = 689;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 684;

DELETE FROM "public"."directus_fields" WHERE "id" = 702;

DELETE FROM "public"."directus_fields" WHERE "id" = 698;

DELETE FROM "public"."directus_fields" WHERE "id" = 700;

DELETE FROM "public"."directus_fields" WHERE "id" = 693;

DELETE FROM "public"."directus_fields" WHERE "id" = 696;

DELETE FROM "public"."directus_fields" WHERE "id" = 699;

DELETE FROM "public"."directus_fields" WHERE "id" = 694;

DELETE FROM "public"."directus_fields" WHERE "id" = 695;

DELETE FROM "public"."directus_fields" WHERE "id" = 697;

DELETE FROM "public"."directus_fields" WHERE "id" = 701;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 214;

DELETE FROM "public"."directus_relations" WHERE "id" = 215;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
