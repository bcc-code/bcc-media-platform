-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-02T10:43:26.481Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 210;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 267;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-02T10:43:27.797Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 210;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 267;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
