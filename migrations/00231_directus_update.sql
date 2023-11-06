-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-06T12:12:14.463Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."directus_versions" ---

CREATE TABLE IF NOT EXISTS "public"."directus_versions" (
	"id" uuid NOT NULL  ,
	"key" varchar(64) NOT NULL  ,
	"name" varchar(255) NULL  ,
	"collection" varchar(64) NOT NULL  ,
	"item" varchar(255) NOT NULL  ,
	"hash" varchar(255) NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "directus_versions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_versions_collection_foreign" FOREIGN KEY (collection) REFERENCES directus_collections(collection) ON DELETE CASCADE ,
	CONSTRAINT "directus_versions_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL ,
	CONSTRAINT "directus_versions_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."directus_versions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."directus_versions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."directus_versions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."directus_versions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."directus_versions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."directus_versions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."directus_versions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."directus_versions"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."key"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."item"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."hash"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_versions"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "directus_versions_pkey" ON "public"."directus_versions" IS NULL;


COMMENT ON CONSTRAINT "directus_versions_collection_foreign" ON "public"."directus_versions" IS NULL;


COMMENT ON CONSTRAINT "directus_versions_user_created_foreign" ON "public"."directus_versions" IS NULL;


COMMENT ON CONSTRAINT "directus_versions_user_updated_foreign" ON "public"."directus_versions" IS NULL;

COMMENT ON TABLE "public"."directus_versions"  IS NULL;

--- END CREATE TABLE "public"."directus_versions" ---

--- BEGIN CREATE TABLE "public"."directus_extensions" ---

CREATE TABLE IF NOT EXISTS "public"."directus_extensions" (
	"name" varchar(255) NOT NULL  ,
	"enabled" bool NOT NULL DEFAULT true ,
	CONSTRAINT "directus_extensions_pkey" PRIMARY KEY (name)
);

GRANT SELECT ON TABLE "public"."directus_extensions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."directus_extensions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."directus_extensions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."directus_extensions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."directus_extensions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."directus_extensions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."directus_extensions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."directus_extensions"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_extensions"."enabled"  IS NULL;

COMMENT ON CONSTRAINT "directus_extensions_pkey" ON "public"."directus_extensions" IS NULL;

COMMENT ON TABLE "public"."directus_extensions"  IS NULL;

--- END CREATE TABLE "public"."directus_extensions" ---

--- BEGIN ALTER TABLE "public"."directus_collections" ---

ALTER TABLE IF EXISTS "public"."directus_collections" ADD COLUMN IF NOT EXISTS "versioning" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "public"."directus_collections"."versioning"  IS NULL;

--- END ALTER TABLE "public"."directus_collections" ---

--- BEGIN ALTER TABLE "public"."directus_revisions" ---

ALTER TABLE IF EXISTS "public"."directus_revisions" ADD COLUMN IF NOT EXISTS "version" uuid NULL  ;

COMMENT ON COLUMN "public"."directus_revisions"."version"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_revisions" ADD CONSTRAINT "directus_revisions_version_foreign" FOREIGN KEY (version) REFERENCES directus_versions(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "directus_revisions_version_foreign" ON "public"."directus_revisions" IS NULL;

--- END ALTER TABLE "public"."directus_revisions" ---

--- BEGIN ALTER TABLE "public"."directus_users" ---

ALTER TABLE IF EXISTS "public"."directus_users" ADD COLUMN IF NOT EXISTS "appearance" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_users"."appearance"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_users" ADD COLUMN IF NOT EXISTS "theme_dark" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_users"."theme_dark"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_users" ADD COLUMN IF NOT EXISTS "theme_light" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_users"."theme_light"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_users" ADD COLUMN IF NOT EXISTS "theme_light_overrides" json NULL  ;

COMMENT ON COLUMN "public"."directus_users"."theme_light_overrides"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_users" ADD COLUMN IF NOT EXISTS "theme_dark_overrides" json NULL  ;

COMMENT ON COLUMN "public"."directus_users"."theme_dark_overrides"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_users" DROP COLUMN IF EXISTS "theme" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_users" ---

--- BEGIN ALTER TABLE "public"."directus_settings" ---

ALTER TABLE IF EXISTS "public"."directus_settings"
	ALTER COLUMN "project_color" SET NOT NULL,
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "project_color" SET DATA TYPE varchar(255) USING "project_color"::varchar(255),
	ALTER COLUMN "project_color" SET DEFAULT '#6644FF'::character varying;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "public_favicon" uuid NULL  ;

COMMENT ON COLUMN "public"."directus_settings"."public_favicon"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "default_appearance" varchar(255) NOT NULL DEFAULT 'auto'::character varying ;

COMMENT ON COLUMN "public"."directus_settings"."default_appearance"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "default_theme_light" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_settings"."default_theme_light"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "theme_light_overrides" json NULL  ;

COMMENT ON COLUMN "public"."directus_settings"."theme_light_overrides"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "default_theme_dark" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_settings"."default_theme_dark"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "theme_dark_overrides" json NULL  ;

COMMENT ON COLUMN "public"."directus_settings"."theme_dark_overrides"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD CONSTRAINT "directus_settings_public_favicon_foreign" FOREIGN KEY (public_favicon) REFERENCES directus_files(id);

COMMENT ON CONSTRAINT "directus_settings_public_favicon_foreign" ON "public"."directus_settings" IS NULL;

--- END ALTER TABLE "public"."directus_settings" ---

--- BEGIN ALTER TABLE "public"."directus_shares" ---

ALTER TABLE IF EXISTS "public"."directus_shares" DROP CONSTRAINT IF EXISTS "directus_shares_collection_foreign";

ALTER TABLE IF EXISTS "public"."directus_shares"
	ALTER COLUMN "collection" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."directus_shares"
	ALTER COLUMN "item" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."directus_shares" ADD CONSTRAINT "directus_shares_collection_foreign" FOREIGN KEY (collection) REFERENCES directus_collections(collection) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "directus_shares_collection_foreign" ON "public"."directus_shares" IS NULL;

--- END ALTER TABLE "public"."directus_shares" ---

--- BEGIN ALTER TABLE "public"."playlists" ---

ALTER TABLE IF EXISTS "public"."playlists" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."playlists"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."playlists" ---

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons" ADD COLUMN IF NOT EXISTS "translations_required" bool NULL  ;

COMMENT ON COLUMN "public"."lessons"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."episodes"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "translations_required" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."sections"."translations_required"  IS NULL;

--- END ALTER TABLE "public"."sections" ---

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

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1390, 'lessons', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

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

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1391, 'tasks', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 10, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1394, 'faqs', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 11, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1392, 'links', 'translations_required', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1393, 'notificationtemplates', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1352;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 198;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1395, 'achievementgroups', 'translations_required', 'cast-boolean', NULL, NULL, NULL, NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1396, 'surveys', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

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

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 638;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1381, 'playlists', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 639;

UPDATE "public"."directus_fields" SET "sort" = 2, "width" = 'half', "group" = 'metadata' WHERE "id" = 563;

UPDATE "public"."directus_fields" SET "sort" = 5, "group" = 'metadata' WHERE "id" = 613;

UPDATE "public"."directus_fields" SET "sort" = 5, "width" = 'half', "group" = 'metadata' WHERE "id" = 564;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 247;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 551;

UPDATE "public"."directus_fields" SET "sort" = 17, "group" = NULL WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'half', "group" = 'configuration' WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 5, "width" = 'half', "group" = 'configuration' WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 636;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 637;

UPDATE "public"."directus_fields" SET "sort" = 6, "group" = 'configuration' WHERE "id" = 612;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 675;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1382, 'games', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 536;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 644;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 635;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 642;

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

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 749;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1384, 'seasons', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'details', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 750;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 752;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 751;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 753;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 754;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 755;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 761;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 784;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 840;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 823;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 786;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 806;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 854;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 859;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 783;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 782;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1385, 'shows', 'details', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 785;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 839;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 831;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 855;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 830;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 141;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 847;

UPDATE "public"."directus_fields" SET "sort" = 21 WHERE "id" = 894;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1386, 'shows', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'details', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 850;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 872;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 822;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 879;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 900;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1387, 'sections', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

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

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1042;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1076;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1066;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1388, 'pages', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1068;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1168;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1142;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1200;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1201;

UPDATE "public"."directus_fields" SET "sort" = 5, "width" = 'half' WHERE "id" = 1217;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1035;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1208;

UPDATE "public"."directus_fields" SET "sort" = 3, "group" = 'metadata' WHERE "id" = 1189;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'half' WHERE "id" = 1206;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1389, 'studytopics', 'translations_required', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 1, "group" = 'configuration' WHERE "id" = 146;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1316;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1330;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1314;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'shows';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'assetfiles';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'assets';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'assetstreams';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'seasons';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'episodes';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'collections';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'playlists';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'playlists_styledimages';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'playlists_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'playlists_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'pages';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'tags';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'episodes_usergroups_download';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'lists';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'ageratings';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'messagetemplates';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'categories';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'sections';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'pages_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'episodes_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'episodes_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'shows_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'seasons_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'sections_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'episodes_tags';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'calendarentries';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'sections_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'collections_items';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'events';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'studies';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'messages_messagetemplates';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'links';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'computeddatagroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'seasons_tags';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'shows_tags';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'lessons';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'achievementconditions';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'collections_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'studytopics';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'applications';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'computeddata';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'achievements';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'achievementgroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'achievements_images';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'targets';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'events_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'categories_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'calendarentries_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'tags_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'episodes_usergroups_earlyaccess';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'studytopics_images';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'links_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'notificationtemplates';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'lessons_images';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'tasks';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'questionalternatives';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'messages';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'computeddata_conditions';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'collections_entries';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'languages';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'surveyquestions';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'messagetemplates_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'faqcategories';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'faqs';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'studytopics_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'lessons_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'tasks_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'games_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'timedmetadata_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'surveyquestions_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'surveys_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'faqs_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'prompts_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'faqcategories_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'questionalternatives_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'surveys';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'applicationgroups_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'faqs_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'targets_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'achievements_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'games_usergroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'games';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'achievementgroups_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'computeddata_group';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'notifications_group';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'faqs_group';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'applications_group';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'applicationgroups';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'usergroups_relations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'redirects';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'achievementconditions_studytopics';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'lessons_relations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'tasks_images';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'timedmetadata';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'notifications_targets';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'games_styledimages';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'prompts';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'prompts_targets';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'images';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'styledimages';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'achievements_group';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'songs_group';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'persons';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'phrases';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'messages_group';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'songs';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'songcollections';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'songcollections_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'phrases_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'songs_translations';

UPDATE "public"."directus_collections" SET "versioning" = false WHERE "collection" = 'timedmetadata_persons';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20230721A', 'Require Shares Fields', '2023-11-06T12:11:28.941Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20230823A', 'Add Content Versioning', '2023-11-06T12:11:28.970Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20230927A', 'Themes', '2023-11-06T12:11:28.985Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20231009A', 'Update CSV Fields to Text', '2023-11-06T12:11:28.989Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20231009B', 'Update Panel Options', '2023-11-06T12:11:28.991Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20231010A', 'Add Extensions', '2023-11-06T12:11:28.996Z');

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-06T12:12:16.291Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."directus_collections" ---

ALTER TABLE IF EXISTS "public"."directus_collections" DROP COLUMN IF EXISTS "versioning" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_collections" ---

--- BEGIN ALTER TABLE "public"."directus_revisions" ---

ALTER TABLE IF EXISTS "public"."directus_revisions" DROP COLUMN IF EXISTS "version" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_revisions" DROP CONSTRAINT IF EXISTS "directus_revisions_version_foreign";

--- END ALTER TABLE "public"."directus_revisions" ---

--- BEGIN ALTER TABLE "public"."directus_settings" ---

ALTER TABLE IF EXISTS "public"."directus_settings"
	ALTER COLUMN "project_color" DROP NOT NULL,
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "project_color" SET DATA TYPE varchar(50) USING "project_color"::varchar(50),
	ALTER COLUMN "project_color" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "public_favicon" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "default_appearance" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "default_theme_light" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "theme_light_overrides" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "default_theme_dark" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "theme_dark_overrides" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP CONSTRAINT IF EXISTS "directus_settings_public_favicon_foreign";

--- END ALTER TABLE "public"."directus_settings" ---

--- BEGIN ALTER TABLE "public"."directus_shares" ---

ALTER TABLE IF EXISTS "public"."directus_shares" DROP CONSTRAINT IF EXISTS "directus_shares_collection_foreign";

ALTER TABLE IF EXISTS "public"."directus_shares"
	ALTER COLUMN "collection" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."directus_shares"
	ALTER COLUMN "item" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."directus_shares" ADD CONSTRAINT "directus_shares_collection_foreign" FOREIGN KEY (collection) REFERENCES directus_collections(collection) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "directus_shares_collection_foreign" ON "public"."directus_shares" IS NULL;

--- END ALTER TABLE "public"."directus_shares" ---

--- BEGIN ALTER TABLE "public"."directus_users" ---

ALTER TABLE IF EXISTS "public"."directus_users" ADD COLUMN IF NOT EXISTS "theme" varchar(20) NULL DEFAULT 'auto'::character varying ;

COMMENT ON COLUMN "public"."directus_users"."theme"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_users" DROP COLUMN IF EXISTS "appearance" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_users" DROP COLUMN IF EXISTS "theme_dark" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_users" DROP COLUMN IF EXISTS "theme_light" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_users" DROP COLUMN IF EXISTS "theme_light_overrides" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_users" DROP COLUMN IF EXISTS "theme_dark_overrides" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_users" ---

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."episodes" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "translations_required" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

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

--- BEGIN DROP TABLE "public"."directus_versions" ---

DROP TABLE IF EXISTS "public"."directus_versions";

--- END DROP TABLE "public"."directus_versions" ---

--- BEGIN DROP TABLE "public"."directus_extensions" ---

DROP TABLE IF EXISTS "public"."directus_extensions";

--- END DROP TABLE "public"."directus_extensions" ---

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

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 636;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 638;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 637;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 639;

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'full', "group" = 'related' WHERE "id" = 564;

UPDATE "public"."directus_fields" SET "sort" = 13, "width" = 'full', "group" = 'metadata' WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 675;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 644;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 642;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 635;

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

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 755;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 749;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 750;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 752;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 753;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 754;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 761;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 751;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 786;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 782;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 830;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 840;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 854;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 823;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 806;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 839;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 785;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 859;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 855;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 784;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 831;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 783;

UPDATE "public"."directus_fields" SET "readonly" = false, "sort" = 11 WHERE "id" = 1365;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 822;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 872;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 141;

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

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1042;

UPDATE "public"."directus_fields" SET "sort" = 21 WHERE "id" = 895;

UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 887;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1076;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1077;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1066;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 891;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 1371;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1068;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1142;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 1168;

UPDATE "public"."directus_fields" SET "sort" = 16, "group" = NULL WHERE "id" = 1189;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1201;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1200;

UPDATE "public"."directus_fields" SET "sort" = 3, "width" = 'full' WHERE "id" = 1206;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1208;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'full' WHERE "id" = 1217;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1035;

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

DELETE FROM "public"."directus_fields" WHERE "id" = 1390;

DELETE FROM "public"."directus_fields" WHERE "id" = 1391;

DELETE FROM "public"."directus_fields" WHERE "id" = 1394;

DELETE FROM "public"."directus_fields" WHERE "id" = 1392;

DELETE FROM "public"."directus_fields" WHERE "id" = 1393;

DELETE FROM "public"."directus_fields" WHERE "id" = 1395;

DELETE FROM "public"."directus_fields" WHERE "id" = 1396;

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

DELETE FROM "public"."directus_fields" WHERE "id" = 1389;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

DELETE FROM "public"."directus_migrations" WHERE "version" = '20230721A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20230823A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20230927A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20231009A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20231009B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20231010A';

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---
