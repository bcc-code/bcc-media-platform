-- +goose Up
/*************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreas.gangso@bcc.no) ***/
/***    CREATED ON: 2022-09-22T10:27:15.337Z               ***/
/*************************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "hidden" = false WHERE "collection" = 'calendar';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
-- +goose Down
/*************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreas.gangso@bcc.no) ***/
/***    CREATED ON: 2022-09-22T10:27:16.540Z               ***/
/*************************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "hidden" = true WHERE "collection" = 'calendar';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
