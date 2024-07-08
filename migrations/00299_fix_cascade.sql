-- +goose Up
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-07-08T09:11:56.026Z                 ***/
/***************************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 379;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-07-08T09:11:58.339Z                 ***/
/***************************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 379;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
