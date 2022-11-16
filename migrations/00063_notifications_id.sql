-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T10:22:36.018Z             ***/
/***********************************************************/

--- BEGIN ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."notificationtemplates_translations_id_seq" FROM directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."notificationtemplates_translations_id_seq" FROM directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."notificationtemplates_translations_id_seq" FROM directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates" ---

REVOKE SELECT ON TABLE "public"."notificationtemplates" FROM directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE INSERT ON TABLE "public"."notificationtemplates" FROM directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."notificationtemplates" FROM directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."notificationtemplates" ---

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_pkey";

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_user_created_foreign";

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_user_updated_foreign";

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_template_id_foreign";

DELETE FROM "public"."notifications";

ALTER TABLE IF EXISTS "public"."notifications"
    DROP COLUMN id;

ALTER TABLE IF EXISTS "public"."notifications"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ADD COLUMN "id" uuid;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_pk" PRIMARY KEY (id);

COMMENT ON CONSTRAINT "notifications_pk" ON "public"."notifications" IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id);

COMMENT ON CONSTRAINT "notifications_user_created_foreign" ON "public"."notifications" IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id);

COMMENT ON CONSTRAINT "notifications_user_updated_foreign" ON "public"."notifications" IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_template_id_foreign" FOREIGN KEY (template_id) REFERENCES notificationtemplates(id);

COMMENT ON CONSTRAINT "notifications_template_id_foreign" ON "public"."notifications" IS NULL;

CREATE UNIQUE INDEX notifications_id_uindex ON public.notifications USING btree (id);

COMMENT ON INDEX "public"."notifications_id_uindex"  IS NULL;

--- END ALTER TABLE "public"."notifications" ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T10:22:37.343Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."notifications_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."notifications_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."notifications_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."notifications_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."notifications_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."notifications_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."notifications_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."notifications_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."notifications_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."notifications_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."notifications_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."notifications_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."notifications_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."notifications_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."notificationtemplates_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."notificationtemplates_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."notificationtemplates_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_pk";

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_user_created_foreign";

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_user_updated_foreign";

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_template_id_foreign";

DROP INDEX IF EXISTS notifications_id_uindex;

DELETE FROM notifications;

ALTER TABLE "public"."notifications"
    DROP COLUMN id;

ALTER TABLE IF EXISTS "public"."notifications"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ADD COLUMN "id" int4 DEFAULT nextval('notifications_id_seq'::regclass);

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_pkey" PRIMARY KEY (id);

COMMENT ON CONSTRAINT "notifications_pkey" ON "public"."notifications" IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id);

COMMENT ON CONSTRAINT "notifications_user_created_foreign" ON "public"."notifications" IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id);

COMMENT ON CONSTRAINT "notifications_user_updated_foreign" ON "public"."notifications" IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_template_id_foreign" FOREIGN KEY (template_id) REFERENCES notificationtemplates(id);

COMMENT ON CONSTRAINT "notifications_template_id_foreign" ON "public"."notifications" IS NULL;

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates" ---

GRANT SELECT ON TABLE "public"."notificationtemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notificationtemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notificationtemplates" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."notificationtemplates" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

GRANT SELECT ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."notificationtemplates_translations" ---
