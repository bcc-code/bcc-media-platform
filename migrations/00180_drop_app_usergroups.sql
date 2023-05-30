-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:18:37.560Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."applications_usergroups" ---

DROP TABLE IF EXISTS "public"."applications_usergroups";

--- END DROP TABLE "public"."applications_usergroups" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:18:39.192Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."applications_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."applications_usergroups" (
	"id" int4 NOT NULL DEFAULT nextval('applications_usergroups_id_seq'::regclass) ,
	"applications_id" int4 NULL  ,
	"usergroups_code" varchar(255) NULL  ,
	CONSTRAINT "applications_usergroups_applications_id_foreign" FOREIGN KEY (applications_id) REFERENCES applications(id) ON DELETE SET NULL ,
	CONSTRAINT "applications_usergroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "applications_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."applications_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."applications_usergroups" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."applications_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."applications_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."applications_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."applications_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."applications_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."applications_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."applications_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."applications_usergroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."applications_usergroups"."applications_id"  IS NULL;


COMMENT ON COLUMN "public"."applications_usergroups"."usergroups_code"  IS NULL;

COMMENT ON CONSTRAINT "applications_usergroups_applications_id_foreign" ON "public"."applications_usergroups" IS NULL;


COMMENT ON CONSTRAINT "applications_usergroups_pkey" ON "public"."applications_usergroups" IS NULL;


COMMENT ON CONSTRAINT "applications_usergroups_usergroups_code_foreign" ON "public"."applications_usergroups" IS NULL;

COMMENT ON TABLE "public"."applications_usergroups"  IS NULL;

--- END CREATE TABLE "public"."applications_usergroups" ---
