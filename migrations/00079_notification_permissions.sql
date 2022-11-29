-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-29T06:43:01.196Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

GRANT INSERT ON TABLE "public"."notificationtemplates_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."notificationtemplates_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-29T06:43:02.803Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

REVOKE INSERT ON TABLE "public"."notificationtemplates_translations" FROM directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."notificationtemplates_translations" ---
