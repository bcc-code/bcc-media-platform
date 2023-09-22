-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-20T09:09:12.938Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."songs_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."songs_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."songs_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."songs_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."songs_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."songs_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."songs_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."songs_translations" ---

CREATE TABLE IF NOT EXISTS "public"."songs_translations"
(
    "id"             int4         NOT NULL DEFAULT nextval('songs_translations_id_seq'::regclass),
    "songs_id"       uuid         NOT NULL,
    "languages_code" varchar(255) NOT NULL,
    "title"          text         NOT NULL,
    CONSTRAINT "songs_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "songs_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE ,
    CONSTRAINT "songs_translations_songs_id_foreign" FOREIGN KEY (songs_id) REFERENCES songs (id) ON DELETE CASCADE,
    CONSTRAINT "songs_translations_songs_id_languages_unique" UNIQUE (songs_id, languages_code)
);

GRANT SELECT ON TABLE "public"."songs_translations" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."songs_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."songs_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."songs_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."songs_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."songs_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."songs_translations" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."songs_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."songs_translations"."songs_id" IS NULL;


COMMENT ON COLUMN "public"."songs_translations"."languages_code" IS NULL;



COMMENT ON COLUMN "public"."songs_translations"."title" IS NULL;

COMMENT ON CONSTRAINT "songs_translations_pkey" ON "public"."songs_translations" IS NULL;


COMMENT ON CONSTRAINT "songs_translations_languages_code_foreign" ON "public"."songs_translations" IS NULL;


COMMENT ON CONSTRAINT "songs_translations_songs_id_foreign" ON "public"."songs_translations" IS NULL;

COMMENT ON TABLE "public"."songs_translations" IS NULL;

--- END CREATE TABLE "public"."songs_translations" ---

--- BEGIN ALTER TABLE "public"."songs" ---

ALTER TABLE IF EXISTS "public"."songs"
    DROP CONSTRAINT IF EXISTS "songs_collection_id_foreign";

ALTER TABLE IF EXISTS "public"."songs"
    ALTER COLUMN "collection_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."songs"
    ADD COLUMN IF NOT EXISTS "key" varchar(255) NOT NULL; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."songs"."key" IS NULL;

ALTER TABLE IF EXISTS "public"."songs"
    ADD CONSTRAINT "songs_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES songcollections (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "songs_collection_id_foreign" ON "public"."songs" IS NULL;

ALTER TABLE IF EXISTS "public"."songs"
    ADD CONSTRAINT "songs_collection_key_unique" UNIQUE (collection_id, key);

--- END ALTER TABLE "public"."songs" ---

--- BEGIN ALTER TABLE "public"."songcollections" ---

ALTER TABLE IF EXISTS "public"."songcollections"
    ADD COLUMN IF NOT EXISTS "key" varchar(255) NOT NULL; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."songcollections"."key" IS NULL;

ALTER TABLE IF EXISTS "public"."songcollections"
    ADD CONSTRAINT "songcollections_key_unique" UNIQUE (key);

COMMENT ON CONSTRAINT "songcollections_key_unique" ON "public"."songcollections" IS NULL;

CREATE UNIQUE INDEX i_songcollections_key_unique ON public.songcollections USING btree (key);

COMMENT ON INDEX "public"."i_songcollections_key_unique" IS NULL;

--- END ALTER TABLE "public"."songcollections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1317;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1302;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1303;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1310;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1337, 'songs_translations', 'songs_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1338, 'songs_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1339, 'songs_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1334, 'songs', 'key', NULL, 'input', NULL, 'raw', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1335, 'songs', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 5,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1336, 'songs_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1333, 'songcollections', 'key', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('songs_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, NULL, NULL, 'open', NULL);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (405, 'songs_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'songs_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (406, 'songs_translations', 'songs_id', 'songs', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-20T09:09:15.014Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."songcollections" ---

ALTER TABLE IF EXISTS "public"."songcollections"
    DROP COLUMN IF EXISTS "key" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."songcollections"
    DROP CONSTRAINT IF EXISTS "songcollections_key_unique";

DROP INDEX IF EXISTS songcollections_key_unique;

--- END ALTER TABLE "public"."songcollections" ---

--- BEGIN ALTER TABLE "public"."songs" ---

ALTER TABLE IF EXISTS "public"."songs"
    DROP CONSTRAINT IF EXISTS "songs_collection_id_foreign";

ALTER TABLE IF EXISTS "public"."songs"
    ALTER COLUMN "collection_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."songs"
    DROP COLUMN IF EXISTS "key" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."songs"
    ADD CONSTRAINT "songs_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES songcollections (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "songs_collection_id_foreign" ON "public"."songs" IS NULL;

--- END ALTER TABLE "public"."songs" ---

--- BEGIN DROP TABLE "public"."songs_translations" ---

DROP TABLE IF EXISTS "public"."songs_translations";

--- END DROP TABLE "public"."songs_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'songs_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1303;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1302;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1310;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1317;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1337;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1338;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1339;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1334;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1335;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1336;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1333;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 405;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 406;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
