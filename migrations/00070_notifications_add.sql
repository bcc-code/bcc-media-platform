-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-18T11:26:28.606Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."notificationtemplates_translations_id_seq1" ---


CREATE SEQUENCE IF NOT EXISTS "public"."notificationtemplates_translations_id_seq1"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."notificationtemplates_translations_id_seq1" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."notificationtemplates_translations_id_seq1" IS NULL;

--- END CREATE SEQUENCE "public"."notificationtemplates_translations_id_seq1" ---

--- BEGIN CREATE TABLE "public"."notificationtemplates" ---

CREATE TABLE IF NOT EXISTS "public"."notificationtemplates"
(
    "id"           uuid         NOT NULL,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "label"        varchar(255) NULL,
    CONSTRAINT "notificationtemplates_pkey" PRIMARY KEY (id),
    CONSTRAINT "notificationtemplates_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "notificationtemplates_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."notificationtemplates" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notificationtemplates"."id" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."user_created" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."date_created" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates"."label" IS NULL;

COMMENT ON CONSTRAINT "notificationtemplates_pkey" ON "public"."notificationtemplates" IS NULL;


COMMENT ON CONSTRAINT "notificationtemplates_user_created_foreign" ON "public"."notificationtemplates" IS NULL;


COMMENT ON CONSTRAINT "notificationtemplates_user_updated_foreign" ON "public"."notificationtemplates" IS NULL;

COMMENT ON TABLE "public"."notificationtemplates" IS NULL;

--- END CREATE TABLE "public"."notificationtemplates" ---

--- BEGIN CREATE TABLE "public"."notifications" ---

CREATE TABLE IF NOT EXISTS "public"."notifications"
(
    "id"             uuid         NOT NULL,
    "status"         varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created"   uuid         NULL,
    "date_created"   timestamptz  NULL,
    "user_updated"   uuid         NULL,
    "date_updated"   timestamptz  NULL,
    "schedule_at"    timestamp    NULL,
    "send_started"   timestamp    NULL,
    "send_completed" timestamp    NULL,
    "action"         varchar(255) NULL,
    "deep_link"      varchar(255) NULL,
    "template_id"    uuid         NULL,
    CONSTRAINT "notifications_template_id_foreign" FOREIGN KEY (template_id) REFERENCES notificationtemplates (id) ON DELETE CASCADE,
    CONSTRAINT "notifications_pkey" PRIMARY KEY (id),
    CONSTRAINT "notifications_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "notifications_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "public"."notifications" TO background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notifications"."id" IS NULL;


COMMENT ON COLUMN "public"."notifications"."status" IS NULL;


COMMENT ON COLUMN "public"."notifications"."user_created" IS NULL;


COMMENT ON COLUMN "public"."notifications"."date_created" IS NULL;


COMMENT ON COLUMN "public"."notifications"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."notifications"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."notifications"."schedule_at" IS NULL;


COMMENT ON COLUMN "public"."notifications"."send_started" IS NULL;


COMMENT ON COLUMN "public"."notifications"."send_completed" IS NULL;


COMMENT ON COLUMN "public"."notifications"."action" IS NULL;


COMMENT ON COLUMN "public"."notifications"."deep_link" IS NULL;


COMMENT ON COLUMN "public"."notifications"."template_id" IS NULL;

COMMENT ON CONSTRAINT "notifications_template_id_foreign" ON "public"."notifications" IS NULL;


COMMENT ON CONSTRAINT "notifications_pkey" ON "public"."notifications" IS NULL;


COMMENT ON CONSTRAINT "notifications_user_created_foreign" ON "public"."notifications" IS NULL;


COMMENT ON CONSTRAINT "notifications_user_updated_foreign" ON "public"."notifications" IS NULL;

COMMENT ON TABLE "public"."notifications" IS NULL;

--- END CREATE TABLE "public"."notifications" ---

--- BEGIN CREATE TABLE "public"."notificationtemplates_translations" ---

CREATE TABLE IF NOT EXISTS "public"."notificationtemplates_translations"
(
    "id"                       int4         NOT NULL DEFAULT nextval('notificationtemplates_translations_id_seq1'::regclass),
    "notificationtemplates_id" uuid         NULL,
    "languages_code"           varchar(255) NULL,
    "title"                    varchar(255) NULL,
    "description"              varchar(255) NULL,
    CONSTRAINT "notificationtemplates_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "notificationtemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "notificationtemplates_translations_notific__402aa733_foreign" FOREIGN KEY (notificationtemplates_id) REFERENCES notificationtemplates (id) ON DELETE SET NULL
);

GRANT SELECT, UPDATE, DELETE ON TABLE "public"."notificationtemplates_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notificationtemplates_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates_translations"."notificationtemplates_id" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates_translations"."title" IS NULL;


COMMENT ON COLUMN "public"."notificationtemplates_translations"."description" IS NULL;

COMMENT ON CONSTRAINT "notificationtemplates_translations_pkey" ON "public"."notificationtemplates_translations" IS NULL;


COMMENT ON CONSTRAINT "notificationtemplates_translations_languages_code_foreign" ON "public"."notificationtemplates_translations" IS NULL;


COMMENT ON CONSTRAINT "notificationtemplates_translations_notific__402aa733_foreign" ON "public"."notificationtemplates_translations" IS NULL;

COMMENT ON TABLE "public"."notificationtemplates_translations" IS NULL;

--- END CREATE TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images"
    ADD COLUMN IF NOT EXISTS "notificationtemplate_id" uuid NULL;

COMMENT ON COLUMN "public"."images"."notificationtemplate_id" IS NULL;

ALTER TABLE IF EXISTS "public"."images"
    ADD CONSTRAINT "images_notificationtemplate_id_foreign" FOREIGN KEY (notificationtemplate_id) REFERENCES notificationtemplates (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "images_notificationtemplate_id_foreign" ON "public"."images" IS NULL;

--- END ALTER TABLE "public"."images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'messages';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('notifications', 'add_alert', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all',
        '#E35169', NULL, 6, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('notificationtemplates', NULL, NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL,
        1, 'notifications', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('notificationtemplates_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL,
        NULL, 'all', NULL, NULL, 1, 'notificationtemplates', 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (739, 'notifications', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (763, 'notifications', 'template_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false,
        1, 'full', NULL, NULL, NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (741, 'notifications', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (742, 'notifications', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (740, 'notifications', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (737, 'notifications', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (743, 'notifications', 'schedule_at', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 2, 'full', NULL,
        NULL, NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (738, 'notifications', 'status', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "$t:published",
      "value": "published"
    },
    {
      "text": "$t:draft",
      "value": "draft"
    },
    {
      "text": "$t:archived",
      "value": "archived"
    }
  ]
}', 'labels', '{
  "showAsDot": true,
  "choices": [
    {
      "text": "$t:published",
      "value": "published",
      "foreground": "#FFFFFF",
      "background": "var(--primary)"
    },
    {
      "text": "$t:draft",
      "value": "draft",
      "foreground": "#18222F",
      "background": "#D3DAE4"
    },
    {
      "text": "$t:archived",
      "value": "archived",
      "foreground": "#FFFFFF",
      "background": "var(--warning)"
    }
  ]
}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (744, 'notifications', 'config', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 7,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (745, 'notifications', 'send_started', NULL, 'datetime', NULL, 'datetime', NULL, true, false, 8, 'half', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (762, 'images', 'notificationtemplate_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 6, 'full',
        NULL, NULL, NULL, false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (747, 'notifications', 'action', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "Clear Cache",
      "value": "clear_cache"
    },
    {
      "text": "Deep Link",
      "value": "deep_link"
    }
  ]
}', NULL, NULL, false, false, 3, 'half', NULL, NULL, NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (748, 'notifications', 'deep_link', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'half', NULL, NULL, '[
  {
    "name": "Is deep link",
    "rule": {
      "_and": [
        {
          "action": {
            "_neq": "deep_link"
          }
        }
      ]
    },
    "hidden": true,
    "options": {
      "font": "sans-serif",
      "trim": false,
      "masked": false,
      "clear": false,
      "slug": false
    }
  }
]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (746, 'notifications', 'send_completed', NULL, 'datetime', NULL, 'datetime', NULL, true, false, 9, 'half', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (755, 'notificationtemplates', 'translations', 'translations', 'translations', '{
  "languageField": "code",
  "languageDirectionField": "code",
  "defaultLanguage": "no",
  "userLanguage": true
}', 'translations', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (756, 'notificationtemplates_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (757, 'notificationtemplates_translations', 'notificationtemplates_id', NULL, NULL, NULL, NULL, NULL, false,
        true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (749, 'notificationtemplates', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (750, 'notificationtemplates', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (751, 'notificationtemplates', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (752, 'notificationtemplates', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (753, 'notificationtemplates', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (758, 'notificationtemplates_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (754, 'notificationtemplates', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (759, 'notificationtemplates_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (760, 'notificationtemplates_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (761, 'notificationtemplates', 'images', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, NULL,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (224, 'notifications', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (225, 'notifications', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (226, 'notificationtemplates', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (227, 'notificationtemplates', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (228, 'notificationtemplates_translations', 'languages_code', 'languages', NULL, NULL, NULL,
        'notificationtemplates_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (229, 'notificationtemplates_translations', 'notificationtemplates_id', 'notificationtemplates', 'translations',
        NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (230, 'images', 'notificationtemplate_id', 'notificationtemplates', 'images', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (231, 'notifications', 'template_id', 'notificationtemplates', NULL, NULL, NULL, NULL, NULL, 'nullify');

ALTER TABLE IF EXISTS "public"."images"
    ADD CONSTRAINT "one_item" CHECK ((((((
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
                                          END) = 1);

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-18T11:26:29.955Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images"
    DROP COLUMN IF EXISTS "notificationtemplate_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."images"
    DROP CONSTRAINT IF EXISTS "images_notificationtemplate_id_foreign";

--- END ALTER TABLE "public"."images" ---

--- BEGIN DROP TABLE "public"."notifications" ---

DROP TABLE IF EXISTS "public"."notifications";

--- END DROP TABLE "public"."notifications" ---

--- BEGIN DROP TABLE "public"."notificationtemplates_translations" ---

DROP TABLE IF EXISTS "public"."notificationtemplates_translations";

--- END DROP TABLE "public"."notificationtemplates_translations" ---

--- BEGIN DROP TABLE "public"."notificationtemplates" ---

DROP TABLE IF EXISTS "public"."notificationtemplates";

--- END DROP TABLE "public"."notificationtemplates" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'messages';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'notificationtemplates_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'notificationtemplates';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'notifications';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 739;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 763;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 741;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 742;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 740;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 737;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 743;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 738;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 744;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 745;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 762;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 747;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 748;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 746;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 755;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 756;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 757;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 749;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 750;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 751;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 752;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 753;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 758;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 754;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 759;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 760;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 761;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 224;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 225;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 226;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 227;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 228;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 229;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 230;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 231;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
