-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-20T11:06:43.538Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "parent_episode_id" int4 NULL;

COMMENT ON COLUMN "public"."mediaitems"."parent_episode_id" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "parent_starts_at" float4 NULL;

COMMENT ON COLUMN "public"."mediaitems"."parent_starts_at" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "parent_ends_at" float4 NULL;

COMMENT ON COLUMN "public"."mediaitems"."parent_ends_at" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "status" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD CONSTRAINT "mediaitems_parent_episode_id_foreign" FOREIGN KEY (parent_episode_id) REFERENCES episodes (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_parent_episode_id_foreign" ON "public"."mediaitems" IS NULL;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN ALTER VIEW "public"."mediaitems_view" ---

DROP VIEW IF EXISTS "public"."mediaitems_view";
CREATE OR REPLACE VIEW "public"."mediaitems_view" AS
SELECT mi.id,
       mi.asset_id,
       mi.title                                       AS original_title,
       mi.description                                 AS original_description,
       COALESCE(titles.title, '{}'::json)             AS title,
       COALESCE(descriptions.description, '{}'::json) AS description,
       COALESCE(images.images, '{}'::json)            AS images,
       mi.parent_episode_id,
       mi.parent_starts_at,
       mi.parent_ends_at
FROM (((mediaitems mi
    LEFT JOIN (SELECT ts.mediaitems_id,
                      json_object_agg(ts.languages_code, ts.title) AS title
               FROM mediaitems_translations ts
               GROUP BY ts.mediaitems_id) titles ON ((titles.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT ts.mediaitems_id,
                      json_object_agg(ts.languages_code, ts.description) AS description
               FROM mediaitems_translations ts
               GROUP BY ts.mediaitems_id) descriptions ON ((descriptions.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT simg.mediaitems_id,
                      json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk',
                                                 df.filename_disk)) AS images
               FROM ((mediaitems_styledimages simg
                   JOIN styledimages img ON ((img.id = simg.styledimages_id)))
                   JOIN directus_files df ON ((img.file = df.id)))
               GROUP BY simg.mediaitems_id) images ON ((images.mediaitems_id = mi.id)));
GRANT SELECT ON TABLE "public"."mediaitems_view" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."mediaitems_view" IS NULL;

--- END ALTER VIEW "public"."mediaitems_view" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1436, 'mediaitems', 'parent_episode_id', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{label}}"
}', 'related-values', NULL, false, false, 1, 'full', NULL, 'Episode this is a subclip of', NULL, false, 'parent', NULL,
        NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1437, 'mediaitems', 'parent_starts_at', NULL, 'input', '{
  "min": 0
}', 'raw', NULL, false, false, 1, 'half', '[
  {
    "language": "en-US",
    "translation": "Starts at"
  }
]', NULL, NULL, false, 'parent_range', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1439, 'mediaitems', 'parent_ends_at', NULL, 'input', '{
  "min": 0
}', 'formatted-value', NULL, false, false, 2, 'half', '[
  {
    "language": "en-US",
    "translation": "Ends at"
  }
]', NULL, NULL, false, 'parent_range', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1440, 'mediaitems', 'parent_range', 'alias,no-data,group', 'group-raw', NULL, NULL, NULL, false, false, 2,
        'full', NULL, NULL, '[
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
  ]', false, 'parent', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1441, 'mediaitems', 'parent', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 10, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1442, 'mediaitems', 'details', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 11,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 1422;

UPDATE "public"."directus_fields"
SET "sort"  = 4,
    "group" = 'details'
WHERE "id" = 1427;

UPDATE "public"."directus_fields"
SET "sort"  = 2,
    "group" = 'details'
WHERE "id" = 1406;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1435;

UPDATE "public"."directus_fields"
SET "sort"  = 3,
    "group" = 'details'
WHERE "id" = 1431;

UPDATE "public"."directus_fields"
SET "sort"  = 1,
    "group" = 'details'
WHERE "id" = 1405;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1399;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "archive_field" = NULL
WHERE "collection" = 'mediaitems';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (433, 'mediaitems', 'parent_episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-20T11:06:45.047Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "status" varchar(255) NOT NULL DEFAULT 'draft'::character varying;

COMMENT ON COLUMN "public"."mediaitems"."status" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "parent_episode_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "parent_starts_at" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "parent_ends_at" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP CONSTRAINT IF EXISTS "mediaitems_parent_episode_id_foreign";

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN ALTER VIEW "public"."mediaitems_view" ---

DROP VIEW IF EXISTS "public"."mediaitems_view";
CREATE OR REPLACE VIEW "public"."mediaitems_view" AS
SELECT mi.id,
       mi.title                                       AS original_title,
       mi.description                                 AS original_description,
       COALESCE(titles.title, '{}'::json)             AS title,
       COALESCE(descriptions.description, '{}'::json) AS description,
       COALESCE(images.images, '{}'::json)            AS images
FROM ((((mediaitems mi
    LEFT JOIN (SELECT ts.mediaitems_id,
                      json_object_agg(ts.languages_code, ts.title) AS title
               FROM mediaitems_translations ts
               GROUP BY ts.mediaitems_id) titles ON ((titles.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT ts.mediaitems_id,
                      json_object_agg(ts.languages_code, ts.description) AS description
               FROM mediaitems_translations ts
               GROUP BY ts.mediaitems_id) descriptions ON ((descriptions.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT simg.mediaitems_id,
                      json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk',
                                                 df.filename_disk)) AS images
               FROM ((mediaitems_styledimages simg
                   JOIN styledimages img ON ((img.id = simg.styledimages_id)))
                   JOIN directus_files df ON ((img.file = df.id)))
               GROUP BY simg.mediaitems_id) images ON ((images.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT t.mediaitems_id,
                      json_agg(tg.code) AS json_agg
               FROM (mediaitems_tags t
                   JOIN tags tg ON ((tg.id = t.id)))
               GROUP BY t.mediaitems_id) tags ON ((tags.mediaitems_id = mi.id)));
ALTER VIEW IF EXISTS "public"."mediaitems_view" OWNER TO bccm;
GRANT SELECT ON TABLE "public"."mediaitems_view" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_view" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_view" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_view" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_view" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_view" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_view" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."mediaitems_view" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."mediaitems_view" IS NULL;

--- END ALTER VIEW "public"."mediaitems_view" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "archive_field" = 'status'
WHERE "collection" = 'mediaitems';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort"  = 10,
    "group" = NULL
WHERE "id" = 1405;

UPDATE "public"."directus_fields"
SET "sort" = 15
WHERE "id" = 1422;

UPDATE "public"."directus_fields"
SET "sort"  = 13,
    "group" = NULL
WHERE "id" = 1427;

UPDATE "public"."directus_fields"
SET "sort"  = 12,
    "group" = NULL
WHERE "id" = 1431;

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 1435;

UPDATE "public"."directus_fields"
SET "sort"  = 11,
    "group" = NULL
WHERE "id" = 1406;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1399, 'mediaitems', 'status', NULL, 'select-dropdown', '{
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
      "background": "var(--theme--primary)"
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
      "background": "var(--theme--warning)"
    }
  ]
}', false, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1436;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1437;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1439;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1440;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1441;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1442;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 433;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
