-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-11T12:39:36.668Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."mediaitems_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_usergroups_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."mediaitems_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."mediaitems_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."mediaitems_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."mediaitems_usergroups_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."mediaitems_usergroups_id_seq" ---

--- BEGIN CREATE TABLE "public"."mediaitems_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_usergroups"
(
    "id"              int4         NOT NULL DEFAULT nextval('mediaitems_usergroups_id_seq'::regclass),
    "mediaitems_id"   uuid         NOT NULL,
    "usergroups_code" varchar(255) NOT NULL,
    CONSTRAINT "mediaitems_usergroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE,
    CONSTRAINT "mediaitems_usergroups_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE CASCADE,
    CONSTRAINT "mediaitems_usergroups_unique" UNIQUE (mediaitems_id, usergroups_code)
);

GRANT SELECT ON TABLE "public"."mediaitems_usergroups" TO api, background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_usergroups"."id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_usergroups"."mediaitems_id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_usergroups"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "mediaitems_usergroups_pkey" ON "public"."mediaitems_usergroups" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_usergroups_usergroups_code_foreign" ON "public"."mediaitems_usergroups" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_usergroups_mediaitems_id_foreign" ON "public"."mediaitems_usergroups" IS NULL;

COMMENT ON TABLE "public"."mediaitems_usergroups" IS NULL;

--- END CREATE TABLE "public"."mediaitems_usergroups" ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "available_from" timestamp NULL;

COMMENT ON COLUMN "public"."mediaitems"."available_from" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "available_to" timestamp NULL;

COMMENT ON COLUMN "public"."mediaitems"."available_to" IS NULL;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 483;

UPDATE "public"."directus_fields"
SET "sort" = 17
WHERE "id" = 130;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1459;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 120;

UPDATE "public"."directus_fields"
SET "sort" = 15
WHERE "id" = 1460;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1466, 'mediaitems', 'availability', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 11,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1471, 'mediaitems', 'available_from', NULL, 'custom-datepicker', NULL, 'datetime', NULL, false, false, 1,
        'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

UPDATE "public"."directus_fields"
SET "hidden" = true,
    "sort"   = 7
WHERE "id" = 144;

UPDATE "public"."directus_fields"
SET "hidden" = true,
    "sort"   = 8
WHERE "id" = 137;

UPDATE "public"."directus_fields"
SET "sort" = 16
WHERE "id" = 143;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1468, 'mediaitems_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1469, 'mediaitems_usergroups', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1470, 'mediaitems_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1467, 'mediaitems', 'usergroups', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 3, 'full',
        NULL, NULL, NULL, false, 'availability', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 1378;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1472, 'mediaitems', 'available_to', NULL, 'custom-datepicker', NULL, 'datetime', NULL, false, false, 2, 'half',
        NULL, NULL, NULL, false, 'availability', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 1435;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 147;

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 124;

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 148;

UPDATE "public"."directus_fields"
SET "sort" = 15
WHERE "id" = 125;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1442;

UPDATE "public"."directus_fields"
SET "hidden" = true,
    "sort"   = 11
WHERE "id" = 1314;

UPDATE "public"."directus_fields"
SET "sort" = 16
WHERE "id" = 1422;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true)
FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('mediaitems_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (447, 'mediaitems_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'mediaitems_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (448, 'mediaitems_usergroups', 'mediaitems_id', 'mediaitems', 'usergroups', NULL, NULL, 'usergroups_code', NULL,
        'nullify');

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true)
FROM "public"."directus_relations";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---


--- COPY FROM EPISODES TO MEDIAITEMS

INSERT INTO mediaitems (id, user_created, user_updated, date_updated, date_created, title, description, asset_id, label,
                        published_at, type, agerating_code, content_type, audience, production_date,
                        translations_required)
SELECT uuid,
       user_created,
       user_updated,
       date_updated,
       date_created,
       ts.title,
       ts.description,
       asset_id,
       COALESCE(label, ts.title, ''),
       publish_date,
       'video',
       agerating_code,
       content_type,
       audience,
       production_date,
       translations_required
FROM episodes
         LEFT JOIN episodes_translations ts ON ts.episodes_id = episodes.id AND ts.languages_code = 'no';

INSERT INTO mediaitems_translations (mediaitems_id, languages_code, title, description)
SELECT e.uuid, ts.languages_code, ts.title, ts.description
FROM episodes e
         JOIN episodes_translations ts ON ts.episodes_id = e.id AND ts.languages_code != 'no';

UPDATE mediaitems
SET parent_id = (SELECT uuid FROM episodes WHERE id = parent_episode_id)
WHERE parent_episode_id IS NOT NULL;

INSERT INTO mediaitems_assets (mediaitems_id, assets_id, language)
SELECT e.uuid, a.assets_id, a.language
FROM episodes_assets a
         JOIN episodes e ON e.id = a.episodes_id;

UPDATE episodes
SET mediaitem_id = uuid;

INSERT INTO timedmetadata (id, type, status, label, mediaitem_id, title, seconds, date_created, date_updated,
                           user_created, user_updated)
SELECT gen_random_uuid(),
       md.type,
       md.status,
       md.label,
       e.uuid,
       md.title,
       md.seconds,
       md.date_created,
       md.date_updated,
       md.user_created,
       md.user_updated
FROM timedmetadata md
         JOIN episodes e ON episode_id = e.id;

INSERT INTO mediaitems_usergroups (mediaitems_id, usergroups_code)
SELECT DISTINCT e.uuid, ug.usergroups_code
FROM episodes_usergroups ug
         JOIN episodes e ON e.id = ug.episodes_id;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-11T12:39:38.350Z             ***/
/***********************************************************/

DELETE
FROM timedmetadata
WHERE mediaitem_id IS NOT NULL;

DELETE
FROM mediaitems
WHERE id IN (SELECT uuid FROM episodes);

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "available_from" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "available_to" CASCADE;
--WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN DROP TABLE "public"."mediaitems_usergroups" ---

DROP TABLE IF EXISTS "public"."mediaitems_usergroups";

--- END DROP TABLE "public"."mediaitems_usergroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'mediaitems_usergroups';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 120;

UPDATE "public"."directus_fields"
SET "sort" = 16
WHERE "id" = 130;

UPDATE "public"."directus_fields"
SET "hidden" = false,
    "sort"   = 6
WHERE "id" = 144;

UPDATE "public"."directus_fields"
SET "hidden" = false,
    "sort"   = 7
WHERE "id" = 137;

UPDATE "public"."directus_fields"
SET "sort" = 15
WHERE "id" = 143;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 147;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 124;

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 148;

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 125;

UPDATE "public"."directus_fields"
SET "hidden" = false,
    "sort"   = 10
WHERE "id" = 1314;

UPDATE "public"."directus_fields"
SET "sort" = 8
WHERE "id" = 1378;

UPDATE "public"."directus_fields"
SET "sort" = 15
WHERE "id" = 1422;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1435;

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 483;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 1442;

UPDATE "public"."directus_fields"
SET "sort" = 17
WHERE "id" = 1459;

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 1460;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1466;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1471;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1468;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1469;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1470;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1467;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1472;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 447;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 448;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
