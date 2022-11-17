-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-10T09:55:58.715Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 641;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 561;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 558;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 557;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 559;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 625;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (691, 'images', 'link', 'alias,no-data,group', 'group-detail', '{"start":"closed"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 562;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 560;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-10T09:55:59.988Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 641;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 558;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 559;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 625;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 557;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 561;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 560;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 562;

DELETE FROM "public"."directus_fields" WHERE "id" = 691;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
