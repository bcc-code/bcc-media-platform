-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-04T07:42:17.902Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."faqs_translations_id_seq1" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqs_translations_id_seq1"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."faqs_translations_id_seq1" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqs_translations_id_seq1" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_translations_id_seq1" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."faqs_translations_id_seq1" IS NULL;

--- END CREATE SEQUENCE "public"."faqs_translations_id_seq1" ---

--- BEGIN CREATE SEQUENCE "public"."faqs_usergroups_id_seq1" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqs_usergroups_id_seq1"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."faqs_usergroups_id_seq1" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqs_usergroups_id_seq1" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_usergroups_id_seq1" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."faqs_usergroups_id_seq1" IS NULL;

--- END CREATE SEQUENCE "public"."faqs_usergroups_id_seq1" ---

--- BEGIN CREATE SEQUENCE "public"."faqcategories_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqcategories_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."faqcategories_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqcategories_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqcategories_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."faqcategories_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."faqcategories_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."faqcategories" ---

CREATE TABLE IF NOT EXISTS "public"."faqcategories"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "sort"         int4         NULL,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "title"        text         NOT NULL,
    "description"  text         NULL,
    CONSTRAINT "faqcategories_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "faqcategories_pkey" PRIMARY KEY (id),
    CONSTRAINT "faqcategories_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."faqcategories" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqcategories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqcategories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqcategories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqcategories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqcategories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqcategories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faqcategories"."id" IS NULL;


COMMENT ON COLUMN "public"."faqcategories"."status" IS NULL;


COMMENT ON COLUMN "public"."faqcategories"."sort" IS NULL;


COMMENT ON COLUMN "public"."faqcategories"."user_created" IS NULL;


COMMENT ON COLUMN "public"."faqcategories"."date_created" IS NULL;


COMMENT ON COLUMN "public"."faqcategories"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."faqcategories"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."faqcategories"."title" IS NULL;


COMMENT ON COLUMN "public"."faqcategories"."description" IS NULL;

COMMENT ON CONSTRAINT "faqcategories_user_updated_foreign" ON "public"."faqcategories" IS NULL;


COMMENT ON CONSTRAINT "faqcategories_pkey" ON "public"."faqcategories" IS NULL;


COMMENT ON CONSTRAINT "faqcategories_user_created_foreign" ON "public"."faqcategories" IS NULL;

COMMENT ON TABLE "public"."faqcategories" IS NULL;

--- END CREATE TABLE "public"."faqcategories" ---

--- BEGIN CREATE TABLE "public"."faqs" ---

CREATE TABLE IF NOT EXISTS "public"."faqs"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "sort"         int4         NULL,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "question"     text         NOT NULL,
    "answer"       text         NOT NULL,
    "category_id"  uuid         NOT NULL,
    CONSTRAINT "faqs_pkey" PRIMARY KEY (id),
    CONSTRAINT "faqs_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "faqs_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "faqs_category_id_foreign" FOREIGN KEY (category_id) REFERENCES faqcategories (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."faqs" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faqs"."id" IS NULL;


COMMENT ON COLUMN "public"."faqs"."status" IS NULL;


COMMENT ON COLUMN "public"."faqs"."sort" IS NULL;


COMMENT ON COLUMN "public"."faqs"."user_created" IS NULL;


COMMENT ON COLUMN "public"."faqs"."date_created" IS NULL;


COMMENT ON COLUMN "public"."faqs"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."faqs"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."faqs"."question" IS NULL;


COMMENT ON COLUMN "public"."faqs"."answer" IS NULL;


COMMENT ON COLUMN "public"."faqs"."category_id" IS NULL;

COMMENT ON CONSTRAINT "faqs_pkey" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_user_created_foreign" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_user_updated_foreign" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_category_id_foreign" ON "public"."faqs" IS NULL;

COMMENT ON TABLE "public"."faqs" IS NULL;

--- END CREATE TABLE "public"."faqs" ---


--- BEGIN CREATE TABLE "public"."faqs_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."faqs_usergroups"
(
    "id"              int4         NOT NULL DEFAULT nextval('faqs_usergroups_id_seq1'::regclass),
    "faqs_id"         uuid         NULL,
    "usergroups_code" varchar(255) NULL,
    CONSTRAINT "faqs_usergroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "faqs_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE SET NULL,
    CONSTRAINT "faqs_usergroups_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."faqs_usergroups" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faqs_usergroups"."id" IS NULL;


COMMENT ON COLUMN "public"."faqs_usergroups"."faqs_id" IS NULL;


COMMENT ON COLUMN "public"."faqs_usergroups"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "faqs_usergroups_pkey" ON "public"."faqs_usergroups" IS NULL;


COMMENT ON CONSTRAINT "faqs_usergroups_usergroups_code_foreign" ON "public"."faqs_usergroups" IS NULL;


COMMENT ON CONSTRAINT "faqs_usergroups_faqs_id_foreign" ON "public"."faqs_usergroups" IS NULL;

COMMENT ON TABLE "public"."faqs_usergroups" IS NULL;

--- END CREATE TABLE "public"."faqs_usergroups" ---

--- BEGIN CREATE TABLE "public"."faqs_translations" ---

CREATE TABLE IF NOT EXISTS "public"."faqs_translations"
(
    "id"             int4         NOT NULL DEFAULT nextval('faqs_translations_id_seq1'::regclass),
    "faqs_id"        uuid         NULL,
    "languages_code" varchar(255) NULL,
    "question"       text         NULL,
    "answer"         text         NULL,
    CONSTRAINT "faqs_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "faqs_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE,
    CONSTRAINT "faqs_translations_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."faqs_translations" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faqs_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."faqs_id" IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."question" IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."answer" IS NULL;

COMMENT ON CONSTRAINT "faqs_translations_pkey" ON "public"."faqs_translations" IS NULL;


COMMENT ON CONSTRAINT "faqs_translations_languages_code_foreign" ON "public"."faqs_translations" IS NULL;


COMMENT ON CONSTRAINT "faqs_translations_faqs_id_foreign" ON "public"."faqs_translations" IS NULL;

COMMENT ON TABLE "public"."faqs_translations" IS NULL;

--- END CREATE TABLE "public"."faqs_translations" ---

--- BEGIN CREATE TABLE "public"."faqcategories_translations" ---

CREATE TABLE IF NOT EXISTS "public"."faqcategories_translations"
(
    "id"               int4         NOT NULL DEFAULT nextval('faqcategories_translations_id_seq'::regclass),
    "faqcategories_id" uuid         NULL,
    "languages_code"   varchar(255) NULL,
    "description"      text         NULL,
    "title"            text         NULL,
    CONSTRAINT "faqcategories_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE,
    CONSTRAINT "faqcategories_translations_faqcategories_id_foreign" FOREIGN KEY (faqcategories_id) REFERENCES faqcategories (id) ON DELETE CASCADE,
    CONSTRAINT "faqcategories_translations_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."faqcategories_translations" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqcategories_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqcategories_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqcategories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqcategories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqcategories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqcategories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faqcategories_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."faqcategories_translations"."faqcategories_id" IS NULL;


COMMENT ON COLUMN "public"."faqcategories_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."faqcategories_translations"."description" IS NULL;


COMMENT ON COLUMN "public"."faqcategories_translations"."title" IS NULL;

COMMENT ON CONSTRAINT "faqcategories_translations_languages_code_foreign" ON "public"."faqcategories_translations" IS NULL;


COMMENT ON CONSTRAINT "faqcategories_translations_faqcategories_id_foreign" ON "public"."faqcategories_translations" IS NULL;


COMMENT ON CONSTRAINT "faqcategories_translations_pkey" ON "public"."faqcategories_translations" IS NULL;

COMMENT ON TABLE "public"."faqcategories_translations" IS NULL;

--- END CREATE TABLE "public"."faqcategories_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faqcategories_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL,
        'all', NULL, NULL, NULL, NULL, 'open');

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'achievements';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faqs_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, NULL, NULL, 'open');

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'computeddata';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'notifications';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faqs', 'question_mark', NULL, '{{question}}', false, false, NULL, 'status', true, 'archived', 'draft', 'sort',
        'all', '#2ECDA7', NULL, 9, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faqcategories', 'tab_group', NULL, '{{title}}', false, false, NULL, 'status', true, 'archived', 'draft',
        'sort', 'all', NULL, NULL, 1, 'faqs', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faqs_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, 30, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1143, 'faqs_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1144, 'faqs_translations', 'faqs_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1145, 'faqs_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1140, 'faqs', 'question', NULL, 'input', NULL, 'raw', NULL, false, false, 9, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1141, 'faqs', 'answer', NULL, 'input-multiline', '{
  "softLength": 2048
}', 'raw', NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1146, 'faqcategories', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1148, 'faqcategories', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 3, 'half', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1149, 'faqcategories', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1142, 'faqs', 'translations', 'translations', 'translations', '{
  "languageField": "code",
  "languageDirectionField": "code",
  "defaultLanguage": "no",
  "userLanguage": true
}', 'translations', NULL, true, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1147, 'faqcategories', 'status', NULL, 'select-dropdown', '{
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
}', false, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1150, 'faqcategories', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1151, 'faqcategories', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1152, 'faqcategories', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1153, 'faqs', 'category_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', '{
  "template": "{{title}}"
}', false, false, 8, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1154, 'faqcategories', 'faqs', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1157, 'faqcategories_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1158, 'faqcategories_translations', 'faqcategories_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1159, 'faqcategories_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1160, 'faqs_translations', 'question', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1161, 'faqs_translations', 'answer', NULL, 'input', '{
  "softLength": 2048
}', 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1165, 'faqcategories_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1164, 'faqcategories_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 5, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1166, 'faqcategories', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 8, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1167, 'faqcategories', 'description', NULL, 'input-multiline', NULL, 'raw', NULL, false, false, 9, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1156, 'faqcategories', 'translations', 'translations', 'translations', '{
  "languageField": "code",
  "languageDirectionField": "code",
  "defaultLanguage": "no",
  "userLanguage": true
}', 'translations', '{
  "template": "{{title}}",
  "languageField": "code",
  "defaultLanguage": "no",
  "userLanguage": true
}', true, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1168, 'faqs', 'usergroups', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1169, 'faqs_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1170, 'faqs_usergroups', 'faqs_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1171, 'faqs_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1139, 'faqs', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1133, 'faqs', 'id', 'uuid', 'input', NULL, NULL, NULL, true, false, 1, 'half', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1134, 'faqs', 'status', NULL, 'select-dropdown', '{
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
}', false, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1135, 'faqs', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1136, 'faqs', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1137, 'faqs', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1138, 'faqs', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (346, 'faqs', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (347, 'faqs', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (348, 'faqs_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'faqs_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (349, 'faqs_translations', 'faqs_id', 'faqs', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (350, 'faqcategories', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (351, 'faqcategories', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (352, 'faqs', 'category_id', 'faqcategories', 'faqs', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (353, 'faqcategories_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'faqcategories_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (354, 'faqcategories_translations', 'faqcategories_id', 'faqcategories', 'translations', NULL, NULL,
        'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (355, 'faqs_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'faqs_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (356, 'faqs_usergroups', 'faqs_id', 'faqs', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-04T07:42:19.519Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."faqs_usergroups" ---

DROP TABLE IF EXISTS "public"."faqs_usergroups";

--- END DROP TABLE "public"."faqs_usergroups" ---

--- BEGIN DROP TABLE "public"."faqs_translations" ---

DROP TABLE IF EXISTS "public"."faqs_translations";

--- END DROP TABLE "public"."faqs_translations" ---

--- BEGIN DROP TABLE "public"."faqs" ---

DROP TABLE IF EXISTS "public"."faqs";

--- END DROP TABLE "public"."faqs" ---

--- BEGIN DROP TABLE "public"."faqcategories_translations" ---

DROP TABLE IF EXISTS "public"."faqcategories_translations";

--- END DROP TABLE "public"."faqcategories_translations" ---

--- BEGIN DROP TABLE "public"."faqcategories" ---

DROP TABLE IF EXISTS "public"."faqcategories";

--- END DROP TABLE "public"."faqcategories" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'achievements';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'computeddata';

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'notifications';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqcategories_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqs_usergroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqcategories';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqs_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqs';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1143;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1144;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1145;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1140;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1141;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1146;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1148;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1149;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1142;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1147;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1150;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1151;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1152;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1153;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1154;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1157;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1158;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1159;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1160;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1161;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1165;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1164;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1166;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1167;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1156;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1168;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1169;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1170;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1171;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1139;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1133;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1134;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1135;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1136;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1137;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1138;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 346;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 347;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 348;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 349;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 350;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 351;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 352;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 353;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 354;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 355;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 356;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
