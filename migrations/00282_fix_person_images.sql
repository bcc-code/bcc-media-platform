-- +goose Up
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-04-26T13:41:55.377Z                 ***/
/***************************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3033, 'persons', 'images', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 3026;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 3027;

DELETE FROM "public"."directus_fields" WHERE "id" = 3028;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-04-26T13:41:57.930Z                 ***/
/***************************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 3026;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 3027;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3028, 'persons', 'images', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 3033;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
