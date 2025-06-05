-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-06-02T07:48:43.153Z            ***/
/**********************************************************/


ALTER TABLE IF EXISTS "public"."applicationgroups" ADD COLUMN IF NOT EXISTS "only_content_in_preferred_languages" bool NOT NULL DEFAULT false;

CREATE SEQUENCE IF NOT EXISTS "public"."applicationgroups_languages_id_seq" START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE TABLE IF NOT EXISTS "public"."applicationgroups_languages" (
	"id" int4 NOT NULL DEFAULT nextval('applicationgroups_languages_id_seq'::regclass) ,
	"applicationgroups_id" uuid NULL  ,
	"languages_code" varchar(255) NULL  ,
	CONSTRAINT "applicationgroups_languages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "applicationgroups_languages_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "applicationgroups_languages_applicationgroups_id_foreign" FOREIGN KEY (applicationgroups_id) REFERENCES applicationgroups(id) ON DELETE CASCADE
);

ALTER SEQUENCE "public"."applicationgroups_languages_id_seq" OWNED BY "public"."applicationgroups_languages"."id";

CREATE SEQUENCE IF NOT EXISTS "public"."applicationgroups_languages_subs_id_seq" START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE TABLE IF NOT EXISTS "public"."applicationgroups_languages_subs" (
	"id" int4 NOT NULL DEFAULT nextval('applicationgroups_languages_subs_id_seq'::regclass) ,
	"applicationgroups_id" uuid NULL  ,
	"languages_code" varchar(255) NULL  ,
	CONSTRAINT "applicationgroups_languages_subs_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "applicationgroups_languages_subs_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "applicationgroups_languages_subs_applicati__4eac5f88_foreign" FOREIGN KEY (applicationgroups_id) REFERENCES applicationgroups(id) ON DELETE CASCADE
);

ALTER SEQUENCE "public"."applicationgroups_languages_subs_id_seq" OWNED BY "public"."applicationgroups_languages_subs"."id";

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3060, 'applicationgroups', 'only_content_in_preferred_languages', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3062, 'applicationgroups_default_preferred_audio_languages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3063, 'applicationgroups_default_preferred_audio_languages', 'applicationgroups_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3064, 'applicationgroups_default_preferred_audio_languages', 'item', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3065, 'applicationgroups_default_preferred_audio_languages', 'collection', NULL, NULL, NULL, NULL, NULL, false, true, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3072, 'applicationgroups_default_preferred_subtitle_languages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3073, 'applicationgroups_default_preferred_subtitle_languages', 'applicationgroups_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3074, 'applicationgroups_default_preferred_subtitle_languages', 'item', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3075, 'applicationgroups_default_preferred_subtitle_languages', 'collection', NULL, NULL, NULL, NULL, NULL, false, true, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3076, 'applicationgroups', 'default_prefered_audio_languages', 'm2m', 'list-m2m', '{"enableCreate":false,"filter":{"_and":[{"code":{"_nempty":true}}]}}', NULL, NULL, false, false, 13, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3077, 'applicationgroups_languages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3078, 'applicationgroups_languages', 'applicationgroups_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3081, 'applicationgroups_languages_subs', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3082, 'applicationgroups_languages_subs', 'applicationgroups_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3083, 'applicationgroups_languages_subs', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3080, 'applicationgroups', 'default_preferred_subtitle_languages', 'm2m', 'list-m2m', '{"enableCreate":false,"filter":{"_and":[{"code":{"_nempty":true}}]}}', NULL, NULL, false, false, 14, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('applicationgroups_default_preferred_audio_languages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);
INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('applicationgroups_default_preferred_subtitle_languages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);
INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('applicationgroups_languages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);
INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('applicationgroups_languages_subs', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);
INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (457, 'applicationgroups_default_preferred_audio_languages', 'item', NULL, NULL, 'collection', 'languages', 'applicationgroups_id', NULL, 'nullify');
INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (477, 'applicationgroups_default_preferred_subtitle_languages', 'item', NULL, NULL, 'collection', 'languages', 'applicationgroups_id', NULL, 'nullify');
INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (478, 'applicationgroups_default_preferred_subtitle_languages', 'applicationgroups_id', 'applicationgroups', NULL, NULL, NULL, 'item', NULL, 'delete');
INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (458, 'applicationgroups_default_preferred_audio_languages', 'applicationgroups_id', 'applicationgroups', NULL, NULL, NULL, 'item', NULL, 'delete');
INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (479, 'applicationgroups_languages', 'languages_code', 'languages', NULL, NULL, NULL, 'applicationgroups_id', NULL, 'nullify');
INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (480, 'applicationgroups_languages', 'applicationgroups_id', 'applicationgroups', 'default_prefered_audio_languages', NULL, NULL, 'languages_code', NULL, 'delete');
INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (481, 'applicationgroups_languages_subs', 'languages_code', 'languages', NULL, NULL, NULL, 'applicationgroups_id', NULL, 'nullify');
INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (482, 'applicationgroups_languages_subs', 'applicationgroups_id', 'applicationgroups', 'default_preferred_subtitle_languages', NULL, NULL, 'languages_code', NULL, 'delete');

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true) FROM "public"."directus_relations";

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-06-02T07:48:44.288Z            ***/
/**********************************************************/

-- Drop the column added to applicationgroups
ALTER TABLE IF EXISTS "public"."applicationgroups" DROP COLUMN IF EXISTS "only_content_in_preferred_languages";

-- Drop the junction tables and their sequences created in the up migration
DROP TABLE IF EXISTS "public"."applicationgroups_languages_subs" CASCADE;
DROP TABLE IF EXISTS "public"."applicationgroups_languages" CASCADE;
DROP SEQUENCE IF EXISTS "public"."applicationgroups_languages_subs_id_seq";
DROP SEQUENCE IF EXISTS "public"."applicationgroups_languages_id_seq";

-- Clean up Directus collections
DELETE FROM "public"."directus_collections" WHERE "collection" = 'applicationgroups_default_preferred_audio_languages';
DELETE FROM "public"."directus_collections" WHERE "collection" = 'applicationgroups_default_preferred_subtitle_languages';
DELETE FROM "public"."directus_collections" WHERE "collection" = 'applicationgroups_languages';
DELETE FROM "public"."directus_collections" WHERE "collection" = 'applicationgroups_languages_subs';

-- Clean up Directus fields (only those that exist in the up migration)
DELETE FROM "public"."directus_fields" WHERE "id" IN (
    3060, 3062, 3063, 3064, 3065, 3072, 3073, 3074, 3075, 3076, 3077, 3078, 3080, 3081, 3082, 3083
);

-- Clean up Directus relations (only those that exist in the up migration)
DELETE FROM "public"."directus_relations" WHERE "id" IN (
    457, 458, 477, 478, 479, 480, 481, 482
);
