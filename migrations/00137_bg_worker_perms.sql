-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-15T11:05:25.167Z             ***/
/***********************************************************/

GRANT SELECT ON TABLE "users"."users" TO background_worker;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-15T11:05:26.821Z             ***/
/***********************************************************/

SELECT 1;

