-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-07T07:48:59.906Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."taskanswers" ---

CREATE TABLE IF NOT EXISTS "users"."taskanswers" (
	"profile_id" uuid NOT NULL  ,
	"task_id" uuid NOT NULL  ,
	"answer" text NULL  ,
	"updated_at" timestamp NULL  ,
	CONSTRAINT "taskanswers_pk" PRIMARY KEY (profile_id, task_id) ,
	CONSTRAINT "taskanswers_profiles_id_fk" FOREIGN KEY (profile_id) REFERENCES users.profiles(id) ,
	CONSTRAINT "taskanswers_tasks_id_fk" FOREIGN KEY (task_id) REFERENCES tasks(id)
);

ALTER TABLE IF EXISTS "users"."taskanswers" OWNER TO builder;

GRANT SELECT ON TABLE "users"."taskanswers" TO api, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."taskanswers" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."taskanswers" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."taskanswers" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."taskanswers" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."taskanswers" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."taskanswers" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."taskanswers"."profile_id"  IS NULL;


COMMENT ON COLUMN "users"."taskanswers"."task_id"  IS NULL;


COMMENT ON COLUMN "users"."taskanswers"."answer"  IS NULL;


COMMENT ON COLUMN "users"."taskanswers"."updated_at"  IS NULL;

COMMENT ON CONSTRAINT "taskanswers_pk" ON "users"."taskanswers" IS NULL;


COMMENT ON CONSTRAINT "taskanswers_profiles_id_fk" ON "users"."taskanswers" IS NULL;


COMMENT ON CONSTRAINT "taskanswers_tasks_id_fk" ON "users"."taskanswers" IS NULL;

COMMENT ON TABLE "users"."taskanswers"  IS NULL;

--- END CREATE TABLE "users"."taskanswers" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-07T07:49:01.435Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "users"."taskanswers" ---

DROP TABLE IF EXISTS "users"."taskanswers";

--- END DROP TABLE "users"."taskanswers" ---
