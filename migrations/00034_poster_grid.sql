-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-24T12:17:40.291Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Posters","value":"posters"},{"text":"Grid","value":"grid"},{"text":"Poster Grid","value":"poster_grid"},{"text":"Icons","value":"icons"},{"text":"Labels","value":"labels"}]}' WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-24T12:17:41.618Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Icons","value":"icons"},{"text":"Labels","value":"labels"}]}' WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
