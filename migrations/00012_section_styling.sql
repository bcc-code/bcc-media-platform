-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-29T14:24:20.873Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "size" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."sections"."size"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "grid_size" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."sections"."grid_size"  IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 236;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 246;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"}]}', "sort" = 1, "width" = 'half', "group" = 'styling' WHERE "id" = 405;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (535, 'sections', 'styling', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (533, 'sections', 'size', NULL, 'select-dropdown', '{"choices":[{"text":"Small","value":"small"},{"text":"Medium","value":"medium"}]}', NULL, NULL, false, false, 2, 'half', NULL, NULL, '[{"name":"Hide if grid","rule":{"_and":[{"style":{"_eq":"grid"}}]},"hidden":true,"options":{"allowOther":false,"allowNone":false}}]', false, 'styling', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (534, 'sections', 'grid_size', NULL, 'select-dropdown', '{"choices":[{"text":"Half","value":"half"}]}', 'labels', NULL, false, true, 3, 'half', NULL, NULL, '[{"name":"Show if grid","rule":{"_and":[{"style":{"_eq":"grid"}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}}]', false, 'styling', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-29T14:24:22.040Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "size" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "grid_size" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 246;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 236;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Slider","value":"carousel"},{"text":"Cards","value":"cards"}]}', "sort" = 3, "width" = 'full', "group" = 'configuration' WHERE "id" = 405;

DELETE FROM "public"."directus_fields" WHERE "id" = 535;

DELETE FROM "public"."directus_fields" WHERE "id" = 533;

DELETE FROM "public"."directus_fields" WHERE "id" = 534;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
