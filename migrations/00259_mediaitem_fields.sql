-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-11T10:21:35.780Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."mediaitems_assets_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_assets_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."mediaitems_assets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."mediaitems_assets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."mediaitems_assets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."mediaitems_assets_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."mediaitems_assets_id_seq" ---

--- BEGIN CREATE TABLE "public"."mediaitems_assets" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_assets"
(
    "id"            int4         NOT NULL DEFAULT nextval('mediaitems_assets_id_seq'::regclass),
    "mediaitems_id" uuid         NOT NULL,
    "assets_id"     int4         NOT NULL,
    "language"      varchar(255) NOT NULL,
    CONSTRAINT "mediaitems_assets_language_foreign" FOREIGN KEY (language) REFERENCES languages (code) ON DELETE CASCADE,
    CONSTRAINT "mediaitems_assets_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_assets_assets_id_foreign" FOREIGN KEY (assets_id) REFERENCES assets (id) ON DELETE CASCADE,
    CONSTRAINT "mediaitems_assets_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."mediaitems_assets" TO api, background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_assets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_assets"."id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_assets"."mediaitems_id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_assets"."assets_id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_assets"."language" IS NULL;

COMMENT ON CONSTRAINT "mediaitems_assets_language_foreign" ON "public"."mediaitems_assets" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_assets_pkey" ON "public"."mediaitems_assets" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_assets_assets_id_foreign" ON "public"."mediaitems_assets" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_assets_mediaitems_id_foreign" ON "public"."mediaitems_assets" IS NULL;

COMMENT ON TABLE "public"."mediaitems_assets" IS NULL;

--- END CREATE TABLE "public"."mediaitems_assets" ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "production_date" timestamp NULL;

COMMENT ON COLUMN "public"."mediaitems"."production_date" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "parent_id" uuid NULL;

COMMENT ON COLUMN "public"."mediaitems"."parent_id" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "content_type" varchar(255) NULL;

COMMENT ON COLUMN "public"."mediaitems"."content_type" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "audience" varchar(255) NULL;

COMMENT ON COLUMN "public"."mediaitems"."audience" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "agerating_code" varchar(255) NULL;

COMMENT ON COLUMN "public"."mediaitems"."agerating_code" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD CONSTRAINT "mediaitems_parent_id_foreign" FOREIGN KEY (parent_id) REFERENCES mediaitems (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_parent_id_foreign" ON "public"."mediaitems" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD CONSTRAINT "mediaitems_agerating_code_foreign" FOREIGN KEY (agerating_code) REFERENCES ageratings (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_agerating_code_foreign" ON "public"."mediaitems" IS NULL;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (481, 'mediaitems', 'production_date', NULL, 'custom-datepicker', NULL, 'datetime', NULL, false, false, 2,
        'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1435;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (483, 'mediaitems', 'metadata', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 13,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (482, 'mediaitems', 'parent_id', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{label}}"
}', 'related-values', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'parent', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1406;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (484, 'mediaitems', 'content_type', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "Other transmission",
      "value": "other_transmission"
    },
    {
      "text": "Event transmission",
      "value": "event_transmission"
    },
    {
      "text": "Individual film",
      "value": "individual_film"
    },
    {
      "text": "Series film",
      "value": "series_film"
    }
  ]
}', NULL, NULL, false, false, 3, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (485, 'mediaitems', 'audience', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "Kids",
      "value": "kids"
    },
    {
      "text": "Youth",
      "value": "youth"
    },
    {
      "text": "General",
      "value": "general"
    }
  ]
}', NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1431;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1427;

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 1422;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 1405;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (486, 'mediaitems', 'agerating_code', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{title}}"
}', 'related-values', NULL, false, false, 5, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (496, 'mediaitems_assets', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (497, 'mediaitems_assets', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (498, 'mediaitems_assets', 'assets_id', NULL, NULL, NULL, NULL, NULL, false, true, 4, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (495, 'mediaitems', 'assets', 'm2m', 'list-m2m', '{
  "template": "{{language}}- {{assets_id.name}}",
  "junctionFieldLocation": "top",
  "enableCreate": false
}', 'related-values', '{
  "template": "{{language}}- {{assets_id.name}}"
}', false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (499, 'mediaitems_assets', 'language', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{name}}"
}', 'related-values', NULL, false, false, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort"       = 3,
    "conditions" = '[
      {
        "rule": {
          "_and": [
            {
              "_and": [
                {
                  "parent_id": {
                    "_null": true
                  }
                },
                {
                  "parent_episode_id": {
                    "_null": true
                  }
                }
              ]
            }
          ]
        },
        "options": {},
        "hidden": true
      }
    ]'
WHERE "id" = 1440;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1436;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 1441;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 1442;

UPDATE "public"."directus_fields"
SET "width" = 'half',
    "group" = 'metadata'
WHERE "id" = 1458;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true)
FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('mediaitems_assets', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (144, 'mediaitems', 'parent_id', 'mediaitems', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (444, 'mediaitems_assets', 'language', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (145, 'mediaitems', 'agerating_code', 'ageratings', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (442, 'mediaitems_assets', 'assets_id', 'assets', NULL, NULL, NULL, 'mediaitems_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (443, 'mediaitems_assets', 'mediaitems_id', 'mediaitems', 'assets', NULL, NULL, 'assets_id', NULL, 'nullify');

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true)
FROM "public"."directus_relations";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."mediaitems"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1408;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 1422;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 1460;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1465, 'mediaitems', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'translations_preview', NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";


UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1406;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1408;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1431;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1427;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1405;

UPDATE "public"."directus_fields" SET "group" = 'details' WHERE "id" = 1465;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-11T10:21:37.435Z             ***/
/***********************************************************/


--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1406;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1427;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1408;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1405;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1431;

UPDATE "public"."directus_fields" SET "group" = 'translations_preview' WHERE "id" = 1465;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1408;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 1422;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1460;

DELETE FROM "public"."directus_fields" WHERE "id" = 1465;


--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "production_date" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "parent_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "content_type" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "audience" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "agerating_code" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP CONSTRAINT IF EXISTS "mediaitems_parent_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP CONSTRAINT IF EXISTS "mediaitems_agerating_code_foreign";

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN DROP TABLE "public"."mediaitems_assets" ---

DROP TABLE IF EXISTS "public"."mediaitems_assets";

--- END DROP TABLE "public"."mediaitems_assets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'mediaitems_assets';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1406;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1427;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1422;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 1436;

UPDATE "public"."directus_fields"
SET "sort"       = 2,
    "conditions" = '[
      {
        "rule": {
          "_and": [
            {
              "parent_episode_id": {
                "_null": true
              }
            }
          ]
        },
        "options": {},
        "hidden": true
      }
    ]'
WHERE "id" = 1440;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 1435;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1431;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1405;

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 1441;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 1442;

UPDATE "public"."directus_fields"
SET "width" = 'full',
    "group" = 'details'
WHERE "id" = 1458;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 481;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 483;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 482;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 484;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 485;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 486;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 496;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 497;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 498;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 495;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 499;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 144;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 444;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 145;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 442;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 443;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
