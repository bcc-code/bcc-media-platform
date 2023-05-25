-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:53:36.882Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."collections" ---

ALTER TABLE IF EXISTS "users"."collections" DROP COLUMN IF EXISTS "application_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "users"."collections" DROP CONSTRAINT IF EXISTS "collections_applications_id_fk";

--- END ALTER TABLE "users"."collections" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:53:38.625Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."collections" ---

ALTER TABLE IF EXISTS "users"."collections" ADD COLUMN IF NOT EXISTS "application_id" uuid NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "users"."collections"."application_id"  IS NULL;

ALTER TABLE IF EXISTS "users"."collections" ADD CONSTRAINT "collections_applications_id_fk" FOREIGN KEY (application_id) REFERENCES applications(uuid) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "collections_applications_id_fk" ON "users"."collections" IS NULL;

--- END ALTER TABLE "users"."collections" ---
