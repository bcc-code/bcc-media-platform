-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-07T06:19:04.190Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Page","value":"page"},{"text":"Show","value":"show"},{"text":"Episode","value":"episode"}]}' WHERE "id" = 346;

UPDATE "public"."directus_fields" SET "hidden" = true, "conditions" = '[{"name":"Show if Item","rule":{"_and":[{"type":{"_eq":"item"}}]},"hidden":false,"options":{"enableCreate":true,"enableSelect":true}}]' WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"}]}' WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-07T06:19:05.302Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Page","value":"page"},{"text":"Show","value":"show"},{"text":"Season","value":"season"},{"text":"Episode","value":"episode"}]}' WHERE "id" = 346;

UPDATE "public"."directus_fields" SET "hidden" = false, "conditions" = NULL WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Labels","value":"labels"}]}' WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
