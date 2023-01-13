-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-13T15:19:43.529Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "users"."taskanswers" ---

ALTER TABLE IF EXISTS "users"."taskanswers" ADD COLUMN IF NOT EXISTS "locked" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "users"."taskanswers"."locked"  IS NULL;

--- END ALTER TABLE "users"."taskanswers" ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-13T15:19:45.039Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "users"."taskanswers" ---

ALTER TABLE IF EXISTS "users"."taskanswers" DROP COLUMN IF EXISTS "locked" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."taskanswers" ---
