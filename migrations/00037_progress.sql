-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-24T06:38:19.657Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."progress" ---

CREATE TABLE IF NOT EXISTS "users"."progress"
(
    "profile_id" uuid      NOT NULL,
    "episode_id" int4      NOT NULL,
    "progress"   int       NOT NULL,
    "duration"   int       NOT NULL,
    "updated_at" timestamp not null,
    CONSTRAINT "progress_unique_key" PRIMARY KEY (profile_id, episode_id)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "users"."progress" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."progress"."profile_id" IS NULL;

COMMENT ON COLUMN "users"."progress"."episode_id" IS NULL;

COMMENT ON COLUMN "users"."progress"."progress" IS NULL;

COMMENT ON COLUMN "users"."progress"."duration" IS NULL;

COMMENT ON COLUMN "users"."progress"."updated_at" IS NULL;

COMMENT ON CONSTRAINT "progress_unique_key" ON "users"."progress" IS NULL;

COMMENT ON TABLE "users"."progress" IS NULL;

--- END CREATE TABLE "users"."progress" ---
-- +goose Down

DROP TABLE "users"."progress";
