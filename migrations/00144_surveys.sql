-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-24T08:19:05.565Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."surveyquestions_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."surveyquestions_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

COMMENT ON SEQUENCE "public"."surveyquestions_translations_id_seq"  IS NULL;

GRANT ALL ON SEQUENCE "public"."surveyquestions_translations_id_seq" TO background_worker;

--- END CREATE SEQUENCE "public"."surveyquestions_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."surveys_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."surveys_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

COMMENT ON SEQUENCE "public"."surveys_translations_id_seq"  IS NULL;

GRANT ALL ON SEQUENCE "public"."surveys_translations_id_seq" TO background_worker;

--- END CREATE SEQUENCE "public"."surveys_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."surveys" ---

CREATE TABLE IF NOT EXISTS "public"."surveys" (
	"id" uuid NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"description" text NULL  ,
	"title" text NOT NULL  ,
	CONSTRAINT "surveys_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "surveys_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "surveys_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."surveys" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."surveys" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."surveys" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."surveys" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."surveys" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."surveys" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."surveys" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."surveys" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."surveys" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."surveys" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."surveys" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."surveys" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."surveys" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."surveys" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."surveys" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."surveys"."id"  IS NULL;


COMMENT ON COLUMN "public"."surveys"."status"  IS NULL;


COMMENT ON COLUMN "public"."surveys"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."surveys"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."surveys"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."surveys"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."surveys"."description"  IS NULL;


COMMENT ON COLUMN "public"."surveys"."title"  IS NULL;

COMMENT ON CONSTRAINT "surveys_pkey" ON "public"."surveys" IS NULL;


COMMENT ON CONSTRAINT "surveys_user_created_foreign" ON "public"."surveys" IS NULL;


COMMENT ON CONSTRAINT "surveys_user_updated_foreign" ON "public"."surveys" IS NULL;

COMMENT ON TABLE "public"."surveys"  IS NULL;

--- END CREATE TABLE "public"."surveys" ---

--- BEGIN CREATE TABLE "public"."surveyquestions" ---

CREATE TABLE IF NOT EXISTS "public"."surveyquestions" (
	"id" uuid NOT NULL  ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"title" varchar(255) NOT NULL  ,
	"description" varchar(255) NULL  ,
	"type" varchar(255) NOT NULL  ,
	"survey_id" uuid NOT NULL  ,
	"sort" int4 NULL  ,
	CONSTRAINT "surveyquestions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "surveyquestions_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "surveyquestions_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "surveyquestions_survey_id_foreign" FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."surveyquestions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."surveyquestions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."surveyquestions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."surveyquestions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."surveyquestions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."surveyquestions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."surveyquestions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."surveyquestions" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."surveyquestions" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."surveyquestions" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."surveyquestions" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."surveyquestions" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."surveyquestions" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."surveyquestions" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."surveyquestions" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."surveyquestions"."id"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."title"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."description"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."type"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."survey_id"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions"."sort"  IS NULL;

COMMENT ON CONSTRAINT "surveyquestions_pkey" ON "public"."surveyquestions" IS NULL;


COMMENT ON CONSTRAINT "surveyquestions_user_created_foreign" ON "public"."surveyquestions" IS NULL;


COMMENT ON CONSTRAINT "surveyquestions_user_updated_foreign" ON "public"."surveyquestions" IS NULL;


COMMENT ON CONSTRAINT "surveyquestions_survey_id_foreign" ON "public"."surveyquestions" IS NULL;

COMMENT ON TABLE "public"."surveyquestions"  IS NULL;

--- END CREATE TABLE "public"."surveyquestions" ---

--- BEGIN CREATE TABLE "public"."surveys_translations" ---

CREATE TABLE IF NOT EXISTS "public"."surveys_translations" (
	"id" int4 NOT NULL DEFAULT nextval('surveys_translations_id_seq'::regclass) ,
	"surveys_id" uuid NOT NULL  ,
	"languages_code" varchar(255) NOT NULL  ,
	"title" text NULL  ,
	"description" text NULL  ,
	CONSTRAINT "surveys_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "surveys_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "surveys_translations_surveys_id_foreign" FOREIGN KEY (surveys_id) REFERENCES surveys(id) ON DELETE CASCADE
);

COMMENT ON COLUMN "public"."surveys_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."surveys_translations"."surveys_id"  IS NULL;


COMMENT ON COLUMN "public"."surveys_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."surveys_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."surveys_translations"."description"  IS NULL;

COMMENT ON CONSTRAINT "surveys_translations_pkey" ON "public"."surveys_translations" IS NULL;


COMMENT ON CONSTRAINT "surveys_translations_languages_code_foreign" ON "public"."surveys_translations" IS NULL;


COMMENT ON CONSTRAINT "surveys_translations_surveys_id_foreign" ON "public"."surveys_translations" IS NULL;

COMMENT ON TABLE "public"."surveys_translations"  IS NULL;

--- END CREATE TABLE "public"."surveys_translations" ---

--- BEGIN CREATE TABLE "public"."surveyquestions_translations" ---

CREATE TABLE IF NOT EXISTS "public"."surveyquestions_translations" (
	"id" int4 NOT NULL DEFAULT nextval('surveyquestions_translations_id_seq'::regclass) ,
	"surveyquestions_id" uuid NOT NULL ,
	"languages_code" varchar(255) NOT NULL ,
    "title" text NULL  ,
    "description" text NULL  ,
	CONSTRAINT "surveyquestions_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "surveyquestions_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "surveyquestions_translations_surveyquestions_id_foreign" FOREIGN KEY (surveyquestions_id) REFERENCES surveyquestions(id) ON DELETE SET NULL
);

GRANT SELECT ON "public"."surveys_translations" TO api;
GRANT ALL ON "public"."surveys_translations" TO background_worker, directus;
GRANT SELECT ON "public"."surveyquestions_translations" TO api;
GRANT ALL ON "public"."surveyquestions_translations" TO background_worker, directus;

COMMENT ON COLUMN "public"."surveyquestions_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions_translations"."surveyquestions_id"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."surveyquestions_translations"."description"  IS NULL;

COMMENT ON CONSTRAINT "surveyquestions_translations_pkey" ON "public"."surveyquestions_translations" IS NULL;


COMMENT ON CONSTRAINT "surveyquestions_translations_languages_code_foreign" ON "public"."surveyquestions_translations" IS NULL;


COMMENT ON CONSTRAINT "surveyquestions_translations_surveyquestions_id_foreign" ON "public"."surveyquestions_translations" IS NULL;

COMMENT ON TABLE "public"."surveyquestions_translations"  IS NULL;

--- END CREATE TABLE "public"."surveyquestions_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('surveys', 'search', NULL, '{{title}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', '#FFA439', '["description","surveyquestions.title","surveyquestions.description","surveyquestions.type","translations.languages_code","translations.title","translations.description"]', 4, 'main_content', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('surveyquestions', 'question_mark', NULL, '{{title}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 1, 'surveys', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('surveys_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('surveyquestions_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1067, 'surveyquestions', 'sort', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1058, 'surveyquestions', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1064, 'surveyquestions', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"text","value":"text"},{"text":"rating","value":"rating"}]}', NULL, NULL, false, false, 9, 'full', NULL, 'What type of answers do you expect?', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1053, 'surveys', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1063, 'surveyquestions', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 8, 'full', NULL, 'Helper text.', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1057, 'surveyquestions', 'id', 'uuid', 'input', NULL, NULL, NULL, true, false, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1059, 'surveyquestions', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1060, 'surveyquestions', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1061, 'surveyquestions', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1065, 'surveyquestions', 'survey_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1062, 'surveyquestions', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, 'The question being asked.', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1049, 'surveys', 'id', 'uuid', 'input', NULL, NULL, NULL, true, false, 1, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1069, 'surveys_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1070, 'surveys_translations', 'surveys_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1071, 'surveys_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1074, 'surveys_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1075, 'surveys_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1052, 'surveys', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1054, 'surveys', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1076, 'surveys', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1066, 'surveys', 'surveyquestions', 'o2m', 'list-o2m', '{"limit":30}', NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1079, 'surveyquestions_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1080, 'surveyquestions_translations', 'surveyquestions_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1050, 'surveys', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1051, 'surveys', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1077, 'surveys', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1068, 'surveys', 'translations', 'translations', 'translations', '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"no","userLanguage":true}', NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1081, 'surveyquestions_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1078, 'surveyquestions', 'translations', 'translations', 'translations', '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"no","userLanguage":true}', 'translations', NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (322, 'surveys', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (323, 'surveys', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (324, 'surveyquestions', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (325, 'surveyquestions', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (327, 'surveys_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'surveys_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (328, 'surveys_translations', 'surveys_id', 'surveys', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (329, 'surveyquestions_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'surveyquestions_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (330, 'surveyquestions_translations', 'surveyquestions_id', 'surveyquestions', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (326, 'surveyquestions', 'survey_id', 'surveys', 'surveyquestions', NULL, NULL, NULL, 'sort', 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-24T08:19:07.178Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."surveys_translations" ---

DROP TABLE IF EXISTS "public"."surveys_translations";

--- END DROP TABLE "public"."surveys_translations" ---

--- BEGIN DROP TABLE "public"."surveyquestions_translations" ---

DROP TABLE IF EXISTS "public"."surveyquestions_translations";

--- END DROP TABLE "public"."surveyquestions_translations" ---

--- BEGIN DROP TABLE "public"."surveyquestions" ---

DROP TABLE IF EXISTS "public"."surveyquestions";

--- END DROP TABLE "public"."surveyquestions" ---

--- BEGIN DROP TABLE "public"."surveys" ---

DROP TABLE IF EXISTS "public"."surveys";

--- END DROP TABLE "public"."surveys" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'surveyquestions';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'surveys_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'surveys';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'surveyquestions_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1067;

DELETE FROM "public"."directus_fields" WHERE "id" = 1058;

DELETE FROM "public"."directus_fields" WHERE "id" = 1064;

DELETE FROM "public"."directus_fields" WHERE "id" = 1053;

DELETE FROM "public"."directus_fields" WHERE "id" = 1063;

DELETE FROM "public"."directus_fields" WHERE "id" = 1057;

DELETE FROM "public"."directus_fields" WHERE "id" = 1059;

DELETE FROM "public"."directus_fields" WHERE "id" = 1060;

DELETE FROM "public"."directus_fields" WHERE "id" = 1061;

DELETE FROM "public"."directus_fields" WHERE "id" = 1065;

DELETE FROM "public"."directus_fields" WHERE "id" = 1062;

DELETE FROM "public"."directus_fields" WHERE "id" = 1049;

DELETE FROM "public"."directus_fields" WHERE "id" = 1069;

DELETE FROM "public"."directus_fields" WHERE "id" = 1070;

DELETE FROM "public"."directus_fields" WHERE "id" = 1071;

DELETE FROM "public"."directus_fields" WHERE "id" = 1074;

DELETE FROM "public"."directus_fields" WHERE "id" = 1075;

DELETE FROM "public"."directus_fields" WHERE "id" = 1052;

DELETE FROM "public"."directus_fields" WHERE "id" = 1054;

DELETE FROM "public"."directus_fields" WHERE "id" = 1076;

DELETE FROM "public"."directus_fields" WHERE "id" = 1066;

DELETE FROM "public"."directus_fields" WHERE "id" = 1079;

DELETE FROM "public"."directus_fields" WHERE "id" = 1080;

DELETE FROM "public"."directus_fields" WHERE "id" = 1050;

DELETE FROM "public"."directus_fields" WHERE "id" = 1051;

DELETE FROM "public"."directus_fields" WHERE "id" = 1077;

DELETE FROM "public"."directus_fields" WHERE "id" = 1068;

DELETE FROM "public"."directus_fields" WHERE "id" = 1081;

DELETE FROM "public"."directus_fields" WHERE "id" = 1078;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 322;

DELETE FROM "public"."directus_relations" WHERE "id" = 323;

DELETE FROM "public"."directus_relations" WHERE "id" = 324;

DELETE FROM "public"."directus_relations" WHERE "id" = 325;

DELETE FROM "public"."directus_relations" WHERE "id" = 327;

DELETE FROM "public"."directus_relations" WHERE "id" = 328;

DELETE FROM "public"."directus_relations" WHERE "id" = 329;

DELETE FROM "public"."directus_relations" WHERE "id" = 330;

DELETE FROM "public"."directus_relations" WHERE "id" = 326;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
