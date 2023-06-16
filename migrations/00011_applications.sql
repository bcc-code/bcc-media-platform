-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-22T13:35:29.030Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."applications_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."applications_usergroups_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."applications_usergroups_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."applications_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."applications_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."applications_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."applications_usergroups_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."applications_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."applications_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."applications_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."applications_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."applications_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."applications_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."applications_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."applications_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."applications_id_seq" ---

--- BEGIN CREATE TABLE "public"."applications_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."applications_usergroups" (
	"id" int4 NOT NULL DEFAULT nextval('applications_usergroups_id_seq'::regclass) ,
	"applications_id" int4 NULL  ,
	"usergroups_code" varchar(255) NULL  ,
	CONSTRAINT "applications_usergroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "applications_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."applications_usergroups" OWNER TO manager;

GRANT SELECT ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."applications_usergroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."applications_usergroups"."applications_id"  IS NULL;


COMMENT ON COLUMN "public"."applications_usergroups"."usergroups_code"  IS NULL;

COMMENT ON CONSTRAINT "applications_usergroups_pkey" ON "public"."applications_usergroups" IS NULL;

COMMENT ON TABLE "public"."applications_usergroups"  IS NULL;

--- END CREATE TABLE "public"."applications_usergroups" ---

--- BEGIN CREATE TABLE "public"."applications" ---

CREATE TABLE IF NOT EXISTS "public"."applications" (
	"id" int4 NOT NULL DEFAULT nextval('applications_id_seq'::regclass) ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"name" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"client_version" varchar(255) NULL  ,
	"page_id" int4 NULL  ,
	"default" bool NOT NULL DEFAULT false ,
	CONSTRAINT "applications_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "applications_code_unique" UNIQUE (code) ,
	CONSTRAINT "applications_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "applications_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "applications_page_id_foreign" FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS applications_code_unique ON public.applications USING btree (code);

ALTER TABLE IF EXISTS "public"."applications" OWNER TO manager;

GRANT SELECT ON TABLE "public"."applications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."applications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."applications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."applications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."applications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."applications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."applications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."applications"."id"  IS NULL;


COMMENT ON COLUMN "public"."applications"."status"  IS NULL;


COMMENT ON COLUMN "public"."applications"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."applications"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."applications"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."applications"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."applications"."name"  IS NULL;


COMMENT ON COLUMN "public"."applications"."code"  IS NULL;


COMMENT ON COLUMN "public"."applications"."client_version"  IS NULL;


COMMENT ON COLUMN "public"."applications"."page_id"  IS NULL;


COMMENT ON COLUMN "public"."applications"."default"  IS NULL;

COMMENT ON CONSTRAINT "applications_pkey" ON "public"."applications" IS NULL;


COMMENT ON CONSTRAINT "applications_code_unique" ON "public"."applications" IS NULL;


COMMENT ON CONSTRAINT "applications_user_created_foreign" ON "public"."applications" IS NULL;


COMMENT ON CONSTRAINT "applications_user_updated_foreign" ON "public"."applications" IS NULL;


COMMENT ON CONSTRAINT "applications_page_id_foreign" ON "public"."applications" IS NULL;

COMMENT ON INDEX "public"."applications_code_unique"  IS NULL;

COMMENT ON TABLE "public"."applications"  IS NULL;

ALTER TABLE ONLY public.applications_usergroups
    ADD CONSTRAINT "applications_usergroups_applications_id_foreign" FOREIGN KEY (applications_id) REFERENCES applications(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "applications_usergroups_usergroups_code_foreign" ON "public"."applications_usergroups" IS NULL;

COMMENT ON CONSTRAINT "applications_usergroups_applications_id_foreign" ON "public"."applications_usergroups" IS NULL;

--- END CREATE TABLE "public"."applications" ---

GRANT SELECT ON "public"."applications" TO api;
GRANT SELECT ON "public"."applications_usergroups" TO api;

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "hidden" = true WHERE "collection" = 'appconfig';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('applications', 'app_shortcut', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 6, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('applications_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 17, NULL, 'open');

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'languages';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Slider","value":"carousel"},{"text":"Cards","value":"cards"}]}' WHERE "id" = 405;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (511, 'applications_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (512, 'applications_usergroups', 'applications_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (513, 'applications_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (503, 'applications', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (504, 'applications', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (505, 'applications', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (506, 'applications', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (507, 'applications', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (508, 'applications', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (509, 'applications', 'name', NULL, 'input', NULL, NULL, NULL, false, false, 8, 'full', NULL, 'For internal use', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (514, 'applications', 'code', NULL, 'input', '{"trim":true}', 'raw', NULL, false, false, 9, 'full', NULL, 'The identifying code for this application', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (515, 'applications', 'client_version', NULL, 'input', '{"trim":true}', 'raw', NULL, false, false, 10, 'full', NULL, 'Minimum client version.', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (516, 'applications', 'page_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 11, 'full', '[{"language":"en-US","translation":"Default page"}]', NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (510, 'applications', 'roles', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (517, 'applications', 'default', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (146, 'applications', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (147, 'applications', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (148, 'applications_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'applications_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (150, 'applications', 'page_id', 'pages', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-22T13:35:30.184Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."applications_usergroups" ---

DROP TABLE IF EXISTS "public"."applications_usergroups";

--- END DROP TABLE "public"."applications_usergroups" ---

--- BEGIN DROP TABLE "public"."applications" ---

DROP TABLE IF EXISTS "public"."applications";

--- END DROP TABLE "public"."applications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "hidden" = false WHERE "collection" = 'appconfig';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'languages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'applications';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'applications_usergroups';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Slider","value":"carousel"},{"text":"Cards","value":"cards"}]}' WHERE "id" = 405;

DELETE FROM "public"."directus_fields" WHERE "id" = 511;

DELETE FROM "public"."directus_fields" WHERE "id" = 512;

DELETE FROM "public"."directus_fields" WHERE "id" = 513;

DELETE FROM "public"."directus_fields" WHERE "id" = 503;

DELETE FROM "public"."directus_fields" WHERE "id" = 504;

DELETE FROM "public"."directus_fields" WHERE "id" = 505;

DELETE FROM "public"."directus_fields" WHERE "id" = 506;

DELETE FROM "public"."directus_fields" WHERE "id" = 507;

DELETE FROM "public"."directus_fields" WHERE "id" = 508;

DELETE FROM "public"."directus_fields" WHERE "id" = 509;

DELETE FROM "public"."directus_fields" WHERE "id" = 514;

DELETE FROM "public"."directus_fields" WHERE "id" = 515;

DELETE FROM "public"."directus_fields" WHERE "id" = 516;

DELETE FROM "public"."directus_fields" WHERE "id" = 510;

DELETE FROM "public"."directus_fields" WHERE "id" = 517;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 146;

DELETE FROM "public"."directus_relations" WHERE "id" = 147;

DELETE FROM "public"."directus_relations" WHERE "id" = 148;

DELETE FROM "public"."directus_relations" WHERE "id" = 150;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
