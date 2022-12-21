-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-20T14:11:41.897Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."achievements" ---

ALTER TABLE IF EXISTS "users"."achievements" ADD COLUMN IF NOT EXISTS "confirmed_at" timestamp NULL  ;

COMMENT ON COLUMN "users"."achievements"."confirmed_at"  IS NULL;

--- END ALTER TABLE "users"."achievements" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-20T14:11:43.297Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."achievements" ---

ALTER TABLE IF EXISTS "users"."achievements" DROP COLUMN IF EXISTS "confirmed_at" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."achievements" ---
