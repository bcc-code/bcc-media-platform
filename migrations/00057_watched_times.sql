-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-15T07:57:11.652Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."progress" ---

ALTER TABLE IF EXISTS "users"."progress" ADD COLUMN IF NOT EXISTS "watched" int4 NULL  ;

COMMENT ON COLUMN "users"."progress"."watched"  IS NULL;

ALTER TABLE IF EXISTS "users"."progress" ADD COLUMN IF NOT EXISTS "watched_at" timestamp NULL  ;

COMMENT ON COLUMN "users"."progress"."watched_at"  IS NULL;

--- END ALTER TABLE "users"."progress" ---
-- +goose Down
