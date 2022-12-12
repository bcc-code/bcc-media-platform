-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-12T09:52:34.759Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"iconLeft":"description","softLength":1024}' WHERE "id" = 156;

UPDATE "public"."directus_fields" SET "options" = '{"iconLeft":"description","softLength":1024}' WHERE "id" = 225;

UPDATE "public"."directus_fields" SET "options" = '{"iconLeft":"description","softLength":1024}' WHERE "id" = 282;

UPDATE "public"."directus_fields" SET "options" = '{"softLength":1024}' WHERE "id" = 406;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-12T09:52:36.083Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"iconLeft":"description"}' WHERE "id" = 156;

UPDATE "public"."directus_fields" SET "options" = '{"iconLeft":"description","placeholder":null}' WHERE "id" = 225;

UPDATE "public"."directus_fields" SET "options" = '{"iconLeft":"description"}' WHERE "id" = 282;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 406;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
