-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-14T11:17:34.922Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections"
    ADD COLUMN IF NOT EXISTS "query_filter" json NULL;

COMMENT ON COLUMN "public"."collections"."query_filter" IS NULL;

ALTER TABLE IF EXISTS "public"."collections"
    DROP COLUMN IF EXISTS "episodes_query_filter" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."collections"
    DROP COLUMN IF EXISTS "pages_query_filter" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."collections"
    DROP COLUMN IF EXISTS "seasons_query_filter" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."collections"
    DROP COLUMN IF EXISTS "shows_query_filter" CASCADE;
--WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."collections" ---

--- BEGIN CREATE VIEW "public"."filter_dataset" ---

CREATE OR REPLACE VIEW "public"."filter_dataset" AS
WITH e_tags AS (SELECT et.episodes_id       AS id,
                       array_agg(tags.code) AS tags
                FROM episodes_tags et
                         JOIN tags ON tags.id = et.tags_id
                GROUP BY et.episodes_id),
     s_tags AS (SELECT st.seasons_id        AS id,
                       array_agg(tags.code) AS tags
                FROM seasons_tags st
                         JOIN tags ON tags.id = st.tags_id
                GROUP BY st.seasons_id),
     sh_tags AS (SELECT sht.shows_id         AS id,
                        array_agg(tags.code) AS tags
                 FROM shows_tags sht
                          JOIN tags ON tags.id = sht.tags_id
                 GROUP BY sht.shows_id)
SELECT 'episodes'::text                                 AS collection,
       e.id,
       e.season_id,
       se.show_id,
       COALESCE(e.agerating_code, se.agerating_code)    AS agerating_code,
       e.type,
       e.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[]) AS roles,
       COALESCE(e_tags.tags, '{}'::character varying[]) AS tags
FROM episodes e
         LEFT JOIN e_tags ON e_tags.id = e.id
         LEFT JOIN seasons se ON se.id = e.season_id
         LEFT JOIN episode_roles roles ON roles.id = e.id
         LEFT JOIN episode_availability av ON av.id = e.id
UNION
SELECT 'seasons'::text                                  AS collection,
       se.id,
       NULL::integer                                    AS season_id,
       se.show_id,
       NULL::character varying                          AS agerating_code,
       se.agerating_code                                AS type,
       se.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[]) AS roles,
       COALESCE(s_tags.tags, '{}'::character varying[]) AS tags
FROM seasons se
         LEFT JOIN s_tags ON s_tags.id = se.id
         LEFT JOIN season_roles roles ON roles.id = se.id
         LEFT JOIN season_availability av ON av.id = se.id
UNION
SELECT 'shows'::text                                     AS collection,
       sh.id,
       NULL::integer                                     AS season_id,
       NULL::integer                                     AS show_id,
       sh.agerating_code,
       sh.type,
       sh.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(shr.roles, '{}'::character varying[])    AS roles,
       COALESCE(sh_tags.tags, '{}'::character varying[]) AS tags
FROM shows sh
         LEFT JOIN sh_tags ON sh_tags.id = sh.id
         LEFT JOIN show_roles shr ON shr.id = sh.id
         LEFT JOIN show_availability av ON av.id = sh.id;

GRANT SELECT ON TABLE "public"."filter_dataset" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."filter_dataset" IS NULL;

--- END CREATE VIEW "public"."filter_dataset" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 693;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (703, 'collections', 'query_filter', 'cast-json', 'query-builder', NULL, 'formatted-json-value', NULL, false,
        false, 3, 'full', NULL, NULL, '[
    {
      "name": "hidden if not query",
      "rule": {
        "_and": [
          {
            "filter_type": {
              "_neq": "query"
            }
          }
        ]
      },
      "hidden": true,
      "options": {
        "fieldCollection": ""
      }
    }
  ]', false, 'config', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 684;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 390;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 392;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 391;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 385;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-14T11:17:36.182Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections"
    ADD COLUMN IF NOT EXISTS "episodes_query_filter" json NULL;

COMMENT ON COLUMN "public"."collections"."episodes_query_filter" IS NULL;

ALTER TABLE IF EXISTS "public"."collections"
    ADD COLUMN IF NOT EXISTS "pages_query_filter" json NULL;

COMMENT ON COLUMN "public"."collections"."pages_query_filter" IS NULL;

ALTER TABLE IF EXISTS "public"."collections"
    ADD COLUMN IF NOT EXISTS "seasons_query_filter" json NULL;

COMMENT ON COLUMN "public"."collections"."seasons_query_filter" IS NULL;

ALTER TABLE IF EXISTS "public"."collections"
    ADD COLUMN IF NOT EXISTS "shows_query_filter" json NULL;

COMMENT ON COLUMN "public"."collections"."shows_query_filter" IS NULL;

ALTER TABLE IF EXISTS "public"."collections"
    DROP COLUMN IF EXISTS "query_filter" CASCADE;
--WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."collections" ---

--- BEGIN DROP VIEW "public"."filter_dataset" ---

DROP VIEW IF EXISTS "public"."filter_dataset";
--- END DROP VIEW "public"."filter_dataset" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (390, 'collections', 'pages_query_filter', 'cast-json', 'query-builder', '{
  "fieldCollection": "pages"
}', NULL, NULL, false, false, 3, 'full', NULL, NULL, '[
  {
    "name": "Hidden if not Pages",
    "rule": {
      "_and": [
        {
          "_or": [
            {
              "collection": {
                "_neq": "pages"
              }
            },
            {
              "filter_type": {
                "_neq": "query"
              }
            }
          ]
        }
      ]
    },
    "hidden": true,
    "options": {
      "fieldCollection": ""
    }
  }
]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (392, 'collections', 'shows_query_filter', 'cast-json', 'query-builder', '{
  "fieldCollection": "shows"
}', NULL, NULL, false, false, 4, 'full', NULL, NULL, '[
  {
    "name": "Hidden if not Shows",
    "rule": {
      "_and": [
        {
          "_or": [
            {
              "collection": {
                "_neq": "shows"
              }
            },
            {
              "filter_type": {
                "_neq": "query"
              }
            }
          ]
        }
      ]
    },
    "options": {
      "fieldCollection": ""
    },
    "hidden": true
  }
]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (391, 'collections', 'seasons_query_filter', 'cast-json', 'query-builder', '{
  "fieldCollection": "seasons"
}', NULL, NULL, false, false, 5, 'full', NULL, NULL, '[
  {
    "name": "Hidden if not Seasons",
    "rule": {
      "_and": [
        {
          "_or": [
            {
              "collection": {
                "_neq": "seasons"
              }
            },
            {
              "filter_type": {
                "_neq": "query"
              }
            }
          ]
        }
      ]
    },
    "hidden": true,
    "options": {
      "fieldCollection": ""
    }
  }
]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (385, 'collections', 'episodes_query_filter', 'cast-json', 'query-builder', '{
  "fieldCollection": "episodes"
}', NULL, NULL, false, false, 6, 'full', NULL, NULL, '[
  {
    "name": "Hidden if not Episodes",
    "rule": {
      "_and": [
        {
          "_or": [
            {
              "collection": {
                "_neq": "episodes"
              }
            },
            {
              "filter_type": {
                "_neq": "query"
              }
            }
          ]
        }
      ]
    },
    "hidden": true,
    "options": {
      "fieldCollection": ""
    }
  }
]', false, 'config', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 8
WHERE "id" = 693;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 684;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 703;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
