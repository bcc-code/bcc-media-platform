-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-10-05T11:10:48.812Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."playlists_styledimages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."playlists_styledimages_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."playlists_styledimages_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."playlists_styledimages_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."playlists_styledimages_id_seq" ---

--- BEGIN CREATE TABLE "public"."playlists" ---

CREATE TABLE IF NOT EXISTS "public"."playlists"
(
    "id"            uuid         NOT NULL,
    "status"        varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created"  uuid         NULL,
    "date_created"  timestamptz  NULL,
    "user_updated"  uuid         NULL,
    "date_updated"  timestamptz  NULL,
    "title"         text         NOT NULL,
    "description"   text         NULL,
    "collection_id" int4         NULL,
    CONSTRAINT "playlists_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "playlists_pkey" PRIMARY KEY (id),
    CONSTRAINT "playlists_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "playlists_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES collections (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."playlists" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."playlists" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."playlists" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."playlists" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."playlists" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."playlists" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."playlists" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."playlists"."id" IS NULL;


COMMENT ON COLUMN "public"."playlists"."status" IS NULL;


COMMENT ON COLUMN "public"."playlists"."user_created" IS NULL;


COMMENT ON COLUMN "public"."playlists"."date_created" IS NULL;


COMMENT ON COLUMN "public"."playlists"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."playlists"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."playlists"."title" IS NULL;


COMMENT ON COLUMN "public"."playlists"."description" IS NULL;


COMMENT ON COLUMN "public"."playlists"."collection_id" IS NULL;

COMMENT ON CONSTRAINT "playlists_user_updated_foreign" ON "public"."playlists" IS NULL;


COMMENT ON CONSTRAINT "playlists_pkey" ON "public"."playlists" IS NULL;


COMMENT ON CONSTRAINT "playlists_user_created_foreign" ON "public"."playlists" IS NULL;


COMMENT ON CONSTRAINT "playlists_collection_id_foreign" ON "public"."playlists" IS NULL;

COMMENT ON TABLE "public"."playlists" IS NULL;

--- END CREATE TABLE "public"."playlists" ---

--- BEGIN CREATE TABLE "public"."playlists_styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."playlists_styledimages"
(
    "id"              int4 NOT NULL DEFAULT nextval('playlists_styledimages_id_seq'::regclass),
    "playlists_id"    uuid NULL,
    "styledimages_id" uuid NULL,
    CONSTRAINT "playlists_styledimages_pkey" PRIMARY KEY (id),
    CONSTRAINT "playlists_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages (id) ON DELETE CASCADE,
    CONSTRAINT "playlists_styledimages_playlists_id_foreign" FOREIGN KEY (playlists_id) REFERENCES playlists (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."playlists_styledimages" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."playlists_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."playlists_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."playlists_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."playlists_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."playlists_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."playlists_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."playlists_styledimages"."id" IS NULL;


COMMENT ON COLUMN "public"."playlists_styledimages"."playlists_id" IS NULL;


COMMENT ON COLUMN "public"."playlists_styledimages"."styledimages_id" IS NULL;

COMMENT ON CONSTRAINT "playlists_styledimages_pkey" ON "public"."playlists_styledimages" IS NULL;


COMMENT ON CONSTRAINT "playlists_styledimages_styledimages_id_foreign" ON "public"."playlists_styledimages" IS NULL;


COMMENT ON CONSTRAINT "playlists_styledimages_playlists_id_foreign" ON "public"."playlists_styledimages" IS NULL;

COMMENT ON TABLE "public"."playlists_styledimages" IS NULL;

--- END CREATE TABLE "public"."playlists_styledimages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1351, 'playlists', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1352, 'playlists', 'status', NULL, 'select-dropdown', '{
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
VALUES (1353, 'playlists', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1354, 'playlists', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1355, 'playlists', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1356, 'playlists', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1358, 'playlists', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 8, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1360, 'playlists', 'images', 'm2m', 'list-m2m', '{
  "enableSelect": false
}', 'related-values', NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1363, 'playlists_styledimages', 'styledimages_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1357, 'playlists', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1359, 'playlists', 'collection_id', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{name}}"
}', 'related-values', NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1361, 'playlists_styledimages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1362, 'playlists_styledimages', 'playlists_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1364, 'collections_items', 'playlist_id', 'm2o', NULL, NULL, NULL, NULL, false, false, 7, 'half', NULL, NULL, '{
  "conditions": [
    {
      "name": "hide if not playlist",
      "rule": {
        "_and": [
          {
            "type": {
              "_neq": "playlist"
            }
          }
        ]
      },
      "hidden": true,
      "options": {}
    }
  ]
}', false, 'config', NULL, NULL);

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Page",
      "value": "page"
    },
    {
      "text": "Show",
      "value": "show"
    },
    {
      "text": "Episode",
      "value": "episode"
    },
    {
      "text": "Link",
      "value": "link"
    },
    {
      "text": "Playlist",
      "value": "playlist"
    }
  ]
}'
WHERE "id" = 346;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('playlists', 'format_list_numbered', NULL, '{{title}}', false, false, NULL, 'status', true, 'archived', 'draft',
        NULL, 'all', NULL, NULL, 6, 'main_content', 'open', NULL);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('playlists_styledimages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, 23, NULL, 'open', NULL);

UPDATE "public"."directus_collections"
SET "sort" = 24
WHERE "collection" = 'songs_translations';

UPDATE "public"."directus_collections"
SET "sort" = 25
WHERE "collection" = 'timedmetadata_persons';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_allowed_collections" = 'episodes,links,pages,seasons,shows,studytopics,games,playlists'
WHERE "id" = 214;

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (409, 'playlists', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (410, 'playlists', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (411, 'playlists', 'collection_id', 'collections', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (412, 'playlists_styledimages', 'styledimages_id', 'styledimages', NULL, NULL, NULL, 'playlists_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (413, 'playlists_styledimages', 'playlists_id', 'playlists', 'images', NULL, NULL, 'styledimages_id', NULL,
        'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (414, 'collections_items', 'playlist_id', 'playlists', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN CREATE SEQUENCE "public"."playlists_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."playlists_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."playlists_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."playlists_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."playlists_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."playlists_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."playlists_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."playlists_translations" ---

CREATE TABLE IF NOT EXISTS "public"."playlists_translations"
(
    "id"             int4         NOT NULL DEFAULT nextval('playlists_translations_id_seq'::regclass),
    "playlists_id"   uuid         NOT NULL,
    "languages_code" varchar(255) NOT NULL,
    "title"          text         NULL,
    "description"    text         NULL,
    CONSTRAINT "playlists_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "playlists_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "playlists_translations_playlists_id_foreign" FOREIGN KEY (playlists_id) REFERENCES playlists (id) ON DELETE SET NULL,
    CONSTRAINT "playlists_translations_unique" UNIQUE (playlists_id, languages_code)
);

GRANT SELECT ON TABLE "public"."playlists_translations" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."playlists_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."playlists_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."playlists_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."playlists_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."playlists_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."playlists_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."playlists_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."playlists_translations"."playlists_id" IS NULL;


COMMENT ON COLUMN "public"."playlists_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."playlists_translations"."title" IS NULL;


COMMENT ON COLUMN "public"."playlists_translations"."description" IS NULL;

COMMENT ON CONSTRAINT "playlists_translations_pkey" ON "public"."playlists_translations" IS NULL;


COMMENT ON CONSTRAINT "playlists_translations_languages_code_foreign" ON "public"."playlists_translations" IS NULL;


COMMENT ON CONSTRAINT "playlists_translations_playlists_id_foreign" ON "public"."playlists_translations" IS NULL;

COMMENT ON TABLE "public"."playlists_translations" IS NULL;

--- END CREATE TABLE "public"."playlists_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1365, 'playlists', 'translations', 'translations', 'translations', '{
  "languageField": "code",
  "languageDirectionField": "code",
  "defaultLanguage": "no",
  "userLanguage": true
}', 'translations', NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1368, 'playlists_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1366, 'playlists_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1367, 'playlists_translations', 'playlists_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1369, 'playlists_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1370, 'playlists_translations', 'description', NULL, 'input', NULL, NULL, NULL, false, false, 5, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('playlists_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, NULL, NULL, 'open', NULL);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (415, 'playlists_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'playlists_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (416, 'playlists_translations', 'playlists_id', 'playlists', 'translations', NULL, NULL, 'languages_code', NULL,
        'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN CREATE SEQUENCE "public"."playlists_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."playlists_usergroups_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."playlists_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."playlists_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."playlists_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."playlists_usergroups_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."playlists_usergroups_id_seq" ---

--- BEGIN CREATE TABLE "public"."playlists_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."playlists_usergroups"
(
    "id"              int4         NOT NULL DEFAULT nextval('playlists_usergroups_id_seq'::regclass),
    "playlists_id"    uuid         NOT NULL,
    "usergroups_code" varchar(255) NOT NULL,
    CONSTRAINT "playlists_usergroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "playlists_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE,
    CONSTRAINT "playlists_usergroups_playlists_id_foreign" FOREIGN KEY (playlists_id) REFERENCES playlists (id) ON DELETE CASCADE,
    CONSTRAINT "playlists_usergroups_unique" UNIQUE (playlists_id, usergroups_code)
);

GRANT SELECT ON TABLE "public"."playlists_usergroups" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."playlists_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."playlists_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."playlists_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."playlists_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."playlists_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."playlists_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."playlists_usergroups"."id" IS NULL;


COMMENT ON COLUMN "public"."playlists_usergroups"."playlists_id" IS NULL;


COMMENT ON COLUMN "public"."playlists_usergroups"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "playlists_usergroups_pkey" ON "public"."playlists_usergroups" IS NULL;


COMMENT ON CONSTRAINT "playlists_usergroups_usergroups_code_foreign" ON "public"."playlists_usergroups" IS NULL;


COMMENT ON CONSTRAINT "playlists_usergroups_playlists_id_foreign" ON "public"."playlists_usergroups" IS NULL;

COMMENT ON TABLE "public"."playlists_usergroups" IS NULL;

--- END CREATE TABLE "public"."playlists_usergroups" ---

--- BEGIN ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

DROP MATERIALIZED VIEW IF EXISTS "public"."filter_dataset";
CREATE MATERIALIZED VIEW IF NOT EXISTS "public"."filter_dataset" AS
WITH e_tags AS (SELECT et.episodes_id       AS id,
                       array_agg(tags.code) AS tags
                FROM (episodes_tags et
                    JOIN tags ON ((tags.id = et.tags_id)))
                GROUP BY et.episodes_id),
     s_tags AS (SELECT st.seasons_id        AS id,
                       array_agg(tags.code) AS tags
                FROM (seasons_tags st
                    JOIN tags ON ((tags.id = st.tags_id)))
                GROUP BY st.seasons_id),
     sh_tags AS (SELECT sht.shows_id         AS id,
                        array_agg(tags.code) AS tags
                 FROM (shows_tags sht
                     JOIN tags ON ((tags.id = sht.tags_id)))
                 GROUP BY sht.shows_id),
     g_roles AS (SELECT r.games_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM games_usergroups r
                 GROUP BY r.games_id),
     p_roles AS (SELECT r.playlists_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM playlists_usergroups r
                 GROUP BY r.playlists_id)
SELECT 'episodes'::text                                                                                      AS collection,
       e.id,
       e.uuid,
       COALESCE(e.season_id, 0)                                                                              AS season_id,
       COALESCE(se.show_id, 0)                                                                               AS show_id,
       COALESCE(e.agerating_code, se.agerating_code,
                ''::character varying)                                                                       AS agerating_code,
       e.episode_number                                                                                      AS number,
       e.type,
       e.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                                                      AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags
FROM ((((((episodes e
    LEFT JOIN episode_roles roles ON ((roles.id = e.id)))
    LEFT JOIN episode_availability av ON ((av.id = e.id)))
    LEFT JOIN e_tags ON ((e_tags.id = e.id)))
    LEFT JOIN seasons se ON ((se.id = e.season_id)))
    LEFT JOIN s_tags ON ((s_tags.id = e.season_id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
SELECT 'seasons'::text                                                               AS collection,
       se.id,
       se.uuid,
       0                                                                             AS season_id,
       se.show_id,
       COALESCE(se.agerating_code, ''::character varying)                            AS agerating_code,
       se.season_number                                                              AS number,
       ''::character varying                                                         AS type,
       se.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                              AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags
FROM ((((seasons se
    LEFT JOIN season_roles roles ON ((roles.id = se.id)))
    LEFT JOIN season_availability av ON ((av.id = se.id)))
    LEFT JOIN s_tags ON ((s_tags.id = se.id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
SELECT 'shows'::text                                      AS collection,
       sh.id,
       sh.uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       COALESCE(sh.agerating_code, ''::character varying) AS agerating_code,
       0                                                  AS number,
       sh.type,
       sh.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(shr.roles, '{}'::character varying[])     AS roles,
       COALESCE(sh_tags.tags, '{}'::character varying[])  AS tags
FROM (((shows sh
    LEFT JOIN show_roles shr ON ((shr.id = sh.id)))
    LEFT JOIN show_availability av ON ((av.id = sh.id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = sh.id)))
UNION
SELECT 'games'::text                                      AS collection,
       0                                                  AS id,
       g.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((g.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (games g
    LEFT JOIN g_roles r ON ((r.games_id = g.id)))
UNION
SELECT 'playlists'::text                                  AS collection,
       0                                                  AS id,
       p.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((p.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (playlists p LEFT JOIN p_roles r ON ((r.playlists_id = p.id)));

CREATE UNIQUE INDEX filter_dataset_uuid ON public.filter_dataset USING btree (uuid);

GRANT SELECT ON TABLE "public"."filter_dataset" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON MATERIALIZED VIEW "public"."filter_dataset" IS NULL;

--- END ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1374, 'playlists_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1371, 'playlists', 'roles', 'm2m', 'list-m2m', '{
  "enableCreate": false
}', 'related-values', NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1372, 'playlists_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1373, 'playlists_usergroups', 'playlists_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('playlists_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, NULL, NULL, 'open', NULL);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (417, 'playlists_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'playlists_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (418, 'playlists_usergroups', 'playlists_id', 'playlists', 'roles', NULL, NULL, 'usergroups_code', NULL,
        'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-10-05T11:10:50.745Z             ***/
/***********************************************************/


--- BEGIN ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

DROP MATERIALIZED VIEW IF EXISTS "public"."filter_dataset";
CREATE MATERIALIZED VIEW IF NOT EXISTS "public"."filter_dataset" AS
WITH e_tags AS (SELECT et.episodes_id       AS id,
                       array_agg(tags.code) AS tags
                FROM (episodes_tags et
                    JOIN tags ON ((tags.id = et.tags_id)))
                GROUP BY et.episodes_id),
     s_tags AS (SELECT st.seasons_id        AS id,
                       array_agg(tags.code) AS tags
                FROM (seasons_tags st
                    JOIN tags ON ((tags.id = st.tags_id)))
                GROUP BY st.seasons_id),
     sh_tags AS (SELECT sht.shows_id         AS id,
                        array_agg(tags.code) AS tags
                 FROM (shows_tags sht
                     JOIN tags ON ((tags.id = sht.tags_id)))
                 GROUP BY sht.shows_id),
     g_roles AS (SELECT r.games_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM games_usergroups r
                 GROUP BY r.games_id)
SELECT 'episodes'::text                                                                                      AS collection,
       e.id,
       e.uuid,
       COALESCE(e.season_id, 0)                                                                              AS season_id,
       COALESCE(se.show_id, 0)                                                                               AS show_id,
       COALESCE(e.agerating_code, se.agerating_code,
                ''::character varying)                                                                       AS agerating_code,
       e.episode_number                                                                                      AS number,
       e.type,
       e.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                                                      AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags
FROM ((((((episodes e
    LEFT JOIN episode_roles roles ON ((roles.id = e.id)))
    LEFT JOIN episode_availability av ON ((av.id = e.id)))
    LEFT JOIN e_tags ON ((e_tags.id = e.id)))
    LEFT JOIN seasons se ON ((se.id = e.season_id)))
    LEFT JOIN s_tags ON ((s_tags.id = e.season_id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
SELECT 'seasons'::text                                                               AS collection,
       se.id,
       se.uuid,
       0                                                                             AS season_id,
       se.show_id,
       COALESCE(se.agerating_code, ''::character varying)                            AS agerating_code,
       se.season_number                                                              AS number,
       ''::character varying                                                         AS type,
       se.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                              AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags
FROM ((((seasons se
    LEFT JOIN season_roles roles ON ((roles.id = se.id)))
    LEFT JOIN season_availability av ON ((av.id = se.id)))
    LEFT JOIN s_tags ON ((s_tags.id = se.id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
SELECT 'shows'::text                                      AS collection,
       sh.id,
       sh.uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       COALESCE(sh.agerating_code, ''::character varying) AS agerating_code,
       0                                                  AS number,
       sh.type,
       sh.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(shr.roles, '{}'::character varying[])     AS roles,
       COALESCE(sh_tags.tags, '{}'::character varying[])  AS tags
FROM (((shows sh
    LEFT JOIN show_roles shr ON ((shr.id = sh.id)))
    LEFT JOIN show_availability av ON ((av.id = sh.id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = sh.id)))
UNION
SELECT 'games'::text                                      AS collection,
       0                                                  AS id,
       g.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((g.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (games g
    LEFT JOIN g_roles r ON ((r.games_id = g.id)));

CREATE UNIQUE INDEX filter_dataset_uuid ON public.filter_dataset USING btree (uuid);

GRANT SELECT ON TABLE "public"."filter_dataset" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON MATERIALIZED VIEW "public"."filter_dataset" IS NULL;

--- END ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

--- BEGIN DROP TABLE "public"."playlists_usergroups" ---

DROP TABLE IF EXISTS "public"."playlists_usergroups";

--- END DROP TABLE "public"."playlists_usergroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'playlists_usergroups';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1374;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1371;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1372;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1373;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 417;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 418;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---


--- BEGIN DROP TABLE "public"."playlists_translations" ---

DROP TABLE IF EXISTS "public"."playlists_translations";

--- END DROP TABLE "public"."playlists_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'playlists_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1365;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1368;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1366;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1367;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1369;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1370;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 415;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 416;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---


--- BEGIN DROP TABLE "public"."playlists_styledimages" ---

DROP TABLE IF EXISTS "public"."playlists_styledimages";

--- END DROP TABLE "public"."playlists_styledimages" ---

--- BEGIN DROP TABLE "public"."playlists" ---

DROP TABLE IF EXISTS "public"."playlists";

--- END DROP TABLE "public"."playlists" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'songs_translations';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'timedmetadata_persons';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'playlists';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'playlists_styledimages';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Page",
      "value": "page"
    },
    {
      "text": "Show",
      "value": "show"
    },
    {
      "text": "Episode",
      "value": "episode"
    },
    {
      "text": "Link",
      "value": "link"
    }
  ]
}'
WHERE "id" = 346;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1351;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1352;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1353;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1354;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1355;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1356;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1358;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1360;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1363;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1357;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1359;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1361;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1362;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1364;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_allowed_collections" = 'episodes,links,pages,seasons,shows,studytopics,games'
WHERE "id" = 214;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 409;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 410;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 411;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 412;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 413;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 414;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
