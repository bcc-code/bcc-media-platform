-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-14T13:11:51.343Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."achievementgroups_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."achievementgroups_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."achievementgroups_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."achievementgroups_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."achievementgroups_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."achievementgroups_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."achievementgroups_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."achievements_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."achievements_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."achievements_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."achievements_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."achievements_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."achievements_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."achievements_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."achievementgroups" ---

CREATE TABLE IF NOT EXISTS "public"."achievementgroups"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "title"        varchar(255) NULL,
    CONSTRAINT "achievementgroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "achievementgroups_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "achievementgroups_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."achievementgroups" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."achievementgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievementgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."achievementgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."achievementgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."achievementgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."achievementgroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."achievementgroups"."id" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups"."status" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups"."user_created" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups"."date_created" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups"."title" IS NULL;

COMMENT ON CONSTRAINT "achievementgroups_pkey" ON "public"."achievementgroups" IS NULL;


COMMENT ON CONSTRAINT "achievementgroups_user_updated_foreign" ON "public"."achievementgroups" IS NULL;


COMMENT ON CONSTRAINT "achievementgroups_user_created_foreign" ON "public"."achievementgroups" IS NULL;

COMMENT ON TABLE "public"."achievementgroups" IS NULL;

--- END CREATE TABLE "public"."achievementgroups" ---

--- BEGIN CREATE TABLE "public"."achievements" ---

CREATE TABLE IF NOT EXISTS "public"."achievements"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "group_id"     uuid         NULL,
    "title"        varchar(255) NULL,
    CONSTRAINT "achievements_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "achievements_group_id_foreign" FOREIGN KEY (group_id) REFERENCES achievementgroups (id),
    CONSTRAINT "achievements_pkey" PRIMARY KEY (id),
    CONSTRAINT "achievements_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."achievements" TO api, directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."achievements" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievements" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."achievements" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."achievements" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."achievements" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."achievements" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."achievements"."id" IS NULL;


COMMENT ON COLUMN "public"."achievements"."status" IS NULL;


COMMENT ON COLUMN "public"."achievements"."user_created" IS NULL;


COMMENT ON COLUMN "public"."achievements"."date_created" IS NULL;


COMMENT ON COLUMN "public"."achievements"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."achievements"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."achievements"."group_id" IS NULL;


COMMENT ON COLUMN "public"."achievements"."title" IS NULL;

COMMENT ON CONSTRAINT "achievements_user_created_foreign" ON "public"."achievements" IS NULL;


COMMENT ON CONSTRAINT "achievements_group_id_foreign" ON "public"."achievements" IS NULL;


COMMENT ON CONSTRAINT "achievements_pkey" ON "public"."achievements" IS NULL;


COMMENT ON CONSTRAINT "achievements_user_updated_foreign" ON "public"."achievements" IS NULL;

COMMENT ON TABLE "public"."achievements" IS NULL;

--- END CREATE TABLE "public"."achievements" ---

--- BEGIN CREATE TABLE "public"."achievements_images" ---

CREATE TABLE IF NOT EXISTS "public"."achievements_images"
(
    "id"             uuid         NOT NULL,
    "image"          uuid         NULL,
    "achievement_id" uuid         NULL,
    "language"       varchar(255) NULL,
    CONSTRAINT "achievements_images_language_foreign" FOREIGN KEY (language) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "achievements_images_pkey" PRIMARY KEY (id),
    CONSTRAINT "achievements_images_image_foreign" FOREIGN KEY (image) REFERENCES directus_files (id) ON DELETE SET NULL,
    CONSTRAINT "achievements_images_achievement_id_foreign" FOREIGN KEY (achievement_id) REFERENCES achievements (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."achievements_images" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."achievements_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievements_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."achievements_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."achievements_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."achievements_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."achievements_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."achievements_images"."id" IS NULL;


COMMENT ON COLUMN "public"."achievements_images"."image" IS NULL;


COMMENT ON COLUMN "public"."achievements_images"."achievement_id" IS NULL;


COMMENT ON COLUMN "public"."achievements_images"."language" IS NULL;

COMMENT ON CONSTRAINT "achievements_images_language_foreign" ON "public"."achievements_images" IS NULL;


COMMENT ON CONSTRAINT "achievements_images_pkey" ON "public"."achievements_images" IS NULL;


COMMENT ON CONSTRAINT "achievements_images_image_foreign" ON "public"."achievements_images" IS NULL;


COMMENT ON CONSTRAINT "achievements_images_achievement_id_foreign" ON "public"."achievements_images" IS NULL;

COMMENT ON TABLE "public"."achievements_images" IS NULL;

--- END CREATE TABLE "public"."achievements_images" ---


--- BEGIN CREATE TABLE "public"."achievementgroups_translations" ---

CREATE TABLE IF NOT EXISTS "public"."achievementgroups_translations"
(
    "id"                   int4         NOT NULL DEFAULT nextval('achievementgroups_translations_id_seq'::regclass),
    "achievementgroups_id" uuid         NULL,
    "languages_code"       varchar(255) NULL,
    "title"                varchar(255) NULL,
    CONSTRAINT "achievementgroups_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "achievementgroups_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "achievementgroups_translations_achievementgroups_id_foreign" FOREIGN KEY (achievementgroups_id) REFERENCES achievementgroups (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."achievementgroups_translations" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."achievementgroups_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievementgroups_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."achievementgroups_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."achievementgroups_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."achievementgroups_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."achievementgroups_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."achievementgroups_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups_translations"."achievementgroups_id" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."achievementgroups_translations"."title" IS NULL;

COMMENT ON CONSTRAINT "achievementgroups_translations_pkey" ON "public"."achievementgroups_translations" IS NULL;


COMMENT ON CONSTRAINT "achievementgroups_translations_languages_code_foreign" ON "public"."achievementgroups_translations" IS NULL;


COMMENT ON CONSTRAINT "achievementgroups_translations_achievementgroups_id_foreign" ON "public"."achievementgroups_translations" IS NULL;

COMMENT ON TABLE "public"."achievementgroups_translations" IS NULL;

--- END CREATE TABLE "public"."achievementgroups_translations" ---

--- BEGIN CREATE TABLE "public"."achievements_translations" ---

CREATE TABLE IF NOT EXISTS "public"."achievements_translations"
(
    "id"              int4         NOT NULL DEFAULT nextval('achievements_translations_id_seq'::regclass),
    "achievements_id" uuid         NULL,
    "languages_code"  varchar(255) NOT NULL DEFAULT NULL::character varying,
    "title"           varchar(255) NULL,
    CONSTRAINT "achievements_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code),
    CONSTRAINT "achievements_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "achievements_translations_achievements_id_foreign" FOREIGN KEY (achievements_id) REFERENCES achievements (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."achievements_translations" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."achievements_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievements_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."achievements_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."achievements_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."achievements_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."achievements_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."achievements_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."achievements_translations"."achievements_id" IS NULL;


COMMENT ON COLUMN "public"."achievements_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."achievements_translations"."title" IS NULL;

COMMENT ON CONSTRAINT "achievements_translations_languages_code_foreign" ON "public"."achievements_translations" IS NULL;


COMMENT ON CONSTRAINT "achievements_translations_pkey" ON "public"."achievements_translations" IS NULL;


COMMENT ON CONSTRAINT "achievements_translations_achievements_id_foreign" ON "public"."achievements_translations" IS NULL;

COMMENT ON TABLE "public"."achievements_translations" IS NULL;

--- END CREATE TABLE "public"."achievements_translations" ---

--- BEGIN CREATE TABLE "public"."achievementconditions" ---

CREATE TABLE IF NOT EXISTS "public"."achievementconditions"
(
    "id"             uuid         NOT NULL,
    "collection"     varchar(255) NULL,
    "action"         varchar(255) NULL,
    "amount"         int4         NULL,
    "achievement_id" uuid         NULL,
    CONSTRAINT "achievementconditions_pkey" PRIMARY KEY (id),
    CONSTRAINT "achievementconditions_achievement_id_foreign" FOREIGN KEY (achievement_id) REFERENCES achievements (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."achievementconditions" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."achievementconditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievementconditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."achievementconditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."achievementconditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."achievementconditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."achievementconditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."achievementconditions"."id" IS NULL;


COMMENT ON COLUMN "public"."achievementconditions"."collection" IS NULL;


COMMENT ON COLUMN "public"."achievementconditions"."action" IS NULL;


COMMENT ON COLUMN "public"."achievementconditions"."amount" IS NULL;


COMMENT ON COLUMN "public"."achievementconditions"."achievement_id" IS NULL;

COMMENT ON CONSTRAINT "achievementconditions_pkey" ON "public"."achievementconditions" IS NULL;


COMMENT ON CONSTRAINT "achievementconditions_achievement_id_foreign" ON "public"."achievementconditions" IS NULL;

COMMENT ON TABLE "public"."achievementconditions" IS NULL;

--- END CREATE TABLE "public"."achievementconditions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('achievements', 'stars', NULL, '{{title}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL,
        'all', '#FFA439', NULL, 9, NULL, 'open');


UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'main_content';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('achievementconditions', NULL, NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL,
        2, 'achievements', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('achievements_images', NULL, NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 3,
        'achievements', 'open');

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'ageratings_translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('achievementgroups_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL,
        'all', NULL, NULL, 21, 'translations', 'open');

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'FAQ';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'studies';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'studytopics_translations';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'messagetemplates_translations';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'events_translations';

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'categories_translations';

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'calendarentries_translations';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'tags_translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('achievements_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL,
        'all', NULL, NULL, 20, 'translations', 'open');

UPDATE "public"."directus_collections"
SET "sort" = 23
WHERE "collection" = 'translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('achievementgroups', NULL, NULL, '{{title}}', false, false, '[
  {
    "language": "en-US",
    "translation": "Groups",
    "singular": "Group",
    "plural": "Groups"
  }
]', 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'achievements', 'open');

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'faqs_translations';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'faq_categories_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (919, 'achievements_images', 'language', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false,
        false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (940, 'achievementconditions', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (947, 'achievementconditions', 'achievement_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true,
        NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (916, 'achievements_images', 'image', 'file', 'file-image', NULL, 'image', NULL, false, false, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (941, 'achievementconditions', 'collection', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "Lessons",
      "value": "lessons"
    },
    {
      "text": "Tasks",
      "value": "tasks"
    },
    {
      "text": "Topics",
      "value": "topics"
    },
    {
      "text": "Episodes",
      "value": "episodes"
    }
  ]
}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (943, 'achievementconditions', 'amount', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (918, 'achievements_images', 'achievement_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 2,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (917, 'achievements', 'images', 'o2m', 'list-o2m', NULL, 'raw', NULL, false, false, 10, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (920, 'achievementgroups', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (922, 'achievementgroups', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (923, 'achievementgroups', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (924, 'achievementgroups', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (925, 'achievementgroups', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (929, 'achievementgroups_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (927, 'achievementgroups_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (928, 'achievementgroups_translations', 'achievementgroups_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (934, 'achievements', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 8, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (935, 'achievements', 'translations', 'translations', NULL, NULL, NULL, NULL, false, true, 11, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (932, 'achievements', 'group_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', '{
  "template": "{{title}}"
}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (938, 'achievements_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (926, 'achievementgroups', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false,
        true, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (942, 'achievementconditions', 'action', NULL, 'select-dropdown', '{
  "choices": null
}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, '[
  {
    "name": "Watched",
    "rule": {
      "_and": [
        {
          "_and": [
            {
              "collection": {
                "_eq": "episodes"
              }
            }
          ]
        }
      ]
    },
    "options": {
      "allowOther": false,
      "allowNone": false,
      "choices": [
        {
          "text": "Watched",
          "value": "watched"
        }
      ]
    }
  },
  {
    "name": "Completed",
    "rule": {
      "_and": [
        {
          "collection": {
            "_in": [
              "lessons",
              "tasks",
              "topics"
            ]
          }
        }
      ]
    },
    "options": {
      "allowOther": false,
      "allowNone": false,
      "choices": [
        {
          "text": "Completed",
          "value": "completed"
        }
      ]
    }
  }
]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (933, 'achievementgroups', 'achievements', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 10,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (931, 'achievementgroups_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (930, 'achievementgroups', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (902, 'achievements', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (903, 'achievements', 'status', NULL, 'select-dropdown', '{
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
VALUES (904, 'achievements', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (905, 'achievements', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (906, 'achievements', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (907, 'achievements', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (936, 'achievements_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (937, 'achievements_translations', 'achievements_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (921, 'achievementgroups', 'status', NULL, 'select-dropdown', '{
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
VALUES (915, 'achievements_images', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (939, 'achievements_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (946, 'achievements', 'conditions', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 9, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (275, 'achievements', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (278, 'achievements_images', 'image', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (280, 'achievements_images', 'language', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (282, 'achievementgroups', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (287, 'achievements_translations', 'achievements_id', 'achievements', 'translations', NULL, NULL,
        'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (286, 'achievements_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'achievements_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (289, 'achievementconditions', 'achievement_id', 'achievements', 'conditions', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (274, 'achievements', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (279, 'achievements_images', 'achievement_id', 'achievements', 'images', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (281, 'achievementgroups', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (283, 'achievementgroups_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'achievementgroups_id',
        NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (284, 'achievementgroups_translations', 'achievementgroups_id', 'achievementgroups', 'translations', NULL, NULL,
        'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (285, 'achievements', 'group_id', 'achievementgroups', 'achievements', NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-14T13:11:52.732Z             ***/
/***********************************************************/


--- BEGIN DROP TABLE "public"."achievementgroups_translations" ---

DROP TABLE IF EXISTS "public"."achievementgroups_translations";

--- END DROP TABLE "public"."achievementgroups_translations" ---

--- BEGIN DROP TABLE "public"."achievements_translations" ---

DROP TABLE IF EXISTS "public"."achievements_translations";

--- END DROP TABLE "public"."achievements_translations" ---

--- BEGIN DROP TABLE "public"."achievementconditions" ---

DROP TABLE IF EXISTS "public"."achievementconditions";

--- END DROP TABLE "public"."achievementconditions" ---

--- BEGIN DROP TABLE "public"."achievements_images" ---

DROP TABLE IF EXISTS "public"."achievements_images";

--- END DROP TABLE "public"."achievements_images" ---

--- BEGIN DROP TABLE "public"."achievements" ---

DROP TABLE IF EXISTS "public"."achievements";

--- END DROP TABLE "public"."achievements" ---

--- BEGIN DROP TABLE "public"."achievementgroups" ---

DROP TABLE IF EXISTS "public"."achievementgroups";

--- END DROP TABLE "public"."achievementgroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'FAQ';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'faqs_translations';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'faq_categories_translations';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'messagetemplates_translations';

UPDATE "public"."directus_collections"
SET "sort" = 21
WHERE "collection" = 'translations';

UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections"
SET "sort" = 22
WHERE "collection" = 'studytopics_translations';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'studies';

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'events_translations';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'categories_translations';

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'calendarentries_translations';

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'tags_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'achievementgroups_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'achievements_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'achievementconditions';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'achievements_images';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'achievementgroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'achievements';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 919;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 940;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 947;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 916;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 941;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 943;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 918;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 917;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 920;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 922;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 923;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 924;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 925;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 929;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 927;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 928;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 934;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 935;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 932;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 938;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 926;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 942;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 933;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 931;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 930;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 902;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 903;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 904;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 905;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 906;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 907;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 936;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 937;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 921;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 915;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 939;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 946;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 275;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 278;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 280;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 282;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 287;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 286;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 289;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 274;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 279;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 281;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 283;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 284;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 285;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
