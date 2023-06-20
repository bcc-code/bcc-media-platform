-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-20T09:23:34.583Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."usergroups" ---

ALTER TABLE IF EXISTS "public"."usergroups" ADD COLUMN IF NOT EXISTS "explicitly_available" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "public"."usergroups"."explicitly_available"  IS NULL;

--- END ALTER TABLE "public"."usergroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 326;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 327;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 328;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 329;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 324;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 323;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1246, 'usergroups', 'explicitly_available', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 2, 'full', NULL, 'Can be explicitly specified by clients to be used as a public role.', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 322;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-20T09:23:36.260Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."usergroups" ---

ALTER TABLE IF EXISTS "public"."usergroups" DROP COLUMN IF EXISTS "explicitly_available" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."usergroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 324;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 326;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 327;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 328;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 329;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 323;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 322;

DELETE FROM "public"."directus_fields" WHERE "id" = 1246;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
