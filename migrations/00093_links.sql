-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-09T11:09:17.797Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_allowed_collections" = 'episodes,links' WHERE "id" = 262;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-09T11:09:19.417Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_allowed_collections" = 'episodes' WHERE "id" = 262;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
