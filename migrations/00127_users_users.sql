-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-07T08:35:33.239Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."users" ---

CREATE TABLE IF NOT EXISTS "users"."users" (
	"id" varchar NOT NULL  ,
	"email" varchar NOT NULL  ,
	"display_name" varchar NULL  ,
	"age" int4 NULL  ,
	"church_ids" _int4 NULL  ,
	"active_bcc" bool NULL  ,
	"roles" _varchar NULL  ,
	"age_group" varchar NULL  ,
	CONSTRAINT "users_pk" PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS users_id_uindex ON users.users USING btree (id);

GRANT SELECT ON TABLE "users"."users" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."users" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."users" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."users" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."users" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."users" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."users" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."users"."id"  IS NULL;


COMMENT ON COLUMN "users"."users"."email"  IS NULL;


COMMENT ON COLUMN "users"."users"."display_name"  IS NULL;


COMMENT ON COLUMN "users"."users"."age"  IS NULL;


COMMENT ON COLUMN "users"."users"."church_ids"  IS NULL;


COMMENT ON COLUMN "users"."users"."active_bcc"  IS NULL;


COMMENT ON COLUMN "users"."users"."roles"  IS NULL;


COMMENT ON COLUMN "users"."users"."age_group"  IS NULL;

COMMENT ON CONSTRAINT "users_pk" ON "users"."users" IS NULL;

COMMENT ON INDEX "users"."users_id_uindex"  IS NULL;

COMMENT ON TABLE "users"."users"  IS NULL;

--- END CREATE TABLE "users"."users" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-07T08:35:34.659Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "users"."users" ---

DROP TABLE IF EXISTS "users"."users";

--- END DROP TABLE "users"."users" ---
