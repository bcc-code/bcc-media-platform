-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-13T12:47:55.602Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "competition_mode" bool NULL DEFAULT false ;

COMMENT ON COLUMN "public"."tasks"."competition_mode"  IS NULL;

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN ALTER TABLE "users"."taskanswers" ---

ALTER TABLE IF EXISTS "users"."taskanswers" ADD COLUMN IF NOT EXISTS "selected_alternatives" _uuid NULL DEFAULT '{}'::uuid[] ;

COMMENT ON COLUMN "users"."taskanswers"."selected_alternatives"  IS NULL;

--- END ALTER TABLE "users"."taskanswers" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 855;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 894;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 895;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1040, 'tasks', 'competition_mode', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, true, 15, 'full', NULL, 'When this is "true": You don''t get to see if you answered correctly. You can not chnage the answer.', '[{"name":"visible if alternatives","rule":{"_and":[{"_and":[{"question_type":{"_eq":"alternatives"}},{"type":{"_eq":"question"}}]}]},"options":{"iconOn":"check_box","iconOff":"check_box_outline_blank","label":"Enabled"},"hidden":false}]', false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-13T12:47:57.148Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "competition_mode" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN ALTER TABLE "users"."taskanswers" ---

ALTER TABLE IF EXISTS "users"."taskanswers" DROP COLUMN IF EXISTS "selected_alternatives" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "users"."taskanswers" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 855;

UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 894;

UPDATE "public"."directus_fields" SET "sort" = 20 WHERE "id" = 895;

DELETE FROM "public"."directus_fields" WHERE "id" = 1040;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
