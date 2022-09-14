-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-13T07:35:08.529Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."directus_activity" ---

ALTER TABLE IF EXISTS "public"."directus_activity" ADD COLUMN IF NOT EXISTS "origin" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_activity"."origin"  IS NULL;

--- END ALTER TABLE "public"."directus_activity" ---

--- BEGIN ALTER TABLE "public"."directus_sessions" ---

ALTER TABLE IF EXISTS "public"."directus_sessions" ADD COLUMN IF NOT EXISTS "origin" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_sessions"."origin"  IS NULL;

--- END ALTER TABLE "public"."directus_sessions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220826A', 'Add Origin to Accountability', '2022-09-13T07:33:18.348Z');

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-13T07:35:09.526Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."directus_activity" ---

ALTER TABLE IF EXISTS "public"."directus_activity" DROP COLUMN IF EXISTS "origin" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_activity" ---

--- BEGIN ALTER TABLE "public"."directus_sessions" ---

ALTER TABLE IF EXISTS "public"."directus_sessions" DROP COLUMN IF EXISTS "origin" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_sessions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220826A';

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---
