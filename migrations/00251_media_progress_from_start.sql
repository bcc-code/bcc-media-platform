-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-15T10:55:48.810Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."media_progress" ---

ALTER TABLE IF EXISTS "users"."media_progress" ADD COLUMN IF NOT EXISTS "from_start" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "users"."media_progress"."from_start"  IS NULL;

--- END ALTER TABLE "users"."media_progress" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-15T10:55:50.475Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."media_progress" ---

ALTER TABLE IF EXISTS "users"."media_progress" DROP COLUMN IF EXISTS "from_start" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."media_progress" ---
