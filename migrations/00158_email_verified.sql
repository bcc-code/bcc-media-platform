-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-13T09:07:06.528Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."users" ---

ALTER TABLE IF EXISTS "users"."users" ADD COLUMN IF NOT EXISTS "email_verified" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "users"."users"."email_verified"  IS NULL;

--- END ALTER TABLE "users"."users" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-13T09:07:07.988Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."users" ---

ALTER TABLE IF EXISTS "users"."users" DROP COLUMN IF EXISTS "email_verified" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."users" ---
