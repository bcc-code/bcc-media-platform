-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-06T12:18:37.821Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications"
    ADD COLUMN IF NOT EXISTS "high_priority" bool NOT NULL DEFAULT false;

COMMENT ON COLUMN "public"."notifications"."high_priority" IS NULL;

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1397, 'notifications', 'high_priority', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 2,
        'half', NULL, 'Should this be sent as high priority? Time sensitive notifications only.', NULL, false, 'config',
        NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 747;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 748;

UPDATE "public"."directus_fields"
SET "width" = 'half'
WHERE "id" = 763;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 743;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 981;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-06T12:18:39.727Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications"
    DROP COLUMN IF EXISTS "high_priority" CASCADE;
--WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 748;

UPDATE "public"."directus_fields"
SET "width" = 'full'
WHERE "id" = 763;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 743;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 747;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 981;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1397;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
