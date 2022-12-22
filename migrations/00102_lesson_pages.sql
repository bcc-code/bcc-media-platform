-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-22T08:50:18.244Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"limit":200}' WHERE "id" = 831;

UPDATE "public"."directus_fields" SET "options" = '{"limit":200}' WHERE "id" = 847;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-22T08:50:19.614Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 831;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 847;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
