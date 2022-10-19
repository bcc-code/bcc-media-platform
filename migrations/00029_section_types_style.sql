-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-19T06:13:41.204Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Icons","value":"icons"},{"text":"Labels","value":"labels"}]}', "required" = true WHERE "id" = 405;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Item","value":"item"}]}', "hidden" = false WHERE "id" = 536;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-19T06:13:42.423Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Item","value":"item"},{"text":"Link","value":"link"}]}', "hidden" = true WHERE "id" = 536;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"}]}', "required" = false WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
