-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-23T08:53:35.251Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{title}}' WHERE "collection" = 'tasks';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "translations" = '[{"language":"en-US","translation":"Production date in title"}]', "note" = 'Should the episode production date be visible in title' WHERE "id" = 689;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-23T08:53:36.668Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{type}}' WHERE "collection" = 'tasks';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "translations" = NULL, "note" = 'Should the episode publish date be visible in title' WHERE "id" = 689;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
