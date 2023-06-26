-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-23T10:23:30.086Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applicationgroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups" ADD COLUMN IF NOT EXISTS "support_email" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."applicationgroups"."support_email"  IS NULL;

--- END ALTER TABLE "public"."applicationgroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1247, 'applicationgroups', 'support_email', NULL, 'input', '{"iconLeft":"alternate_email"}', 'raw', NULL, false, false, NULL, 'full', NULL, 'Defaults to support@brunstad.tv', NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-23T10:23:31.649Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applicationgroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups" DROP COLUMN IF EXISTS "support_email" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."applicationgroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1247;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
