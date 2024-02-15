-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-15T10:55:48.810Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."applicationgroups_usergroups_ls_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" OWNER TO bccm;
GRANT SELECT ON SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" ---

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
