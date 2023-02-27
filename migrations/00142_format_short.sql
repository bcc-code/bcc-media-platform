-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-24T07:13:35.776Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "display_options" = '{"format":"short"}' WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "display_options" = '{"format":"short"}' WHERE "id" = 215;

UPDATE "public"."directus_fields" SET "display_options" = '{"format":"short"}' WHERE "id" = 272;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-24T07:13:37.373Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "display_options" = NULL WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "display_options" = NULL WHERE "id" = 215;

UPDATE "public"."directus_fields" SET "display_options" = NULL WHERE "id" = 272;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
