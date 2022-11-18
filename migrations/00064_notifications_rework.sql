-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T08:52:48.182Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."notificationtemplates_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."notificationtemplates_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."notificationtemplates_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."notificationtemplates_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."notificationtemplates" ---

CREATE TABLE IF NOT EXISTS "public"."notificationtemplates" (
	"id" uuid NOT NULL  ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"label" varchar(255) NULL  ,
	CONSTRAINT "notificationtemplates_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "notificationtemplates_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "notificationtemplates_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT, INSERT, UPDATE ON TABLE "public"."notificationtemplates" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notificationtemplates"."id"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."label"  IS NULL;

COMMENT ON CONSTRAINT "notificationtemplates_pkey" ON "public"."notificationtemplates" IS NULL;


COMMENT ON CONSTRAINT "notificationtemplates_user_created_foreign" ON "public"."notificationtemplates" IS NULL;


COMMENT ON CONSTRAINT "notificationtemplates_user_updated_foreign" ON "public"."notificationtemplates" IS NULL;

COMMENT ON TABLE "public"."notificationtemplates"  IS NULL;

--- END CREATE TABLE "public"."notificationtemplates" ---

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" ADD COLUMN IF NOT EXISTS "template_id" uuid NULL  ;

COMMENT ON COLUMN "public"."notifications"."template_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD COLUMN IF NOT EXISTS "schedule_at" timestamp NULL  ;

COMMENT ON COLUMN "public"."notifications"."schedule_at"  IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD COLUMN IF NOT EXISTS "action" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."notifications"."action"  IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD COLUMN IF NOT EXISTS "deep_link" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."notifications"."deep_link"  IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_template_id_foreign" FOREIGN KEY (template_id) REFERENCES notificationtemplates(id);

COMMENT ON CONSTRAINT "notifications_template_id_foreign" ON "public"."notifications" IS NULL;

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN CREATE TABLE "public"."notificationtemplates_translations" ---

CREATE TABLE IF NOT EXISTS "public"."notificationtemplates_translations" (
	"id" int4 NOT NULL DEFAULT nextval('notificationtemplates_translations_id_seq'::regclass) ,
	"notificationtemplates_id" uuid NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	"description" text NULL  ,
	CONSTRAINT "notificationtemplates_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "notificationtemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "notificationtemplates_translations_notific__402aa733_foreign" FOREIGN KEY (notificationtemplates_id) REFERENCES notificationtemplates(id) ON DELETE SET NULL
);


GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."notificationtemplates_translations" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notificationtemplates_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates_translations"."notificationtemplates_id"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates_translations"."description"  IS NULL;

COMMENT ON CONSTRAINT "notificationtemplates_translations_pkey" ON "public"."notificationtemplates_translations" IS NULL;


COMMENT ON CONSTRAINT "notificationtemplates_translations_languages_code_foreign" ON "public"."notificationtemplates_translations" IS NULL;


COMMENT ON CONSTRAINT "notificationtemplates_translations_notific__402aa733_foreign" ON "public"."notificationtemplates_translations" IS NULL;

COMMENT ON TABLE "public"."notificationtemplates_translations"  IS NULL;

--- END CREATE TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" ADD COLUMN IF NOT EXISTS "notificationtemplate_id" uuid NULL  ;

COMMENT ON COLUMN "public"."images"."notificationtemplate_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "images_notificationtemplate_id_foreign" FOREIGN KEY (notificationtemplate_id) REFERENCES notificationtemplates(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "images_notificationtemplate_id_foreign" ON "public"."images" IS NULL;

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "one_item";

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "one_item" CHECK (((((((
CASE
    WHEN (show_id IS NULL) THEN 0
    ELSE 1
END +
CASE
    WHEN (season_id IS NULL) THEN 0
    ELSE 1
END) +
CASE
    WHEN (episode_id IS NULL) THEN 0
    ELSE 1
END) +
CASE
    WHEN (page_id IS NULL) THEN 0
    ELSE 1
END) +
CASE
    WHEN (link_id IS NULL) THEN 0
    ELSE 1
END) +
CASE
    WHEN (notificationtemplate_id IS NULL) THEN 0
    ELSE 1
END) = 1));

COMMENT ON CONSTRAINT "one_item" ON "public"."images" IS NULL;

--- END ALTER TABLE "public"."images" ---

--- BEGIN DROP TABLE "public"."notifications_translations" ---

DROP TABLE IF EXISTS "public"."notifications_translations";

--- END DROP TABLE "public"."notifications_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'ageratings';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('notificationtemplates', NULL, NULL, '{{label}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'notifications', 'open');

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'appconfig';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'usergroups';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'collections_items';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('notificationtemplates_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'notificationtemplates', 'open');

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'webconfig';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'languages';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'applications';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'applications_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'notifications_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (717, 'notificationtemplates', 'images', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 641;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (718, 'images', 'notificationtemplate_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 6, 'full', NULL, NULL, NULL, false, 'link', NULL, NULL);

UPDATE "public"."directus_fields" SET "conditions" = '[]' WHERE "id" = 558;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (730, 'notifications', 'action', NULL, 'select-dropdown', '{"choices":[{"text":"Deep Link","value":"deep_link"},{"text":"Clear Cache","value":"clear_cache"}],"allowNone":true}', 'labels', NULL, false, false, 3, 'half', NULL, 'Any specific action that should happen?', NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (731, 'notifications', 'deep_link', NULL, 'input', NULL, 'raw', NULL, false, true, 4, 'half', NULL, NULL, '[{"name":"show if deeplink","rule":{"_and":[{"action":{"_eq":"deep_link"}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (722, 'notificationtemplates_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (723, 'notificationtemplates_translations', 'notificationtemplates_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (719, 'notifications', 'template_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 1, 'full', NULL, 'Templates contains translations and images for the notification. Leave empty to trigger only a notification.', '[]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (721, 'notificationtemplates', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (724, 'notificationtemplates_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (720, 'notificationtemplates', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 6, 'full', NULL, 'For internal use', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "conditions" = '[]' WHERE "id" = 557;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (725, 'notificationtemplates_translations', 'title', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "conditions" = '[]' WHERE "id" = 625;

UPDATE "public"."directus_fields" SET "conditions" = '[]' WHERE "id" = 559;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (726, 'notificationtemplates_translations', 'description', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 691;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (707, 'notificationtemplates', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (708, 'notificationtemplates', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (709, 'notificationtemplates', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (710, 'notificationtemplates', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (706, 'notificationtemplates', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (727, 'notifications', 'config', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 7, 'full', NULL, NULL, '[{"name":"Readonly on published","rule":{"_and":[{"status":{"_eq":"published"}}]},"readonly":true,"options":{"start":"open"}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (728, 'notifications', 'schedule_at', NULL, 'datetime', NULL, 'datetime', '{}', false, false, 2, 'full', NULL, 'Should the notification be run at a specific time?', NULL, false, 'config', NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 661;

DELETE FROM "public"."directus_fields" WHERE "id" = 656;

DELETE FROM "public"."directus_fields" WHERE "id" = 657;

DELETE FROM "public"."directus_fields" WHERE "id" = 658;

DELETE FROM "public"."directus_fields" WHERE "id" = 659;

DELETE FROM "public"."directus_fields" WHERE "id" = 660;

DELETE FROM "public"."directus_fields" WHERE "id" = 662;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (763, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (764, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (765, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (766, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (767, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (768, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (770, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (769, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (771, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (772, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'update', '{}', '{}', NULL, '*');

DELETE FROM "public"."directus_permissions" WHERE "id" = 718;

DELETE FROM "public"."directus_permissions" WHERE "id" = 719;

DELETE FROM "public"."directus_permissions" WHERE "id" = 720;

DELETE FROM "public"."directus_permissions" WHERE "id" = 721;

DELETE FROM "public"."directus_permissions" WHERE "id" = 722;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (221, 'notifications', 'template_id', 'notificationtemplates', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (216, 'notificationtemplates', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (217, 'notificationtemplates', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (220, 'images', 'notificationtemplate_id', 'notificationtemplates', 'images', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (222, 'notificationtemplates_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'notificationtemplates_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (223, 'notificationtemplates_translations', 'notificationtemplates_id', 'notificationtemplates', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 203;

DELETE FROM "public"."directus_relations" WHERE "id" = 204;

DELETE FROM "public"."directus_relations" WHERE "id" = 205;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T08:52:49.861Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."notifications_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."notifications_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."notifications_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."notifications_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."notifications_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."notifications_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."notifications_translations_id_seq" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" DROP COLUMN IF EXISTS "notificationtemplate_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "one_item";

DELETE FROM "public"."images" WHERE show_id IS NULL AND season_id IS NULL and episode_id IS NULL AND page_id IS NULL and link_id IS NULL;

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "one_item" CHECK ((((show_id IS NOT NULL) AND (season_id IS NULL) AND (episode_id IS NULL) AND (page_id IS NULL) AND (link_id IS NULL)) OR ((season_id IS NOT NULL) AND (show_id IS NULL) AND (episode_id IS NULL) AND (page_id IS NULL) AND (link_id IS NULL)) OR ((episode_id IS NOT NULL) AND (show_id IS NULL) AND (season_id IS NULL) AND (page_id IS NULL) AND (link_id IS NULL)) OR ((episode_id IS NULL) AND (show_id IS NULL) AND (season_id IS NULL) AND (page_id IS NOT NULL) AND (link_id IS NULL)) OR ((episode_id IS NULL) AND (show_id IS NULL) AND (season_id IS NULL) AND (page_id IS NULL) AND (link_id IS NOT NULL))));

COMMENT ON CONSTRAINT "one_item" ON "public"."images" IS NULL;

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "images_notificationtemplate_id_foreign";

--- END ALTER TABLE "public"."images" ---

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "template_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "schedule_at" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "send_started" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "send_completed" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "action" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "deep_link" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_template_id_foreign";

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN CREATE TABLE "public"."notifications_translations" ---

CREATE TABLE IF NOT EXISTS "public"."notifications_translations" (
	"id" int4 NOT NULL DEFAULT nextval('notifications_translations_id_seq'::regclass) ,
	"notifications_id" int4 NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" varchar(255) NOT NULL  ,
	"description" text NULL  ,
	"image" uuid NULL  ,
	CONSTRAINT "notifications_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "notifications_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "notifications_translations_notifications_id_foreign" FOREIGN KEY (notifications_id) REFERENCES notifications(id) ON DELETE SET NULL ,
	CONSTRAINT "notifications_translations_image_foreign" FOREIGN KEY (image) REFERENCES directus_files(id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."notifications_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notifications_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notifications_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."notifications_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."notifications_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."notifications_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."notifications_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notifications_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."notifications_id"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."notifications_translations"."image"  IS NULL;

COMMENT ON CONSTRAINT "notifications_translations_pkey" ON "public"."notifications_translations" IS NULL;


COMMENT ON CONSTRAINT "notifications_translations_languages_code_foreign" ON "public"."notifications_translations" IS NULL;


COMMENT ON CONSTRAINT "notifications_translations_notifications_id_foreign" ON "public"."notifications_translations" IS NULL;


COMMENT ON CONSTRAINT "notifications_translations_image_foreign" ON "public"."notifications_translations" IS NULL;

COMMENT ON TABLE "public"."notifications_translations"  IS NULL;

--- END CREATE TABLE "public"."notifications_translations" ---

--- BEGIN DROP TABLE "public"."notificationtemplates_translations" ---

DROP TABLE IF EXISTS "public"."notificationtemplates_translations";

--- END DROP TABLE "public"."notificationtemplates_translations" ---

--- BEGIN DROP TABLE "public"."notificationtemplates" ---

DROP TABLE IF EXISTS "public"."notificationtemplates";

--- END DROP TABLE "public"."notificationtemplates" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'collections_items';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'ageratings';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'usergroups';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'appconfig';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'webconfig';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'applications';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'languages';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('notifications_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'notifications', 'open');

UPDATE "public"."directus_collections" SET "sort" = 18 WHERE "collection" = 'applications_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'notificationtemplates_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'notificationtemplates';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 641;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"episode_id":{"_null":true}},{"page_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 558;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"season_id":{"_null":true}},{"episode_id":{"_null":true}},{"page_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 557;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"season_id":{"_null":true}},{"page_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 559;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Shown if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"season_id":{"_null":true}},{"episode_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 625;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (661, 'notifications_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (656, 'notifications', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, NULL, 'full', NULL, NULL, '[{"name":"Readonly when published","rule":{"_and":[{"status":{"_eq":"published"}}]},"readonly":true,"options":{"languageDirectionField":null,"userLanguage":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (657, 'notifications_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (658, 'notifications_translations', 'notifications_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (659, 'notifications_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (660, 'notifications_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (662, 'notifications_translations', 'image', 'file', 'file-image', NULL, 'image', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 691;

DELETE FROM "public"."directus_fields" WHERE "id" = 717;

DELETE FROM "public"."directus_fields" WHERE "id" = 729;

DELETE FROM "public"."directus_fields" WHERE "id" = 718;

DELETE FROM "public"."directus_fields" WHERE "id" = 730;

DELETE FROM "public"."directus_fields" WHERE "id" = 731;

DELETE FROM "public"."directus_fields" WHERE "id" = 722;

DELETE FROM "public"."directus_fields" WHERE "id" = 723;

DELETE FROM "public"."directus_fields" WHERE "id" = 719;

DELETE FROM "public"."directus_fields" WHERE "id" = 721;

DELETE FROM "public"."directus_fields" WHERE "id" = 724;

DELETE FROM "public"."directus_fields" WHERE "id" = 720;

DELETE FROM "public"."directus_fields" WHERE "id" = 725;

DELETE FROM "public"."directus_fields" WHERE "id" = 726;

DELETE FROM "public"."directus_fields" WHERE "id" = 707;

DELETE FROM "public"."directus_fields" WHERE "id" = 708;

DELETE FROM "public"."directus_fields" WHERE "id" = 709;

DELETE FROM "public"."directus_fields" WHERE "id" = 710;

DELETE FROM "public"."directus_fields" WHERE "id" = 706;

DELETE FROM "public"."directus_fields" WHERE "id" = 727;

DELETE FROM "public"."directus_fields" WHERE "id" = 728;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (718, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (719, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (720, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (721, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (722, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'read', '{}', '{}', NULL, '*');

DELETE FROM "public"."directus_permissions" WHERE "id" = 763;

DELETE FROM "public"."directus_permissions" WHERE "id" = 764;

DELETE FROM "public"."directus_permissions" WHERE "id" = 765;

DELETE FROM "public"."directus_permissions" WHERE "id" = 766;

DELETE FROM "public"."directus_permissions" WHERE "id" = 767;

DELETE FROM "public"."directus_permissions" WHERE "id" = 768;

DELETE FROM "public"."directus_permissions" WHERE "id" = 770;

DELETE FROM "public"."directus_permissions" WHERE "id" = 769;

DELETE FROM "public"."directus_permissions" WHERE "id" = 771;

DELETE FROM "public"."directus_permissions" WHERE "id" = 772;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (203, 'notifications_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'notifications_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (204, 'notifications_translations', 'notifications_id', 'notifications', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (205, 'notifications_translations', 'image', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 221;

DELETE FROM "public"."directus_relations" WHERE "id" = 216;

DELETE FROM "public"."directus_relations" WHERE "id" = 217;

DELETE FROM "public"."directus_relations" WHERE "id" = 220;

DELETE FROM "public"."directus_relations" WHERE "id" = 222;

DELETE FROM "public"."directus_relations" WHERE "id" = 223;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
