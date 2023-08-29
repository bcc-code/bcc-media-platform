-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-29T12:40:08.474Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 1, "group" = 'details' WHERE "id" = 1238;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'details' WHERE "id" = 1232;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1233;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1239;

UPDATE "public"."directus_fields" SET "sort" = 9, "conditions" = '[]' WHERE "id" = 1235;

UPDATE "public"."directus_fields" SET "sort" = 2, "group" = 'details' WHERE "id" = 1231;

UPDATE "public"."directus_fields" SET "sort" = 4, "note" = 'Can be used as {{title}} and {{description}} in the title and description fields.', "group" = 'details' WHERE "id" = 1295;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1296;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-29T12:40:10.350Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9, "group" = NULL WHERE "id" = 1238;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1233;

UPDATE "public"."directus_fields" SET "sort" = 11, "group" = NULL WHERE "id" = 1232;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1296;

UPDATE "public"."directus_fields" SET "sort" = 12, "note" = 'Use title, description and images from this source.', "group" = NULL WHERE "id" = 1295;

UPDATE "public"."directus_fields" SET "sort" = 10, "group" = NULL WHERE "id" = 1231;

UPDATE "public"."directus_fields" SET "sort" = 13, "conditions" = '[{"name":"Hide if Source is set","rule":{"_and":[{"datasource_id":{"_nnull":true}}]},"hidden":true,"options":{"start":"open"}}]' WHERE "id" = 1235;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 1239;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
