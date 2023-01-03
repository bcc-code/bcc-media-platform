-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-14T13:27:24.867Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."achievements.sql" ---

CREATE TABLE IF NOT EXISTS "users"."achievements" (
	"profile_id" uuid NOT NULL  ,
	"achievement_id" uuid NOT NULL  ,
	"achieved_at" timestamp NOT NULL  ,
	"condition_ids" uuid[] ,
	CONSTRAINT "achievements_pk" PRIMARY KEY (profile_id, achievement_id) ,
	CONSTRAINT "achievements_profiles_id_fk" FOREIGN KEY (profile_id) REFERENCES users.profiles(id) ON DELETE CASCADE ,
    CONSTRAINT "achievements_achievements_id_fk" FOREIGN KEY (achievement_id) REFERENCES public.achievements(id) ON DELETE cascade
);

GRANT SELECT ON TABLE "users"."achievements" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."achievements" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."achievements" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."achievements" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."achievements" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."achievements" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."achievements" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."achievements"."profile_id"  IS NULL;


COMMENT ON COLUMN "users"."achievements"."achievement_id"  IS NULL;


COMMENT ON COLUMN "users"."achievements"."achieved_at"  IS NULL;

COMMENT ON CONSTRAINT "achievements_pk" ON "users"."achievements" IS NULL;


COMMENT ON CONSTRAINT "achievements_profiles_id_fk" ON "users"."achievements" IS NULL;

COMMENT ON TABLE "users"."achievements"  IS NULL;

--- END CREATE TABLE "users"."achievements.sql" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-14T13:27:26.313Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "users"."achievements.sql" ---

DROP TABLE IF EXISTS "users"."achievements";

--- END DROP TABLE "users"."achievements.sql" ---
