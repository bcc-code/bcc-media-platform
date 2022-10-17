-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-14T10:02:21.632Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."links_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."links_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

COMMENT ON SEQUENCE "public"."links_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."links_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."links_translations" ---

CREATE TABLE IF NOT EXISTS "public"."links_translations" (
	"id" int4 NOT NULL DEFAULT nextval('links_translations_id_seq'::regclass) ,
	"links_id" int4 NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" varchar(255) NOT NULL  ,
	"description" varchar(255) NOT NULL  ,
	CONSTRAINT "links_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "links_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "links_translations_links_id_foreign" FOREIGN KEY (links_id) REFERENCES links(id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."links_translations" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."links_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."links_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."links_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."links_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."links_translations"."links_id"  IS NULL;


COMMENT ON COLUMN "public"."links_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."links_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."links_translations"."description"  IS NULL;

COMMENT ON CONSTRAINT "links_translations_pkey" ON "public"."links_translations" IS NULL;


COMMENT ON CONSTRAINT "links_translations_languages_code_foreign" ON "public"."links_translations" IS NULL;


COMMENT ON CONSTRAINT "links_translations_links_id_foreign" ON "public"."links_translations" IS NULL;

COMMENT ON TABLE "public"."links_translations"  IS NULL;

--- END CREATE TABLE "public"."links_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('links_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (645, 'links_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (646, 'links_translations', 'links_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (647, 'links_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (644, 'links', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (648, 'links_translations', 'title', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (649, 'links_translations', 'description', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (199, 'links_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'links_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (200, 'links_translations', 'links_id', 'links', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-14T10:02:22.802Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."links_translations" ---

DROP TABLE IF EXISTS "public"."links_translations";

--- END DROP TABLE "public"."links_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'links_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 645;

DELETE FROM "public"."directus_fields" WHERE "id" = 646;

DELETE FROM "public"."directus_fields" WHERE "id" = 647;

DELETE FROM "public"."directus_fields" WHERE "id" = 644;

DELETE FROM "public"."directus_fields" WHERE "id" = 648;

DELETE FROM "public"."directus_fields" WHERE "id" = 649;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 199;

DELETE FROM "public"."directus_relations" WHERE "id" = 200;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
