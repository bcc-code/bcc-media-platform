-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-11T10:44:38.738Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{}', "required" = false WHERE "id" = 139;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-11T10:44:40.082Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = NULL, "required" = true WHERE "id" = 139;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
