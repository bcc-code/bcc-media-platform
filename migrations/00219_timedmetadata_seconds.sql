-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-14T12:10:28.565Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata" ADD COLUMN IF NOT EXISTS "seconds" float4 NOT NULL DEFAULT '0'::real ;

COMMENT ON COLUMN "public"."timedmetadata"."seconds"  IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata" DROP COLUMN IF EXISTS "timestamp" CASCADE; --WARN: Drop column can occure in data loss!

GRANT INSERT,UPDATE,DELETE ON TABLE "public"."timedmetadata" TO "api";

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1329, 'timedmetadata', 'seconds', NULL, 'input', NULL, 'raw', NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 1238;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-14T12:10:30.736Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata" ADD COLUMN IF NOT EXISTS "timestamp" time NOT NULL DEFAULT '00:00:00'  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."timedmetadata"."timestamp"  IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata" DROP COLUMN IF EXISTS "seconds" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1238, 'timedmetadata', 'timestamp', NULL, 'datetime', '{"includeSeconds":true}', 'raw', NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 1329;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
