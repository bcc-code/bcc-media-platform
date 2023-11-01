-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-01T09:21:19.544Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons" ADD COLUMN IF NOT EXISTS "translations_required" bool NULL  ;

COMMENT ON COLUMN "public"."lessons"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."links"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."notificationtemplates"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."notificationtemplates" ---

--- BEGIN ALTER TABLE "public"."studytopics" ---

ALTER TABLE IF EXISTS "public"."studytopics" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."studytopics"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."studytopics" ---

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."tasks"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN ALTER TABLE "public"."achievementgroups" ---

ALTER TABLE IF EXISTS "public"."achievementgroups" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."achievementgroups"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."achievementgroups" ---

--- BEGIN ALTER TABLE "public"."surveys" ---

ALTER TABLE IF EXISTS "public"."surveys" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."surveys"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."surveys" ---

--- BEGIN ALTER TABLE "public"."faqs" ---

ALTER TABLE IF EXISTS "public"."faqs" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."faqs"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."faqs" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1390, 'lessons', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1391, 'tasks', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 10, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1394, 'faqs', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 11, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1392, 'links', 'translations_required', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1393, 'notificationtemplates', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1395, 'achievementgroups', 'translations_required', 'cast-boolean', NULL, NULL, NULL, NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1396, 'surveys', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 638;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 639;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 636;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 637;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 644;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 635;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 642;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 749;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 750;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 752;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 751;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 753;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 754;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 755;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 761;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 840;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 823;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 806;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 854;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 859;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 839;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 831;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 855;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 830;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 847;

UPDATE "public"."directus_fields" SET "sort" = 21 WHERE "id" = 894;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 850;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 872;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 822;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 879;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 900;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 807;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 818;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 898;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 930;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 993;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 999;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 992;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 995;

UPDATE "public"."directus_fields" SET "sort" = 22 WHERE "id" = 895;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1077;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 1040;

UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 891;

UPDATE "public"."directus_fields" SET "sort" = 20 WHERE "id" = 887;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1076;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1066;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1068;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1168;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1142;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1035;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1208;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1389, 'studytopics', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-01T09:21:21.332Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."notificationtemplates" ---

--- BEGIN ALTER TABLE "public"."studytopics" ---

ALTER TABLE IF EXISTS "public"."studytopics" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."studytopics" ---

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN ALTER TABLE "public"."achievementgroups" ---

ALTER TABLE IF EXISTS "public"."achievementgroups" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."achievementgroups" ---

--- BEGIN ALTER TABLE "public"."surveys" ---

ALTER TABLE IF EXISTS "public"."surveys" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."surveys" ---

--- BEGIN ALTER TABLE "public"."faqs" ---

ALTER TABLE IF EXISTS "public"."faqs" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."faqs" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 636;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 638;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 637;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 639;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 644;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 642;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 635;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 755;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 749;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 750;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 752;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 753;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 754;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 761;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 751;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 830;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 840;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 854;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 823;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 806;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 839;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 859;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 855;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 831;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 822;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 872;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 850;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 847;

UPDATE "public"."directus_fields" SET "sort" = 20 WHERE "id" = 894;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 879;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 818;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 900;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 807;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 930;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 898;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 999;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 992;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 993;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 995;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 1040;

UPDATE "public"."directus_fields" SET "sort" = 21 WHERE "id" = 895;

UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 887;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1076;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1077;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1066;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 891;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1068;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1142;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 1168;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1208;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1035;

DELETE FROM "public"."directus_fields" WHERE "id" = 1390;

DELETE FROM "public"."directus_fields" WHERE "id" = 1391;

DELETE FROM "public"."directus_fields" WHERE "id" = 1394;

DELETE FROM "public"."directus_fields" WHERE "id" = 1392;

DELETE FROM "public"."directus_fields" WHERE "id" = 1393;

DELETE FROM "public"."directus_fields" WHERE "id" = 1395;

DELETE FROM "public"."directus_fields" WHERE "id" = 1396;

DELETE FROM "public"."directus_fields" WHERE "id" = 1389;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
