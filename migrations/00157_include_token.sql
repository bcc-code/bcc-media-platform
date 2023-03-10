-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-10T13:54:53.280Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."redirects" ---

ALTER TABLE IF EXISTS "public"."redirects" ADD COLUMN IF NOT EXISTS "include_token" bool NULL  ;

COMMENT ON COLUMN "public"."redirects"."include_token"  IS NULL;

--- END ALTER TABLE "public"."redirects" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1125, 'redirects', 'include_token', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-10T13:54:54.874Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."redirects" ---

ALTER TABLE IF EXISTS "public"."redirects" DROP COLUMN IF EXISTS "include_token" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."redirects" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1125;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
