-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T15:07:20.775Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."achievements" ---

ALTER TABLE IF EXISTS "public"."achievements" ADD COLUMN IF NOT EXISTS "sort" int4 NULL  ;

COMMENT ON COLUMN "public"."achievements"."sort"  IS NULL;

ALTER TABLE IF EXISTS "public"."achievements" DROP CONSTRAINT IF EXISTS "achievements_group_id_foreign";

ALTER TABLE IF EXISTS "public"."achievements" ADD CONSTRAINT "achievements_group_id_foreign" FOREIGN KEY (group_id) REFERENCES achievementgroups(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievements_group_id_foreign" ON "public"."achievements" IS NULL;

--- END ALTER TABLE "public"."achievements" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1037, 'achievements', 'sort', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "options" = '{"limit":100}' WHERE "id" = 933;

UPDATE "public"."directus_fields" SET "options" = '{"enableSelect":false}' WHERE "id" = 1031;

UPDATE "public"."directus_relations" SET "sort_field" = 'sort' WHERE "id" = 285;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T15:07:22.414Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."achievements" ---

ALTER TABLE IF EXISTS "public"."achievements" DROP COLUMN IF EXISTS "sort" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."achievements" DROP CONSTRAINT IF EXISTS "achievements_group_id_foreign";

ALTER TABLE IF EXISTS "public"."achievements" ADD CONSTRAINT "achievements_group_id_foreign" FOREIGN KEY (group_id) REFERENCES achievementgroups(id);

COMMENT ON CONSTRAINT "achievements_group_id_foreign" ON "public"."achievements" IS NULL;

--- END ALTER TABLE "public"."achievements" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 933;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 1031;

DELETE FROM "public"."directus_fields" WHERE "id" = 1037;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
