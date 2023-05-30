-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T11:35:20.369Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."applicationgroups_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."applicationgroups_usergroups_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."applicationgroups_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."applicationgroups_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."applicationgroups_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."applicationgroups_usergroups_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."applicationgroups_usergroups_id_seq" ---

--- BEGIN CREATE TABLE "public"."applicationgroups" ---

CREATE TABLE IF NOT EXISTS "public"."applicationgroups" (
	"id" uuid NOT NULL  ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	CONSTRAINT "applicationgroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "applicationgroups_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "applicationgroups_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."applicationgroups" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."applicationgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."applicationgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."applicationgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."applicationgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."applicationgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."applicationgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."applicationgroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."applicationgroups"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."applicationgroups"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."applicationgroups"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."applicationgroups"."date_updated"  IS NULL;

COMMENT ON CONSTRAINT "applicationgroups_pkey" ON "public"."applicationgroups" IS NULL;


COMMENT ON CONSTRAINT "applicationgroups_user_created_foreign" ON "public"."applicationgroups" IS NULL;


COMMENT ON CONSTRAINT "applicationgroups_user_updated_foreign" ON "public"."applicationgroups" IS NULL;

COMMENT ON TABLE "public"."applicationgroups"  IS NULL;

--- END CREATE TABLE "public"."applicationgroups" ---

--- BEGIN CREATE TABLE "public"."applicationgroups_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."applicationgroups_usergroups" (
	"id" int4 NOT NULL DEFAULT nextval('applicationgroups_usergroups_id_seq'::regclass) ,
	"applicationgroups_id" uuid NULL  ,
	"usergroups_code" varchar(255) NULL  ,
	CONSTRAINT "applicationgroups_usergroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "applicationgroups_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE ,
	CONSTRAINT "applicationgroups_usergroups_applicationgroups_id_foreign" FOREIGN KEY (applicationgroups_id) REFERENCES applicationgroups(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."applicationgroups_usergroups" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."applicationgroups_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."applicationgroups_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."applicationgroups_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."applicationgroups_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."applicationgroups_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."applicationgroups_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."applicationgroups_usergroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."applicationgroups_usergroups"."applicationgroups_id"  IS NULL;


COMMENT ON COLUMN "public"."applicationgroups_usergroups"."usergroups_code"  IS NULL;

COMMENT ON CONSTRAINT "applicationgroups_usergroups_pkey" ON "public"."applicationgroups_usergroups" IS NULL;


COMMENT ON CONSTRAINT "applicationgroups_usergroups_usergroups_code_foreign" ON "public"."applicationgroups_usergroups" IS NULL;


COMMENT ON CONSTRAINT "applicationgroups_usergroups_applicationgroups_id_foreign" ON "public"."applicationgroups_usergroups" IS NULL;

COMMENT ON TABLE "public"."applicationgroups_usergroups"  IS NULL;

--- END CREATE TABLE "public"."applicationgroups_usergroups" ---

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications" ADD COLUMN IF NOT EXISTS "group_id" uuid NULL  ;

COMMENT ON COLUMN "public"."applications"."group_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."applications" ADD CONSTRAINT "applications_group_id_foreign" FOREIGN KEY (group_id) REFERENCES applicationgroups(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "applications_group_id_foreign" ON "public"."applications" IS NULL;

--- END ALTER TABLE "public"."applications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('applicationgroups', 'groups', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'applications', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('applicationgroups_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1174, 'applicationgroups', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1175, 'applicationgroups', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1176, 'applicationgroups', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1177, 'applicationgroups', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1178, 'applicationgroups', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2, "width" = 'half', "group" = 'content' WHERE "id" = 690;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1180, 'applicationgroups_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1181, 'applicationgroups_usergroups', 'applicationgroups_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1182, 'applicationgroups_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1179, 'applicationgroups', 'roles', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1185, 'applications', 'content', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 3, "width" = 'half', "group" = 'content' WHERE "id" = 692;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1184, 'applicationgroups', 'applications', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1183, 'applications', 'group_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1186, 'applications', 'options', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'half', "group" = 'options' WHERE "id" = 509;

UPDATE "public"."directus_fields" SET "sort" = 2, "width" = 'half', "group" = 'options' WHERE "id" = 514;

UPDATE "public"."directus_fields" SET "sort" = 3, "width" = 'half', "group" = 'options' WHERE "id" = 515;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 510;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'half', "group" = 'options' WHERE "id" = 517;

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'half', "group" = 'content' WHERE "id" = 516;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (359, 'applicationgroups_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'applicationgroups_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (360, 'applicationgroups_usergroups', 'applicationgroups_id', 'applicationgroups', 'roles', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (357, 'applicationgroups', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (361, 'applications', 'group_id', 'applicationgroups', 'applications', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (358, 'applicationgroups', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T11:35:22.153Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications" DROP COLUMN IF EXISTS "group_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."applications" DROP CONSTRAINT IF EXISTS "applications_group_id_foreign";

--- END ALTER TABLE "public"."applications" ---

--- BEGIN DROP TABLE "public"."applicationgroups_usergroups" ---

DROP TABLE IF EXISTS "public"."applicationgroups_usergroups";

--- END DROP TABLE "public"."applicationgroups_usergroups" ---

--- BEGIN DROP TABLE "public"."applicationgroups" ---

DROP TABLE IF EXISTS "public"."applicationgroups";

--- END DROP TABLE "public"."applicationgroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'applicationgroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'applicationgroups_usergroups';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 8, "width" = 'full' WHERE "id" = 517;

UPDATE "public"."directus_fields" SET "sort" = 9, "width" = 'full' WHERE "id" = 509;

UPDATE "public"."directus_fields" SET "sort" = 10, "width" = 'full' WHERE "id" = 514;

UPDATE "public"."directus_fields" SET "sort" = 11, "width" = 'full' WHERE "id" = 515;

UPDATE "public"."directus_fields" SET "sort" = 12, "width" = 'full' WHERE "id" = 516;

UPDATE "public"."directus_fields" SET "sort" = 14, "width" = 'full' WHERE "id" = 692;

UPDATE "public"."directus_fields" SET "sort" = 13, "width" = 'full' WHERE "id" = 690;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 510;

DELETE FROM "public"."directus_fields" WHERE "id" = 1174;

DELETE FROM "public"."directus_fields" WHERE "id" = 1175;

DELETE FROM "public"."directus_fields" WHERE "id" = 1176;

DELETE FROM "public"."directus_fields" WHERE "id" = 1177;

DELETE FROM "public"."directus_fields" WHERE "id" = 1178;

DELETE FROM "public"."directus_fields" WHERE "id" = 1180;

DELETE FROM "public"."directus_fields" WHERE "id" = 1181;

DELETE FROM "public"."directus_fields" WHERE "id" = 1182;

DELETE FROM "public"."directus_fields" WHERE "id" = 1179;

DELETE FROM "public"."directus_fields" WHERE "id" = 1185;

DELETE FROM "public"."directus_fields" WHERE "id" = 1184;

DELETE FROM "public"."directus_fields" WHERE "id" = 1183;

DELETE FROM "public"."directus_fields" WHERE "id" = 1186;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 359;

DELETE FROM "public"."directus_relations" WHERE "id" = 360;

DELETE FROM "public"."directus_relations" WHERE "id" = 357;

DELETE FROM "public"."directus_relations" WHERE "id" = 361;

DELETE FROM "public"."directus_relations" WHERE "id" = 358;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
