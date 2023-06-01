-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:51:33.347Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."collections" ---

ALTER TABLE IF EXISTS "users"."collections" ADD COLUMN IF NOT EXISTS "applicationgroup_id" uuid NULL  ;

COMMENT ON COLUMN "users"."collections"."applicationgroup_id"  IS NULL;

ALTER TABLE IF EXISTS "users"."collections" ADD CONSTRAINT "collections_applicationgroups_id_fk" FOREIGN KEY (applicationgroup_id) REFERENCES applicationgroups(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "collections_applicationgroups_id_fk" ON "users"."collections" IS NULL;

UPDATE "users"."collections" c SET applicationgroup_id = (SELECT a.group_id FROM applications a WHERE a.uuid = c.application_id);

ALTER TABLE "users"."collections" ALTER COLUMN "applicationgroup_id" SET NOT NULL;

--- END ALTER TABLE "users"."collections" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:51:35.025Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."collections" ---

ALTER TABLE IF EXISTS "users"."collections" DROP COLUMN IF EXISTS "applicationgroup_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "users"."collections" DROP CONSTRAINT IF EXISTS "collections_applicationgroups_id_fk";

--- END ALTER TABLE "users"."collections" ---
