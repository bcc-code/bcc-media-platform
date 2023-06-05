-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-01T11:52:14.442Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."games_styledimages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."games_styledimages_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."games_styledimages_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."games_styledimages_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."games_styledimages_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."games_styledimages_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."games_styledimages_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."games_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."games_usergroups_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."games_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."games_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."games_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."games_usergroups_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."games_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."games_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."games_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."games_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."games_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."games_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."games_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."games_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."games" ---

CREATE TABLE IF NOT EXISTS "public"."games"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "title"        text         NOT NULL,
    "description"  text         NULL,
    "link_id"      int4         NOT NULL,
    CONSTRAINT "games_pkey" PRIMARY KEY (id),
    CONSTRAINT "games_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "games_link_id_foreign" FOREIGN KEY (link_id) REFERENCES links (id),
    CONSTRAINT "games_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."games" TO directus,api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."games" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."games" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."games" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."games" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."games" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."games" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."games"."id" IS NULL;


COMMENT ON COLUMN "public"."games"."status" IS NULL;


COMMENT ON COLUMN "public"."games"."user_created" IS NULL;


COMMENT ON COLUMN "public"."games"."date_created" IS NULL;


COMMENT ON COLUMN "public"."games"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."games"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."games"."title" IS NULL;


COMMENT ON COLUMN "public"."games"."description" IS NULL;


COMMENT ON COLUMN "public"."games"."link_id" IS NULL;

COMMENT ON CONSTRAINT "games_pkey" ON "public"."games" IS NULL;


COMMENT ON CONSTRAINT "games_user_created_foreign" ON "public"."games" IS NULL;


COMMENT ON CONSTRAINT "games_link_id_foreign" ON "public"."games" IS NULL;


COMMENT ON CONSTRAINT "games_user_updated_foreign" ON "public"."games" IS NULL;

COMMENT ON TABLE "public"."games" IS NULL;

--- END CREATE TABLE "public"."games" ---

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links"
    ALTER COLUMN "type" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."links"
    ADD COLUMN IF NOT EXISTS "requires_authentication" bool NOT NULL DEFAULT false;

COMMENT ON COLUMN "public"."links"."requires_authentication" IS NULL;

--- END ALTER TABLE "public"."links" ---

--- BEGIN CREATE TABLE "public"."games_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."games_usergroups"
(
    "id"              int4         NOT NULL DEFAULT nextval('games_usergroups_id_seq'::regclass),
    "games_id"        uuid         NOT NULL,
    "usergroups_code" varchar(255) NOT NULL,
    CONSTRAINT "games_usergroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "games_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE,
    CONSTRAINT "games_usergroups_games_id_foreign" FOREIGN KEY (games_id) REFERENCES games (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."games_usergroups" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."games_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."games_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."games_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."games_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."games_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."games_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."games_usergroups"."id" IS NULL;


COMMENT ON COLUMN "public"."games_usergroups"."games_id" IS NULL;


COMMENT ON COLUMN "public"."games_usergroups"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "games_usergroups_pkey" ON "public"."games_usergroups" IS NULL;


COMMENT ON CONSTRAINT "games_usergroups_usergroups_code_foreign" ON "public"."games_usergroups" IS NULL;


COMMENT ON CONSTRAINT "games_usergroups_games_id_foreign" ON "public"."games_usergroups" IS NULL;

COMMENT ON TABLE "public"."games_usergroups" IS NULL;

--- END CREATE TABLE "public"."games_usergroups" ---

--- BEGIN CREATE TABLE "public"."games_translations" ---

CREATE TABLE IF NOT EXISTS "public"."games_translations"
(
    "id"             int4         NOT NULL DEFAULT nextval('games_translations_id_seq'::regclass),
    "games_id"       uuid         NOT NULL,
    "languages_code" varchar(255) NOT NULL,
    CONSTRAINT "games_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "games_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "games_translations_games_id_foreign" FOREIGN KEY (games_id) REFERENCES games (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."games_translations" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."games_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."games_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."games_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."games_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."games_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."games_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."games_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."games_translations"."games_id" IS NULL;


COMMENT ON COLUMN "public"."games_translations"."languages_code" IS NULL;

COMMENT ON CONSTRAINT "games_translations_pkey" ON "public"."games_translations" IS NULL;


COMMENT ON CONSTRAINT "games_translations_languages_code_foreign" ON "public"."games_translations" IS NULL;


COMMENT ON CONSTRAINT "games_translations_games_id_foreign" ON "public"."games_translations" IS NULL;

COMMENT ON TABLE "public"."games_translations" IS NULL;

--- END CREATE TABLE "public"."games_translations" ---

--- BEGIN CREATE TABLE "public"."styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."styledimages"
(
    "id"           uuid         NOT NULL,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "style"        varchar(255) NOT NULL,
    "language"     varchar(255) NOT NULL,
    "file"         uuid         NOT NULL,
    CONSTRAINT "styledimages_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "styledimages_file_foreign" FOREIGN KEY (file) REFERENCES directus_files (id),
    CONSTRAINT "styledimages_pkey" PRIMARY KEY (id),
    CONSTRAINT "styledimages_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "styledimages_language_foreign" FOREIGN KEY (language) REFERENCES languages (code) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."styledimages" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."styledimages"."id" IS NULL;


COMMENT ON COLUMN "public"."styledimages"."user_created" IS NULL;


COMMENT ON COLUMN "public"."styledimages"."date_created" IS NULL;


COMMENT ON COLUMN "public"."styledimages"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."styledimages"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."styledimages"."style" IS NULL;


COMMENT ON COLUMN "public"."styledimages"."language" IS NULL;


COMMENT ON COLUMN "public"."styledimages"."file" IS NULL;

COMMENT ON CONSTRAINT "styledimages_user_updated_foreign" ON "public"."styledimages" IS NULL;


COMMENT ON CONSTRAINT "styledimages_file_foreign" ON "public"."styledimages" IS NULL;


COMMENT ON CONSTRAINT "styledimages_pkey" ON "public"."styledimages" IS NULL;


COMMENT ON CONSTRAINT "styledimages_user_created_foreign" ON "public"."styledimages" IS NULL;


COMMENT ON CONSTRAINT "styledimages_language_foreign" ON "public"."styledimages" IS NULL;

COMMENT ON TABLE "public"."styledimages" IS NULL;

--- END CREATE TABLE "public"."styledimages" ---

--- BEGIN CREATE TABLE "public"."games_styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."games_styledimages"
(
    "id"              int4 NOT NULL DEFAULT nextval('games_styledimages_id_seq'::regclass),
    "games_id"        uuid NULL,
    "styledimages_id" uuid NULL,
    CONSTRAINT "games_styledimages_pkey" PRIMARY KEY (id),
    CONSTRAINT "games_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages (id) ON DELETE SET NULL,
    CONSTRAINT "games_styledimages_games_id_foreign" FOREIGN KEY (games_id) REFERENCES games (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."games_styledimages" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."games_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."games_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."games_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."games_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."games_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."games_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."games_styledimages"."id" IS NULL;


COMMENT ON COLUMN "public"."games_styledimages"."games_id" IS NULL;


COMMENT ON COLUMN "public"."games_styledimages"."styledimages_id" IS NULL;

COMMENT ON CONSTRAINT "games_styledimages_pkey" ON "public"."games_styledimages" IS NULL;


COMMENT ON CONSTRAINT "games_styledimages_styledimages_id_foreign" ON "public"."games_styledimages" IS NULL;


COMMENT ON CONSTRAINT "games_styledimages_games_id_foreign" ON "public"."games_styledimages" IS NULL;

COMMENT ON TABLE "public"."games_styledimages" IS NULL;

--- END CREATE TABLE "public"."games_styledimages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('games', 'videogame_asset', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all',
        '#E35169', NULL, 5, 'main_content', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('styledimages', NULL, NULL, '{{language.code}} - {{style}}', true, false, NULL, NULL, true, NULL, NULL, NULL,
        'all', NULL, NULL, NULL, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('games_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, 35, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('games_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, 36, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('games_styledimages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1191, 'games', 'status', NULL, 'select-dropdown', '{
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
VALUES (1192, 'games', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1193, 'games', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1190, 'games', 'id', 'uuid', 'input', NULL, NULL, NULL, true, false, 1, 'half', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1194, 'games', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1195, 'games', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1199, 'games_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1196, 'games', 'roles', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 8, 'full', NULL,
        'Which user roles should have access to this game?', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1197, 'games_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1198, 'games_usergroups', 'games_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Text",
      "value": "text"
    },
    {
      "text": "Audio",
      "value": "audio"
    },
    {
      "text": "Video",
      "value": "video"
    },
    {
      "text": "Game",
      "value": "game"
    },
    {
      "text": "Other",
      "value": "other"
    }
  ]
}'
WHERE "id" = 898;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1201, 'games', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 2, 'full', NULL, NULL, NULL,
        false, 'configuration', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 644;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1200, 'games', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 1, 'full', NULL, NULL, NULL, false,
        'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1203, 'games_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1204, 'games_translations', 'games_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1202, 'games', 'translations', 'translations', 'translations', NULL, 'translations', NULL, true, true, 9,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1207, 'games', 'configuration', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 7,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1205, 'games_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1206, 'games', 'link_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'full',
        NULL, NULL, NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1208, 'links', 'requires_authentication', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 12,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1209, 'styledimages', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1210, 'styledimages', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1211, 'styledimages', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1212, 'styledimages', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1213, 'styledimages', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1214, 'styledimages', 'style', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "Featured",
      "value": "featured"
    },
    {
      "text": "Poster",
      "value": "poster"
    },
    {
      "text": "Default",
      "value": "default"
    },
    {
      "text": "Icon",
      "value": "icon"
    }
  ]
}', 'labels', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1220, 'games_styledimages', 'styledimages_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1217, 'games', 'images', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 4, 'full', NULL, NULL,
        NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1216, 'styledimages', 'file', 'file', 'file-image', NULL, 'image', NULL, false, false, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1215, 'styledimages', 'language', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false,
        NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1039;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1035;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1218, 'games_styledimages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1219, 'games_styledimages', 'games_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (896, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (895, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (897, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (898, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (899, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (900, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games_usergroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (901, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games_usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (902, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games_usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (903, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games_usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (904, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'games_usergroups', 'delete', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (363, 'games', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (364, 'games', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (365, 'games_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'games_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (366, 'games_usergroups', 'games_id', 'games', 'roles', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (367, 'games_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'games_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (368, 'games_translations', 'games_id', 'games', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (370, 'styledimages', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (371, 'styledimages', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (372, 'styledimages', 'language', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (374, 'games_styledimages', 'styledimages_id', 'styledimages', NULL, NULL, NULL, 'games_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (375, 'games_styledimages', 'games_id', 'games', 'images', NULL, NULL, 'styledimages_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (373, 'styledimages', 'file', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (369, 'games', 'link_id', 'links', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-01T11:52:16.264Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links"
    ALTER COLUMN "type" DROP DEFAULT;

ALTER TABLE IF EXISTS "public"."links"
    DROP COLUMN IF EXISTS "requires_authentication" CASCADE;
--WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."links" ---

--- BEGIN DROP TABLE "public"."games_usergroups" ---

DROP TABLE IF EXISTS "public"."games_usergroups";

--- END DROP TABLE "public"."games_usergroups" ---

--- BEGIN DROP TABLE "public"."games_translations" ---

DROP TABLE IF EXISTS "public"."games_translations";

--- END DROP TABLE "public"."games_translations" ---

--- BEGIN DROP TABLE "public"."games_styledimages" ---

DROP TABLE IF EXISTS "public"."games_styledimages";

--- END DROP TABLE "public"."games_styledimages" ---

--- BEGIN DROP TABLE "public"."games" ---

DROP TABLE IF EXISTS "public"."games";

--- END DROP TABLE "public"."games" ---

--- BEGIN DROP TABLE "public"."styledimages" ---

DROP TABLE IF EXISTS "public"."styledimages";

--- END DROP TABLE "public"."styledimages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'games';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'styledimages';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'games_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'games_usergroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'games_styledimages';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 644;

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Text",
      "value": "text"
    },
    {
      "text": "Audio",
      "value": "audio"
    },
    {
      "text": "Video",
      "value": "video"
    },
    {
      "text": "Other",
      "value": "other"
    }
  ]
}'
WHERE "id" = 898;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1035;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 1039;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1191;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1192;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1193;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1190;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1194;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1195;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1199;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1196;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1197;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1198;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1201;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1200;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1203;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1204;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1202;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1207;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1205;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1206;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1208;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1209;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1210;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1211;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1212;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1213;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1214;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1220;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1217;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1216;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1215;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1218;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1219;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 896;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 895;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 897;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 898;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 899;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 900;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 901;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 902;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 903;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 904;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 363;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 364;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 365;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 366;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 367;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 368;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 370;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 371;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 372;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 374;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 375;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 373;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 369;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
