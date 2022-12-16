-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-14T07:34:53.964Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Default","value":"default"},{"text":"Featured","value":"featured"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Poster Grid","value":"poster_grid"},{"text":"List","value":"list"},{"text":"Icons","value":"icons"},{"text":"Icon Grid","value":"icon_grid"},{"text":"Labels","value":"labels"},{"text":"Cards","value":"cards"},{"text":"Card List","value":"card_list"}]}' WHERE "id" = 405;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if needed","rule":{"_and":[{"style":{"_in":["featured","default","posters","cards"]}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}},{"name":"more opts for cards","rule":{"_and":[{"style":{"_in":["cards","card_list"]}}]},"options":{"allowOther":false,"allowNone":false,"choices":[{"text":"Large","value":"large"},{"text":"Mini","value":"mini"}]},"hidden":false}]' WHERE "id" = 533;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-14T07:34:55.316Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if needed","rule":{"_and":[{"style":{"_in":["featured","default","posters"]}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}}]' WHERE "id" = 533;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Default","value":"default"},{"text":"Featured","value":"featured"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Poster Grid","value":"poster_grid"},{"text":"List","value":"list"},{"text":"Icons","value":"icons"},{"text":"Icon Grid","value":"icon_grid"},{"text":"Labels","value":"labels"}]}' WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
