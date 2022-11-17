-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-08T08:01:29.781Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Default","value":"default"},{"text":"Featured","value":"featured"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Poster Grid","value":"poster_grid"},{"text":"List","value":"list"},{"text":"Icons","value":"icons"},{"text":"Icon Grid","value":"icon_grid"},{"text":"Labels","value":"labels"}]}' WHERE "id" = 405;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if grid","rule":{"_and":[{"style":{"_in":["grid","poster_grid","icon_grid"]}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}}]' WHERE "id" = 534;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-08T08:01:30.945Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if grid","rule":{"_and":[{"style":{"_eq":"grid"}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}}]' WHERE "id" = 534;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Posters","value":"posters"},{"text":"Grid","value":"grid"},{"text":"Poster Grid","value":"poster_grid"},{"text":"Icons","value":"icons"},{"text":"Labels","value":"labels"}]}' WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
