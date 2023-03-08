-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-06T09:40:55.877Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 692;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 690;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 506;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 504;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 507;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 508;

UPDATE "public"."directus_fields" SET "hidden" = false, "width" = 'half' WHERE "id" = 503;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 505;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 517;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 509;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 514;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 515;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 516;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 510;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1094, 'applications', 'uuid', 'uuid', NULL, NULL, NULL, NULL, true, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-06T09:40:57.415Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = true, "width" = 'full' WHERE "id" = 503;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 504;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 505;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 506;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 507;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 508;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 509;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 514;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 515;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 516;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 517;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 510;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 690;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 692;

DELETE FROM "public"."directus_fields" WHERE "id" = 1094;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
