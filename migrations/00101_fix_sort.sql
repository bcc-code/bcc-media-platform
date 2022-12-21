-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-21T13:10:39.981Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "sort_field" = 'sort' WHERE "id" = 255;

UPDATE "public"."directus_relations" SET "sort_field" = 'sort' WHERE "id" = 250;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
