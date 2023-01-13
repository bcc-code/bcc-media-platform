-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-13T10:25:31.017Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links" ADD COLUMN IF NOT EXISTS "label" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."links"."label"  IS NULL;

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."computeddata" ---

ALTER TABLE IF EXISTS "public"."computeddata" ADD COLUMN IF NOT EXISTS "label" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."computeddata"."label"  IS NULL;

--- END ALTER TABLE "public"."computeddata" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"crop":false,"folder":null}' WHERE "id" = 210;

UPDATE "public"."directus_fields" SET "options" = '{"crop":false,"folder":null}' WHERE "id" = 267;

UPDATE "public"."directus_fields" SET "options" = '{"enableLink":true}' WHERE "id" = 563;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 644;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1035;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1038, 'computeddata', 'label', NULL, 'input', '{"iconLeft":"label","placeholder":"For admin"}', NULL, NULL, false, false, 2, 'full', NULL, 'This is only for internal admin use', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1039, 'links', 'label', NULL, 'input', '{"placeholder":"Internal only","iconLeft":"label"}', NULL, NULL, false, false, 1, 'full', NULL, 'Only used in admin', NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-13T10:25:32.581Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links" DROP COLUMN IF EXISTS "label" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."computeddata" ---

ALTER TABLE IF EXISTS "public"."computeddata" DROP COLUMN IF EXISTS "label" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."computeddata" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"crop":false,"folder":"00000000-0000-0000-0000-000000000000"}' WHERE "id" = 210;

UPDATE "public"."directus_fields" SET "options" = '{"crop":false,"folder":"00000000-0000-0000-0000-000000000000"}' WHERE "id" = 267;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 563;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 644;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1035;

DELETE FROM "public"."directus_fields" WHERE "id" = 1038;

DELETE FROM "public"."directus_fields" WHERE "id" = 1039;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
