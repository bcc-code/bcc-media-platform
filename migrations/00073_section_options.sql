-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-21T12:54:28.076Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "use_context" bool NULL  ;

COMMENT ON COLUMN "public"."sections"."use_context"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "embed_aspect_ratio" float4 NULL  ;

COMMENT ON COLUMN "public"."sections"."embed_aspect_ratio"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "embed_height" int4 NULL  ;

COMMENT ON COLUMN "public"."sections"."embed_height"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "embed_size" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN ALTER TABLE "users"."progress" ---

ALTER TABLE IF EXISTS "users"."progress" ADD COLUMN IF NOT EXISTS "context" json NULL  ;

COMMENT ON COLUMN "users"."progress"."context"  IS NULL;

--- END ALTER TABLE "users"."progress" ---

--- BEGIN ALTER TABLE "public"."calendarentries" ---

ALTER TABLE IF EXISTS "public"."calendarentries" ADD COLUMN IF NOT EXISTS "is_replay" bool NULL  ;

COMMENT ON COLUMN "public"."calendarentries"."is_replay"  IS NULL;

--- END ALTER TABLE "public"."calendarentries" ---

--- BEGIN DROP TABLE "public"."appconfig" ---

DROP TABLE IF EXISTS "public"."appconfig";

--- END DROP TABLE "public"."appconfig" ---

--- BEGIN DROP TABLE "public"."webconfig" ---

DROP TABLE IF EXISTS "public"."webconfig";

--- END DROP TABLE "public"."webconfig" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'appconfig';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'webconfig';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (765, 'calendarentries', 'is_replay', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 6, 'full', NULL, NULL, NULL, false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (766, 'sections', 'embed_aspect_ratio', NULL, 'input', NULL, 'raw', NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'embed_config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (767, 'sections', 'embed_height', NULL, 'input', NULL, 'raw', NULL, false, false, 3, 'half', NULL, NULL, NULL, false, 'embed_config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (764, 'sections', 'use_context', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 2, 'half', NULL, 'Should items clicked on be opened in the section context?', NULL, false, 'options', NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 734;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 687;

DELETE FROM "public"."directus_fields" WHERE "id" = 469;

DELETE FROM "public"."directus_fields" WHERE "id" = 470;

DELETE FROM "public"."directus_fields" WHERE "id" = 471;

DELETE FROM "public"."directus_fields" WHERE "id" = 472;

DELETE FROM "public"."directus_fields" WHERE "id" = 478;

DELETE FROM "public"."directus_fields" WHERE "id" = 479;

DELETE FROM "public"."directus_fields" WHERE "id" = 480;

DELETE FROM "public"."directus_fields" WHERE "id" = 685;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 141;

DELETE FROM "public"."directus_relations" WHERE "id" = 143;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-21T12:54:29.527Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."appconfig" ---

CREATE TABLE IF NOT EXISTS "public"."appconfig" (
	"app_version" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"date_updated" timestamptz NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('appconfig_id_seq'::regclass) ,
	"user_updated" uuid NOT NULL  ,
	CONSTRAINT "appconfig_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "appconfig_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."appconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."appconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."appconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."appconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."appconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."appconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."appconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."appconfig"."app_version"  IS NULL;


COMMENT ON COLUMN "public"."appconfig"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."appconfig"."id"  IS NULL;


COMMENT ON COLUMN "public"."appconfig"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "appconfig_pkey" ON "public"."appconfig" IS NULL;


COMMENT ON CONSTRAINT "appconfig_user_updated_foreign" ON "public"."appconfig" IS NULL;

COMMENT ON TABLE "public"."appconfig"  IS NULL;

--- END CREATE TABLE "public"."appconfig" ---

--- BEGIN ALTER TABLE "public"."calendarentries" ---

ALTER TABLE IF EXISTS "public"."calendarentries" DROP COLUMN IF EXISTS "is_replay" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."calendarentries" ---

--- BEGIN CREATE TABLE "public"."webconfig" ---

CREATE TABLE IF NOT EXISTS "public"."webconfig" (
	"date_updated" timestamptz NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('webconfig_id_seq'::regclass) ,
	"user_updated" uuid NOT NULL  ,
	CONSTRAINT "webconfig_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "webconfig_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."webconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."webconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."webconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."webconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."webconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."webconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."webconfig" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."webconfig"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."webconfig"."id"  IS NULL;


COMMENT ON COLUMN "public"."webconfig"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "webconfig_pkey" ON "public"."webconfig" IS NULL;


COMMENT ON CONSTRAINT "webconfig_user_updated_foreign" ON "public"."webconfig" IS NULL;

COMMENT ON TABLE "public"."webconfig"  IS NULL;

--- END CREATE TABLE "public"."webconfig" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "embed_size" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."sections"."embed_size"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "use_context" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "embed_aspect_ratio" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "embed_height" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN ALTER TABLE "users"."progress" ---

ALTER TABLE IF EXISTS "users"."progress" DROP COLUMN IF EXISTS "context" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."progress" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('appconfig', 'app_settings_alt', NULL, NULL, true, true, '[{"language":"en-US","translation":"App","singular":"App","plural":"App"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 3, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('webconfig', 'desktop_windows', NULL, NULL, true, true, '[{"language":"en-US","translation":"Web","singular":"Web","plural":"Web"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 4, 'config', 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (469, 'appconfig', 'app_version', NULL, 'input', '{"iconLeft":"get_app"}', 'formatted-value', NULL, false, false, NULL, 'half', NULL, 'Minimum required app version', NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (470, 'appconfig', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (471, 'appconfig', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (472, 'appconfig', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (478, 'webconfig', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (479, 'webconfig', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (480, 'webconfig', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (685, 'sections', 'embed_size', NULL, 'select-dropdown', '{"choices":[{"text":"16:9","value":"16:9"},{"text":"4:3","value":"4:3"},{"text":"9:16","value":"9:16"},{"text":"1:1","value":"1:1"}]}', 'raw', NULL, false, false, 2, 'half', NULL, NULL, '[]', false, 'embed_config', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 687;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 734;

DELETE FROM "public"."directus_fields" WHERE "id" = 765;

DELETE FROM "public"."directus_fields" WHERE "id" = 766;

DELETE FROM "public"."directus_fields" WHERE "id" = 767;

DELETE FROM "public"."directus_fields" WHERE "id" = 764;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (141, 'appconfig', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (143, 'webconfig', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
