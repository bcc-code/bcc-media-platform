-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-15T09:25:21.362Z             ***/
/***********************************************************/

GRANT SELECT ON TABLE "public"."applicationgroups_usergroups_ls" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

-- +goose Down

