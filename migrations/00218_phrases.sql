-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-31T07:51:14.887Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."phrases_translations_id_seq" ---

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO onsite_backup;


CREATE SEQUENCE IF NOT EXISTS "public"."phrases_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."phrases_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."phrases_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."phrases_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."phrases_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."phrases_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."phrases" ---

CREATE TABLE IF NOT EXISTS "public"."phrases"
(
    "key"          varchar(255) NOT NULL,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "value"        text         NOT NULL,
    CONSTRAINT "phrases_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "phrases_pkey" PRIMARY KEY (key),
    CONSTRAINT "phrases_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."phrases" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."phrases" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."phrases" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."phrases" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."phrases" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."phrases" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."phrases" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

INSERT INTO "public"."phrases" (key, value)
VALUES ('song', 'Sang'),
       ('sing_along', 'Allsang'),
       ('speech', 'Tale'),
       ('testimony', 'Vidnesbyrd'),
       ('appeal', 'Appell');

COMMENT ON COLUMN "public"."phrases"."key" IS NULL;


COMMENT ON COLUMN "public"."phrases"."user_created" IS NULL;


COMMENT ON COLUMN "public"."phrases"."date_created" IS NULL;


COMMENT ON COLUMN "public"."phrases"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."phrases"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."phrases"."value" IS NULL;

COMMENT ON CONSTRAINT "phrases_user_updated_foreign" ON "public"."phrases" IS NULL;


COMMENT ON CONSTRAINT "phrases_pkey" ON "public"."phrases" IS NULL;


COMMENT ON CONSTRAINT "phrases_user_created_foreign" ON "public"."phrases" IS NULL;

COMMENT ON TABLE "public"."phrases" IS NULL;

--- END CREATE TABLE "public"."phrases" ---

--- BEGIN CREATE TABLE "public"."phrases_translations" ---

CREATE TABLE IF NOT EXISTS "public"."phrases_translations"
(
    "id"             int4         NOT NULL DEFAULT nextval('phrases_translations_id_seq'::regclass),
    "phrases_key"    varchar(255) NULL,
    "languages_code" varchar(255) NULL,
    "value"          text         NULL,
    CONSTRAINT "phrases_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "phrases_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "phrases_translations_phrases_key_foreign" FOREIGN KEY (phrases_key) REFERENCES phrases (key) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."phrases_translations" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."phrases_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."phrases_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."phrases_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."phrases_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."phrases_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."phrases_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."phrases_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."phrases_translations"."phrases_key" IS NULL;


COMMENT ON COLUMN "public"."phrases_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."phrases_translations"."value" IS NULL;

COMMENT ON CONSTRAINT "phrases_translations_pkey" ON "public"."phrases_translations" IS NULL;


COMMENT ON CONSTRAINT "phrases_translations_languages_code_foreign" ON "public"."phrases_translations" IS NULL;


COMMENT ON CONSTRAINT "phrases_translations_phrases_key_foreign" ON "public"."phrases_translations" IS NULL;

COMMENT ON TABLE "public"."phrases_translations" IS NULL;

--- END CREATE TABLE "public"."phrases_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "note" = 'Can be used in "title" with for example: {{song.title}}'
WHERE "id" = 1308;

UPDATE "public"."directus_fields"
SET "note" = 'Can be used in "title" with for example: {{person.name}}'
WHERE "id" = 1312;

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Song",
      "value": "song"
    },
    {
      "text": "Sing along",
      "value": "sing_along"
    },
    {
      "text": "Speech",
      "value": "speech"
    },
    {
      "text": "Testimony",
      "value": "testimony"
    },
    {
      "text": "Appeal",
      "value": "appeal"
    }
  ]
}'
WHERE "id" = 1299;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1318, 'phrases', 'key', NULL, 'input', NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1319, 'phrases', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1327, 'phrases_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1320, 'phrases', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1321, 'phrases', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1322, 'phrases', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1323, 'phrases', 'value', NULL, 'input', NULL, 'raw', NULL, false, false, 6, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1324, 'phrases', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 7,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1325, 'phrases_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1326, 'phrases_translations', 'phrases_key', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1328, 'phrases_translations', 'value', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'asset_management';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('phrases_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, 22, NULL, 'open', NULL);

UPDATE "public"."directus_collections"
SET "sort" = 21
WHERE "collection" = 'songcollections_translations';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'songs_group';

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'persons';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'achievements_group';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'computeddata_group';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('phrases', 'translate', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#2ECDA7', NULL,
        10, NULL, 'open', NULL);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (401, 'phrases', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (403, 'phrases_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'phrases_key', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (404, 'phrases_translations', 'phrases_key', 'phrases', 'translations', NULL, NULL, 'languages_code', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (402, 'phrases', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-31T07:51:16.691Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."phrases_translations" ---

DROP TABLE IF EXISTS "public"."phrases_translations";

--- END DROP TABLE "public"."phrases_translations" ---

--- BEGIN DROP TABLE "public"."phrases" ---

DROP TABLE IF EXISTS "public"."phrases";

--- END DROP TABLE "public"."phrases" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'computeddata_group';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'achievements_group';

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'songs_group';

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'persons';

UPDATE "public"."directus_collections"
SET "sort" = 23
WHERE "collection" = 'songcollections_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'phrases_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'phrases';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Song",
      "value": "song"
    },
    {
      "text": "Speech",
      "value": "speech"
    },
    {
      "text": "Testimony",
      "value": "testimony"
    }
  ]
}'
WHERE "id" = 1299;

UPDATE "public"."directus_fields"
SET "note" = NULL
WHERE "id" = 1308;

UPDATE "public"."directus_fields"
SET "note" = NULL
WHERE "id" = 1312;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1318;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1319;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1327;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1320;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1321;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1322;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1323;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1324;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1325;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1326;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1328;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 401;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 403;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 404;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 402;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
