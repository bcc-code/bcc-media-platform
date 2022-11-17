-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-09T12:36:01.010Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 390;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 392;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 391;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 385;

UPDATE "public"."directus_fields" SET "options" = '{"limit":100,"fields":["type","page_id.translations","show_id.translations","season_id.translations","episode_id.translations","link_id.translations"],"enableLink":true,"enableSearchFilter":true,"template":null}', "hidden" = false, "sort" = 7, "conditions" = '[{"name":"Hidden if not Select","rule":{"_and":[{"filter_type":{"_neq":"select"}}]},"hidden":true,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 684;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-09T12:36:02.330Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 385;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 390;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 391;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 392;

UPDATE "public"."directus_fields" SET "options" = '{"limit":100}', "hidden" = true, "sort" = 5, "conditions" = '[{"name":"Shown if Select","rule":{"_and":[{"filter_type":{"_eq":"select"}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 684;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
