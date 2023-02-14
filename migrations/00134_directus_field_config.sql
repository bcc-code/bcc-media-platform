-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-14T12:54:29.963Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{label}}' WHERE "collection" = 'episodes';

UPDATE "public"."directus_collections" SET "display_template" = '{{label}}' WHERE "collection" = 'shows';

UPDATE "public"."directus_collections" SET "display_template" = '{{label}}' WHERE "collection" = 'seasons';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 223;

UPDATE "public"."directus_fields" SET "hidden" = false, "width" = 'half' WHERE "id" = 209;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 222;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 279;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 277;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 271;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 261;

UPDATE "public"."directus_fields" SET "hidden" = false, "width" = 'half' WHERE "id" = 266;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 206;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 265;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 264;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 207;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 785;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 784;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 700;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1047, 'seasons', 'uuid', 'uuid', NULL, NULL, NULL, NULL, true, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 273;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1048, 'shows', 'uuid', 'uuid', 'input', NULL, 'raw', NULL, true, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 699;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 280;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 275;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 220;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 689;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 214;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 216;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 203;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 221;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 219;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-14T12:54:31.431Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}}' WHERE "collection" = 'shows';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}}' WHERE "collection" = 'episodes';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}}' WHERE "collection" = 'seasons';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = true, "width" = 'full' WHERE "id" = 209;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 222;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 223;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 219;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 203;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 216;

UPDATE "public"."directus_fields" SET "hidden" = true, "width" = 'full' WHERE "id" = 266;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 277;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 279;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 275;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 261;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 271;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 206;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 207;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 265;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 264;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 700;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 699;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 280;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 214;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 220;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 221;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 689;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 784;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 785;

DELETE FROM "public"."directus_fields" WHERE "id" = 1047;

DELETE FROM "public"."directus_fields" WHERE "id" = 1048;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
