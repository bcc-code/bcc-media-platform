-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-07T10:07:52.322Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections" ADD COLUMN IF NOT EXISTS "number_in_titles" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "public"."collections"."number_in_titles"  IS NULL;

--- END ALTER TABLE "public"."collections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 19 WHERE "collection" = 'achievements_translations';

UPDATE "public"."directus_collections" SET "sort" = 20 WHERE "collection" = 'achievementgroups_translations';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'studytopics_translations';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'messagetemplates_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 389;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1245, 'collections', 'number_in_titles', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 3, 'half', NULL, 'Should items viewed in context of this collection be prefixed with numbers?', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 388;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 85;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-07T10:07:54.061Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections" DROP COLUMN IF EXISTS "number_in_titles" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."collections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 21 WHERE "collection" = 'achievements_translations';

UPDATE "public"."directus_collections" SET "sort" = 22 WHERE "collection" = 'achievementgroups_translations';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'studytopics_translations';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'messagetemplates_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 85;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 388;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 389;

DELETE FROM "public"."directus_fields" WHERE "id" = 1245;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
