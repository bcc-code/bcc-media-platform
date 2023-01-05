-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T13:55:14.791Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Equals","value":"=="},{"text":"Less Than","value":"<"},{"text":"Greater Than","value":">"}]}' WHERE "id" = 1033;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T13:55:16.353Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Equals","value":"=="},{"text":"Less Than","value":"<"}]}' WHERE "id" = 1033;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
