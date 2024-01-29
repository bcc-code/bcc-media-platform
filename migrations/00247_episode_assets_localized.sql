-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-29T12:32:40.504Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."episodes_assets_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_assets_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."episodes_assets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."episodes_assets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."episodes_assets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."episodes_assets_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_assets_id_seq" ---

--- BEGIN CREATE TABLE "public"."episodes_assets" ---

CREATE TABLE IF NOT EXISTS "public"."episodes_assets" (
	"id" int4 NOT NULL DEFAULT nextval('episodes_assets_id_seq'::regclass) ,
	"episodes_id" int4 NULL  ,
	"assets_id" int4 NULL  ,
	"language" varchar(255) NOT NULL  ,
	CONSTRAINT "episodes_assets_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "episodes_assets_assets_id_foreign" FOREIGN KEY (assets_id) REFERENCES assets(id) ON DELETE SET NULL ,
	CONSTRAINT "episodes_assets_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE SET NULL ,
	CONSTRAINT "episodes_assets_language_foreign" FOREIGN KEY (language) REFERENCES languages(code)
);

GRANT SELECT ON TABLE "public"."episodes_assets" TO directus, background_worker, onsite_backup, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."episodes_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."episodes_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."episodes_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."episodes_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."episodes_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."episodes_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."episodes_assets"."id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_assets"."episodes_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_assets"."assets_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_assets"."language"  IS NULL;

COMMENT ON CONSTRAINT "episodes_assets_pkey" ON "public"."episodes_assets" IS NULL;


COMMENT ON CONSTRAINT "episodes_assets_assets_id_foreign" ON "public"."episodes_assets" IS NULL;


COMMENT ON CONSTRAINT "episodes_assets_episodes_id_foreign" ON "public"."episodes_assets" IS NULL;


COMMENT ON CONSTRAINT "episodes_assets_language_foreign" ON "public"."episodes_assets" IS NULL;

COMMENT ON TABLE "public"."episodes_assets"  IS NULL;

--- END CREATE TABLE "public"."episodes_assets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1447, 'episodes', 'assets', 'm2m', 'list-m2m', '{"junctionFieldLocation":"top","template":"{{language}} - {{assets_id}}"}', 'related-values', NULL, false, false, 5, 'full', NULL, 'For localized assets', NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1450, 'episodes_assets', 'assets_id', NULL, 'select-dropdown-m2o', NULL, 'related-values', '{"template":"{{name}}"}', false, true, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1448, 'episodes_assets', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1449, 'episodes_assets', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1451, 'episodes_assets', 'language', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', 'related-values', '{"template":"{{name}}"}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "display" = 'related-values', "display_options" = '{"template":"{{name}}"}', "note" = 'Primary asset ID / fallback' WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 612;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('episodes_assets', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (436, 'episodes_assets', 'assets_id', 'assets', NULL, NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (437, 'episodes_assets', 'episodes_id', 'episodes', 'assets', NULL, NULL, 'assets_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (438, 'episodes_assets', 'language', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-29T12:32:42.120Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."episodes_assets" ---

DROP TABLE IF EXISTS "public"."episodes_assets";

--- END DROP TABLE "public"."episodes_assets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'episodes_assets';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "display" = NULL, "display_options" = NULL, "note" = NULL WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 612;

DELETE FROM "public"."directus_fields" WHERE "id" = 1447;

DELETE FROM "public"."directus_fields" WHERE "id" = 1450;

DELETE FROM "public"."directus_fields" WHERE "id" = 1448;

DELETE FROM "public"."directus_fields" WHERE "id" = 1449;

DELETE FROM "public"."directus_fields" WHERE "id" = 1451;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 436;

DELETE FROM "public"."directus_relations" WHERE "id" = 437;

DELETE FROM "public"."directus_relations" WHERE "id" = 438;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
