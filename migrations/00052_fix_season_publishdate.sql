-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-11T10:52:50.987Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 215;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-11T10:52:52.282Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 215;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
