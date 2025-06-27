-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-06-27T08:12:13.425Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 137;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1378;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1314;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "collection" = 'seasons', "field" = 'tags', "interface" = 'list-m2m' WHERE "id" = '571';

-- +goose Down

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 137;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1314;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1378;

UPDATE "public"."directus_fields" SET "collection" = 'seasons', "field" = 'tags', "interface" = NULL WHERE "id" = '571';
