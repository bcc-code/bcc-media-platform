-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:30:52.545Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."profiles" ---

ALTER TABLE IF EXISTS "users"."profiles" ADD COLUMN IF NOT EXISTS "applicationgroup_id" uuid NULL  ;

COMMENT ON COLUMN "users"."profiles"."applicationgroup_id"  IS NULL;

ALTER TABLE IF EXISTS "users"."profiles" ADD CONSTRAINT "profiles_applicationgroups_id_fk" FOREIGN KEY (applicationgroup_id) REFERENCES applicationgroups(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "profiles_applicationgroups_id_fk" ON "users"."profiles" IS NULL;

UPDATE "users"."profiles" SET "applicationgroup_id" = (SELECT a.group_id FROM applications a WHERE a.default LIMIT 1);

ALTER TABLE "users"."profiles" ALTER COLUMN "applicationgroup_id" SET NOT NULL;

--- END ALTER TABLE "users"."profiles" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:30:54.271Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."profiles" ---

ALTER TABLE IF EXISTS "users"."profiles" DROP COLUMN IF EXISTS "applicationgroup_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "users"."profiles" DROP CONSTRAINT IF EXISTS "profiles_applicationgroups_id_fk";

--- END ALTER TABLE "users"."profiles" ---
