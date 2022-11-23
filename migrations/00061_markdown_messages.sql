-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T10:49:54.422Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "interface" = 'input-rich-text-md' WHERE "id" = 463;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T10:49:55.801Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "interface" = 'input-rich-text-html' WHERE "id" = 463;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
