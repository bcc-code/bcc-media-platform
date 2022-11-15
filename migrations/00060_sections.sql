-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-15T13:44:47.163Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "options" = '{"limit":100}' WHERE "id" = 409;

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'half' WHERE "id" = 705;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 85;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-15T13:44:48.498Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 85;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 409;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'full' WHERE "id" = 705;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
