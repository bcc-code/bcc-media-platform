-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-11-17T10:39:12.129Z            ***/
/**********************************************************/

--- BEGIN CREATE TABLE "public"."redirects" ---

CREATE TABLE IF NOT EXISTS "public"."redirects" (
	"id" uuid NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NOT NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NOT NULL  ,
	"date_updated" timestamptz NULL  ,
	"target_url" varchar(255) NOT NULL  ,
	"code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "redirects_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "redirects_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "redirects_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."redirects" OWNER TO builder;

GRANT SELECT ON TABLE "public"."redirects" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT, INSERT, UPDATE, DELETE ON TABLE "public"."redirects" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."redirects"."id"  IS NULL;
COMMENT ON COLUMN "public"."redirects"."status"  IS NULL;
COMMENT ON COLUMN "public"."redirects"."user_created"  IS NULL;
COMMENT ON COLUMN "public"."redirects"."date_created"  IS NULL;
COMMENT ON COLUMN "public"."redirects"."user_updated"  IS NULL;
COMMENT ON COLUMN "public"."redirects"."date_updated"  IS NULL;
COMMENT ON COLUMN "public"."redirects"."target_url"  IS NULL;
COMMENT ON COLUMN "public"."redirects"."code"  IS NULL;
COMMENT ON CONSTRAINT "redirects_pkey" ON "public"."redirects" IS NULL;
COMMENT ON CONSTRAINT "redirects_user_updated_foreign" ON "public"."redirects" IS NULL;
COMMENT ON CONSTRAINT "redirects_user_created_foreign" ON "public"."redirects" IS NULL;
COMMENT ON TABLE "public"."redirects"  IS NULL;

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'shows_usergroups';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('redirects', 'redo', NULL, '{{code}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 9, 'config', 'open');

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'ageratings_translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (615, 'redirects', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (616, 'redirects', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (618, 'redirects', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (620, 'redirects', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (619, 'redirects', 'user_updated', 'user-updated,user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (617, 'redirects', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (621, 'redirects', 'target_url', NULL, 'input', '{"iconLeft":"link","trim":true}', 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (622, 'redirects', 'code', NULL, 'input', '{"iconLeft":"qr_code","softLength":50,"trim":true,"slug":true}', 'raw', '{"prefix":"https://brunstad.tv/r/","border":true,"conditionalFormatting":null}', false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (176, 'redirects', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (177, 'redirects', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-11-17T10:39:13.346Z            ***/
/**********************************************************/

--- BEGIN DROP TABLE "public"."redirects" ---

DROP TABLE IF EXISTS "public"."redirects";

--- END DROP TABLE "public"."redirects" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections" SET "sort" = 18 WHERE "collection" = 'applications_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'redirects';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 615;

DELETE FROM "public"."directus_fields" WHERE "id" = 616;

DELETE FROM "public"."directus_fields" WHERE "id" = 618;

DELETE FROM "public"."directus_fields" WHERE "id" = 620;

DELETE FROM "public"."directus_fields" WHERE "id" = 619;

DELETE FROM "public"."directus_fields" WHERE "id" = 617;

DELETE FROM "public"."directus_fields" WHERE "id" = 621;

DELETE FROM "public"."directus_fields" WHERE "id" = 622;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 176;

DELETE FROM "public"."directus_relations" WHERE "id" = 177;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
