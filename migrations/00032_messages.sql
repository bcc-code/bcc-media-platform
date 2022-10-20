-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-20T09:57:33.479Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."messages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."messages_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."messages_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."messages_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."messages_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."messages_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."messages_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."messages_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."messages_messagetemplates_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."messages_messagetemplates_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."messages_messagetemplates_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."messages_messagetemplates_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."messages_messagetemplates_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."messages_messagetemplates_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."messages_messagetemplates_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."messages_messagetemplates_id_seq" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "message_id" int4 NULL  ;

COMMENT ON COLUMN "public"."sections"."message_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" ADD CONSTRAINT "sections_message_id_foreign" FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "sections_message_id_foreign" ON "public"."sections" IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN CREATE TABLE "public"."messages" ---

CREATE TABLE IF NOT EXISTS "public"."messages" (
	"id" int4 NOT NULL DEFAULT nextval('messages_id_seq'::regclass) ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"enabled" bool NULL  ,
	"name" varchar(255) NULL  ,
	CONSTRAINT "messages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "messages_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "messages_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) 
);

ALTER TABLE IF EXISTS "public"."messages" OWNER TO btv;

GRANT SELECT ON TABLE "public"."messages" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."messages" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."messages" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."messages" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."messages" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."messages" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."messages" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."messages"."id"  IS NULL;


COMMENT ON COLUMN "public"."messages"."status"  IS NULL;


COMMENT ON COLUMN "public"."messages"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."messages"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."messages"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."messages"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."messages"."enabled"  IS NULL;


COMMENT ON COLUMN "public"."messages"."name"  IS NULL;

COMMENT ON CONSTRAINT "messages_pkey" ON "public"."messages" IS NULL;


COMMENT ON CONSTRAINT "messages_user_created_foreign" ON "public"."messages" IS NULL;


COMMENT ON CONSTRAINT "messages_user_updated_foreign" ON "public"."messages" IS NULL;

COMMENT ON TABLE "public"."messages"  IS NULL;

--- END CREATE TABLE "public"."messages" ---

--- BEGIN CREATE TABLE "public"."messages_messagetemplates" ---

CREATE TABLE IF NOT EXISTS "public"."messages_messagetemplates" (
	"id" int4 NOT NULL DEFAULT nextval('messages_messagetemplates_id_seq'::regclass) ,
	"messages_id" int4 NULL  ,
	"messagetemplates_id" int4 NULL  ,
	CONSTRAINT "messages_messagetemplates_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "messages_messagetemplates_messagetemplates_id_foreign" FOREIGN KEY (messagetemplates_id) REFERENCES messagetemplates(id) ON DELETE SET NULL ,
	CONSTRAINT "messages_messagetemplates_messages_id_foreign" FOREIGN KEY (messages_id) REFERENCES messages(id) ON DELETE SET NULL 
);

ALTER TABLE IF EXISTS "public"."messages_messagetemplates" OWNER TO btv;

GRANT SELECT ON TABLE "public"."messages_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."messages_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."messages_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."messages_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."messages_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."messages_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."messages_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."messages_messagetemplates"."id"  IS NULL;


COMMENT ON COLUMN "public"."messages_messagetemplates"."messages_id"  IS NULL;


COMMENT ON COLUMN "public"."messages_messagetemplates"."messagetemplates_id"  IS NULL;

COMMENT ON CONSTRAINT "messages_messagetemplates_pkey" ON "public"."messages_messagetemplates" IS NULL;


COMMENT ON CONSTRAINT "messages_messagetemplates_messagetemplates_id_foreign" ON "public"."messages_messagetemplates" IS NULL;


COMMENT ON CONSTRAINT "messages_messagetemplates_messages_id_foreign" ON "public"."messages_messagetemplates" IS NULL;

COMMENT ON TABLE "public"."messages_messagetemplates"  IS NULL;

--- END CREATE TABLE "public"."messages_messagetemplates" ---

--- BEGIN ALTER TABLE "public"."messagetemplates" ---

ALTER TABLE IF EXISTS "public"."messagetemplates" ADD COLUMN IF NOT EXISTS "style" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."messagetemplates"."style"  IS NULL;

ALTER TABLE IF EXISTS "public"."messagetemplates" DROP COLUMN IF EXISTS "type" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."messagetemplates" ---

--- BEGIN DROP TABLE "public"."maintenancemessage" ---

DROP TABLE IF EXISTS "public"."maintenancemessage";

--- END DROP TABLE "public"."maintenancemessage" ---

--- BEGIN DROP TABLE "public"."maintenancemessage_messagetemplates" ---

DROP TABLE IF EXISTS "public"."maintenancemessage_messagetemplates";

--- END DROP TABLE "public"."maintenancemessage_messagetemplates" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'messages' WHERE "collection" = 'messagetemplates';

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'lists_relations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('messages', NULL, NULL, '{{name}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 6, NULL, 'open');

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections" SET "sort" = 18 WHERE "collection" = 'applications_usergroups';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('messages_messagetemplates', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'messages', 'open');

DELETE FROM "public"."directus_collections" WHERE "collection" = 'maintenance_messages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'maintenancemessage';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'maintenancemessage_messagetemplates';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (671, 'messages_messagetemplates', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (672, 'messages_messagetemplates', 'messages_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 238;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (673, 'messages_messagetemplates', 'messagetemplates_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (674, 'messages', 'enabled', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 402;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (670, 'messages', 'templates', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (675, 'sections', 'message_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 4, 'full', NULL, NULL, '[{"name":"Show if Message","rule":{"_and":[{"type":{"_eq":"message"}}]},"hidden":false,"required":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'configuration', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 245;

UPDATE "public"."directus_fields" SET "sort" = 3, "conditions" = '[{"name":"Show if Item","rule":{"_and":[{"type":{"_eq":"item"}}]},"hidden":false,"options":{"enableCreate":true,"enableSelect":true},"required":true}]' WHERE "id" = 237;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (676, 'messages', 'sections', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Required if item","rule":{"_and":[{"type":{"_eq":"item"}}]},"required":true,"options":{"allowOther":false,"allowNone":false}}]', "required" = false WHERE "id" = 405;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (664, 'messages', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (665, 'messages', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (666, 'messages', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (667, 'messages', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (668, 'messages', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (669, 'messages', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (677, 'messages', 'name', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, 'For internal use', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (678, 'messagetemplates', 'style', NULL, 'select-dropdown', '{"choices":[{"text":"Error","value":"error"},{"text":"Info","value":"info"},{"text":"Warning","value":"warning"}]}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Item","value":"item"},{"text":"Message","value":"message"}]}' WHERE "id" = 536;

UPDATE "public"."directus_fields" SET "hidden" = true, "conditions" = '[{"name":"Show if needed","rule":{"_and":[{"style":{"_in":["featured","default","posters"]}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}}]' WHERE "id" = 533;

DELETE FROM "public"."directus_fields" WHERE "id" = 447;

DELETE FROM "public"."directus_fields" WHERE "id" = 448;

DELETE FROM "public"."directus_fields" WHERE "id" = 449;

DELETE FROM "public"."directus_fields" WHERE "id" = 450;

DELETE FROM "public"."directus_fields" WHERE "id" = 451;

DELETE FROM "public"."directus_fields" WHERE "id" = 452;

DELETE FROM "public"."directus_fields" WHERE "id" = 453;

DELETE FROM "public"."directus_fields" WHERE "id" = 454;

DELETE FROM "public"."directus_fields" WHERE "id" = 460;

DELETE FROM "public"."directus_fields" WHERE "id" = 446;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (206, 'messages', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (207, 'messages', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (208, 'messages_messagetemplates', 'messagetemplates_id', 'messagetemplates', NULL, NULL, NULL, 'messages_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (209, 'messages_messagetemplates', 'messages_id', 'messages', 'templates', NULL, NULL, 'messagetemplates_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (210, 'sections', 'message_id', 'messages', 'sections', NULL, NULL, NULL, NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 134;

DELETE FROM "public"."directus_relations" WHERE "id" = 135;

DELETE FROM "public"."directus_relations" WHERE "id" = 136;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-20T09:57:34.831Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."maintenancemessage" ---

CREATE TABLE IF NOT EXISTS "public"."maintenancemessage" (
	"active" bool NULL DEFAULT false ,
	"date_updated" timestamptz NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('maintenancemessage_id_seq'::regclass) ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "maintenancemessage_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "maintenancemessage_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) 
);

ALTER TABLE IF EXISTS "public"."maintenancemessage" OWNER TO manager;

GRANT SELECT ON TABLE "public"."maintenancemessage" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."maintenancemessage" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."maintenancemessage" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."maintenancemessage" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."maintenancemessage" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."maintenancemessage" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."maintenancemessage" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."maintenancemessage" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."maintenancemessage" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."maintenancemessage" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."maintenancemessage" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."maintenancemessage" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."maintenancemessage" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."maintenancemessage" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."maintenancemessage"."active"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage"."id"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "maintenancemessage_pkey" ON "public"."maintenancemessage" IS NULL;


COMMENT ON CONSTRAINT "maintenancemessage_user_updated_foreign" ON "public"."maintenancemessage" IS NULL;

COMMENT ON TABLE "public"."maintenancemessage"  IS NULL;

--- END CREATE TABLE "public"."maintenancemessage" ---

--- BEGIN CREATE TABLE "public"."maintenancemessage_messagetemplates" ---

CREATE TABLE IF NOT EXISTS "public"."maintenancemessage_messagetemplates" (
	"id" int4 NOT NULL DEFAULT nextval('maintenancemessage_messagetemplates_id_seq'::regclass) ,
	"maintenancemessage_id" int4 NULL  ,
	"messagetemplates_id" int4 NULL  ,
	"sort" int4 NULL  ,
	CONSTRAINT "maintenancemessage_messagetemplates_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "maintenancemessage_messagetemplates_mainte__6b993ed9_foreign" FOREIGN KEY (maintenancemessage_id) REFERENCES maintenancemessage(id) ON DELETE SET NULL ,
	CONSTRAINT "maintenancemessage_messagetemplates_messag__488cfa1b_foreign" FOREIGN KEY (messagetemplates_id) REFERENCES messagetemplates(id) ON DELETE SET NULL 
);

ALTER TABLE IF EXISTS "public"."maintenancemessage_messagetemplates" OWNER TO manager;

GRANT SELECT ON TABLE "public"."maintenancemessage_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."maintenancemessage_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."maintenancemessage_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."maintenancemessage_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."maintenancemessage_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."maintenancemessage_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."maintenancemessage_messagetemplates" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."maintenancemessage_messagetemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."maintenancemessage_messagetemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."maintenancemessage_messagetemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."maintenancemessage_messagetemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."maintenancemessage_messagetemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."maintenancemessage_messagetemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."maintenancemessage_messagetemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."maintenancemessage_messagetemplates"."id"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage_messagetemplates"."maintenancemessage_id"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage_messagetemplates"."messagetemplates_id"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage_messagetemplates"."sort"  IS NULL;

COMMENT ON CONSTRAINT "maintenancemessage_messagetemplates_pkey" ON "public"."maintenancemessage_messagetemplates" IS NULL;


COMMENT ON CONSTRAINT "maintenancemessage_messagetemplates_mainte__6b993ed9_foreign" ON "public"."maintenancemessage_messagetemplates" IS NULL;


COMMENT ON CONSTRAINT "maintenancemessage_messagetemplates_messag__488cfa1b_foreign" ON "public"."maintenancemessage_messagetemplates" IS NULL;

COMMENT ON TABLE "public"."maintenancemessage_messagetemplates"  IS NULL;

--- END CREATE TABLE "public"."maintenancemessage_messagetemplates" ---

--- BEGIN ALTER TABLE "public"."messagetemplates" ---

ALTER TABLE IF EXISTS "public"."messagetemplates" ADD COLUMN IF NOT EXISTS "type" varchar(255) NOT NULL DEFAULT 'error'::character varying ;

COMMENT ON COLUMN "public"."messagetemplates"."type"  IS NULL;

ALTER TABLE IF EXISTS "public"."messagetemplates" DROP COLUMN IF EXISTS "style" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."messagetemplates" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "message_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."sections" DROP CONSTRAINT IF EXISTS "sections_message_id_foreign";

--- END ALTER TABLE "public"."sections" ---

--- BEGIN DROP TABLE "public"."messages" ---

DROP TABLE IF EXISTS "public"."messages";

--- END DROP TABLE "public"."messages" ---

--- BEGIN DROP TABLE "public"."messages_messagetemplates" ---

DROP TABLE IF EXISTS "public"."messages_messagetemplates";

--- END DROP TABLE "public"."messages_messagetemplates" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'assetstreams_subtitle_languages';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenance_messages', 'warning_amber', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 6, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenancemessage', 'sd_card_alert', NULL, NULL, false, true, '[{"language":"en-US","translation":"Messages","singular":"Messages","plural":"Messages"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'maintenance_messages', 'open');

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'episodes_categories';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenancemessage_messagetemplates', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 16, NULL, 'open');

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 2, "group" = 'maintenance_messages' WHERE "collection" = 'messagetemplates';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'applications_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'messages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'messages_messagetemplates';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 238;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 402;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (447, 'maintenancemessage', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (448, 'maintenancemessage', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (449, 'maintenancemessage', 'messages', 'm2m', 'list-m2m', '{"template":"{{messagetemplates_id.translations}}"}', 'related-values', '{"template":"{{messagetemplates_id.translations}}"}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (450, 'maintenancemessage', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (451, 'maintenancemessage_messagetemplates', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (452, 'maintenancemessage_messagetemplates', 'maintenancemessage_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (453, 'maintenancemessage_messagetemplates', 'messagetemplates_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (454, 'maintenancemessage_messagetemplates', 'sort', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (460, 'messagetemplates', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Warning","value":"warning"},{"text":"Error","value":"error"},{"text":"Info","value":"info"}]}', 'labels', NULL, false, false, 7, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (446, 'maintenancemessage', 'active', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 4, "conditions" = '[{"name":"Show if Item","rule":{"_and":[{"type":{"_eq":"item"}}]},"hidden":false,"options":{"enableCreate":true,"enableSelect":true}}]' WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "hidden" = false, "conditions" = '[{"name":"Hide if grid","rule":{"_and":[{"style":{"_eq":"grid"}}]},"hidden":true,"options":{"allowOther":false,"allowNone":false}}]' WHERE "id" = 533;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 245;

UPDATE "public"."directus_fields" SET "conditions" = NULL, "required" = true WHERE "id" = 405;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Item","value":"item"}]}' WHERE "id" = 536;

DELETE FROM "public"."directus_fields" WHERE "id" = 671;

DELETE FROM "public"."directus_fields" WHERE "id" = 672;

DELETE FROM "public"."directus_fields" WHERE "id" = 673;

DELETE FROM "public"."directus_fields" WHERE "id" = 674;

DELETE FROM "public"."directus_fields" WHERE "id" = 670;

DELETE FROM "public"."directus_fields" WHERE "id" = 675;

DELETE FROM "public"."directus_fields" WHERE "id" = 676;

DELETE FROM "public"."directus_fields" WHERE "id" = 664;

DELETE FROM "public"."directus_fields" WHERE "id" = 665;

DELETE FROM "public"."directus_fields" WHERE "id" = 666;

DELETE FROM "public"."directus_fields" WHERE "id" = 667;

DELETE FROM "public"."directus_fields" WHERE "id" = 668;

DELETE FROM "public"."directus_fields" WHERE "id" = 669;

DELETE FROM "public"."directus_fields" WHERE "id" = 677;

DELETE FROM "public"."directus_fields" WHERE "id" = 678;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (134, 'maintenancemessage', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (135, 'maintenancemessage_messagetemplates', 'maintenancemessage_id', 'maintenancemessage', 'messages', NULL, NULL, 'messagetemplates_id', 'sort', 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (136, 'maintenancemessage_messagetemplates', 'messagetemplates_id', 'messagetemplates', NULL, NULL, NULL, 'maintenancemessage_id', NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 206;

DELETE FROM "public"."directus_relations" WHERE "id" = 207;

DELETE FROM "public"."directus_relations" WHERE "id" = 208;

DELETE FROM "public"."directus_relations" WHERE "id" = 209;

DELETE FROM "public"."directus_relations" WHERE "id" = 210;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
