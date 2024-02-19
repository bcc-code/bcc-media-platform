-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-19T10:30:02.429Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."redirects" ---

ALTER TABLE IF EXISTS "public"."redirects" ADD COLUMN IF NOT EXISTS "requires_authentication" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "public"."redirects"."requires_authentication"  IS NULL;

--- END ALTER TABLE "public"."redirects" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 617;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 618;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 619;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 620;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 621;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 622;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1457, 'redirects', 'requires_authentication', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 615;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 616;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1125;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-19T10:30:03.929Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."redirects" ---

ALTER TABLE IF EXISTS "public"."redirects" DROP COLUMN IF EXISTS "requires_authentication" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."redirects" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 615;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 616;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 620;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 619;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 617;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 621;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 622;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 618;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 1125;

DELETE FROM "public"."directus_fields" WHERE "id" = 1457;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
