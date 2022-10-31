-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-31T10:54:16.996Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."devices" ---

DELETE FROM "users"."devices";

ALTER TABLE IF EXISTS "users"."devices" ADD COLUMN IF NOT EXISTS "languages" varchar array NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "users"."devices"."languages"  IS NULL;

--- END ALTER TABLE "users"."devices" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-31T10:54:18.341Z             ***/
/***********************************************************/

ALTER TABLE "users"."devices" DROP COLUMN "languages";
