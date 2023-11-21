-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-21T08:38:56.997Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."media_progress" ---

CREATE TABLE IF NOT EXISTS "users"."media_progress" (
	"profile_id" uuid NOT NULL  ,
	"item_id" uuid NOT NULL  ,
	"progress" float4 NOT NULL  ,
	"duration" float4 NOT NULL  ,
	"watched" int4 NOT NULL  ,
	"updated_at" timestamp NOT NULL  ,
	"context" json NULL  ,
	"watched_at" timestamp NULL  ,
	CONSTRAINT "media_progress_pk" PRIMARY KEY (profile_id, item_id) ,
	CONSTRAINT "media_progress_profiles_id_fk" FOREIGN KEY (profile_id) REFERENCES users.profiles(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "users"."media_progress" TO api, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."media_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."media_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."media_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."media_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."media_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."media_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."media_progress"."profile_id"  IS NULL;


COMMENT ON COLUMN "users"."media_progress"."item_id"  IS NULL;


COMMENT ON COLUMN "users"."media_progress"."progress"  IS NULL;


COMMENT ON COLUMN "users"."media_progress"."duration"  IS NULL;


COMMENT ON COLUMN "users"."media_progress"."watched"  IS NULL;


COMMENT ON COLUMN "users"."media_progress"."updated_at"  IS NULL;


COMMENT ON COLUMN "users"."media_progress"."context"  IS NULL;


COMMENT ON COLUMN "users"."media_progress"."watched_at"  IS NULL;

COMMENT ON CONSTRAINT "media_progress_pk" ON "users"."media_progress" IS NULL;


COMMENT ON CONSTRAINT "media_progress_profiles_id_fk" ON "users"."media_progress" IS NULL;

COMMENT ON TABLE "users"."media_progress"  IS NULL;

--- END CREATE TABLE "users"."media_progress" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-21T08:38:58.600Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "users"."media_progress" ---

DROP TABLE IF EXISTS "users"."media_progress";

--- END DROP TABLE "users"."media_progress" ---
