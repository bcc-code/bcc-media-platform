-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-17T08:17:11.552Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."notifications_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."notifications_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."notifications_id_seq" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."notifications_id_seq" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."notifications_id_seq" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."notifications_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."notifications_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."notifications_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."notifications_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."notifications_translations_id_seq" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."notifications_translations_id_seq" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."notifications_translations_id_seq" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."notifications_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."notifications_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."notifications" ---

CREATE TABLE IF NOT EXISTS "public"."notifications" (
	"id" int4 NOT NULL DEFAULT nextval('notifications_id_seq'::regclass) ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	CONSTRAINT "notifications_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "notifications_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "notifications_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."notifications" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notifications" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notifications" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."notifications" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."notifications" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."notifications" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."notifications" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notifications"."id"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."status"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."date_updated"  IS NULL;

COMMENT ON CONSTRAINT "notifications_pkey" ON "public"."notifications" IS NULL;


COMMENT ON CONSTRAINT "notifications_user_created_foreign" ON "public"."notifications" IS NULL;


COMMENT ON CONSTRAINT "notifications_user_updated_foreign" ON "public"."notifications" IS NULL;

COMMENT ON TABLE "public"."notifications"  IS NULL;

--- END CREATE TABLE "public"."notifications" ---

--- BEGIN CREATE TABLE "public"."notifications_translations" ---

CREATE TABLE IF NOT EXISTS "public"."notifications_translations" (
	"id" int4 NOT NULL DEFAULT nextval('notifications_translations_id_seq'::regclass) ,
	"notifications_id" int4 NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" varchar(255) NOT NULL  ,
	"description" text NULL  ,
	"image" uuid NULL  ,
	CONSTRAINT "notifications_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "notifications_translations_notifications_id_foreign" FOREIGN KEY (notifications_id) REFERENCES notifications(id) ON DELETE SET NULL ,
	CONSTRAINT "notifications_translations_image_foreign" FOREIGN KEY (image) REFERENCES directus_files(id) ON DELETE SET NULL ,
	CONSTRAINT "notifications_translations_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."notifications_translations" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notifications_translations" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notifications_translations" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."notifications_translations" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."notifications_translations" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."notifications_translations" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."notifications_translations" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notifications_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."notifications_id"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."image"  IS NULL;

COMMENT ON CONSTRAINT "notifications_translations_languages_code_foreign" ON "public"."notifications_translations" IS NULL;


COMMENT ON CONSTRAINT "notifications_translations_notifications_id_foreign" ON "public"."notifications_translations" IS NULL;


COMMENT ON CONSTRAINT "notifications_translations_image_foreign" ON "public"."notifications_translations" IS NULL;


COMMENT ON CONSTRAINT "notifications_translations_pkey" ON "public"."notifications_translations" IS NULL;

COMMENT ON TABLE "public"."notifications_translations"  IS NULL;

--- END CREATE TABLE "public"."notifications_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'ageratings';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'appconfig';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('notifications', NULL, NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'config', 'open');

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'usergroups';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'webconfig';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'applications';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'languages';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('notifications_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'notifications', 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (650, 'notifications', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (652, 'notifications', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (653, 'notifications', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (654, 'notifications', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (655, 'notifications', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (661, 'notifications_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (656, 'notifications', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, NULL, 'full', NULL, NULL, '[{"name":"Readonly when published","rule":{"_and":[{"status":{"_eq":"published"}}]},"readonly":true,"options":{"languageDirectionField":null,"userLanguage":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (651, 'notifications', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, NULL, 'full', NULL, NULL, '[{"name":"Readonly when published","rule":{"_and":[{"_and":[{"status":{"_eq":"published"}},{"id":{"_nnull":true}}]}]},"readonly":true,"options":{"allowOther":false,"allowNone":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (657, 'notifications_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (658, 'notifications_translations', 'notifications_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (659, 'notifications_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (660, 'notifications_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (662, 'notifications_translations', 'image', 'file', 'file-image', NULL, 'image', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (201, 'notifications', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (202, 'notifications', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (203, 'notifications_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'notifications_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (204, 'notifications_translations', 'notifications_id', 'notifications', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (205, 'notifications_translations', 'image', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-17T08:17:12.761Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."notifications" ---

DROP TABLE IF EXISTS "public"."notifications";

--- END DROP TABLE "public"."notifications" ---

--- BEGIN DROP TABLE "public"."notifications_translations" ---

DROP TABLE IF EXISTS "public"."notifications_translations";

--- END DROP TABLE "public"."notifications_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'ageratings';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'usergroups';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'webconfig';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'appconfig';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'applications';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'languages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'notifications';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'notifications_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 650;

DELETE FROM "public"."directus_fields" WHERE "id" = 652;

DELETE FROM "public"."directus_fields" WHERE "id" = 653;

DELETE FROM "public"."directus_fields" WHERE "id" = 654;

DELETE FROM "public"."directus_fields" WHERE "id" = 655;

DELETE FROM "public"."directus_fields" WHERE "id" = 661;

DELETE FROM "public"."directus_fields" WHERE "id" = 656;

DELETE FROM "public"."directus_fields" WHERE "id" = 651;

DELETE FROM "public"."directus_fields" WHERE "id" = 657;

DELETE FROM "public"."directus_fields" WHERE "id" = 658;

DELETE FROM "public"."directus_fields" WHERE "id" = 659;

DELETE FROM "public"."directus_fields" WHERE "id" = 660;

DELETE FROM "public"."directus_fields" WHERE "id" = 662;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 201;

DELETE FROM "public"."directus_relations" WHERE "id" = 202;

DELETE FROM "public"."directus_relations" WHERE "id" = 203;

DELETE FROM "public"."directus_relations" WHERE "id" = 204;

DELETE FROM "public"."directus_relations" WHERE "id" = 205;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
