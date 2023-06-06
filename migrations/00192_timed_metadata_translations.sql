-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-05T11:54:25.822Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."timedmetadata_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."timedmetadata_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."timedmetadata_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."timedmetadata_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."timedmetadata_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."timedmetadata_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."timedmetadata_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."timedmetadata_translations" ---

CREATE TABLE IF NOT EXISTS "public"."timedmetadata_translations" (
	"id" int4 NOT NULL DEFAULT nextval('timedmetadata_translations_id_seq'::regclass) ,
	"timedmetadata_id" uuid NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" text NULL  ,
	"description" text NULL  ,
	CONSTRAINT "timedmetadata_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "timedmetadata_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "timedmetadata_translations_timedmetadata_id_foreign" FOREIGN KEY (timedmetadata_id) REFERENCES timedmetadata(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."timedmetadata_translations" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."timedmetadata_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."timedmetadata_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."timedmetadata_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."timedmetadata_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."timedmetadata_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."timedmetadata_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."timedmetadata_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_translations"."timedmetadata_id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_translations"."description"  IS NULL;

COMMENT ON CONSTRAINT "timedmetadata_translations_pkey" ON "public"."timedmetadata_translations" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_translations_languages_code_foreign" ON "public"."timedmetadata_translations" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_translations_timedmetadata_id_foreign" ON "public"."timedmetadata_translations" IS NULL;

COMMENT ON TABLE "public"."timedmetadata_translations"  IS NULL;

--- END CREATE TABLE "public"."timedmetadata_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url")  VALUES ('timedmetadata_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1240, 'timedmetadata_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1241, 'timedmetadata_translations', 'timedmetadata_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1242, 'timedmetadata_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1239, 'timedmetadata', 'translations', 'translations', 'translations', '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"no","userLanguage":true}', 'translations', NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1244, 'timedmetadata_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1243, 'timedmetadata_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (380, 'timedmetadata_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'timedmetadata_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (381, 'timedmetadata_translations', 'timedmetadata_id', 'timedmetadata', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-05T11:54:27.651Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."timedmetadata_translations" ---

DROP TABLE IF EXISTS "public"."timedmetadata_translations";

--- END DROP TABLE "public"."timedmetadata_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'timedmetadata_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"enableSelect":false,"template":"{{timestamp}} - {{label}}"}', "display_options" = '{"template":"{{timestamp}} - {{label}}"}' WHERE "id" = 1237;

DELETE FROM "public"."directus_fields" WHERE "id" = 1240;

DELETE FROM "public"."directus_fields" WHERE "id" = 1241;

DELETE FROM "public"."directus_fields" WHERE "id" = 1242;

DELETE FROM "public"."directus_fields" WHERE "id" = 1239;

DELETE FROM "public"."directus_fields" WHERE "id" = 1244;

DELETE FROM "public"."directus_fields" WHERE "id" = 1243;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 380;

DELETE FROM "public"."directus_relations" WHERE "id" = 381;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
