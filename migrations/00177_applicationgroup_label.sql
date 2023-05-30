-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T11:54:53.341Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applicationgroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups" ADD COLUMN IF NOT EXISTS "label" text NOT NULL DEFAULT ''; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."applicationgroups"."label"  IS NULL;

--- END ALTER TABLE "public"."applicationgroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1188, 'applicationgroups', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T11:54:55.081Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applicationgroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups" DROP COLUMN IF EXISTS "label" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."applicationgroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1188;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
