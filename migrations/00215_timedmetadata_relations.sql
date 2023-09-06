-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-30T10:10:34.052Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."songcollections_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."songcollections_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."songcollections_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."songcollections_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."songcollections_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."songcollections_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."songcollections_translations_id_seq" ---

CREATE TABLE IF NOT EXISTS "public"."persons"
(
    "id"   uuid NOT NULL,
    "name" text NOT NULL,
    CONSTRAINT "persons_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "public"."songcollections"
(
    "id"    uuid NOT NULL,
    "title" text NULL,
    CONSTRAINT "songcollections_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "public"."songs"
(
    "id"            uuid NOT NULL,
    "collection_id" uuid NULL,
    CONSTRAINT "songs_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES songcollections (id) ON DELETE CASCADE,
    CONSTRAINT "songs_pkey" PRIMARY KEY (id)
);

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP CONSTRAINT IF EXISTS "timedmetadata_asset_id_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ALTER COLUMN "asset_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD COLUMN IF NOT EXISTS "episode_id" int4 NULL;

COMMENT ON COLUMN "public"."timedmetadata"."episode_id" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD COLUMN IF NOT EXISTS "chapter_type" varchar(255) NULL;

COMMENT ON COLUMN "public"."timedmetadata"."chapter_type" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD COLUMN IF NOT EXISTS "song_id" uuid NULL;

COMMENT ON COLUMN "public"."timedmetadata"."song_id" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD COLUMN IF NOT EXISTS "person_id" uuid NULL;

COMMENT ON COLUMN "public"."timedmetadata"."person_id" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP COLUMN IF EXISTS "datasource_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD CONSTRAINT "timedmetadata_episode_id_foreign" FOREIGN KEY (episode_id) REFERENCES episodes (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "timedmetadata_episode_id_foreign" ON "public"."timedmetadata" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD CONSTRAINT "timedmetadata_person_id_foreign" FOREIGN KEY (person_id) REFERENCES persons (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "timedmetadata_person_id_foreign" ON "public"."timedmetadata" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD CONSTRAINT "timedmetadata_song_id_foreign" FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "timedmetadata_song_id_foreign" ON "public"."timedmetadata" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD CONSTRAINT "timedmetadata_asset_id_foreign" FOREIGN KEY (asset_id) REFERENCES assets (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "timedmetadata_asset_id_foreign" ON "public"."timedmetadata" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP CONSTRAINT IF EXISTS "timedmetadata_datasource_id_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD CONSTRAINT "timedmetadata_asset_or_episode" CHECK (
            ("asset_id" IS NOT NULL AND "episode_id" IS NULL) OR ("asset_id" IS NULL AND "episode_id" IS NOT NULL)
        );

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN CREATE TABLE "public"."songs" ---

GRANT SELECT ON TABLE "public"."songs" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."songs" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."songs" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."songs" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."songs" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."songs" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."songs" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."songs"."id" IS NULL;


COMMENT ON COLUMN "public"."songs"."collection_id" IS NULL;

COMMENT ON CONSTRAINT "songs_collection_id_foreign" ON "public"."songs" IS NULL;


COMMENT ON CONSTRAINT "songs_pkey" ON "public"."songs" IS NULL;

COMMENT ON TABLE "public"."songs" IS NULL;

--- END CREATE TABLE "public"."songs" ---

--- BEGIN CREATE TABLE "public"."songcollections_translations" ---

CREATE TABLE IF NOT EXISTS "public"."songcollections_translations"
(
    "id"                 int4         NOT NULL DEFAULT nextval('songcollections_translations_id_seq'::regclass),
    "songcollections_id" uuid         NULL,
    "languages_code"     varchar(255) NULL,
    "title"              text         NULL,
    CONSTRAINT "songcollections_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "songcollections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "songcollections_translations_songcollections_id_foreign" FOREIGN KEY (songcollections_id) REFERENCES songcollections (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."songcollections_translations" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."songcollections_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."songcollections_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."songcollections_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."songcollections_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."songcollections_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."songcollections_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."songcollections_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."songcollections_translations"."songcollections_id" IS NULL;


COMMENT ON COLUMN "public"."songcollections_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."songcollections_translations"."title" IS NULL;

COMMENT ON CONSTRAINT "songcollections_translations_pkey" ON "public"."songcollections_translations" IS NULL;


COMMENT ON CONSTRAINT "songcollections_translations_languages_code_foreign" ON "public"."songcollections_translations" IS NULL;


COMMENT ON CONSTRAINT "songcollections_translations_songcollections_id_foreign" ON "public"."songcollections_translations" IS NULL;

COMMENT ON TABLE "public"."songcollections_translations" IS NULL;

--- END CREATE TABLE "public"."songcollections_translations" ---

--- BEGIN CREATE TABLE "public"."songcollections" ---

GRANT SELECT ON TABLE "public"."songcollections" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."songcollections" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."songcollections" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."songcollections" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."songcollections" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."songcollections" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."songcollections" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."songcollections"."id" IS NULL;


COMMENT ON COLUMN "public"."songcollections"."title" IS NULL;

COMMENT ON CONSTRAINT "songcollections_pkey" ON "public"."songcollections" IS NULL;

COMMENT ON TABLE "public"."songcollections" IS NULL;

--- END CREATE TABLE "public"."songcollections" ---

--- BEGIN CREATE TABLE "public"."persons" ---

CREATE TABLE IF NOT EXISTS "public"."persons"
(
    "id"   uuid NOT NULL,
    "name" text NOT NULL,
    CONSTRAINT "persons_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."persons" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."persons"."id" IS NULL;


COMMENT ON COLUMN "public"."persons"."name" IS NULL;

COMMENT ON CONSTRAINT "persons_pkey" ON "public"."persons" IS NULL;

COMMENT ON TABLE "public"."persons" IS NULL;

--- END CREATE TABLE "public"."persons" ---

--- BEGIN DROP TABLE "public"."datasources_styledimages" ---

DROP TABLE IF EXISTS "public"."datasources_styledimages";

--- END DROP TABLE "public"."datasources_styledimages" ---

--- BEGIN DROP TABLE "public"."datasources_translations" ---

DROP TABLE IF EXISTS "public"."datasources_translations";

--- END DROP TABLE "public"."datasources_translations" ---

--- BEGIN DROP TABLE "public"."datasources" ---

DROP TABLE IF EXISTS "public"."datasources";

--- END DROP TABLE "public"."datasources" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1299, 'timedmetadata', 'chapter_type', NULL, 'select-dropdown', '{
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
}', 'labels', NULL, false, false, 3, 'half', NULL, NULL, NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1303, 'songcollections', 'translations', 'translations', 'translations', '{
  "languageField": "code",
  "languageDirectionField": "code",
  "userLanguage": true,
  "defaultLanguage": "no"
}', 'translations', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1300, 'songs', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1301, 'songcollections', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1302, 'songcollections', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 2, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1304, 'songcollections_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1305, 'songcollections_translations', 'songcollections_id', NULL, NULL, NULL, NULL, NULL, false, true, 2,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1306, 'songcollections_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1307, 'songcollections_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1308, 'timedmetadata', 'song_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4,
        'half', NULL, NULL, '[
    {
      "name": "hide if not song",
      "rule": {
        "_and": [
          {
            "chapter_type": {
              "_neq": "song"
            }
          }
        ]
      },
      "hidden": true,
      "options": {
        "enableCreate": true,
        "enableSelect": true
      }
    }
  ]', false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1309, 'songs', 'collection_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 2,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 125;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1310, 'songcollections', 'songs', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 148;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1311, 'persons', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 143;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1312, 'timedmetadata', 'person_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 5,
        'half', NULL, NULL, '[
    {
      "name": "hide if not person",
      "rule": {
        "_and": [
          {
            "chapter_type": {
              "_in": [
                "speech",
                "testimony"
              ]
            }
          }
        ]
      },
      "hidden": true,
      "options": {
        "enableCreate": true,
        "enableSelect": true
      }
    }
  ]', false, 'details', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort"  = 10,
    "group" = NULL
WHERE "id" = 1238;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1313, 'persons', 'name', NULL, 'input', NULL, 'raw', NULL, false, false, 2, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 147;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1232;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1233;

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 1230;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 1235;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 1231;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1239;

UPDATE "public"."directus_fields"
SET "hidden" = true,
    "width"  = 'half'
WHERE "id" = 1236;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 1296;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 124;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1297, 'timedmetadata', 'episode_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 8,
        'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1298, 'episodes', 'timedmetadata', 'o2m', 'list-o2m', '{
  "layout": "table",
  "fields": [
    "label",
    "timestamp",
    "title"
  ],
  "enableSelect": false
}', 'related-values', NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1278;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1281;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1286;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1283;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1284;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1285;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1282;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1280;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1287;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1289;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1290;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1288;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1291;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1292;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1293;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1294;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1295;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "sort"  = 16,
    "group" = NULL
WHERE "collection" = 'timedmetadata';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('songs_group', 'music_note', NULL, NULL, false, false, '[
  {
    "language": "en-US",
    "translation": "Songs"
  }
]', NULL, true, NULL, NULL, NULL, 'all', '#2ECDA7', NULL, 9, NULL, 'open', NULL);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('songs', 'piano', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2,
        'songs_group', 'open', NULL);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('persons', 'person', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#FFC23B', NULL, 10,
        NULL, 'open', NULL);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('songcollections', 'menu_book', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL,
        1, 'songs_group', 'open', NULL);

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'notifications_group';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'faqs_group';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'materialized_views_meta';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('songcollections_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL,
        'all', NULL, NULL, 23, NULL, 'open', NULL);



UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'messages_group';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'applications_group';

UPDATE "public"."directus_collections"
SET "sort" = 18
WHERE "collection" = 'images';

UPDATE "public"."directus_collections"
SET "sort" = 19
WHERE "collection" = 'styledimages';

UPDATE "public"."directus_collections"
SET "sort" = 20
WHERE "collection" = 'translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'datasources_styledimages';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'datasources_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'datasources';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 905;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 906;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 907;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 908;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 909;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 910;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 911;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 912;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 913;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 914;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 915;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 916;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 917;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 918;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 919;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (395, 'timedmetadata', 'episode_id', 'episodes', 'timedmetadata', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (396, 'songcollections_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'songcollections_id',
        NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (397, 'songcollections_translations', 'songcollections_id', 'songcollections', 'translations', NULL, NULL,
        'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (399, 'songs', 'collection_id', 'songcollections', 'songs', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (400, 'timedmetadata', 'person_id', 'persons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (398, 'timedmetadata', 'song_id', 'songs', NULL, NULL, NULL, NULL, NULL, 'nullify');

DELETE
FROM "public"."directus_relations"
WHERE "id" = 390;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 391;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 392;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 393;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 394;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-30T10:10:36.346Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."datasources" ---

DELETE
FROM timedmetadata;

CREATE TABLE IF NOT EXISTS "public"."datasources"
(
    "id"               uuid         NOT NULL,
    "title"            text         NOT NULL,
    "description"      text         NULL,
    "has_translations" bool         NOT NULL DEFAULT false,
    "key"              varchar(255) NOT NULL,
    CONSTRAINT "datasources_key_unique" UNIQUE (key),
    CONSTRAINT "datasources_pkey" PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS datasources_key_unique ON public.datasources USING btree (key);

ALTER TABLE IF EXISTS "public"."datasources"
    OWNER TO directus;

GRANT SELECT ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."datasources"."id" IS NULL;


COMMENT ON COLUMN "public"."datasources"."title" IS NULL;


COMMENT ON COLUMN "public"."datasources"."description" IS NULL;


COMMENT ON COLUMN "public"."datasources"."has_translations" IS NULL;


COMMENT ON COLUMN "public"."datasources"."key" IS NULL;

COMMENT ON CONSTRAINT "datasources_key_unique" ON "public"."datasources" IS NULL;


COMMENT ON CONSTRAINT "datasources_pkey" ON "public"."datasources" IS NULL;

COMMENT ON INDEX "public"."datasources_key_unique" IS NULL;

COMMENT ON TABLE "public"."datasources" IS NULL;

--- END CREATE TABLE "public"."datasources" ---

--- BEGIN CREATE TABLE "public"."datasources_styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."datasources_styledimages"
(
    "id"              int4 NOT NULL DEFAULT nextval('datasources_styledimages_id_seq'::regclass),
    "datasources_id"  uuid NULL,
    "styledimages_id" uuid NULL,
    CONSTRAINT "datasources_styledimages_datasources_id_foreign" FOREIGN KEY (datasources_id) REFERENCES datasources (id) ON DELETE CASCADE,
    CONSTRAINT "datasources_styledimages_pkey" PRIMARY KEY (id),
    CONSTRAINT "datasources_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages (id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."datasources_styledimages"
    OWNER TO directus;

GRANT SELECT ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources_styledimages" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources_styledimages" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_styledimages" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_styledimages" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_styledimages" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_styledimages" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_styledimages" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_styledimages" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources_styledimages" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_styledimages" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_styledimages" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_styledimages" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_styledimages" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_styledimages" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_styledimages" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."datasources_styledimages"."id" IS NULL;


COMMENT ON COLUMN "public"."datasources_styledimages"."datasources_id" IS NULL;


COMMENT ON COLUMN "public"."datasources_styledimages"."styledimages_id" IS NULL;

COMMENT ON CONSTRAINT "datasources_styledimages_datasources_id_foreign" ON "public"."datasources_styledimages" IS NULL;


COMMENT ON CONSTRAINT "datasources_styledimages_pkey" ON "public"."datasources_styledimages" IS NULL;


COMMENT ON CONSTRAINT "datasources_styledimages_styledimages_id_foreign" ON "public"."datasources_styledimages" IS NULL;

COMMENT ON TABLE "public"."datasources_styledimages" IS NULL;

--- END CREATE TABLE "public"."datasources_styledimages" ---

--- BEGIN CREATE TABLE "public"."datasources_translations" ---

CREATE TABLE IF NOT EXISTS "public"."datasources_translations"
(
    "id"             int4         NOT NULL DEFAULT nextval('datasources_translations_id_seq'::regclass),
    "datasources_id" uuid         NULL,
    "languages_code" varchar(255) NULL,
    "title"          text         NULL,
    "description"    text         NULL,
    CONSTRAINT "datasources_translations_datasources_id_foreign" FOREIGN KEY (datasources_id) REFERENCES datasources (id) ON DELETE SET NULL,
    CONSTRAINT "datasources_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "datasources_translations_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."datasources_translations"
    OWNER TO directus;

GRANT SELECT ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources_translations" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."datasources_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."datasources_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."datasources_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."datasources_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."datasources_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."datasources_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."datasources_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."datasources_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."datasources_translations"."datasources_id" IS NULL;


COMMENT ON COLUMN "public"."datasources_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."datasources_translations"."title" IS NULL;


COMMENT ON COLUMN "public"."datasources_translations"."description" IS NULL;

COMMENT ON CONSTRAINT "datasources_translations_datasources_id_foreign" ON "public"."datasources_translations" IS NULL;


COMMENT ON CONSTRAINT "datasources_translations_languages_code_foreign" ON "public"."datasources_translations" IS NULL;


COMMENT ON CONSTRAINT "datasources_translations_pkey" ON "public"."datasources_translations" IS NULL;

COMMENT ON TABLE "public"."datasources_translations" IS NULL;

--- END CREATE TABLE "public"."datasources_translations" ---

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP CONSTRAINT IF EXISTS "timedmetadata_asset_id_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ALTER COLUMN "asset_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD COLUMN IF NOT EXISTS "datasource_id" uuid NULL;

COMMENT ON COLUMN "public"."timedmetadata"."datasource_id" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP COLUMN IF EXISTS "episode_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP COLUMN IF EXISTS "chapter_type" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP COLUMN IF EXISTS "song_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP COLUMN IF EXISTS "person_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD CONSTRAINT "timedmetadata_asset_id_foreign" FOREIGN KEY (asset_id) REFERENCES assets (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "timedmetadata_asset_id_foreign" ON "public"."timedmetadata" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD CONSTRAINT "timedmetadata_datasource_id_foreign" FOREIGN KEY (datasource_id) REFERENCES datasources (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "timedmetadata_datasource_id_foreign" ON "public"."timedmetadata" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP CONSTRAINT IF EXISTS "timedmetadata_episode_id_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP CONSTRAINT IF EXISTS "timedmetadata_person_id_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP CONSTRAINT IF EXISTS "timedmetadata_song_id_foreign";

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN DROP TABLE "public"."songs" ---

DROP TABLE IF EXISTS "public"."songs";

--- END DROP TABLE "public"."songs" ---

--- BEGIN DROP TABLE "public"."songcollections_translations" ---

DROP TABLE IF EXISTS "public"."songcollections_translations";

--- END DROP TABLE "public"."songcollections_translations" ---

--- BEGIN DROP TABLE "public"."songcollections" ---

DROP TABLE IF EXISTS "public"."songcollections";

--- END DROP TABLE "public"."songcollections" ---

--- BEGIN DROP TABLE "public"."persons" ---

DROP TABLE IF EXISTS "public"."persons";

--- END DROP TABLE "public"."persons" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'assets'
WHERE "collection" = 'timedmetadata';

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'faqs_group';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'notifications_group';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'applications_group';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'images';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'styledimages';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('datasources_styledimages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, 18, NULL, 'open', NULL);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('datasources_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, 19, NULL, 'open', NULL);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('datasources', 'database', 'Sources for storing data used elsewhere in the system.', '{{title}}', false, false,
        NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 4, NULL, 'open', NULL);

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'messages_group';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'songs';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'persons';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'songcollections';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'songcollections_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'songs_group';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 143;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 148;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 125;

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 147;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 124;

UPDATE "public"."directus_fields"
SET "sort" = 8
WHERE "id" = 1230;

UPDATE "public"."directus_fields"
SET "hidden" = false,
    "width"  = 'full'
WHERE "id" = 1236;

UPDATE "public"."directus_fields"
SET "sort"  = 1,
    "group" = 'details'
WHERE "id" = 1238;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1232;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1233;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1278, 'datasources', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1281, 'datasources', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 5, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1286, 'datasources', 'has_translations', 'cast-boolean', NULL, NULL, NULL, NULL, false, false, 3, 'half', NULL,
        'Check this if the source should have translations', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1283, 'datasources_styledimages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1284, 'datasources_styledimages', 'datasources_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1285, 'datasources_styledimages', 'styledimages_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1282, 'datasources', 'images', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1280, 'datasources', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1287, 'datasources', 'key', NULL, 'input', '{
  "placeholder": null
}', 'raw', NULL, false, false, 2, 'half', NULL, 'Used as a key to identify against external sources.', NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1289, 'datasources_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1290, 'datasources_translations', 'datasources_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1288, 'datasources', 'translations', 'translations', 'translations', '{
  "languageField": "code",
  "languageDirectionField": "code",
  "defaultLanguage": "en",
  "userLanguage": true
}', NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'source_translations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1291, 'datasources_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1292, 'datasources_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1293, 'datasources_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 5, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1294, 'datasources', 'source_translations', 'alias,no-data,group', 'group-detail', '{
  "start": "closed"
}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 1239;

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 1235;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1231;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1295, 'timedmetadata', 'datasource_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false,
        false, 4, 'full', NULL, 'Can be used as {{title}} and {{description}} in the title and description fields.',
        NULL, false, 'details', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1296;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1299;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1303;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1300;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1301;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1302;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1304;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1305;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1306;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1307;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1308;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1309;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1310;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1311;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1312;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1313;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1297;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1298;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (905, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (906, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (907, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (908, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (909, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (910, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (911, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (912, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (913, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (914, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_styledimages', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (915, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (916, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (917, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (918, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (919, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'datasources_translations', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (390, 'datasources_styledimages', 'styledimages_id', 'styledimages', NULL, NULL, NULL, 'datasources_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (391, 'datasources_styledimages', 'datasources_id', 'datasources', 'images', NULL, NULL, 'styledimages_id', NULL,
        'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (392, 'datasources_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'datasources_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (393, 'datasources_translations', 'datasources_id', 'datasources', 'translations', NULL, NULL, 'languages_code',
        NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (394, 'timedmetadata', 'datasource_id', 'datasources', NULL, NULL, NULL, NULL, NULL, 'nullify');

DELETE
FROM "public"."directus_relations"
WHERE "id" = 395;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 396;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 397;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 399;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 400;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 398;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
