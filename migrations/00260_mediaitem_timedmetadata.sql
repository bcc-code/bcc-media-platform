-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-11T10:52:50.586Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems"
    ADD COLUMN IF NOT EXISTS "timedmetadata_from_asset" bool NOT NULL DEFAULT true;

COMMENT ON COLUMN "public"."mediaitems"."timedmetadata_from_asset" IS NULL;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes"
    ADD COLUMN IF NOT EXISTS "mediaitem_id" uuid NULL;

COMMENT ON COLUMN "public"."episodes"."mediaitem_id" IS NULL;

ALTER TABLE IF EXISTS "public"."episodes"
    ADD CONSTRAINT "episodes_mediaitem_id_foreign" FOREIGN KEY (mediaitem_id) REFERENCES mediaitems (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "episodes_mediaitem_id_foreign" ON "public"."episodes" IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD COLUMN IF NOT EXISTS "mediaitem_id" uuid NULL;

COMMENT ON COLUMN "public"."timedmetadata"."mediaitem_id" IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata"
    ADD CONSTRAINT "timedmetadata_mediaitem_id_foreign" FOREIGN KEY (mediaitem_id) REFERENCES mediaitems (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "timedmetadata_mediaitem_id_foreign" ON "public"."timedmetadata" IS NULL;

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1459, 'episodes', 'mediaitem_id', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{label}}"
}', 'related-values', NULL, false, false, 17, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 1230;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1461, 'mediaitems', 'timedmetadata_from_asset', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false,
        1, 'half', NULL, NULL, NULL, false, 'timedmetadata_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1460, 'mediaitems', 'timedmetadata_details', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false,
        false, 13, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1462, 'mediaitems', 'timedmetadata_tools', 'alias,no-data', 'timedmetadata-tools', NULL, NULL, NULL, false,
        false, 2, 'half', NULL, NULL, NULL, false, 'timedmetadata_details', NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1235;

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 1239;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 1329;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1463, 'timedmetadata', 'mediaitem_id', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{label}}"
}', 'related-values', NULL, false, true, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1464, 'mediaitems', 'timedmetadata', 'o2m', 'list-o2m', '{
  "layout": "table",
  "fields": [
    "label",
    "seconds",
    "title"
  ],
  "enableSelect": false
}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'timedmetadata_details', NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true)
FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (445, 'episodes', 'mediaitem_id', 'mediaitems', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (446, 'timedmetadata', 'mediaitem_id', 'mediaitems', 'timedmetadata', NULL, NULL, NULL, NULL, 'nullify');

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true)
FROM "public"."directus_relations";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

alter table public.timedmetadata
    drop constraint if exists timedmetadata_asset_or_episode;

--- ---

alter table public.timedmetadata
    add constraint timedmetadata_asset_or_episode
        check ((asset_id IS NOT NULL AND episode_id IS NULL AND mediaitem_id IS NULL) OR
               (asset_id IS NULL AND episode_id IS NOT NULL AND mediaitem_id IS NULL) OR
               (asset_id IS NULL AND episode_id IS NULL AND mediaitem_id IS NOT NULL));


-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-11T10:52:52.294Z             ***/
/***********************************************************/


alter table public.timedmetadata
    drop constraint if exists timedmetadata_asset_or_episode;

alter table public.timedmetadata
    add constraint timedmetadata_asset_or_episode
        check ((asset_id IS NOT NULL AND episode_id IS NULL AND mediaitem_id IS NULL) OR
               (asset_id IS NULL AND episode_id IS NOT NULL AND mediaitem_id IS NULL));

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes"
    DROP COLUMN IF EXISTS "mediaitem_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."episodes"
    DROP CONSTRAINT IF EXISTS "episodes_mediaitem_id_foreign";

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP COLUMN IF EXISTS "mediaitem_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."timedmetadata"
    DROP CONSTRAINT IF EXISTS "timedmetadata_mediaitem_id_foreign";

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems"
    DROP COLUMN IF EXISTS "timedmetadata_from_asset" CASCADE;
--WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 1230;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 1235;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1239;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 1329;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1459;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1461;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1460;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1462;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1463;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1464;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 445;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 446;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
