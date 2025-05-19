-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-05-19T07:02:14.058Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 976;

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-05-19T07:02:15.495Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 976;
