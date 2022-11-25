-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-25T09:35:39.695Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"no","userLanguage":true}', "display_options" = '{"languageField":"code","userLanguage":true,"defaultLanguage":"no","template":"{{title}}"}' WHERE "id" = 424;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-25T09:35:41.084Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = NULL, "display_options" = NULL WHERE "id" = 424;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
