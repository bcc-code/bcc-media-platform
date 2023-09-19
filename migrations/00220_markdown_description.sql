-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-19T12:14:18.811Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1330, 'episodes', 'timedmetadata_tools', 'alias,no-data', 'timedmetadata-tools', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, false, 'timedmetadata_details', NULL, NULL);

UPDATE "public"."directus_fields" SET "interface" = 'input-rich-text-md', "options" = '{"iconLeft":"description","softLength":1024,"toolbar":["heading","bold","italic","strikethrough","blockquote","empty","link"]}' WHERE "id" = 156;

UPDATE "public"."directus_fields" SET "interface" = 'input-rich-text-md', "options" = '{"iconLeft":"description","softLength":1024,"toolbar":["heading","bold","italic","strikethrough","blockquote","empty","link"]}', "sort" = 4 WHERE "id" = 225;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 228;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 232;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 229;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 230;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 231;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 226;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 227;

UPDATE "public"."directus_fields" SET "interface" = 'input-rich-text-md', "options" = '{"iconLeft":"description","softLength":1024,"toolbar":["heading","bold","italic","strikethrough","blockquote","empty","link"]}' WHERE "id" = 282;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1298;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-19T12:14:20.963Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "interface" = 'input', "options" = '{"iconLeft":"description","softLength":1024}' WHERE "id" = 156;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 226;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 227;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 228;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 229;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 230;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 231;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 232;

UPDATE "public"."directus_fields" SET "interface" = 'input', "options" = '{"iconLeft":"description","softLength":1024}', "sort" = NULL WHERE "id" = 225;

UPDATE "public"."directus_fields" SET "interface" = 'input', "options" = '{"iconLeft":"description","softLength":1024}' WHERE "id" = 282;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1298;

DELETE FROM "public"."directus_fields" WHERE "id" = 1330;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
