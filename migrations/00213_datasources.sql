-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-29T09:00:10.392Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."datasources_styledimages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."datasources_styledimages_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."datasources_styledimages_id_seq" OWNER TO manager;
GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."datasources_styledimages_id_seq" TO manager, directus, background_worker, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."datasources_styledimages_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."datasources_styledimages_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."datasources_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."datasources_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."datasources_translations_id_seq" OWNER TO manager;
GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."datasources_translations_id_seq" TO manager, directus, background_worker, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."datasources_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."datasources_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."datasources" ---

CREATE TABLE IF NOT EXISTS "public"."datasources" (
                                                      "id" uuid NOT NULL  ,
                                                      "title" text NOT NULL  ,
                                                      "description" text NULL  ,
                                                      "has_translations" bool NOT NULL DEFAULT false ,
                                                      "key" varchar(255) NOT NULL  ,
                                                      CONSTRAINT "datasources_key_unique" UNIQUE (key) ,
                                                      CONSTRAINT "datasources_pkey" PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS datasources_key_unique ON public.datasources USING btree (key);

ALTER TABLE IF EXISTS "public"."datasources" OWNER TO manager;

GRANT SELECT ON TABLE "public"."datasources" TO manager, directus, background_worker, api, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."datasources"."id"  IS NULL;


COMMENT ON COLUMN "public"."datasources"."title"  IS NULL;


COMMENT ON COLUMN "public"."datasources"."description"  IS NULL;


COMMENT ON COLUMN "public"."datasources"."has_translations"  IS NULL;


COMMENT ON COLUMN "public"."datasources"."key"  IS NULL;

COMMENT ON CONSTRAINT "datasources_key_unique" ON "public"."datasources" IS NULL;


COMMENT ON CONSTRAINT "datasources_pkey" ON "public"."datasources" IS NULL;

COMMENT ON INDEX "public"."datasources_key_unique"  IS NULL;

COMMENT ON TABLE "public"."datasources"  IS NULL;

--- END CREATE TABLE "public"."datasources" ---

--- BEGIN CREATE TABLE "public"."datasources_styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."datasources_styledimages" (
	"id" int4 NOT NULL DEFAULT nextval('datasources_styledimages_id_seq'::regclass) ,
	"datasources_id" uuid NULL  ,
	"styledimages_id" uuid NULL  ,
	CONSTRAINT "datasources_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages(id) ON DELETE CASCADE ,
	CONSTRAINT "datasources_styledimages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "datasources_styledimages_datasources_id_foreign" FOREIGN KEY (datasources_id) REFERENCES datasources(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."datasources_styledimages" OWNER TO manager;

GRANT SELECT ON TABLE "public"."datasources_styledimages" TO manager, directus, background_worker, api, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_styledimages" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_styledimages" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_styledimages" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_styledimages" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_styledimages" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_styledimages" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."datasources_styledimages"."id"  IS NULL;


COMMENT ON COLUMN "public"."datasources_styledimages"."datasources_id"  IS NULL;


COMMENT ON COLUMN "public"."datasources_styledimages"."styledimages_id"  IS NULL;

COMMENT ON CONSTRAINT "datasources_styledimages_styledimages_id_foreign" ON "public"."datasources_styledimages" IS NULL;


COMMENT ON CONSTRAINT "datasources_styledimages_pkey" ON "public"."datasources_styledimages" IS NULL;


COMMENT ON CONSTRAINT "datasources_styledimages_datasources_id_foreign" ON "public"."datasources_styledimages" IS NULL;

COMMENT ON TABLE "public"."datasources_styledimages"  IS NULL;

--- END CREATE TABLE "public"."datasources_styledimages" ---

--- BEGIN CREATE TABLE "public"."datasources_translations" ---

CREATE TABLE IF NOT EXISTS "public"."datasources_translations" (
	"id" int4 NOT NULL DEFAULT nextval('datasources_translations_id_seq'::regclass) ,
	"datasources_id" uuid NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" text NULL  ,
	"description" text NULL  ,
	CONSTRAINT "datasources_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "datasources_translations_datasources_id_foreign" FOREIGN KEY (datasources_id) REFERENCES datasources(id) ON DELETE SET NULL ,
	CONSTRAINT "datasources_translations_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."datasources_translations" OWNER TO manager;

GRANT SELECT ON TABLE "public"."datasources_translations" TO manager, directus, background_worker, api, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_translations" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_translations" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_translations" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_translations" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_translations" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_translations" TO manager, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."datasources_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."datasources_translations"."datasources_id"  IS NULL;


COMMENT ON COLUMN "public"."datasources_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."datasources_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."datasources_translations"."description"  IS NULL;

COMMENT ON CONSTRAINT "datasources_translations_languages_code_foreign" ON "public"."datasources_translations" IS NULL;


COMMENT ON CONSTRAINT "datasources_translations_datasources_id_foreign" ON "public"."datasources_translations" IS NULL;


COMMENT ON CONSTRAINT "datasources_translations_pkey" ON "public"."datasources_translations" IS NULL;

COMMENT ON TABLE "public"."datasources_translations"  IS NULL;

--- END CREATE TABLE "public"."datasources_translations" ---

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata"
	ALTER COLUMN "title" DROP NOT NULL,
	ALTER COLUMN "title" SET DEFAULT ' '::text;

ALTER TABLE IF EXISTS "public"."timedmetadata" ADD COLUMN IF NOT EXISTS "datasource_id" uuid NULL  ;

COMMENT ON COLUMN "public"."timedmetadata"."datasource_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

ALTER TABLE IF EXISTS "public"."timedmetadata" ADD CONSTRAINT "timedmetadata_datasource_id_foreign" FOREIGN KEY (datasource_id) REFERENCES datasources(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "timedmetadata_datasource_id_foreign" ON "public"."timedmetadata" IS NULL;

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1278, 'datasources', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1281, 'datasources', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1286, 'datasources', 'has_translations', 'cast-boolean', NULL, NULL, NULL, NULL, false, false, 3, 'half', NULL, 'Check this if the source should have translations', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1283, 'datasources_styledimages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1284, 'datasources_styledimages', 'datasources_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1285, 'datasources_styledimages', 'styledimages_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1282, 'datasources', 'images', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1280, 'datasources', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1287, 'datasources', 'key', NULL, 'input', '{"placeholder":null}', 'raw', NULL, false, false, 2, 'half', NULL, 'Used as a key to identify against external sources.', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1289, 'datasources_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1290, 'datasources_translations', 'datasources_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1288, 'datasources', 'translations', 'translations', 'translations', '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"en","userLanguage":true}', NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'source_translations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1291, 'datasources_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 9, "group" = NULL WHERE "id" = 1238;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1292, 'datasources_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1293, 'datasources_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1294, 'datasources', 'source_translations', 'alias,no-data,group', 'group-detail', '{"start":"closed"}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1233;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1296, 'timedmetadata', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 2, 'full', NULL, NULL, NULL, false, 'details', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 11, "group" = NULL WHERE "id" = 1232;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1295, 'timedmetadata', 'datasource_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 12, 'full', NULL, 'Use title, description and images from this source.', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 10, "group" = NULL WHERE "id" = 1231;

UPDATE "public"."directus_fields" SET "sort" = 13, "conditions" = '[{"name":"Hide if Source is set","rule":{"_and":[{"datasource_id":{"_nnull":true}}]},"hidden":true,"options":{"start":"open"}}]' WHERE "id" = 1235;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 1239;

DELETE FROM "public"."directus_fields" WHERE "id" = 1234;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'config';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url")  VALUES ('datasources_styledimages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 18, NULL, 'open', NULL);

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'faqs_group';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'materialized_views_meta';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url")  VALUES ('datasources_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 19, NULL, 'open', NULL);

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'notifications_group';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url")  VALUES ('datasources', 'database', 'Sources for storing data used elsewhere in the system.', '{{title}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 4, NULL, 'open', NULL);

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'achievements_group';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'computeddata_group';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'messages_group';

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'applications_group';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'images';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (905, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (906, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (907, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (908, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (909, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (910, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (911, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (912, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (913, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (914, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (915, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (916, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (917, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (918, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (919, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (390, 'datasources_styledimages', 'styledimages_id', 'styledimages', NULL, NULL, NULL, 'datasources_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (391, 'datasources_styledimages', 'datasources_id', 'datasources', 'images', NULL, NULL, 'styledimages_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (392, 'datasources_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'datasources_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (393, 'datasources_translations', 'datasources_id', 'datasources', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (394, 'timedmetadata', 'datasource_id', 'datasources', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-29T09:00:12.288Z             ***/
/***********************************************************/

--- BEGIN ALTER SEQUENCE "public"."faqs_translations_id_seq1" ---

GRANT USAGE ON SEQUENCE "public"."faqs_translations_id_seq1" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_translations_id_seq1" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."faqs_translations_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."faqs_translations_id_seq" ---

REVOKE USAGE ON SEQUENCE "public"."faqs_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."faqs_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."faqs_translations_id_seq" ---

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata"
	ALTER COLUMN "title" SET NOT NULL,
	ALTER COLUMN "title" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."timedmetadata"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

ALTER TABLE IF EXISTS "public"."timedmetadata" DROP COLUMN IF EXISTS "datasource_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."timedmetadata" DROP CONSTRAINT IF EXISTS "timedmetadata_datasource_id_foreign";

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN DROP TABLE "public"."datasources_styledimages" ---

DROP TABLE IF EXISTS "public"."datasources_styledimages";

--- END DROP TABLE "public"."datasources_styledimages" ---

--- BEGIN DROP TABLE "public"."datasources_translations" ---

DROP TABLE IF EXISTS "public"."datasources_translations";

--- END DROP TABLE "public"."datasources_translations" ---

--- BEGIN DROP TABLE "public"."datasources" ---

DROP TABLE IF EXISTS "public"."datasources";

--- END DROP TABLE "public"."datasources" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'faqs_group';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'notifications_group';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'computeddata_group';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'applications_group';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'images';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'translations';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'messages_group';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'achievements_group';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'datasources_styledimages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'datasources_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'datasources';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 1, "group" = 'details' WHERE "id" = 1238;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'details' WHERE "id" = 1232;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1233;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1234, 'timedmetadata', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'details', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 9, "conditions" = NULL WHERE "id" = 1235;

UPDATE "public"."directus_fields" SET "sort" = 2, "group" = 'details' WHERE "id" = 1231;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 1239;

DELETE FROM "public"."directus_fields" WHERE "id" = 1278;

DELETE FROM "public"."directus_fields" WHERE "id" = 1281;

DELETE FROM "public"."directus_fields" WHERE "id" = 1286;

DELETE FROM "public"."directus_fields" WHERE "id" = 1283;

DELETE FROM "public"."directus_fields" WHERE "id" = 1284;

DELETE FROM "public"."directus_fields" WHERE "id" = 1285;

DELETE FROM "public"."directus_fields" WHERE "id" = 1282;

DELETE FROM "public"."directus_fields" WHERE "id" = 1280;

DELETE FROM "public"."directus_fields" WHERE "id" = 1287;

DELETE FROM "public"."directus_fields" WHERE "id" = 1289;

DELETE FROM "public"."directus_fields" WHERE "id" = 1290;

DELETE FROM "public"."directus_fields" WHERE "id" = 1288;

DELETE FROM "public"."directus_fields" WHERE "id" = 1291;

DELETE FROM "public"."directus_fields" WHERE "id" = 1292;

DELETE FROM "public"."directus_fields" WHERE "id" = 1293;

DELETE FROM "public"."directus_fields" WHERE "id" = 1294;

DELETE FROM "public"."directus_fields" WHERE "id" = 1296;

DELETE FROM "public"."directus_fields" WHERE "id" = 1295;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 905;

DELETE FROM "public"."directus_permissions" WHERE "id" = 906;

DELETE FROM "public"."directus_permissions" WHERE "id" = 907;

DELETE FROM "public"."directus_permissions" WHERE "id" = 908;

DELETE FROM "public"."directus_permissions" WHERE "id" = 909;

DELETE FROM "public"."directus_permissions" WHERE "id" = 910;

DELETE FROM "public"."directus_permissions" WHERE "id" = 911;

DELETE FROM "public"."directus_permissions" WHERE "id" = 912;

DELETE FROM "public"."directus_permissions" WHERE "id" = 913;

DELETE FROM "public"."directus_permissions" WHERE "id" = 914;

DELETE FROM "public"."directus_permissions" WHERE "id" = 915;

DELETE FROM "public"."directus_permissions" WHERE "id" = 916;

DELETE FROM "public"."directus_permissions" WHERE "id" = 917;

DELETE FROM "public"."directus_permissions" WHERE "id" = 918;

DELETE FROM "public"."directus_permissions" WHERE "id" = 919;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 390;

DELETE FROM "public"."directus_relations" WHERE "id" = 391;

DELETE FROM "public"."directus_relations" WHERE "id" = 392;

DELETE FROM "public"."directus_relations" WHERE "id" = 393;

DELETE FROM "public"."directus_relations" WHERE "id" = 394;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
