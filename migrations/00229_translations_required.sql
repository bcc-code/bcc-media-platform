-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-01T09:10:07.090Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."playlists" ---

ALTER TABLE IF EXISTS "public"."playlists" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."playlists"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."playlists" ---

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."episodes"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."sections"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."seasons"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN ALTER TABLE "public"."pages" ---

ALTER TABLE IF EXISTS "public"."pages" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."pages"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."pages" ---

--- BEGIN ALTER TABLE "public"."games" ---

ALTER TABLE IF EXISTS "public"."games" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."games"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."games" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" ADD COLUMN IF NOT EXISTS "translations_required" bool NULL DEFAULT true ;

COMMENT ON COLUMN "public"."shows"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 149;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "hidden" = true, "sort" = 16, "group" = NULL WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 2, "group" = 'configuration' WHERE "id" = 140;

UPDATE "public"."directus_fields" SET "hidden" = false, "width" = 'half' WHERE "id" = 242;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'availability' WHERE "id" = 215;

UPDATE "public"."directus_fields" SET "sort" = 16, "group" = NULL WHERE "id" = 224;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 202;

UPDATE "public"."directus_fields" SET "hidden" = false, "width" = 'half' WHERE "id" = 1351;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 194;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 145;

UPDATE "public"."directus_fields" SET "hidden" = true, "sort" = 15, "group" = NULL WHERE "id" = 210;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'availability' WHERE "id" = 272;

UPDATE "public"."directus_fields" SET "hidden" = true, "sort" = 15, "group" = NULL WHERE "id" = 267;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1357;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1358;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1359;

UPDATE "public"."directus_fields" SET "sort" = 11, "width" = 'half' WHERE "id" = 1360;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1371;

UPDATE "public"."directus_fields" SET "readonly" = true, "sort" = 13 WHERE "id" = 1365;

UPDATE "public"."directus_fields" SET "sort" = 16, "group" = NULL WHERE "id" = 281;

UPDATE "public"."directus_fields" SET "sort" = 2, "group" = 'details' WHERE "id" = 277;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 274;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1352;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 198;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1378, 'episodes', 'configuration', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 403;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 400;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 245;

UPDATE "public"."directus_fields" SET "sort" = 2, "group" = 'related' WHERE "id" = 566;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1380, 'episodes', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 208;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'configuration' WHERE "id" = 128;

UPDATE "public"."directus_fields" SET "hidden" = true, "sort" = 14 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 571;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1381, 'playlists', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2, "width" = 'half', "group" = 'metadata' WHERE "id" = 563;

UPDATE "public"."directus_fields" SET "sort" = 5, "group" = 'metadata' WHERE "id" = 613;

UPDATE "public"."directus_fields" SET "sort" = 5, "width" = 'half', "group" = 'metadata' WHERE "id" = 564;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 247;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 551;

UPDATE "public"."directus_fields" SET "sort" = 17, "group" = NULL WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'half', "group" = 'configuration' WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 5, "width" = 'half', "group" = 'configuration' WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "sort" = 6, "group" = 'configuration' WHERE "id" = 612;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 675;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1382, 'games', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 536;

UPDATE "public"."directus_fields" SET "sort" = 3, "width" = 'half' WHERE "id" = 698;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 220;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 688;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 191;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1383, 'seasons', 'details', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 700;

UPDATE "public"."directus_fields" SET "sort" = 4, "group" = 'metadata' WHERE "id" = 689;

UPDATE "public"."directus_fields" SET "sort" = 2, "group" = 'details' WHERE "id" = 221;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 699;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 260;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1384, 'seasons', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'details', NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 784;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 786;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 783;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 782;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1385, 'shows', 'details', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 785;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 141;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1386, 'shows', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1387, 'sections', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1042;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1388, 'pages', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1200;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1201;

UPDATE "public"."directus_fields" SET "sort" = 5, "width" = 'half' WHERE "id" = 1217;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'metadata' WHERE "id" = 1189;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'half' WHERE "id" = 1206;

UPDATE "public"."directus_fields" SET "sort" = 1, "group" = 'configuration' WHERE "id" = 146;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1316;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1330;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1314;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-01T09:10:08.908Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN ALTER TABLE "public"."pages" ---

ALTER TABLE IF EXISTS "public"."pages" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."pages" ---

--- BEGIN ALTER TABLE "public"."games" ---

ALTER TABLE IF EXISTS "public"."games" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."games" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."shows" ---

--- BEGIN ALTER TABLE "public"."playlists" ---

ALTER TABLE IF EXISTS "public"."playlists" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."playlists" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = false, "sort" = 10, "group" = 'metadata' WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 149;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 120;

UPDATE "public"."directus_fields" SET "sort" = 4, "group" = 'metadata' WHERE "id" = 140;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 145;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 194;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'availability' WHERE "id" = 224;

UPDATE "public"."directus_fields" SET "hidden" = true, "width" = 'full' WHERE "id" = 242;

UPDATE "public"."directus_fields" SET "hidden" = false, "sort" = 3, "group" = 'metadata' WHERE "id" = 210;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 202;

UPDATE "public"."directus_fields" SET "sort" = 4, "group" = 'metadata' WHERE "id" = 215;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'availability' WHERE "id" = 281;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "hidden" = false, "sort" = 3, "group" = 'metadata' WHERE "id" = 267;

UPDATE "public"."directus_fields" SET "sort" = 2, "group" = 'metadata' WHERE "id" = 272;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 274;

UPDATE "public"."directus_fields" SET "sort" = 4, "group" = NULL WHERE "id" = 277;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 198;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 400;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 403;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 571;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 208;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "sort" = 5, "group" = 'metadata' WHERE "id" = 128;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 245;

UPDATE "public"."directus_fields" SET "sort" = 17, "group" = NULL WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "hidden" = false, "sort" = 19 WHERE "id" = 276;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 247;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 551;

UPDATE "public"."directus_fields" SET "sort" = 9, "width" = 'full', "group" = 'metadata' WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 14, "group" = NULL WHERE "id" = 613;

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'full', "group" = 'related' WHERE "id" = 563;

UPDATE "public"."directus_fields" SET "sort" = 12, "group" = 'metadata' WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 7, "group" = 'metadata' WHERE "id" = 612;

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'full', "group" = 'related' WHERE "id" = 564;

UPDATE "public"."directus_fields" SET "sort" = 13, "width" = 'full', "group" = 'metadata' WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 675;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 536;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 688;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 191;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 10, "group" = NULL WHERE "id" = 221;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'full' WHERE "id" = 698;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 260;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 700;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 699;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 220;

UPDATE "public"."directus_fields" SET "sort" = 13, "group" = NULL WHERE "id" = 689;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 786;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 782;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 785;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 784;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 783;

UPDATE "public"."directus_fields" SET "readonly" = false, "sort" = 11 WHERE "id" = 1365;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 141;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1042;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 1371;

UPDATE "public"."directus_fields" SET "sort" = 16, "group" = NULL WHERE "id" = 1189;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1201;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1200;

UPDATE "public"."directus_fields" SET "sort" = 3, "width" = 'full' WHERE "id" = 1206;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'full' WHERE "id" = 1217;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1358;

UPDATE "public"."directus_fields" SET "sort" = 10, "width" = 'full' WHERE "id" = 1360;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1357;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1359;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'metadata' WHERE "id" = 146;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1314;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 1316;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 1330;

UPDATE "public"."directus_fields" SET "hidden" = true, "width" = 'full' WHERE "id" = 1351;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 1352;

DELETE FROM "public"."directus_fields" WHERE "id" = 1378;

DELETE FROM "public"."directus_fields" WHERE "id" = 1380;

DELETE FROM "public"."directus_fields" WHERE "id" = 1381;

DELETE FROM "public"."directus_fields" WHERE "id" = 1382;

DELETE FROM "public"."directus_fields" WHERE "id" = 1383;

DELETE FROM "public"."directus_fields" WHERE "id" = 1384;

DELETE FROM "public"."directus_fields" WHERE "id" = 1385;

DELETE FROM "public"."directus_fields" WHERE "id" = 1386;

DELETE FROM "public"."directus_fields" WHERE "id" = 1387;

DELETE FROM "public"."directus_fields" WHERE "id" = 1388;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
