-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-17T13:18:13.345Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "users"."messages" ---

ALTER TABLE IF EXISTS "users"."messages" ADD COLUMN IF NOT EXISTS "age_group" text NULL  ;

COMMENT ON COLUMN "users"."messages"."age_group"  IS NULL;

ALTER TABLE IF EXISTS "users"."messages" ADD COLUMN IF NOT EXISTS "org_id" int4 NULL  ;

COMMENT ON COLUMN "users"."messages"."org_id"  IS NULL;

--- END ALTER TABLE "users"."messages" ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-17T13:18:14.899Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "users"."messages" ---

ALTER TABLE IF EXISTS "users"."messages" DROP COLUMN IF EXISTS "age_group" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "users"."messages" DROP COLUMN IF EXISTS "org_id" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."messages" ---
