-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-03T07:49:27.654Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."notifications_targets_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."notifications_targets_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."notifications_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."notifications_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."notifications_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."notifications_targets_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."notifications_targets_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."targets_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."targets_usergroups_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."targets_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."targets_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."targets_usergroups_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."targets_usergroups_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."targets_usergroups_id_seq" ---

--- BEGIN CREATE TABLE "public"."targets" ---

CREATE TABLE IF NOT EXISTS "public"."targets"
(
    "id"    uuid         NOT NULL,
    "label" varchar(255) NULL,
    "type"  varchar(255) NOT NULL,
    CONSTRAINT "targets_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."targets" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."targets"."id" IS NULL;


COMMENT ON COLUMN "public"."targets"."label" IS NULL;


COMMENT ON COLUMN "public"."targets"."type" IS NULL;

COMMENT ON CONSTRAINT "targets_pkey" ON "public"."targets" IS NULL;

COMMENT ON TABLE "public"."targets" IS NULL;

--- END CREATE TABLE "public"."targets" ---

--- BEGIN CREATE TABLE "public"."notifications_targets" ---

CREATE TABLE IF NOT EXISTS "public"."notifications_targets"
(
    "id"               int4 NOT NULL DEFAULT nextval('notifications_targets_id_seq'::regclass),
    "notifications_id" uuid NULL,
    "targets_id"       uuid NULL,
    CONSTRAINT "notifications_targets_pkey" PRIMARY KEY (id),
    CONSTRAINT "notifications_targets_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets (id) ON DELETE CASCADE,
    CONSTRAINT "notifications_targets_notifications_id_foreign" FOREIGN KEY (notifications_id) REFERENCES notifications (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."notifications_targets" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notifications_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notifications_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."notifications_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."notifications_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."notifications_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."notifications_targets" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."notifications_targets"."id" IS NULL;


COMMENT ON COLUMN "public"."notifications_targets"."notifications_id" IS NULL;


COMMENT ON COLUMN "public"."notifications_targets"."targets_id" IS NULL;

COMMENT ON CONSTRAINT "notifications_targets_pkey" ON "public"."notifications_targets" IS NULL;


COMMENT ON CONSTRAINT "notifications_targets_targets_id_foreign" ON "public"."notifications_targets" IS NULL;


COMMENT ON CONSTRAINT "notifications_targets_notifications_id_foreign" ON "public"."notifications_targets" IS NULL;

COMMENT ON TABLE "public"."notifications_targets" IS NULL;

--- END CREATE TABLE "public"."notifications_targets" ---

--- BEGIN CREATE TABLE "public"."targets_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."targets_usergroups"
(
    "id"              int4         NOT NULL DEFAULT nextval('targets_usergroups_id_seq'::regclass),
    "targets_id"      uuid         NULL,
    "usergroups_code" varchar(255) NULL,
    CONSTRAINT "targets_usergroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "targets_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE,
    CONSTRAINT "targets_usergroups_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."targets_usergroups" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."targets_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."targets_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."targets_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."targets_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."targets_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."targets_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."targets_usergroups"."id" IS NULL;


COMMENT ON COLUMN "public"."targets_usergroups"."targets_id" IS NULL;


COMMENT ON COLUMN "public"."targets_usergroups"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "targets_usergroups_pkey" ON "public"."targets_usergroups" IS NULL;


COMMENT ON CONSTRAINT "targets_usergroups_usergroups_code_foreign" ON "public"."targets_usergroups" IS NULL;


COMMENT ON CONSTRAINT "targets_usergroups_targets_id_foreign" ON "public"."targets_usergroups" IS NULL;

COMMENT ON TABLE "public"."targets_usergroups" IS NULL;

--- END CREATE TABLE "public"."targets_usergroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

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
SET "sort" = 9
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'messages';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('targets', 'location_on', NULL, '{{label}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, 1, 'notifications', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('targets_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, NULL, NULL, 'open');

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "sort" = 18
WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'notificationtemplates';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'shows_usergroups';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('notifications_targets', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, NULL, NULL, 'open');

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'lists_relations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (974, 'targets', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (975, 'targets', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (976, 'targets', 'type', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "User Groups",
      "value": "usergroups"
    }
  ]
}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (978, 'targets_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (979, 'targets_usergroups', 'targets_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (980, 'targets_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (977, 'targets', 'usergroups', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, true, NULL, 'full', NULL,
        NULL, '[
    {
      "name": "show if usergroups",
      "rule": {
        "_and": [
          {
            "type": {
              "_eq": "usergroups"
            }
          }
        ]
      },
      "hidden": false,
      "options": {
        "layout": "list",
        "enableCreate": true,
        "enableSelect": true,
        "limit": 15,
        "junctionFieldLocation": "bottom",
        "allowDuplicates": false,
        "enableSearchFilter": false,
        "enableLink": false
      }
    }
  ]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (981, 'notifications', 'targets', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (982, 'notifications_targets', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (983, 'targets', 'notifications', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (984, 'notifications_targets', 'notifications_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (985, 'notifications_targets', 'targets_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (302, 'notifications_targets', 'targets_id', 'targets', 'notifications', NULL, NULL, 'notifications_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (303, 'notifications_targets', 'notifications_id', 'notifications', 'targets', NULL, NULL, 'targets_id', NULL,
        'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (300, 'targets_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'targets_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (301, 'targets_usergroups', 'targets_id', 'targets', 'usergroups', NULL, NULL, 'usergroups_code', NULL,
        'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-03T07:49:29.048Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."notifications_targets" ---

DROP TABLE IF EXISTS "public"."notifications_targets";

--- END DROP TABLE "public"."notifications_targets" ---

--- BEGIN DROP TABLE "public"."targets_usergroups" ---

DROP TABLE IF EXISTS "public"."targets_usergroups";

--- END DROP TABLE "public"."targets_usergroups" ---

--- BEGIN DROP TABLE "public"."targets" ---

DROP TABLE IF EXISTS "public"."targets";

--- END DROP TABLE "public"."targets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'config';

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
SET "sort" = 1
WHERE "collection" = 'notificationtemplates';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections"
SET "sort" = 18
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "sort" = 19
WHERE "collection" = 'applications_usergroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'targets';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'targets_usergroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'notifications_targets';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 974;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 975;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 976;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 978;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 979;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 980;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 977;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 981;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 982;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 983;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 984;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 985;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 302;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 303;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 300;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 301;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
