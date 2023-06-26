-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-19T10:03:32.043Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 782;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-19T10:03:33.894Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 782;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
