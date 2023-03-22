-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-22T08:25:21.130Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."users" ---

ALTER TABLE IF EXISTS "users"."users" ADD COLUMN IF NOT EXISTS "gender" varchar not null default 'unknown';
ALTER TABLE IF EXISTS "users"."users" ADD COLUMN IF NOT EXISTS "first_name" varchar not null default '';

COMMENT ON COLUMN "users"."users"."gender"  IS NULL;
COMMENT ON COLUMN "users"."users"."first_name"  IS NULL;

--- END ALTER TABLE "users"."users" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-22T08:25:22.601Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."users" ---

ALTER TABLE IF EXISTS "users"."users" DROP COLUMN IF EXISTS "gender" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "users"."users" DROP COLUMN IF EXISTS "first_name" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."users" ---
