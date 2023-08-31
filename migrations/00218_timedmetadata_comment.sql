-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-31T07:35:15.594Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "note" = 'Can be used in "title" with for example: {{song.title}}' WHERE "id" = 1308;

UPDATE "public"."directus_fields" SET "note" = 'Can be used in "title" with for example: {{person.name}}' WHERE "id" = 1312;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-31T07:35:17.524Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "note" = NULL WHERE "id" = 1308;

UPDATE "public"."directus_fields" SET "note" = NULL WHERE "id" = 1312;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
