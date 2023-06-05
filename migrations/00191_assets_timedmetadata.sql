-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-05T11:20:25.222Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."timedmetadata" ---

CREATE TABLE IF NOT EXISTS "public"."timedmetadata"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "label"        text         NOT NULL,
    "type"         varchar(255) NOT NULL DEFAULT 'chapter'::character varying,
    "highlight"    bool         NOT NULL DEFAULT false,
    "title"        text         NOT NULL,
    "description"  varchar(255) NULL,
    "asset_id"     int4         NOT NULL,
    "timestamp"    time         NOT NULL,
    CONSTRAINT "timedmetadata_pkey" PRIMARY KEY (id),
    CONSTRAINT "timedmetadata_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "timedmetadata_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "timedmetadata_asset_id_foreign" FOREIGN KEY (asset_id) REFERENCES assets (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."timedmetadata" TO directus,api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."timedmetadata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."timedmetadata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."timedmetadata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."timedmetadata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."timedmetadata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."timedmetadata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."timedmetadata"."id" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."status" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."user_created" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."date_created" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."label" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."type" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."highlight" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."title" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."description" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."asset_id" IS NULL;


COMMENT ON COLUMN "public"."timedmetadata"."timestamp" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_pkey" ON "public"."timedmetadata" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_user_created_foreign" ON "public"."timedmetadata" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_user_updated_foreign" ON "public"."timedmetadata" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_asset_id_foreign" ON "public"."timedmetadata" IS NULL;

COMMENT ON TABLE "public"."timedmetadata" IS NULL;

--- END CREATE TABLE "public"."timedmetadata" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "collapse" = 'closed'
WHERE "collection" = 'surveys';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('timedmetadata', NULL, NULL, NULL, true, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL,
        NULL, 1, 'assets', 'open', NULL);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 26;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 32;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 30;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 27;

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 31;

UPDATE "public"."directus_fields"
SET "sort" = 15
WHERE "id" = 28;

UPDATE "public"."directus_fields"
SET "sort" = 16
WHERE "id" = 35;

UPDATE "public"."directus_fields"
SET "width" = 'half'
WHERE "id" = 33;

UPDATE "public"."directus_fields"
SET "options" = '{
  "limit": 100,
  "fields": [
    "type",
    "page_id.translations",
    "show_id.translations",
    "season_id.translations",
    "episode_id.translations",
    "link_id.translations"
  ],
  "enableSearchFilter": true,
  "template": null,
  "enableLink": true,
  "enableSelect": false
}'
WHERE "id" = 684;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1226, 'timedmetadata', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1238, 'timedmetadata', 'timestamp', NULL, 'datetime', '{
  "includeSeconds": true
}', 'raw', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1224, 'timedmetadata', 'id', 'uuid', 'input', NULL, NULL, NULL, true, false, 1, 'half', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1228, 'timedmetadata', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1229, 'timedmetadata', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 468;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1225, 'timedmetadata', 'status', NULL, 'select-dropdown', '{
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
VALUES (1232, 'timedmetadata', 'highlight', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 3, 'half',
        NULL, 'Should this be used as a highlight?', NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1233, 'timedmetadata', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 4, 'full', NULL, NULL, NULL,
        false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1227, 'timedmetadata', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1234, 'timedmetadata', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 5, 'full', NULL, NULL,
        NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1230, 'timedmetadata', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 8, 'full', NULL,
        'For internal use', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1235, 'timedmetadata', 'details', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 9,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1231, 'timedmetadata', 'type', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "Chapter",
      "value": "chapter"
    }
  ]
}', NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1236, 'timedmetadata', 'asset_id', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{name}}"
}', 'related-values', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1237, 'assets', 'timedmetadata', 'o2m', 'list-o2m', '{
  "enableSelect": false,
  "template": "{{timestamp}} - {{label}}"
}', 'related-values', '{
  "template": "{{timestamp}} - {{label}}"
}', false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "width" = 'half'
WHERE "id" = 34;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_deselect_action" = 'delete'
WHERE "id" = 211;

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (377, 'timedmetadata', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (378, 'timedmetadata', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (379, 'timedmetadata', 'asset_id', 'assets', 'timedmetadata', NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-05T11:20:26.871Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."timedmetadata" ---

DROP TABLE IF EXISTS "public"."timedmetadata";

--- END DROP TABLE "public"."timedmetadata" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "collapse" = 'open'
WHERE "collection" = 'surveys';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'timedmetadata';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 8
WHERE "id" = 26;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 27;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 30;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 31;

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 32;

UPDATE "public"."directus_fields"
SET "width" = 'full'
WHERE "id" = 33;

UPDATE "public"."directus_fields"
SET "width" = 'full'
WHERE "id" = 34;

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 28;

UPDATE "public"."directus_fields"
SET "sort" = 15
WHERE "id" = 35;

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 468;

UPDATE "public"."directus_fields"
SET "options" = '{
  "limit": 100,
  "fields": [
    "type",
    "page_id.translations",
    "show_id.translations",
    "season_id.translations",
    "episode_id.translations",
    "link_id.translations"
  ],
  "enableLink": true,
  "enableSearchFilter": true,
  "template": null
}'
WHERE "id" = 684;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1226;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1238;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1224;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1228;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1229;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1225;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1232;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1233;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1227;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1234;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1230;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1235;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1231;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1236;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1237;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_deselect_action" = 'nullify'
WHERE "id" = 211;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 377;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 378;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 379;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
