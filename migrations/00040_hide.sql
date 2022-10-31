-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-10-29T15:13:05.312Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"HideInDraft","rule":{"_and":[{"status":{"_eq":"draft"}}]},"hidden":true,"options":{}}]' WHERE "id" = 468;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-10-29T15:13:06.595Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "conditions" = NULL WHERE "id" = 468;
