-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-19T08:34:45.707Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "enableSelect": false
}'
WHERE "id" = 208;

UPDATE "public"."directus_fields"
SET "options" = '{
  "enableLink": true,
  "enableSelect": false
}'
WHERE "id" = 563;

UPDATE "public"."directus_fields"
SET "options" = '{
  "enableSelect": false
}'
WHERE "id" = 564;

UPDATE "public"."directus_fields"
SET "options" = '{
  "enableSelect": false
}'
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "options" = '{
  "enableSelect": false
}'
WHERE "id" = 274;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('computeddata_group', 'component_exchange', NULL, NULL, false, false, '[
  {
    "language": "en-US",
    "translation": "Computed Data"
  }
]', NULL, true, NULL, NULL, NULL, 'all', '#FFA439', NULL, 7, NULL, 'open', NULL);
INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('applications_group', 'home_app_logo', NULL, NULL, false, false, '[
  {
    "language": "en-US",
    "translation": "Applications"
  }
]', NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 11, NULL, 'open', NULL);
INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('messages_group', 'tag', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#2ECDA7', NULL,
        10, NULL, 'open', NULL);

UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'messages_messagetemplates';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'computeddata_group'
WHERE "collection" = 'computeddatagroups';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'messages_group'
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "color" = NULL
WHERE "collection" = 'surveys';

UPDATE "public"."directus_collections"
SET "color" = NULL
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "color" = NULL,
    "sort"  = 1,
    "group" = 'applications_group'
WHERE "collection" = 'applications';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'computeddata_group'
WHERE "collection" = 'computeddata';


UPDATE "public"."directus_collections"
SET "group" = 'messages_group'
WHERE "collection" = 'messagetemplates';


UPDATE "public"."directus_collections"
SET "color" = NULL
WHERE "collection" = 'games';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'applications_group'
WHERE "collection" = 'applicationgroups';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-19T08:34:47.571Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "group" = 'messages'
WHERE "collection" = 'messagetemplates';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'messages_messagetemplates';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'computeddata'
WHERE "collection" = 'computeddatagroups';

UPDATE "public"."directus_collections"
SET "color" = '#E35169'
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "sort"  = 7,
    "group" = NULL
WHERE "collection" = 'computeddata';

UPDATE "public"."directus_collections"
SET "color" = '#E35169',
    "sort"  = 10,
    "group" = NULL
WHERE "collection" = 'applications';

UPDATE "public"."directus_collections"
SET "sort"  = 12,
    "group" = NULL
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "color" = '#E35169'
WHERE "collection" = 'games';

UPDATE "public"."directus_collections"
SET "color" = '#FFA439'
WHERE "collection" = 'surveys';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'applications'
WHERE "collection" = 'applicationgroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'computeddata_group';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'messages_group';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'applications_group';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = NULL
WHERE "id" = 274;

UPDATE "public"."directus_fields"
SET "options" = '{
  "filter": {
    "_and": [
      {
        "type": {
          "_eq": "episode"
        }
      }
    ]
  }
}'
WHERE "id" = 208;

UPDATE "public"."directus_fields"
SET "options" = NULL
WHERE "id" = 564;

UPDATE "public"."directus_fields"
SET "options" = NULL
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "options" = '{
  "enableLink": true
}'
WHERE "id" = 563;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
