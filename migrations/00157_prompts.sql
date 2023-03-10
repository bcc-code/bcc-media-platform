-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-08T13:22:03.280Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."prompts_targets_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."prompts_targets_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."prompts_targets_id_seq" OWNER TO directus;
GRANT SELECT ON SEQUENCE "public"."prompts_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."prompts_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."prompts_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."prompts_targets_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."prompts_targets_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."prompts_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."prompts_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."prompts_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."prompts_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."prompts_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."prompts_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."prompts_translations_id_seq" ---
--- BEGIN CREATE TABLE "public"."prompts" ---

CREATE TABLE IF NOT EXISTS "public"."prompts" (
	"id" uuid NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"title" text NOT NULL  ,
	"secondary_title" text NULL  ,
	"type" varchar(255) NOT NULL DEFAULT 'survey'::character varying ,
	"survey_id" uuid NULL  ,
	"from" timestamp NOT NULL  ,
	"to" timestamp NOT NULL  ,
	CONSTRAINT "prompts_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "prompts_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "prompts_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "prompts_survey_id_foreign" FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."prompts" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."prompts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."prompts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."prompts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."prompts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."prompts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."prompts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."prompts"."id"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."status"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."title"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."secondary_title"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."type"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."survey_id"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."from"  IS NULL;


COMMENT ON COLUMN "public"."prompts"."to"  IS NULL;

COMMENT ON CONSTRAINT "prompts_user_created_foreign" ON "public"."prompts" IS NULL;


COMMENT ON CONSTRAINT "prompts_pkey" ON "public"."prompts" IS NULL;


COMMENT ON CONSTRAINT "prompts_user_updated_foreign" ON "public"."prompts" IS NULL;


COMMENT ON CONSTRAINT "prompts_survey_id_foreign" ON "public"."prompts" IS NULL;

COMMENT ON TABLE "public"."prompts"  IS NULL;

--- END CREATE TABLE "public"."prompts" ---

--- BEGIN CREATE TABLE "public"."prompts_translations" ---

CREATE TABLE IF NOT EXISTS "public"."prompts_translations" (
                                                               "id" int4 NOT NULL DEFAULT nextval('prompts_translations_id_seq'::regclass) ,
                                                               "prompts_id" uuid NULL  ,
                                                               "languages_code" varchar(255) NULL  ,
                                                               "title" text NULL  ,
                                                               "secondary_title" text NULL  ,
                                                               CONSTRAINT "prompts_translations_pkey" PRIMARY KEY (id) ,
                                                               CONSTRAINT "prompts_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
                                                               CONSTRAINT "prompts_translations_prompts_id_foreign" FOREIGN KEY (prompts_id) REFERENCES prompts(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."prompts_translations" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."prompts_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."prompts_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."prompts_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."prompts_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."prompts_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."prompts_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."prompts_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."prompts_translations"."prompts_id"  IS NULL;


COMMENT ON COLUMN "public"."prompts_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."prompts_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."prompts_translations"."secondary_title"  IS NULL;

COMMENT ON CONSTRAINT "prompts_translations_pkey" ON "public"."prompts_translations" IS NULL;


COMMENT ON CONSTRAINT "prompts_translations_languages_code_foreign" ON "public"."prompts_translations" IS NULL;


COMMENT ON CONSTRAINT "prompts_translations_prompts_id_foreign" ON "public"."prompts_translations" IS NULL;

COMMENT ON TABLE "public"."prompts_translations"  IS NULL;

CREATE UNIQUE INDEX prompts_translations_prompts_id_languages_code_uindex ON public.prompts_translations USING btree (prompts_id, languages_code);

COMMENT ON INDEX "public"."prompts_translations_prompts_id_languages_code_uindex"  IS NULL;

--- END CREATE TABLE "public"."prompts_translations" ---

--- BEGIN CREATE TABLE "public"."prompts_targets" ---

CREATE TABLE IF NOT EXISTS "public"."prompts_targets" (
                                                          "id" int4 NOT NULL DEFAULT nextval('prompts_targets_id_seq'::regclass) ,
                                                          "prompts_id" uuid NULL  ,
                                                          "targets_id" uuid NULL  ,
                                                          CONSTRAINT "prompts_targets_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets(id) ON DELETE SET NULL ,
                                                          CONSTRAINT "prompts_targets_prompts_id_foreign" FOREIGN KEY (prompts_id) REFERENCES prompts(id) ON DELETE SET NULL ,
                                                          CONSTRAINT "prompts_targets_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."prompts_targets" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."prompts_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."prompts_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."prompts_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."prompts_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."prompts_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."prompts_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."prompts_targets"."id"  IS NULL;


COMMENT ON COLUMN "public"."prompts_targets"."prompts_id"  IS NULL;


COMMENT ON COLUMN "public"."prompts_targets"."targets_id"  IS NULL;

COMMENT ON CONSTRAINT "prompts_targets_targets_id_foreign" ON "public"."prompts_targets" IS NULL;


COMMENT ON CONSTRAINT "prompts_targets_prompts_id_foreign" ON "public"."prompts_targets" IS NULL;


COMMENT ON CONSTRAINT "prompts_targets_pkey" ON "public"."prompts_targets" IS NULL;

COMMENT ON TABLE "public"."prompts_targets"  IS NULL;

--- END CREATE TABLE "public"."prompts_targets" ---


--- BEGIN ALTER TABLE "public"."surveys" ---

ALTER TABLE IF EXISTS "public"."surveys" DROP COLUMN IF EXISTS "from" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."surveys" DROP COLUMN IF EXISTS "to" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."surveys" ---

--- BEGIN DROP TABLE "public"."surveys_targets" ---

DROP TABLE IF EXISTS "public"."surveys_targets";

--- END DROP TABLE "public"."surveys_targets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 2, "group" = 'config' WHERE "collection" = 'targets';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'ageratings';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'notificationtemplates';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('prompts', 'pending_actions', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'config', 'open');

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'redirects';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('prompts_targets', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 26, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('prompts_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

DELETE FROM "public"."directus_collections" WHERE "collection" = 'surveys_targets';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1104, 'prompts', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1105, 'prompts', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1106, 'prompts', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1107, 'prompts', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1112, 'prompts', 'visibility', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1102, 'prompts', 'id', 'uuid', 'input', NULL, NULL, NULL, true, false, 1, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1108, 'prompts', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1109, 'prompts', 'secondary_title', NULL, 'input', NULL, 'raw', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1116, 'prompts_targets', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1110, 'prompts', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Survey","value":"survey"}]}', 'labels', NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1117, 'prompts_targets', 'prompts_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1113, 'prompts', 'from', NULL, 'custom-datepicker', NULL, 'datetime', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'visibility', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1115, 'prompts', 'targets', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'visibility', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1111, 'prompts', 'survey_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 10, 'full', NULL, NULL, '[{"name":"hide if not survey","rule":{"_and":[{"type":{"_neq":"survey"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1118, 'prompts_targets', 'targets_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1103, 'prompts', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1114, 'prompts', 'to', NULL, 'custom-datepicker', NULL, 'datetime', NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'visibility', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1122, 'prompts_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1119, 'prompts', 'translations', 'translations', 'translations', '{"languageField":"code","languageDirectionField":"name","defaultLanguage":"no","userLanguage":true}', 'translations', NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1120, 'prompts_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1121, 'prompts_translations', 'prompts_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1123, 'prompts_translations', 'title', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1124, 'prompts_translations', 'secondary_title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 1082;

DELETE FROM "public"."directus_fields" WHERE "id" = 1083;

DELETE FROM "public"."directus_fields" WHERE "id" = 1092;

DELETE FROM "public"."directus_fields" WHERE "id" = 1089;

DELETE FROM "public"."directus_fields" WHERE "id" = 1090;

DELETE FROM "public"."directus_fields" WHERE "id" = 1091;

DELETE FROM "public"."directus_fields" WHERE "id" = 1084;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (337, 'prompts', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (339, 'prompts', 'survey_id', 'surveys', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (340, 'prompts_targets', 'targets_id', 'targets', NULL, NULL, NULL, 'prompts_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (341, 'prompts_targets', 'prompts_id', 'prompts', 'targets', NULL, NULL, 'targets_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (338, 'prompts', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (342, 'prompts_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'prompts_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (343, 'prompts_translations', 'prompts_id', 'prompts', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

DELETE FROM "public"."directus_relations" WHERE "id" = 333;

DELETE FROM "public"."directus_relations" WHERE "id" = 334;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-08T13:22:04.857Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."surveys" ---

ALTER TABLE IF EXISTS "public"."surveys" ADD COLUMN IF NOT EXISTS "from" timestamp  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."surveys"."from"  IS NULL;

ALTER TABLE IF EXISTS "public"."surveys" ADD COLUMN IF NOT EXISTS "to" timestamp  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."surveys"."to"  IS NULL;

UPDATE "public"."surveys" SET "to" = NOW(), "from" = NOW();

ALTER TABLE IF EXISTS "public"."surveys" ALTER COLUMN "to" SET NOT NULL  ;
ALTER TABLE IF EXISTS "public"."surveys" ALTER COLUMN "from" SET NOT NULL  ;

--- END ALTER TABLE "public"."surveys" ---

--- BEGIN CREATE TABLE "public"."surveys_targets" ---

CREATE TABLE IF NOT EXISTS "public"."surveys_targets" (
	"id" int4 NOT NULL DEFAULT nextval('surveys_targets_id_seq'::regclass) ,
	"surveys_id" uuid NOT NULL  ,
	"targets_id" uuid NOT NULL  ,
	CONSTRAINT "surveys_targets_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "surveys_targets_surveys_id_foreign" FOREIGN KEY (surveys_id) REFERENCES surveys(id) ON DELETE CASCADE ,
	CONSTRAINT "surveys_targets_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."surveys_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."surveys_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."surveys_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."surveys_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."surveys_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."surveys_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."surveys_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."surveys_targets" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."surveys_targets" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."surveys_targets"."id"  IS NULL;


COMMENT ON COLUMN "public"."surveys_targets"."surveys_id"  IS NULL;


COMMENT ON COLUMN "public"."surveys_targets"."targets_id"  IS NULL;

COMMENT ON CONSTRAINT "surveys_targets_pkey" ON "public"."surveys_targets" IS NULL;


COMMENT ON CONSTRAINT "surveys_targets_surveys_id_foreign" ON "public"."surveys_targets" IS NULL;


COMMENT ON CONSTRAINT "surveys_targets_targets_id_foreign" ON "public"."surveys_targets" IS NULL;

COMMENT ON TABLE "public"."surveys_targets"  IS NULL;

--- END CREATE TABLE "public"."surveys_targets" ---

--- BEGIN DROP TABLE "public"."prompts_targets" ---

DROP TABLE IF EXISTS "public"."prompts_targets";

--- END DROP TABLE "public"."prompts_targets" ---

--- BEGIN DROP TABLE "public"."prompts_translations" ---

DROP TABLE IF EXISTS "public"."prompts_translations";

--- END DROP TABLE "public"."prompts_translations" ---

--- BEGIN DROP TABLE "public"."prompts" ---

DROP TABLE IF EXISTS "public"."prompts";

--- END DROP TABLE "public"."prompts" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'ageratings';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'redirects';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'notifications' WHERE "collection" = 'targets';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'notificationtemplates';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('surveys_targets', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

DELETE FROM "public"."directus_collections" WHERE "collection" = 'prompts';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'prompts_targets';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'prompts_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1082, 'surveys', 'from', NULL, 'custom-datepicker', NULL, 'datetime', '{"format":"short"}', false, false, 1, 'half', NULL, 'Visible from', NULL, false, 'visibility', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1083, 'surveys', 'to', NULL, 'custom-datepicker', NULL, 'datetime', NULL, false, false, 2, 'half', NULL, 'Visible to', NULL, false, 'visibility', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1092, 'surveys_targets', 'targets_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1089, 'surveys', 'targets', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1090, 'surveys_targets', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1091, 'surveys_targets', 'surveys_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1084, 'surveys', 'visibility', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 10, 'full', NULL, 'When should this survey be visible?', NULL, false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 1104;

DELETE FROM "public"."directus_fields" WHERE "id" = 1105;

DELETE FROM "public"."directus_fields" WHERE "id" = 1106;

DELETE FROM "public"."directus_fields" WHERE "id" = 1107;

DELETE FROM "public"."directus_fields" WHERE "id" = 1112;

DELETE FROM "public"."directus_fields" WHERE "id" = 1102;

DELETE FROM "public"."directus_fields" WHERE "id" = 1108;

DELETE FROM "public"."directus_fields" WHERE "id" = 1109;

DELETE FROM "public"."directus_fields" WHERE "id" = 1116;

DELETE FROM "public"."directus_fields" WHERE "id" = 1110;

DELETE FROM "public"."directus_fields" WHERE "id" = 1117;

DELETE FROM "public"."directus_fields" WHERE "id" = 1113;

DELETE FROM "public"."directus_fields" WHERE "id" = 1115;

DELETE FROM "public"."directus_fields" WHERE "id" = 1111;

DELETE FROM "public"."directus_fields" WHERE "id" = 1118;

DELETE FROM "public"."directus_fields" WHERE "id" = 1103;

DELETE FROM "public"."directus_fields" WHERE "id" = 1114;

DELETE FROM "public"."directus_fields" WHERE "id" = 1122;

DELETE FROM "public"."directus_fields" WHERE "id" = 1119;

DELETE FROM "public"."directus_fields" WHERE "id" = 1120;

DELETE FROM "public"."directus_fields" WHERE "id" = 1121;

DELETE FROM "public"."directus_fields" WHERE "id" = 1123;

DELETE FROM "public"."directus_fields" WHERE "id" = 1124;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (333, 'surveys_targets', 'targets_id', 'targets', NULL, NULL, NULL, 'surveys_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (334, 'surveys_targets', 'surveys_id', 'surveys', 'targets', NULL, NULL, 'targets_id', NULL, 'delete');

DELETE FROM "public"."directus_relations" WHERE "id" = 337;

DELETE FROM "public"."directus_relations" WHERE "id" = 339;

DELETE FROM "public"."directus_relations" WHERE "id" = 340;

DELETE FROM "public"."directus_relations" WHERE "id" = 341;

DELETE FROM "public"."directus_relations" WHERE "id" = 338;

DELETE FROM "public"."directus_relations" WHERE "id" = 342;

DELETE FROM "public"."directus_relations" WHERE "id" = 343;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
