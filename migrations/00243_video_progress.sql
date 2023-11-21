-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-21T08:38:56.997Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."video_progress" ---

CREATE TABLE IF NOT EXISTS "users"."video_progress" (
	"profile_id" uuid NOT NULL  ,
	"item_id" uuid NOT NULL  ,
	"progress" float4 NOT NULL  ,
	"duration" float4 NOT NULL  ,
	"watched" int4 NOT NULL  ,
	"updated_at" timestamp NOT NULL  ,
	"context" json NULL  ,
	"watched_at" timestamp NULL  ,
	CONSTRAINT "video_progress_pk" PRIMARY KEY (profile_id, item_id) ,
	CONSTRAINT "video_progress_profiles_id_fk" FOREIGN KEY (profile_id) REFERENCES users.profiles(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "users"."video_progress" TO api, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."video_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."video_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."video_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."video_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."video_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."video_progress" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."video_progress"."profile_id"  IS NULL;


COMMENT ON COLUMN "users"."video_progress"."item_id"  IS NULL;


COMMENT ON COLUMN "users"."video_progress"."progress"  IS NULL;


COMMENT ON COLUMN "users"."video_progress"."duration"  IS NULL;


COMMENT ON COLUMN "users"."video_progress"."watched"  IS NULL;


COMMENT ON COLUMN "users"."video_progress"."updated_at"  IS NULL;


COMMENT ON COLUMN "users"."video_progress"."context"  IS NULL;


COMMENT ON COLUMN "users"."video_progress"."watched_at"  IS NULL;

COMMENT ON CONSTRAINT "video_progress_pk" ON "users"."video_progress" IS NULL;


COMMENT ON CONSTRAINT "video_progress_profiles_id_fk" ON "users"."video_progress" IS NULL;

COMMENT ON TABLE "users"."video_progress"  IS NULL;

--- END CREATE TABLE "users"."video_progress" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-21T08:38:58.600Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "users"."video_progress" ---

DROP TABLE IF EXISTS "users"."video_progress";

--- END DROP TABLE "users"."video_progress" ---
