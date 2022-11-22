-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-22T07:29:13.612Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."collections_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."collections_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."collections_translations_id_seq" OWNER TO builder;

GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."collections_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."collections_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."collections_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."collections_translations" ---

CREATE TABLE IF NOT EXISTS "public"."collections_translations" (
	"id" int4 NOT NULL DEFAULT nextval('collections_translations_id_seq'::regclass) ,
	"collections_id" int4 NULL  ,
	"languages_code" varchar(255) NULL  ,
	"slug" varchar(255) NULL  ,
	"title" varchar(255) NULL  ,
	CONSTRAINT "collections_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "collections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "collections_translations_collections_id_foreign" FOREIGN KEY (collections_id) REFERENCES collections(id) ON DELETE SET NULL ,
	CONSTRAINT "collections_translations_slug_unique" UNIQUE (slug)
);

CREATE UNIQUE INDEX IF NOT EXISTS collections_translations_slug_unique ON public.collections_translations USING btree (slug);

ALTER TABLE IF EXISTS "public"."collections_translations" OWNER TO builder;

GRANT SELECT ON TABLE "public"."collections_translations" TO api;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."collections_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."collections_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."collections_translations"."collections_id"  IS NULL;


COMMENT ON COLUMN "public"."collections_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."collections_translations"."slug"  IS NULL;


COMMENT ON COLUMN "public"."collections_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "collections_translations_pkey" ON "public"."collections_translations" IS NULL;


COMMENT ON CONSTRAINT "collections_translations_languages_code_foreign" ON "public"."collections_translations" IS NULL;


COMMENT ON CONSTRAINT "collections_translations_collections_id_foreign" ON "public"."collections_translations" IS NULL;


COMMENT ON CONSTRAINT "collections_translations_slug_unique" ON "public"."collections_translations" IS NULL;

COMMENT ON INDEX "public"."collections_translations_slug_unique"  IS NULL;

COMMENT ON TABLE "public"."collections_translations"  IS NULL;

--- END CREATE TABLE "public"."collections_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'collections_items';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'messages';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'materialized_views_meta';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('collections_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'collections', 'open');

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'applications_usergroups';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 386;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 389;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (775, 'collections', 'translations', 'translations', 'translations', '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"no","userLanguage":true}', 'translations', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (776, 'collections_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (777, 'collections_translations', 'collections_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (778, 'collections_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 684;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 388;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (779, 'collections_translations', 'slug', NULL, 'input', '{"trim":true,"slug":true}', 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 705;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 693;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (780, 'collections_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 85;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 703;

UPDATE "public"."directus_fields" SET "translations" = '[{"language":"en-US","translation":"Label"}]' WHERE "id" = 389;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (235, 'collections_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'collections_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (236, 'collections_translations', 'collections_id', 'collections', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-22T07:29:15.021Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."collections_translations" ---

UPDATE "public"."directus_fields" SET "translations" = NULL WHERE "id" = 389;

DROP TABLE IF EXISTS "public"."collections_translations";

--- END DROP TABLE "public"."collections_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'collections_items';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'messages';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'ageratings_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'collections_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 85;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 388;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 389;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 386;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 684;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 693;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 703;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 705;

DELETE FROM "public"."directus_fields" WHERE "id" = 775;

DELETE FROM "public"."directus_fields" WHERE "id" = 776;

DELETE FROM "public"."directus_fields" WHERE "id" = 777;

DELETE FROM "public"."directus_fields" WHERE "id" = 778;

DELETE FROM "public"."directus_fields" WHERE "id" = 779;

DELETE FROM "public"."directus_fields" WHERE "id" = 780;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 235;

DELETE FROM "public"."directus_relations" WHERE "id" = 236;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
