-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-15T09:25:21.362Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."applicationgroups_usergroups_ls_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" ---

--- BEGIN CREATE TABLE "public"."applicationgroups_usergroups_ls" ---

CREATE TABLE IF NOT EXISTS "public"."applicationgroups_usergroups_ls" (
	"id" int4 NOT NULL DEFAULT nextval('applicationgroups_usergroups_ls_id_seq'::regclass) ,
	"applicationgroups_id" uuid NULL  ,
	"usergroups_code" varchar(255) NULL  ,
	CONSTRAINT "applicationgroups_usergroups_ls_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "applicationgroups_usergroups_ls_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE SET NULL ,
	CONSTRAINT "applicationgroups_usergroups_ls_applicationgroups_id_foreign" FOREIGN KEY (applicationgroups_id) REFERENCES applicationgroups(id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."applicationgroups_usergroups_ls" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."applicationgroups_usergroups_ls" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."applicationgroups_usergroups_ls" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."applicationgroups_usergroups_ls" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."applicationgroups_usergroups_ls" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."applicationgroups_usergroups_ls" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."applicationgroups_usergroups_ls" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."applicationgroups_usergroups_ls"."id"  IS NULL;


COMMENT ON COLUMN "public"."applicationgroups_usergroups_ls"."applicationgroups_id"  IS NULL;


COMMENT ON COLUMN "public"."applicationgroups_usergroups_ls"."usergroups_code"  IS NULL;

COMMENT ON CONSTRAINT "applicationgroups_usergroups_ls_pkey" ON "public"."applicationgroups_usergroups_ls" IS NULL;


COMMENT ON CONSTRAINT "applicationgroups_usergroups_ls_usergroups_code_foreign" ON "public"."applicationgroups_usergroups_ls" IS NULL;


COMMENT ON CONSTRAINT "applicationgroups_usergroups_ls_applicationgroups_id_foreign" ON "public"."applicationgroups_usergroups_ls" IS NULL;

COMMENT ON TABLE "public"."applicationgroups_usergroups_ls"  IS NULL;

--- END CREATE TABLE "public"."applicationgroups_usergroups_ls" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1453, 'applicationgroups', 'livestream_usergroups', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 11, 'full', NULL, 'If empty, livestream is available to everyone, else only those specified.', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1456, 'applicationgroups_usergroups_ls', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1454, 'applicationgroups_usergroups_ls', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1455, 'applicationgroups_usergroups_ls', 'applicationgroups_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('applicationgroups_usergroups_ls', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (439, 'applicationgroups_usergroups_ls', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'applicationgroups_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (440, 'applicationgroups_usergroups_ls', 'applicationgroups_id', 'applicationgroups', 'livestream_usergroups', NULL, NULL, 'usergroups_code', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-15T09:25:22.972Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."applicationgroups_usergroups_ls" ---

DROP TABLE IF EXISTS "public"."applicationgroups_usergroups_ls";

--- END DROP TABLE "public"."applicationgroups_usergroups_ls" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'applicationgroups_usergroups_ls';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1453;

DELETE FROM "public"."directus_fields" WHERE "id" = 1456;

DELETE FROM "public"."directus_fields" WHERE "id" = 1454;

DELETE FROM "public"."directus_fields" WHERE "id" = 1455;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 439;

DELETE FROM "public"."directus_relations" WHERE "id" = 440;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
