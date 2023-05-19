-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-19T07:15:45.374Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."pages" ---

ALTER TABLE IF EXISTS "public"."pages"
	ALTER COLUMN "type" SET DEFAULT 'custom'::character varying;

--- END ALTER TABLE "public"."pages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = true, "required" = false WHERE "id" = 401;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-19T07:15:47.198Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."pages" ---

ALTER TABLE IF EXISTS "public"."pages"
	ALTER COLUMN "type" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."pages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = false, "required" = true WHERE "id" = 401;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
