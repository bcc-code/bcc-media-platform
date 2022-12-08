-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-07T10:23:57.864Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."questionalternatives" ---

ALTER TABLE IF EXISTS "public"."questionalternatives" ADD COLUMN IF NOT EXISTS "is_correct" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "public"."questionalternatives"."is_correct"  IS NULL;

--- END ALTER TABLE "public"."questionalternatives" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 817;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (878, 'questionalternatives', 'is_correct', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-07T10:23:59.258Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."questionalternatives" ---

ALTER TABLE IF EXISTS "public"."questionalternatives" DROP COLUMN IF EXISTS "is_correct" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."questionalternatives" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 817;

DELETE FROM "public"."directus_fields" WHERE "id" = 878;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
