-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-05T09:22:01.320Z             ***/
/***********************************************************/

--- BEGIN CREATE OR UPDATE SCHEMA users ---

CREATE SCHEMA IF NOT EXISTS users;
ALTER SCHEMA users OWNER TO builder;

COMMENT ON SCHEMA users IS NULL;

--- END CREATE OR UPDATE SCHEMA users ---

--- BEGIN CREATE TABLE "users"."devices" ---

CREATE TABLE IF NOT EXISTS "users"."devices"
(
    "token"      varchar   NOT NULL,
    "profile_id" uuid      NOT NULL,
    "updated_at" timestamp NOT NULL,
    "name"       varchar NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS devices_token_uindex ON users.devices USING btree (token);

CREATE UNIQUE INDEX IF NOT EXISTS devices_updated_at_uindex ON users.devices USING btree (updated_at);

GRANT SELECT ON TABLE "users"."devices" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."devices" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."devices" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."devices" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

GRANT SELECT ON TABLE "users"."devices" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."devices" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."devices" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."devices" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."devices"."token" IS NULL;


COMMENT ON COLUMN "users"."devices"."profile_id" IS NULL;


COMMENT ON COLUMN "users"."devices"."updated_at" IS NULL;

COMMENT ON INDEX "users"."devices_token_uindex" IS NULL;

COMMENT ON INDEX "users"."devices_updated_at_uindex" IS NULL;

COMMENT ON TABLE "users"."devices" IS NULL;

--- END CREATE TABLE "users"."devices" ---

--- BEGIN CREATE TABLE "users"."profiles" ---

CREATE TABLE IF NOT EXISTS "users"."profiles"
(
    "id"      uuid    NOT NULL,
    "user_id" varchar NOT NULL,
    "name"    varchar NOT NULL,
    CONSTRAINT "profiles_pk" PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS profiles_id_uindex ON users.profiles USING btree (id);

GRANT SELECT ON TABLE "users"."profiles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."profiles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."profiles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."profiles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

GRANT SELECT ON TABLE "users"."profiles" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."profiles" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."profiles" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."profiles" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."profiles"."id" IS NULL;


COMMENT ON COLUMN "users"."profiles"."user_id" IS NULL;

COMMENT ON CONSTRAINT "profiles_pk" ON "users"."profiles" IS NULL;

COMMENT ON INDEX "users"."profiles_id_uindex" IS NULL;

COMMENT ON TABLE "users"."profiles" IS NULL;

ALTER TABLE "users"."devices"
    ADD CONSTRAINT "devices_profile_id_fk" FOREIGN KEY (profile_id) REFERENCES users.profiles (id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE "users"."devices"
    ADD CONSTRAINT "devices_pk" PRIMARY KEY (token, profile_id);


COMMENT ON CONSTRAINT "devices_profile_id_fk" ON "users"."devices" IS NULL;


COMMENT ON CONSTRAINT "devices_pk" ON "users"."devices" IS NULL;

--- END CREATE TABLE "users"."profiles" ---
-- +goose Down

DROP TABLE users.devices;

DROP TABLE users.profiles;

DROP SCHEMA users;
