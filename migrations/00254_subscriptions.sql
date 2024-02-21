-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-16T10:22:47.623Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."subscriptions" ---

CREATE TABLE IF NOT EXISTS "users"."subscriptions" (
	"key" varchar NOT NULL  ,
	"profile_id" uuid NOT NULL  ,
	CONSTRAINT "subscriptions_pk" PRIMARY KEY (key, profile_id) ,
	CONSTRAINT "subscriptions_profiles_id_fk" FOREIGN KEY (profile_id) REFERENCES users.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE
);

GRANT SELECT ON TABLE "users"."subscriptions" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."subscriptions" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."subscriptions" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."subscriptions" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."subscriptions" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."subscriptions" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."subscriptions" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."subscriptions"."key"  IS NULL;


COMMENT ON COLUMN "users"."subscriptions"."profile_id"  IS NULL;

COMMENT ON CONSTRAINT "subscriptions_pk" ON "users"."subscriptions" IS NULL;


COMMENT ON CONSTRAINT "subscriptions_profiles_id_fk" ON "users"."subscriptions" IS NULL;

COMMENT ON TABLE "users"."subscriptions"  IS NULL;

--- END CREATE TABLE "users"."subscriptions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "display_options" = '{"template":"{{label}}"}' WHERE "id" = 1421;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{label}}' WHERE "collection" = 'mediaitems';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-16T10:22:49.262Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "users"."subscriptions" ---

DROP TABLE IF EXISTS "users"."subscriptions";

--- END DROP TABLE "users"."subscriptions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = NULL WHERE "collection" = 'mediaitems';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "display_options" = NULL WHERE "id" = 1421;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
