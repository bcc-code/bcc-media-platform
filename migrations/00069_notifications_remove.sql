-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-18T10:58:15.836Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" DROP COLUMN IF EXISTS "notificationtemplate_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "images_notificationtemplate_id_foreign";

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "one_item";

--- END ALTER TABLE "public"."images" ---

--- BEGIN DROP TABLE "public"."notificationtemplates_translations" ---

DROP TABLE IF EXISTS "public"."notificationtemplates_translations";

--- END DROP TABLE "public"."notificationtemplates_translations" ---

--- BEGIN DROP TABLE "public"."notifications" ---

DROP TABLE IF EXISTS "public"."notifications";

--- END DROP TABLE "public"."notifications" ---

--- BEGIN DROP TABLE "public"."notificationtemplates" ---

DROP TABLE IF EXISTS "public"."notificationtemplates";

--- END DROP TABLE "public"."notificationtemplates" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'notificationtemplates_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'notificationtemplates';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'notifications';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 652;

DELETE FROM "public"."directus_fields" WHERE "id" = 653;

DELETE FROM "public"."directus_fields" WHERE "id" = 654;

DELETE FROM "public"."directus_fields" WHERE "id" = 655;

DELETE FROM "public"."directus_fields" WHERE "id" = 651;

DELETE FROM "public"."directus_fields" WHERE "id" = 650;

DELETE FROM "public"."directus_fields" WHERE "id" = 717;

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

DELETE FROM "public"."directus_fields" WHERE "id" = 735;

DELETE FROM "public"."directus_fields" WHERE "id" = 736;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 713;

DELETE FROM "public"."directus_permissions" WHERE "id" = 714;

DELETE FROM "public"."directus_permissions" WHERE "id" = 715;

DELETE FROM "public"."directus_permissions" WHERE "id" = 716;

DELETE FROM "public"."directus_permissions" WHERE "id" = 717;

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

DELETE FROM "public"."directus_relations" WHERE "id" = 201;

DELETE FROM "public"."directus_relations" WHERE "id" = 202;

DELETE FROM "public"."directus_relations" WHERE "id" = 221;

DELETE FROM "public"."directus_relations" WHERE "id" = 216;

DELETE FROM "public"."directus_relations" WHERE "id" = 217;

DELETE FROM "public"."directus_relations" WHERE "id" = 220;

DELETE FROM "public"."directus_relations" WHERE "id" = 222;

DELETE FROM "public"."directus_relations" WHERE "id" = 223;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-18T10:58:17.187Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" ADD COLUMN IF NOT EXISTS "notificationtemplate_id" uuid NULL  ;

COMMENT ON COLUMN "public"."images"."notificationtemplate_id"  IS NULL;

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

GRANT SELECT ON TABLE "public"."notificationtemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notificationtemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notificationtemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."notificationtemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

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

--- BEGIN CREATE TABLE "public"."notifications" ---

DROP TABLE IF EXISTS "public"."notifications";

CREATE TABLE IF NOT EXISTS "public"."notifications" (
                                "status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
                                "user_created" uuid NULL  ,
                                "date_created" timestamptz NULL  ,
                                "user_updated" uuid NULL  ,
                                "date_updated" timestamptz NULL  ,
                                "template_id" uuid NULL  ,
                                "schedule_at" timestamp NULL  ,
                                "action" varchar(255) NULL  ,
                                "deep_link" varchar(255) NULL  ,
                                "id" uuid NOT NULL  ,
                                "send_started" timestamp NULL  ,
                                "send_completed" timestamp NULL  ,
                                CONSTRAINT "notifications_id_key" UNIQUE (id) ,
                                CONSTRAINT "notifications_pk" PRIMARY KEY (id) ,
                                CONSTRAINT "notifications_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
                                CONSTRAINT "notifications_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
                                CONSTRAINT "notifications_template_id_foreign" FOREIGN KEY (template_id) REFERENCES notificationtemplates(id)
);

CREATE UNIQUE INDEX IF NOT EXISTS notifications_id_key ON public.notifications USING btree (id);


CREATE UNIQUE INDEX IF NOT EXISTS notifications_id_uindex ON public.notifications USING btree (id);

GRANT SELECT, UPDATE ON TABLE "public"."notifications" TO background_worker;

GRANT SELECT ON TABLE "public"."notifications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notifications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notifications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."notifications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."notifications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."notifications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."notifications" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notifications"."status"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."template_id"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."schedule_at"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."action"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."deep_link"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."id"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."send_started"  IS NULL;


COMMENT ON COLUMN "public"."notifications"."send_completed"  IS NULL;


COMMENT ON CONSTRAINT "notifications_pk" ON "public"."notifications" IS NULL;


COMMENT ON CONSTRAINT "notifications_user_created_foreign" ON "public"."notifications" IS NULL;


COMMENT ON CONSTRAINT "notifications_user_updated_foreign" ON "public"."notifications" IS NULL;


COMMENT ON CONSTRAINT "notifications_template_id_foreign" ON "public"."notifications" IS NULL;

COMMENT ON INDEX "public"."notifications_id_key"  IS NULL;


COMMENT ON INDEX "public"."notifications_id_uindex"  IS NULL;

COMMENT ON TABLE "public"."notifications"  IS NULL;

--- END CREATE TABLE "public"."notifications" ---

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

GRANT SELECT ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

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

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "images_notificationtemplate_id_foreign" FOREIGN KEY (notificationtemplate_id) REFERENCES notificationtemplates(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "images_notificationtemplate_id_foreign" ON "public"."images" IS NULL;

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('notifications', NULL, NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 7, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('notificationtemplates', NULL, NULL, '{{label}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'notifications', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('notificationtemplates_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'notificationtemplates', 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (652, 'notifications', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (653, 'notifications', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (654, 'notifications', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (655, 'notifications', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (651, 'notifications', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, NULL, 'full', NULL, NULL, '[{"name":"Readonly when published","rule":{"_and":[{"_and":[{"status":{"_eq":"published"}},{"id":{"_nnull":true}}]}]},"readonly":true,"options":{"allowOther":false,"allowNone":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (650, 'notifications', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (717, 'notificationtemplates', 'images', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (718, 'images', 'notificationtemplate_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 6, 'full', NULL, NULL, NULL, false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (730, 'notifications', 'action', NULL, 'select-dropdown', '{"choices":[{"text":"Deep Link","value":"deep_link"},{"text":"Clear Cache","value":"clear_cache"}],"allowNone":true}', 'labels', NULL, false, false, 3, 'half', NULL, 'Any specific action that should happen?', NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (731, 'notifications', 'deep_link', NULL, 'input', NULL, 'raw', NULL, false, true, 4, 'half', NULL, NULL, '[{"name":"show if deeplink","rule":{"_and":[{"action":{"_eq":"deep_link"}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (722, 'notificationtemplates_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (723, 'notificationtemplates_translations', 'notificationtemplates_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (719, 'notifications', 'template_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 1, 'full', NULL, 'Templates contains translations and images for the notification. Leave empty to trigger only a notification.', '[]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (721, 'notificationtemplates', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (724, 'notificationtemplates_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (720, 'notificationtemplates', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 6, 'full', NULL, 'For internal use', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (725, 'notificationtemplates_translations', 'title', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (726, 'notificationtemplates_translations', 'description', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (707, 'notificationtemplates', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (708, 'notificationtemplates', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (709, 'notificationtemplates', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (710, 'notificationtemplates', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (706, 'notificationtemplates', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (727, 'notifications', 'config', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 7, 'full', NULL, NULL, '[{"name":"Readonly on published","rule":{"_and":[{"status":{"_eq":"published"}}]},"readonly":true,"options":{"start":"open"}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (728, 'notifications', 'schedule_at', NULL, 'datetime', NULL, 'datetime', '{}', false, false, 2, 'full', NULL, 'Should the notification be run at a specific time?', NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (735, 'notifications', 'send_started', NULL, 'datetime', NULL, 'datetime', NULL, true, false, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (736, 'notifications', 'send_completed', NULL, NULL, NULL, NULL, NULL, true, false, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (713, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (714, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (715, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (716, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (717, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'share', '{}', '{}', NULL, '*');

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

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (201, 'notifications', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (202, 'notifications', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (221, 'notifications', 'template_id', 'notificationtemplates', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (216, 'notificationtemplates', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (217, 'notificationtemplates', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (220, 'images', 'notificationtemplate_id', 'notificationtemplates', 'images', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (222, 'notificationtemplates_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'notificationtemplates_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (223, 'notificationtemplates_translations', 'notificationtemplates_id', 'notificationtemplates', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
