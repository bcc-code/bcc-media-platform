-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-01T10:59:43.754Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 121;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 122;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 215;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 204;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 205;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 272;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker', "display" = 'raw' WHERE "id" = 422;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 412;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 434;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 436;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 743;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-01T10:59:45.191Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 139;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 121;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 204;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 205;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 215;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 272;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 412;

UPDATE "public"."directus_fields" SET "interface" = 'datetime', "display" = 'datetime' WHERE "id" = 422;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 434;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 436;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 743;

UPDATE "public"."directus_fields" SET "interface" = 'datetime' WHERE "id" = 122;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
