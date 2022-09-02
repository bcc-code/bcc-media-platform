-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-09-02T11:45:16.840Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."directus_dashboards" ---

ALTER TABLE IF EXISTS "public"."directus_dashboards" ADD COLUMN IF NOT EXISTS "color" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_dashboards"."color"  IS NULL;

--- END ALTER TABLE "public"."directus_dashboards" ---

--- BEGIN ALTER TABLE "public"."materialized_views_meta" ---

ALTER TABLE IF EXISTS "public"."materialized_views_meta" ADD CONSTRAINT "materialized_views_meta_pkey" PRIMARY KEY (view_name);

COMMENT ON CONSTRAINT "materialized_views_meta_pkey" ON "public"."materialized_views_meta" IS NULL;

--- END ALTER TABLE "public"."materialized_views_meta" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "description" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."pages_translations" DROP CONSTRAINT IF EXISTS "pages_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "title" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."pages_translations" ADD CONSTRAINT "pages_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_translations_languages_code_foreign" ON "public"."pages_translations" IS NULL;

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN DROP TABLE "public"."calendarevent" ---

DROP TABLE IF EXISTS "public"."calendarevent";

--- END DROP TABLE "public"."calendarevent" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('FAQ', 'folder', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#6BFFE1', NULL, 5, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faq_categories', 'folder', NULL, '{{translations.title}}', false, false, NULL, 'status', true, 'archived', 'draft', 'sort', 'all', NULL, NULL, 2, 'FAQ', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faq_categories_translations', 'import_export', NULL, '{{title}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'faq_categories', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faqs', 'question_mark', NULL, '{{translations.question}}', false, false, NULL, 'status', true, 'archived', 'draft', 'sort', 'all', NULL, NULL, 1, 'FAQ', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faqs_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'faqs', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faqs_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'faqs', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('ageratings_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 8, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('asset_management', 'folder_copy', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 4, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assetfiles', 'file_present', 'Downloadable videos, subtitles, etc.', '{{storage}}/{{path}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 3, 'asset_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assets', 'snippet_folder', NULL, '{{name}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'asset_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assetstreams', 'stream', NULL, '{{service}}/{{path}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'asset_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assetstreams_audio_languages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 13, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assetstreams_subtitle_languages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 14, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('calendar', 'calendar_month', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#FFC23B', NULL, 3, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('calendarentries', 'edit_calendar', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'calendar', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('calendarentries_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'calendarentries', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('events', 'event', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'calendar', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('events_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'events', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('config', 'settings', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#2ECDA7', NULL, 7, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('ageratings', 'child_care', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 1, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('appconfig', 'app_settings_alt', NULL, NULL, false, true, '[{"language":"en-US","translation":"App","singular":"App","plural":"App"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 3, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('globalconfig', 'cloud_done', NULL, NULL, false, true, '[{"language":"en-US","translation":"Global","singular":"Global","plural":"Global"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('languages', 'language', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 6, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('usergroups', 'groups', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 5, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('webconfig', 'desktop_windows', NULL, NULL, true, true, '[{"language":"en-US","translation":"Web","singular":"Web","plural":"Web"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 4, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_categories', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 11, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('lists_relations', 'import_export', NULL, '{{item:shows.translations}}{{item:episodes.translations}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 12, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('main_content', 'perm_media', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#2ECDA7', NULL, 1, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes', 'slow_motion_video', NULL, '{{season_id.show_id.translations}} - {{translations}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, '["agerating_code","available_from","available_to","description","image","publish_at","season_id","status","title"]', 3, 'main_content', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_tags', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 3, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_usergroups_download', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 4, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_usergroups_earlyaccess', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 5, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('seasons', 'format_list_numbered', NULL, '{{translations}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'main_content', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('seasons_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'seasons', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('shows', 'tv', NULL, '{{id}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'main_content', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('shows_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'shows', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenance_messages', 'warning_amber', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 6, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenancemessage', 'sd_card_alert', NULL, NULL, false, true, '[{"language":"en-US","translation":"Messages","singular":"Messages","plural":"Messages"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'maintenance_messages', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('messagetemplates', 'bookmarks', NULL, '{{translations}}', false, false, '[{"language":"en-US","translation":"Templates","singular":"Template","plural":"Templates"}]', 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'maintenance_messages', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('messagetemplates_translations', 'import_export', NULL, '{{message}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'messagetemplates', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenancemessage_messagetemplates', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 16, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('materialized_views_meta', NULL, NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 15, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('page_management', 'pages', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#FFA439', NULL, 2, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('categories', 'bookmarks', NULL, '{{translations}}', true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 6, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('categories_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'categories', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('collections', 'collections_bookmark', NULL, '{{name}}', false, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, '["content","legacy_order_by","list_id","show_episodes_in_section","show_id","sort","translations"]', 3, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('collections_items', NULL, NULL, '{{page_id.translations}}{{show_id.translations}}{{season_id.translations}}{{episode_id.translations}}', true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 5, 'collections', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('lists', 'format_list_numbered', 'Manually selected and ordered shows/episodes.', '{{name}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 4, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('pages', 'pages', NULL, '{{code}} - {{translations}}', false, false, NULL, 'status', true, 'archived', 'draft', 'sort', 'all', NULL, NULL, 1, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('pages_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'pages', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sections', 'view_list', NULL, '{{id}} - {{translations}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sections_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'sections', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sections_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'sections', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tags', 'label', NULL, '{{name}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 5, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tags_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'tags', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('seasons_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 9, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('shows_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 10, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1, 'faq_categories', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (2, 'faq_categories', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3, 'faq_categories', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (4, 'faq_categories', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (5, 'faq_categories_translations', 'faq_categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (6, 'faq_categories_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (7, 'faq_categories_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (8, 'faq_categories_translations', 'title', NULL, 'input', '{"iconLeft":"category"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (9, 'faqs', 'category', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', 'related-values', '{"template":"{{translations.title}}"}', false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (10, 'faqs', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (11, 'faqs', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (12, 'faqs', 'groups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (13, 'faqs', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (14, 'faqs', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (15, 'faqs', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (16, 'faqs', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{question}}","userLanguage":true}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (17, 'faqs', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (18, 'faqs', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (19, 'faqs_translations', 'answer', NULL, 'input-rich-text-html', '{"placeholder":"This is the answer!","toolbar":["blockquote","bold","bullist","code","customImage","customLink","customMedia","italic","numlist","removeformat","underline"],"trim":true}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (20, 'faqs_translations', 'faqs_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (21, 'faqs_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (22, 'faqs_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (23, 'faqs_translations', 'question', NULL, 'input', '{"iconLeft":"question_mark","placeholder":"What is a question?"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (24, 'faqs_usergroups', 'faqs_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (25, 'faqs_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (26, 'faqs_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (27, 'ageratings_translations', 'ageratings_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (28, 'ageratings_translations', 'description', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (29, 'ageratings_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (30, 'ageratings_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (31, 'assetfiles', 'asset_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (32, 'assetfiles', 'audio_language_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', NULL, NULL, false, false, 12, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (33, 'assetfiles', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (34, 'assetfiles', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (35, 'assetfiles', 'extra_metadata', 'cast-json', 'input-code', NULL, NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (36, 'assetfiles', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (37, 'assetfiles', 'mime_type', NULL, 'input', '{"iconLeft":"category"}', NULL, NULL, false, false, 5, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (38, 'assetfiles', 'path', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (39, 'assetfiles', 'storage', NULL, 'select-radio', '{"choices":[{"text":"az_vods1","value":"az_vods1"},{"text":"s3_assets","value":"s3_assets"}]}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (40, 'assetfiles', 'subtitle_language_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', NULL, NULL, false, false, 13, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (41, 'assetfiles', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Video","value":"video"},{"text":"Audio","value":"audio"},{"text":"Subtitle","value":"subtitle"}]}', NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (42, 'assetfiles', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (43, 'assetfiles', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (44, 'assets', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (45, 'assets', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (46, 'assets', 'duration', NULL, 'input', '{"iconLeft":"timer"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (47, 'assets', 'encoding_version', NULL, 'select-dropdown', '{"choices":[{"text":"btv","value":"btv"},{"text":"azure_media_services","value":"azure_media_services"}]}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (48, 'assets', 'files', 'o2m', 'list-o2m', '{"enableCreate":false,"template":"{{storage}}/{{path}}"}', NULL, NULL, false, false, 14, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (49, 'assets', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (50, 'assets', 'legacy_id', NULL, 'input', NULL, NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (51, 'assets', 'main_storage_path', NULL, 'input', NULL, NULL, NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (52, 'assets', 'mediabanken_id', NULL, 'input', '{"iconLeft":"grid_3x3"}', NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (53, 'assets', 'name', NULL, 'input', '{"placeholder":null}', NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (54, 'assets', 'preview', 'alias,no-data', 'video-preview', NULL, NULL, NULL, false, false, 13, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (55, 'assets', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"Draft","value":"draft"},{"text":"Published","value":"published"},{"text":"Archived","value":"archived"}],"icon":"visibility"}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (56, 'assets', 'streams', 'o2m', 'list-o2m', '{"template":"{{service}}/{{path}}"}', 'related-values', NULL, false, false, 15, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (57, 'assets', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (177, 'episodes', 'publish_date', NULL, 'datetime', NULL, NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (58, 'assets', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (59, 'assetstreams', 'asset_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 14, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (60, 'assetstreams', 'audio_languages', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 12, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (61, 'assetstreams', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (62, 'assetstreams', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 10, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (63, 'assetstreams', 'encryption_key_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (64, 'assetstreams', 'extra_metadata', 'cast-json', 'input-code', '{"language":"JSON"}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (65, 'assetstreams', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (66, 'assetstreams', 'legacy_videourl_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (67, 'assetstreams', 'path', NULL, 'input', NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (68, 'assetstreams', 'service', NULL, 'select-radio', '{"choices":[{"text":"mediapackage","value":"mediapackage"},{"text":"azure_media_services","value":"azure_media_services"}]}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (69, 'assetstreams', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (70, 'assetstreams', 'subtitle_languages', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 13, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (71, 'assetstreams', 'type', NULL, 'select-radio', '{"choices":[{"text":"hls-cmaf","value":"hls-cmaf"},{"text":"dash","value":"dash"},{"text":"hls-ts","value":"hls-ts"}]}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (72, 'assetstreams', 'url', NULL, 'input', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (73, 'assetstreams', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (74, 'assetstreams', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (75, 'assetstreams_audio_languages', 'assetstreams_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (76, 'assetstreams_audio_languages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (77, 'assetstreams_audio_languages', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (78, 'assetstreams_subtitle_languages', 'assetstreams_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (79, 'assetstreams_subtitle_languages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (80, 'assetstreams_subtitle_languages', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (81, 'calendarentries', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (82, 'calendarentries', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (83, 'calendarentries', 'end', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 10, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (84, 'calendarentries', 'episode_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 2, 'half', NULL, NULL, '[{"name":"Hidden if not Episode","rule":{"_and":[{"link_type":{"_neq":"episode"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (85, 'calendarentries', 'event_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (86, 'calendarentries', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (87, 'calendarentries', 'image', 'file', 'file-image', '{"crop":false}', 'image', NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (88, 'calendarentries', 'image_from_link', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (89, 'calendarentries', 'link', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (90, 'calendarentries', 'link_type', NULL, 'select-dropdown', '{"allowNone":true,"choices":[{"text":"Episode","value":"episode"},{"text":"Season","value":"season"},{"text":"Show","value":"show"}]}', 'formatted-value', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (91, 'calendarentries', 'season_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'half', NULL, NULL, '[{"name":"Hidden if not Season","rule":{"_and":[{"link_type":{"_neq":"season"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (92, 'calendarentries', 'show_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4, 'half', NULL, NULL, '[{"name":"Hidden if not Show","rule":{"_and":[{"link_type":{"_neq":"show"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (93, 'calendarentries', 'start', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 9, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (94, 'calendarentries', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (95, 'calendarentries', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (96, 'calendarentries', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (97, 'calendarentries', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (98, 'calendarentries_translations', 'calendarentries_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (99, 'calendarentries_translations', 'description', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (100, 'calendarentries_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (101, 'calendarentries_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (102, 'calendarentries_translations', 'title', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (103, 'events', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (104, 'events', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (105, 'events', 'end', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 9, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (106, 'events', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (107, 'events', 'start', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 8, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (108, 'events', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (288, 'messagetemplates', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (109, 'events', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code","userLanguage":true}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (110, 'events', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (111, 'events', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (112, 'events_translations', 'description', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (113, 'events_translations', 'events_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (114, 'events_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (115, 'events_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (116, 'events_translations', 'title', NULL, 'input', '{"iconLeft":"abc"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (117, 'ageratings', 'code', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (118, 'ageratings', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (119, 'ageratings', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (120, 'ageratings', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (121, 'ageratings', 'title', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (122, 'ageratings', 'translations', 'translations', 'translations', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (123, 'appconfig', 'app_version', NULL, 'input', '{"iconLeft":"get_app"}', 'formatted-value', NULL, false, false, NULL, 'half', NULL, 'Minimum required app version', NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (124, 'appconfig', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (125, 'appconfig', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (126, 'appconfig', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (127, 'globalconfig', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (128, 'globalconfig', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (129, 'globalconfig', 'live_online', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, NULL, 'half', NULL, 'Is there a livestream running?', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (130, 'globalconfig', 'npaw_enabled', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, false, NULL, 'half', NULL, 'Is NPAW data collection active?', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (131, 'globalconfig', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (132, 'languages', 'code', NULL, NULL, NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (133, 'languages', 'legacy_2_letter_code', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (134, 'languages', 'legacy_3_letter_code', NULL, 'input', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (135, 'languages', 'name', NULL, NULL, NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (136, 'usergroups', 'code', NULL, 'input', NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (137, 'usergroups', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (138, 'usergroups', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (139, 'usergroups', 'emails', NULL, 'input-multiline', '{"clear":true,"font":"monospace","placeholder":"admin@brunstad.tv","softLength":0,"trim":true}', 'formatted-value', '{"format":true}', false, false, NULL, 'full', NULL, 'One per line', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (140, 'usergroups', 'episode_earlyaccess', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (141, 'usergroups', 'name', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (142, 'usergroups', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (143, 'usergroups', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (144, 'usergroups', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (145, 'webconfig', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (146, 'webconfig', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (147, 'webconfig', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (148, 'episodes_categories', 'categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (149, 'episodes_categories', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (150, 'episodes_categories', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (151, 'lists_relations', 'collection', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (152, 'lists_relations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (153, 'lists_relations', 'item', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (154, 'lists_relations', 'lists_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (155, 'lists_relations', 'sort', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (156, 'episodes', 'agerating_code', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 5, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (157, 'episodes', 'asset_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (158, 'episodes', 'availability', 'alias,group,no-data', 'group-detail', '{"headerIcon":"visibility"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (159, 'episodes', 'available_from', NULL, 'datetime', NULL, NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (160, 'episodes', 'available_to', NULL, 'datetime', '{}', NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (161, 'episodes', 'categories', 'm2m', 'list-m2m', NULL, NULL, NULL, false, true, 9, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (162, 'episodes', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (163, 'episodes', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (164, 'episodes', 'download_usergroups', 'm2m', 'list-m2m', '{"enableCreate":false,"template":"{{usergroups_code.name}}"}', NULL, NULL, false, false, 5, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (165, 'episodes', 'earlyaccess_usergroups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (166, 'episodes', 'episode_number', NULL, 'input', '{"iconLeft":"numbers"}', NULL, NULL, false, false, 3, 'half', NULL, 'For showing "S1:E2" and for sorting.', '[{"name":"Hide when standalone","rule":{"_and":[{"type":{"_eq":"standalone"}}]},"hidden":true}]', false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (167, 'episodes', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (168, 'episodes', 'image_file_id', 'file', 'file-image', '{"crop":false,"folder":null}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (169, 'episodes', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (170, 'episodes', 'legacy_extra_description_id', NULL, 'input', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (171, 'episodes', 'legacy_id', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (172, 'episodes', 'legacy_program_id', NULL, 'input', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (173, 'episodes', 'legacy_tags_id', NULL, 'input', NULL, NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (174, 'episodes', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (175, 'episodes', 'metadata', 'alias,group,no-data', 'group-detail', '{"headerIcon":"display_settings"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (176, 'episodes', 'migration_data', 'cast-json', 'input-code', '{}', NULL, NULL, true, false, 1, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (178, 'episodes', 'season_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', NULL, NULL, false, false, 2, 'half', NULL, NULL, '[{"name":"Hide when standalone","rule":{"_and":[{"type":{"_eq":"standalone"}}]},"hidden":true}]', false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (179, 'episodes', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}],"icon":"visibility"}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (180, 'episodes', 'tags', 'm2m', 'list-m2m', '{"template":"{{tags_id.name}}"}', 'related-values', '{"template":"{{tags_id.name}}"}', false, false, 8, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (181, 'episodes', 'technical_details', 'alias,group,no-data', 'group-detail', '{"headerIcon":"code","start":"closed"}', NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (182, 'episodes', 'translatable_details', 'alias,group,no-data', 'group-detail', '{"headerIcon":"text_snippet"}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (183, 'episodes', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 1, 'full', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (184, 'episodes', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Episode","value":"episode"},{"text":"Standalone","value":"standalone"}],"icon":"build"}', NULL, NULL, false, false, 1, 'full', NULL, NULL, '[{"name":"Disable when season is set","rule":{"_and":[{"season_id":{"_nnull":true}}]},"readonly":true},{"name":"Disable when episode number is set","rule":{"_and":[{"episode_number":{"_nnull":true}}]},"readonly":true},{"name":"Disable when created","rule":{"_and":[{"id":{"_nnull":true}}]},"readonly":true}]', true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (185, 'episodes', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (186, 'episodes', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (187, 'episodes', 'usergroups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (188, 'episodes_tags', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (189, 'episodes_tags', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (190, 'episodes_tags', 'tags_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (191, 'episodes_translations', 'description', NULL, 'input', '{"iconLeft":"description"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (192, 'episodes_translations', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (193, 'episodes_translations', 'extra_description', NULL, 'input', '{"iconLeft":"description"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (194, 'episodes_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (195, 'episodes_translations', 'is_primary', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, true, 8, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (196, 'episodes_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (197, 'episodes_translations', 'title', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (198, 'episodes_usergroups', 'date_created', 'date-created', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (199, 'episodes_usergroups', 'date_updated', 'date-created,date-updated', NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (200, 'episodes_usergroups', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (201, 'episodes_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (202, 'episodes_usergroups', 'type', NULL, 'select-radio', '{"choices":[{"text":"Availability","value":"availability"},{"text":"Early Access","value":"early-access"}]}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (203, 'episodes_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (204, 'episodes_usergroups_download', 'date_created', 'date-created', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (205, 'episodes_usergroups_download', 'date_updated', 'date-created,date-updated', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (206, 'episodes_usergroups_download', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (207, 'episodes_usergroups_download', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (208, 'episodes_usergroups_download', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (209, 'episodes_usergroups_earlyaccess', 'date_created', 'date-created', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (210, 'episodes_usergroups_earlyaccess', 'date_updated', 'date-created,date-updated', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (211, 'episodes_usergroups_earlyaccess', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (212, 'episodes_usergroups_earlyaccess', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (213, 'episodes_usergroups_earlyaccess', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (214, 'seasons', 'agerating_code', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (215, 'seasons', 'availability', 'alias,group,no-data', 'group-detail', '{"headerIcon":"visibility"}', NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (216, 'seasons', 'available_from', NULL, 'datetime', NULL, NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (217, 'seasons', 'available_to', NULL, 'datetime', NULL, NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (218, 'seasons', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (219, 'seasons', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (220, 'seasons', 'episodes', 'o2m', 'list-o2m', '{"filter":{"_and":[{"type":{"_eq":"episode"}}]}}', NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'related', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (221, 'seasons', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (222, 'seasons', 'image_file_id', 'file', 'file-image', '{"crop":false,"folder":"00000000-0000-0000-0000-000000000000"}', NULL, NULL, false, false, 3, 'full', '[{"language":null,"translation":"Image file"}]', NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (223, 'seasons', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (224, 'seasons', 'legacy_id', NULL, 'input', NULL, NULL, NULL, true, false, 1, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (225, 'seasons', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (226, 'seasons', 'metadata', 'alias,group,no-data', 'group-detail', '{"headerIcon":"display_settings"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (227, 'seasons', 'publish_date', NULL, 'datetime', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (228, 'seasons', 'related', 'alias,group,no-data', 'group-detail', '{"headerIcon":"share"}', NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (229, 'seasons', 'season_number', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'half', NULL, 'Used for "S1:E2" and for sorting.', NULL, true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (230, 'seasons', 'show_id', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, false, 1, 'half', '[{"language":"en-US","translation":"Show"}]', NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (231, 'seasons', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (232, 'seasons', 'technical_details', 'alias,group,no-data', 'group-detail', '{"headerIcon":"code","start":"closed"}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (383, 'sections', 'meta', 'alias,group,no-data', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (233, 'seasons', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (234, 'seasons', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (235, 'seasons', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (236, 'seasons', 'usergroups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (237, 'seasons_translations', 'description', NULL, 'input', '{"iconLeft":"description","placeholder":null}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (238, 'seasons_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (239, 'seasons_translations', 'is_primary', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (240, 'seasons_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (241, 'seasons_translations', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (242, 'seasons_translations', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (243, 'seasons_translations', 'seasons_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (244, 'seasons_translations', 'title', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (245, 'shows', 'agerating_code', 'm2o', 'select-dropdown-m2o', '{"template":"{{title}}"}', NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (246, 'shows', 'availability', 'alias,group,no-data', 'group-detail', '{"headerIcon":"visibility"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (247, 'shows', 'available_from', NULL, 'datetime', NULL, NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (248, 'shows', 'available_to', NULL, 'datetime', NULL, NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (249, 'shows', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (250, 'shows', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (251, 'shows', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (252, 'shows', 'image_file_id', 'file', 'file-image', '{"crop":false,"folder":"00000000-0000-0000-0000-000000000000"}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (253, 'shows', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, true, false, 3, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (254, 'shows', 'legacy_id', NULL, 'input', NULL, NULL, NULL, true, false, 1, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (255, 'shows', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, true, false, 2, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (256, 'shows', 'metadata', 'alias,group,no-data', 'group-detail', '{"headerIcon":"display_settings"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (257, 'shows', 'publish_date', NULL, 'datetime', '{}', NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (258, 'shows', 'related', 'alias,group,no-data', 'group-detail', '{"headerIcon":"share"}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (259, 'shows', 'seasons', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'related', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (260, 'shows', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (261, 'shows', 'technical_details', 'alias,group,no-data', 'group-detail', '{"headerIcon":"code","start":"closed"}', NULL, NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (262, 'shows', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (263, 'shows', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Series","value":"series"},{"text":"Event","value":"event"}]}', NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (264, 'shows', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (265, 'shows', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (266, 'shows', 'usergroups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (267, 'shows_translations', 'description', NULL, 'input', '{"iconLeft":"description"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (268, 'shows_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (269, 'shows_translations', 'is_primary', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, true, 7, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (270, 'shows_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (271, 'shows_translations', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, false, true, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (272, 'shows_translations', 'legacy_tags', NULL, 'input', NULL, NULL, NULL, false, true, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (273, 'shows_translations', 'legacy_tags_id', NULL, 'input', NULL, NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (274, 'shows_translations', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, false, true, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (275, 'shows_translations', 'shows_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (276, 'shows_translations', 'title', NULL, 'input', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (277, 'maintenancemessage', 'active', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (278, 'maintenancemessage', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (279, 'maintenancemessage', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (280, 'maintenancemessage', 'messages', 'm2m', 'list-m2m', '{"template":"{{messagetemplates_id.translations}}"}', 'related-values', '{"template":"{{messagetemplates_id.translations}}"}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (281, 'maintenancemessage', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (282, 'messagetemplates', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (283, 'messagetemplates', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (284, 'messagetemplates', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (285, 'messagetemplates', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (286, 'messagetemplates', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code","userLanguage":true}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{message}}","userLanguage":true}', false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (287, 'messagetemplates', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Warning","value":"warning"},{"text":"Error","value":"error"},{"text":"Info","value":"info"}]}', 'labels', NULL, false, false, 7, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (381, 'sections', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (289, 'messagetemplates', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (290, 'messagetemplates_translations', 'details', NULL, 'input-rich-text-html', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (291, 'messagetemplates_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (292, 'messagetemplates_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (293, 'messagetemplates_translations', 'message', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (294, 'messagetemplates_translations', 'messagetemplates_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (295, 'maintenancemessage_messagetemplates', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (296, 'maintenancemessage_messagetemplates', 'maintenancemessage_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (297, 'maintenancemessage_messagetemplates', 'messagetemplates_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (298, 'maintenancemessage_messagetemplates', 'sort', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (299, 'categories', 'appear_in_search', 'cast-boolean', 'boolean', '{"label":"Appear in search"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (300, 'categories', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (301, 'categories', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (302, 'categories', 'episodes', 'm2m', 'list-m2m', '{"enableCreate":false,"template":"{{episodes_id.translations}}"}', 'related-values', '{"template":"{{episodes_id.translations}}"}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (303, 'categories', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (304, 'categories', 'legacy_id', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (305, 'categories', 'parent_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (306, 'categories', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (307, 'categories', 'subcategories', 'o2m', 'list-o2m-tree-view', NULL, NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (308, 'categories', 'translations', 'translations', 'translations', '{"languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{name}}","userLanguage":true}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (309, 'categories', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (310, 'categories', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (311, 'categories_translations', 'categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (312, 'categories_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (313, 'categories_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (314, 'categories_translations', 'name', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (315, 'collections', 'collection', NULL, 'select-dropdown', '{"choices":[{"text":"Pages","value":"pages"},{"text":"Shows","value":"shows"},{"text":"Seasons","value":"seasons"},{"text":"Episodes","value":"episodes"}],"icon":"list_alt","placeholder":"Shows... seasons"}', NULL, NULL, false, false, 2, 'half', '[{"language":"en-US","translation":"Collection"}]', NULL, '[{"name":"Hidden if not Query","rule":{"_and":[{"filter_type":{"_neq":"query"}}]},"hidden":true,"options":{"allowOther":false,"allowNone":false}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (316, 'collections', 'config', 'alias,group,no-data', 'group-detail', '{"headerIcon":"settings"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (317, 'collections', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (318, 'collections', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (319, 'collections', 'episodes_query_filter', 'cast-json', 'query-builder', '{"fieldCollection":"episodes"}', NULL, NULL, false, false, 7, 'full', NULL, NULL, '[{"name":"Hidden if not Episodes","rule":{"_and":[{"_or":[{"collection":{"_neq":"episodes"}},{"filter_type":{"_neq":"query"}}]}]},"hidden":true,"options":{"fieldCollection":""}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (320, 'collections', 'filter_type', NULL, 'select-dropdown', '{"choices":[{"text":"Select","value":"select"},{"text":"Query","value":"query"}]}', NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (321, 'collections', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (322, 'collections', 'items', 'o2m', 'list-o2m', '{"enableSelect":false}', NULL, NULL, false, false, 8, 'full', NULL, NULL, '[{"name":"Hidden if not Select","rule":{"_and":[{"filter_type":{"_neq":"select"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true,"limit":15}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (323, 'collections', 'meta', 'alias,group,no-data', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (324, 'collections', 'name', NULL, 'input', NULL, 'raw', NULL, false, false, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (325, 'collections', 'pages_query_filter', 'cast-json', 'query-builder', '{"fieldCollection":"pages"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, '[{"name":"Hidden if not Pages","rule":{"_and":[{"_or":[{"collection":{"_neq":"pages"}},{"filter_type":{"_neq":"query"}}]}]},"hidden":true,"options":{"fieldCollection":""}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (326, 'collections', 'seasons_query_filter', 'cast-json', 'query-builder', '{"fieldCollection":"seasons"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, '[{"name":"Hidden if not Seasons","rule":{"_and":[{"_or":[{"collection":{"_neq":"seasons"}},{"filter_type":{"_neq":"query"}}]}]},"hidden":true,"options":{"fieldCollection":""}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (327, 'collections', 'shows_query_filter', 'cast-json', 'query-builder', '{"fieldCollection":"shows"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, '[{"name":"Hidden if not Shows","rule":{"_and":[{"_or":[{"collection":{"_neq":"shows"}},{"filter_type":{"_neq":"query"}}]}]},"options":{"fieldCollection":""},"hidden":true}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (328, 'collections', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (329, 'collections', 'used_in_sections', 'o2m', 'list-o2m', '{"template":"{{translations}}"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (330, 'collections', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (331, 'collections', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (332, 'collections_items', 'collection_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 7, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (333, 'collections_items', 'config', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (334, 'collections_items', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (335, 'collections_items', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (336, 'collections_items', 'episode_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 5, 'half', NULL, NULL, '[{"name":"Hidden if not Episode","rule":{"_and":[{"type":{"_neq":"episode"}}]},"hidden":true,"options":{}},{"name":"Required if Episode","rule":{"_and":[{"type":{"_eq":"episode"}}]},"required":true,"options":{}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (337, 'collections_items', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (338, 'collections_items', 'page_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 2, 'half', NULL, NULL, '[{"name":"Hidden if not Page","rule":{"_and":[{"type":{"_neq":"page"}}]},"hidden":true,"options":{}},{"name":"Required if Page","rule":{"_and":[{"type":{"_eq":"page"}}]},"readonly":false,"required":true,"options":{}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (382, 'sections', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (339, 'collections_items', 'season_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4, 'half', NULL, NULL, '[{"name":"Hidden if not Season","rule":{"_and":[{"type":{"_neq":"season"}}]},"hidden":true,"options":{}},{"name":"Required if Season","rule":{"_and":[{"type":{"_eq":"season"}}]},"required":true,"options":{}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (340, 'collections_items', 'show_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'half', NULL, NULL, '[{"name":"Hidden if not Show","rule":{"_and":[{"type":{"_neq":"show"}}]},"hidden":true,"options":{}},{"name":"Required if Show","rule":{"_and":[{"type":{"_eq":"show"}}]},"required":true,"options":{}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (341, 'collections_items', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (342, 'collections_items', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Page","value":"page"},{"text":"Show","value":"show"},{"text":"Season","value":"season"},{"text":"Episode","value":"episode"}]}', NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (343, 'collections_items', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (344, 'collections_items', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (345, 'lists', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (346, 'lists', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (347, 'lists', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (348, 'lists', 'legacy_category_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (349, 'lists', 'legacy_name_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (350, 'lists', 'name', NULL, 'input', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (351, 'lists', 'relations', 'm2a', 'list-m2a', '{}', 'related-values', '{"template":"{{item:shows}}{{item:episodes}}{{item:shows.translations}}"}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (352, 'lists', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (353, 'lists', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (354, 'pages', 'code', NULL, 'input', '{"iconLeft":"tag"}', NULL, NULL, false, false, 3, 'full', NULL, NULL, '[{"name":"Disable when system page","rule":{"_and":[{"system_page":{"_eq":true}}]},"readonly":true}]', true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (355, 'pages', 'collection', NULL, 'select-dropdown', '{"choices":[{"text":"Shows","value":"shows"},{"text":"Seasons","value":"seasons"},{"text":"Episodes","value":"episodes"}]}', NULL, NULL, false, false, 5, 'half', NULL, NULL, '[{"name":"Hidden when not Default","rule":{"_and":[{"type":{"_neq":"default"}}]},"hidden":true,"options":{"allowOther":false,"allowNone":false}},{"name":"Required when Default","rule":{"_and":[{"type":{"_eq":"default"}}]},"readonly":false,"required":true,"options":{"allowOther":false,"allowNone":false}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (356, 'pages', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (357, 'pages', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (358, 'pages', 'episode_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', 'related-values', '{"template":"{{translations}}"}', false, false, 3, 'half', '[{"language":"en-US","translation":"Episode"}]', NULL, '[{"name":"Hide when not Episode","rule":{"_and":[{"type":{"_neq":"episode"}}]},"hidden":true,"options":{}},{"name":"Required when Episode","rule":{"_and":[{"type":{"_eq":"episode"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (359, 'pages', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (360, 'pages', 'meta', 'alias,group,no-data', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (361, 'pages', 'relations', 'alias,group,no-data', 'group-detail', '{"headerColor":null,"headerIcon":"article"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (362, 'pages', 'season_id', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, false, 4, 'half', '[{"language":"en-US","translation":"Season"}]', NULL, '[{"name":"Hidden if not Season","rule":{"_and":[{"type":{"_neq":"season"}}]},"hidden":true,"options":{}},{"name":"Required if Season","rule":{"_and":[{"type":{"_eq":"season"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (363, 'pages', 'sections', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (364, 'pages', 'show_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', 'related-values', '{"template":"{{translations}}"}', false, false, 2, 'half', '[{"language":"en-US","translation":"Show"}]', NULL, '[{"name":"Hide when not Show","rule":{"_and":[{"type":{"_neq":"show"}}]},"hidden":true,"options":{}},{"name":"Required when Show","rule":{"_and":[{"type":{"_eq":"show"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (365, 'pages', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (366, 'pages', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 4, 'full', NULL, NULL, '[{"name":"Disable when system page","rule":{"_and":[{"system_page":{"_eq":true}}]},"readonly":true}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (367, 'pages', 'translatable_details', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (368, 'pages', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code","userLanguage":true}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 1, 'full', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (369, 'pages', 'type', NULL, 'select-dropdown', '{"allowNone":true,"choices":[{"text":"Custom","value":"custom"},{"text":"Default","value":"default"},{"text":"Show","value":"show"},{"text":"Season","value":"season"},{"text":"Episode","value":"episode"}],"icon":"abc"}', 'formatted-value', NULL, false, false, 1, 'half', NULL, NULL, NULL, true, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (370, 'pages', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (371, 'pages', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (372, 'pages_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (373, 'pages_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (374, 'pages_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (375, 'pages_translations', 'pages_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (376, 'pages_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (377, 'sections', 'Visibility', 'alias,group,no-data', 'group-detail', '{"headerIcon":"visibility"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (378, 'sections', 'collection_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', 'related-values', '{"template":"{{name}}"}', false, false, 4, 'full', '[{"language":"en-US","translation":"Collection"}]', NULL, NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (379, 'sections', 'configuration', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (380, 'sections', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 2, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (384, 'sections', 'page_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{code}} - {{translations}}"}', 'related-values', NULL, false, false, 1, 'full', '[{"language":"en-US","translation":"Page"}]', NULL, NULL, true, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (385, 'sections', 'sort', NULL, NULL, NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (386, 'sections', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (387, 'sections', 'style', NULL, 'select-dropdown', '{"choices":[{"text":"Slider","value":"carousel"},{"text":"Cards","value":"cards"}]}', 'raw', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (388, 'sections', 'translatable_details', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (389, 'sections', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code","userLanguage":true}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 1, 'full', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (390, 'sections', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 1, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (391, 'sections', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (392, 'sections', 'usergroups', 'm2m', 'list-m2m', '{}', NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'Visibility', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (393, 'sections_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (394, 'sections_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (395, 'sections_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (396, 'sections_translations', 'sections_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (397, 'sections_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (398, 'sections_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (399, 'sections_usergroups', 'sections_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (400, 'sections_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (401, 'tags', 'code', NULL, 'input', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, '{"_and":[{"code":{"_regex":"[a-z_]+"}}]}', NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (402, 'tags', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (403, 'tags', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (404, 'tags', 'episodes', 'm2m', 'list-m2m', NULL, 'related-values', '{"template":"{{episodes_id.translations}}"}', false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (405, 'tags', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (406, 'tags', 'meta', 'alias,group,no-data', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (407, 'tags', 'name', NULL, 'input', '{"iconLeft":"title","placeholder":null}', 'raw', NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (408, 'tags', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (409, 'tags', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 1, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (410, 'tags', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (411, 'tags_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (412, 'tags_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (413, 'tags_translations', 'name', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (414, 'tags_translations', 'tags_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (415, 'seasons_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (416, 'seasons_usergroups', 'seasons_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (417, 'seasons_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (418, 'shows_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (419, 'shows_usergroups', 'shows_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (420, 'shows_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201028A', 'Remove Collection Foreign Keys', '2022-09-02T11:01:35.731Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201029A', 'Remove System Relations', '2022-09-02T11:01:35.733Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201029B', 'Remove System Collections', '2022-09-02T11:01:35.735Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201029C', 'Remove System Fields', '2022-09-02T11:01:35.740Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201105A', 'Add Cascade System Relations', '2022-09-02T11:01:35.769Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201105B', 'Change Webhook URL Type', '2022-09-02T11:01:35.772Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210225A', 'Add Relations Sort Field', '2022-09-02T11:01:35.775Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210304A', 'Remove Locked Fields', '2022-09-02T11:01:35.778Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210312A', 'Webhooks Collections Text', '2022-09-02T11:01:35.781Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210331A', 'Add Refresh Interval', '2022-09-02T11:01:35.783Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210415A', 'Make Filesize Nullable', '2022-09-02T11:01:35.787Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210416A', 'Add Collections Accountability', '2022-09-02T11:01:35.790Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210422A', 'Remove Files Interface', '2022-09-02T11:01:35.792Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210506A', 'Rename Interfaces', '2022-09-02T11:01:35.808Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210510A', 'Restructure Relations', '2022-09-02T11:01:35.820Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210518A', 'Add Foreign Key Constraints', '2022-09-02T11:01:35.825Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210519A', 'Add System Fk Triggers', '2022-09-02T11:01:35.842Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210521A', 'Add Collections Icon Color', '2022-09-02T11:01:35.844Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210525A', 'Add Insights', '2022-09-02T11:01:35.856Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210608A', 'Add Deep Clone Config', '2022-09-02T11:01:35.858Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210626A', 'Change Filesize Bigint', '2022-09-02T11:01:35.865Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210716A', 'Add Conditions to Fields', '2022-09-02T11:01:35.866Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210721A', 'Add Default Folder', '2022-09-02T11:01:35.870Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210802A', 'Replace Groups', '2022-09-02T11:01:35.872Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210803A', 'Add Required to Fields', '2022-09-02T11:01:35.874Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210805A', 'Update Groups', '2022-09-02T11:01:35.876Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210805B', 'Change Image Metadata Structure', '2022-09-02T11:01:35.878Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210811A', 'Add Geometry Config', '2022-09-02T11:01:35.880Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210831A', 'Remove Limit Column', '2022-09-02T11:01:35.882Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210903A', 'Add Auth Provider', '2022-09-02T11:01:35.892Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210907A', 'Webhooks Collections Not Null', '2022-09-02T11:01:35.897Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210910A', 'Move Module Setup', '2022-09-02T11:01:35.900Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210920A', 'Webhooks URL Not Null', '2022-09-02T11:01:35.905Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210924A', 'Add Collection Organization', '2022-09-02T11:01:35.909Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210927A', 'Replace Fields Group', '2022-09-02T11:01:35.913Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210927B', 'Replace M2M Interface', '2022-09-02T11:01:35.915Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210929A', 'Rename Login Action', '2022-09-02T11:01:35.916Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211007A', 'Update Presets', '2022-09-02T11:01:35.920Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211009A', 'Add Auth Data', '2022-09-02T11:01:35.922Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211016A', 'Add Webhook Headers', '2022-09-02T11:01:35.924Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211103A', 'Set Unique to User Token', '2022-09-02T11:01:35.926Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211103B', 'Update Special Geometry', '2022-09-02T11:01:35.928Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211104A', 'Remove Collections Listing', '2022-09-02T11:01:35.930Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211118A', 'Add Notifications', '2022-09-02T11:01:35.938Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211211A', 'Add Shares', '2022-09-02T11:01:35.950Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211230A', 'Add Project Descriptor', '2022-09-02T11:01:35.952Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220303A', 'Remove Default Project Color', '2022-09-02T11:01:35.957Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220308A', 'Add Bookmark Icon and Color', '2022-09-02T11:01:35.959Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220314A', 'Add Translation Strings', '2022-09-02T11:01:35.961Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220322A', 'Rename Field Typecast Flags', '2022-09-02T11:01:35.963Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220323A', 'Add Field Validation', '2022-09-02T11:01:35.965Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220325A', 'Fix Typecast Flags', '2022-09-02T11:01:35.968Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220325B', 'Add Default Language', '2022-09-02T11:01:35.973Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220402A', 'Remove Default Value Panel Icon', '2022-09-02T11:01:35.977Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220429A', 'Add Flows', '2022-09-02T11:01:35.997Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220429B', 'Add Color to Insights Icon', '2022-09-02T11:01:35.999Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220429C', 'Drop Non Null From IP of Activity', '2022-09-02T11:01:36.001Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220429D', 'Drop Non Null From Sender of Notifications', '2022-09-02T11:01:36.003Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220614A', 'Rename Hook Trigger to Event', '2022-09-02T11:01:36.004Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220801A', 'Update Notifications Timestamp Column', '2022-09-02T11:01:36.008Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220802A', 'Add Custom Aspect Ratios', '2022-09-02T11:01:36.010Z');

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (1, 'ageratings_translations', 'ageratings_code', 'ageratings', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (2, 'ageratings_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'ageratings_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (3, 'appconfig', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (4, 'assetfiles', 'asset_id', 'assets', 'files', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (5, 'assetfiles', 'audio_language_id', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (6, 'assetfiles', 'subtitle_language_id', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (7, 'assetfiles', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (8, 'assetfiles', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (9, 'assets', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (10, 'assets', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (11, 'assetstreams', 'asset_id', 'assets', 'streams', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (12, 'assetstreams', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (13, 'assetstreams', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (14, 'assetstreams_audio_languages', 'assetstreams_id', 'assetstreams', 'audio_languages', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (15, 'assetstreams_audio_languages', 'languages_code', 'languages', NULL, NULL, NULL, 'assetstreams_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (16, 'assetstreams_subtitle_languages', 'assetstreams_id', 'assetstreams', 'subtitle_languages', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (17, 'assetstreams_subtitle_languages', 'languages_code', 'languages', NULL, NULL, NULL, 'assetstreams_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (18, 'calendarentries', 'episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (19, 'calendarentries', 'event_id', 'events', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (20, 'calendarentries', 'image', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (21, 'calendarentries', 'season_id', 'seasons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (22, 'calendarentries', 'show_id', 'shows', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (23, 'calendarentries', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (24, 'calendarentries', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (25, 'calendarentries_translations', 'calendarentries_id', 'calendarentries', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (26, 'calendarentries_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'calendarentries_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (27, 'categories', 'parent_id', 'categories', 'subcategories', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (28, 'categories', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (29, 'categories', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (30, 'categories_translations', 'categories_id', 'categories', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (31, 'categories_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'categories_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (32, 'collections', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (33, 'collections', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (34, 'collections_items', 'collection_id', 'collections', 'items', NULL, NULL, NULL, 'sort', 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (35, 'collections_items', 'episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (36, 'collections_items', 'page_id', 'pages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (37, 'collections_items', 'season_id', 'seasons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (38, 'collections_items', 'show_id', 'shows', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (39, 'collections_items', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (40, 'collections_items', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (41, 'episodes', 'agerating_code', 'ageratings', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (42, 'episodes', 'asset_id', 'assets', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (43, 'episodes', 'image_file_id', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (44, 'episodes', 'season_id', 'seasons', 'episodes', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (45, 'episodes', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (46, 'episodes', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (47, 'episodes_categories', 'categories_id', 'categories', 'episodes', NULL, NULL, 'episodes_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (48, 'episodes_categories', 'episodes_id', 'episodes', 'categories', NULL, NULL, 'categories_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (49, 'episodes_tags', 'episodes_id', 'episodes', 'tags', NULL, NULL, 'tags_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (50, 'episodes_tags', 'tags_id', 'tags', 'episodes', NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (51, 'episodes_translations', 'episodes_id', 'episodes', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (52, 'episodes_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (53, 'episodes_usergroups', 'episodes_id', 'episodes', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (54, 'episodes_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (55, 'episodes_usergroups_download', 'episodes_id', 'episodes', 'download_usergroups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (56, 'episodes_usergroups_download', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (57, 'episodes_usergroups_earlyaccess', 'episodes_id', 'episodes', 'earlyaccess_usergroups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (58, 'episodes_usergroups_earlyaccess', 'usergroups_code', 'usergroups', 'episode_earlyaccess', NULL, NULL, 'episodes_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (59, 'events', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (60, 'events', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (61, 'events_translations', 'events_id', 'events', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (62, 'events_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'events_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (63, 'faq_categories_translations', 'faq_categories_id', 'faq_categories', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (64, 'faq_categories_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'faq_categories_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (65, 'faqs', 'category', 'faq_categories', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (66, 'faqs', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (67, 'faqs', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (68, 'faqs_translations', 'faqs_id', 'faqs', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (69, 'faqs_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'faqs_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (70, 'faqs_usergroups', 'faqs_id', 'faqs', 'groups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (71, 'faqs_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'faqs_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (72, 'globalconfig', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (73, 'lists', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (74, 'lists', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (75, 'lists_relations', 'item', NULL, NULL, 'collection', 'episodes,shows', 'lists_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (76, 'lists_relations', 'lists_id', 'lists', 'relations', NULL, NULL, 'item', 'sort', 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (77, 'maintenancemessage', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (78, 'maintenancemessage_messagetemplates', 'maintenancemessage_id', 'maintenancemessage', 'messages', NULL, NULL, 'messagetemplates_id', 'sort', 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (79, 'maintenancemessage_messagetemplates', 'messagetemplates_id', 'messagetemplates', NULL, NULL, NULL, 'maintenancemessage_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (80, 'messagetemplates', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (81, 'messagetemplates', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (82, 'messagetemplates_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'messagetemplates_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (83, 'messagetemplates_translations', 'messagetemplates_id', 'messagetemplates', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (84, 'pages', 'episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (85, 'pages', 'season_id', 'seasons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (86, 'pages', 'show_id', 'shows', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (87, 'pages', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (88, 'pages', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (89, 'pages_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'pages_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (90, 'pages_translations', 'pages_id', 'pages', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (91, 'seasons', 'agerating_code', 'ageratings', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (92, 'seasons', 'image_file_id', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (93, 'seasons', 'show_id', 'shows', 'seasons', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (94, 'seasons', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (95, 'seasons', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (96, 'seasons_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'seasons_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (97, 'seasons_translations', 'seasons_id', 'seasons', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (98, 'seasons_usergroups', 'seasons_id', 'seasons', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (99, 'seasons_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'seasons_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (100, 'sections', 'collection_id', 'collections', 'used_in_sections', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (101, 'sections', 'page_id', 'pages', 'sections', NULL, NULL, NULL, 'sort', 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (102, 'sections', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (103, 'sections', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (104, 'sections_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'sections_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (105, 'sections_translations', 'sections_id', 'sections', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (106, 'sections_usergroups', 'sections_id', 'sections', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (107, 'sections_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'sections_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (108, 'shows', 'agerating_code', 'ageratings', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (109, 'shows', 'image_file_id', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (110, 'shows', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (111, 'shows', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (112, 'shows_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'shows_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (113, 'shows_translations', 'shows_id', 'shows', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (114, 'shows_usergroups', 'shows_id', 'shows', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (115, 'shows_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'shows_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (116, 'tags', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (117, 'tags', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (118, 'tags_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'tags_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (119, 'tags_translations', 'tags_id', 'tags', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (120, 'usergroups', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (121, 'usergroups', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (122, 'webconfig', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true) FROM "public"."directus_relations";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_roles" RECORDS ---

INSERT INTO "public"."directus_roles" ("id", "name", "icon", "description", "ip_access", "enforce_tfa", "admin_access", "app_access")  VALUES ('e98ac1dc-b0bb-427f-9c30-359cdd12353e', 'Administrator', 'verified', '$t:admin_description', NULL, false, true, true);

--- END SYNCHRONIZE TABLE "public"."directus_roles" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-09-02T11:45:17.620Z            ***/
/**********************************************************/

--- BEGIN CREATE SEQUENCE "public"."calendarevent_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."calendarevent_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."calendarevent_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."calendarevent_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."calendarevent_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."calendarevent_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."calendarevent_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."calendarevent_id_seq" ---

--- BEGIN ALTER TABLE "public"."materialized_views_meta" ---

ALTER TABLE IF EXISTS "public"."materialized_views_meta" DROP CONSTRAINT IF EXISTS "materialized_views_meta_pkey";

--- END ALTER TABLE "public"."materialized_views_meta" ---

--- BEGIN CREATE TABLE "public"."calendarevent" ---

CREATE TABLE IF NOT EXISTS "public"."calendarevent" (
	"id" int4 NOT NULL DEFAULT nextval('calendarevent_id_seq'::regclass) ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"start" timestamp NOT NULL  ,
	"end" timestamp NULL  ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "calendarevent_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "calendarevent_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "calendarevent_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) 
);

ALTER TABLE IF EXISTS "public"."calendarevent" OWNER TO btv;

GRANT SELECT ON TABLE "public"."calendarevent" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."calendarevent" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."calendarevent" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."calendarevent" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."calendarevent" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."calendarevent" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."calendarevent" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."calendarevent"."id"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."status"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."start"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."end"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."title"  IS NULL;

COMMENT ON CONSTRAINT "calendarevent_pkey" ON "public"."calendarevent" IS NULL;


COMMENT ON CONSTRAINT "calendarevent_user_created_foreign" ON "public"."calendarevent" IS NULL;


COMMENT ON CONSTRAINT "calendarevent_user_updated_foreign" ON "public"."calendarevent" IS NULL;

COMMENT ON TABLE "public"."calendarevent"  IS NULL;

--- END CREATE TABLE "public"."calendarevent" ---

--- BEGIN ALTER TABLE "public"."directus_dashboards" ---

ALTER TABLE IF EXISTS "public"."directus_dashboards" DROP COLUMN IF EXISTS "color" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_dashboards" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

ALTER TABLE IF EXISTS "public"."pages_translations" DROP CONSTRAINT IF EXISTS "pages_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "title" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "description" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."pages_translations" ADD CONSTRAINT "pages_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_translations_languages_code_foreign" ON "public"."pages_translations" IS NULL;

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'FAQ';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'faq_categories';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'faq_categories_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'faqs';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'faqs_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'faqs_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'ageratings_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'asset_management';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'assetfiles';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'assets';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'assetstreams';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'assetstreams_audio_languages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'assetstreams_subtitle_languages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'calendar';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'calendarentries';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'calendarentries_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'events';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'events_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'config';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'ageratings';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'appconfig';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'globalconfig';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'languages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'webconfig';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'episodes_categories';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'lists_relations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'main_content';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'episodes';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'episodes_tags';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'episodes_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'episodes_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'episodes_usergroups_download';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'episodes_usergroups_earlyaccess';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'seasons';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'seasons_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'shows';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'shows_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'maintenance_messages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'maintenancemessage';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'messagetemplates';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'messagetemplates_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'maintenancemessage_messagetemplates';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'materialized_views_meta';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'page_management';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'categories';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'categories_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'collections';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'collections_items';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'lists';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'pages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'pages_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'sections';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'sections_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'sections_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'tags';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'tags_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'seasons_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'shows_usergroups';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1;

DELETE FROM "public"."directus_fields" WHERE "id" = 2;

DELETE FROM "public"."directus_fields" WHERE "id" = 3;

DELETE FROM "public"."directus_fields" WHERE "id" = 4;

DELETE FROM "public"."directus_fields" WHERE "id" = 5;

DELETE FROM "public"."directus_fields" WHERE "id" = 6;

DELETE FROM "public"."directus_fields" WHERE "id" = 7;

DELETE FROM "public"."directus_fields" WHERE "id" = 8;

DELETE FROM "public"."directus_fields" WHERE "id" = 9;

DELETE FROM "public"."directus_fields" WHERE "id" = 10;

DELETE FROM "public"."directus_fields" WHERE "id" = 11;

DELETE FROM "public"."directus_fields" WHERE "id" = 12;

DELETE FROM "public"."directus_fields" WHERE "id" = 13;

DELETE FROM "public"."directus_fields" WHERE "id" = 14;

DELETE FROM "public"."directus_fields" WHERE "id" = 15;

DELETE FROM "public"."directus_fields" WHERE "id" = 16;

DELETE FROM "public"."directus_fields" WHERE "id" = 17;

DELETE FROM "public"."directus_fields" WHERE "id" = 18;

DELETE FROM "public"."directus_fields" WHERE "id" = 19;

DELETE FROM "public"."directus_fields" WHERE "id" = 20;

DELETE FROM "public"."directus_fields" WHERE "id" = 21;

DELETE FROM "public"."directus_fields" WHERE "id" = 22;

DELETE FROM "public"."directus_fields" WHERE "id" = 23;

DELETE FROM "public"."directus_fields" WHERE "id" = 24;

DELETE FROM "public"."directus_fields" WHERE "id" = 25;

DELETE FROM "public"."directus_fields" WHERE "id" = 26;

DELETE FROM "public"."directus_fields" WHERE "id" = 27;

DELETE FROM "public"."directus_fields" WHERE "id" = 28;

DELETE FROM "public"."directus_fields" WHERE "id" = 29;

DELETE FROM "public"."directus_fields" WHERE "id" = 30;

DELETE FROM "public"."directus_fields" WHERE "id" = 31;

DELETE FROM "public"."directus_fields" WHERE "id" = 32;

DELETE FROM "public"."directus_fields" WHERE "id" = 33;

DELETE FROM "public"."directus_fields" WHERE "id" = 34;

DELETE FROM "public"."directus_fields" WHERE "id" = 35;

DELETE FROM "public"."directus_fields" WHERE "id" = 36;

DELETE FROM "public"."directus_fields" WHERE "id" = 37;

DELETE FROM "public"."directus_fields" WHERE "id" = 38;

DELETE FROM "public"."directus_fields" WHERE "id" = 39;

DELETE FROM "public"."directus_fields" WHERE "id" = 40;

DELETE FROM "public"."directus_fields" WHERE "id" = 41;

DELETE FROM "public"."directus_fields" WHERE "id" = 42;

DELETE FROM "public"."directus_fields" WHERE "id" = 43;

DELETE FROM "public"."directus_fields" WHERE "id" = 44;

DELETE FROM "public"."directus_fields" WHERE "id" = 45;

DELETE FROM "public"."directus_fields" WHERE "id" = 46;

DELETE FROM "public"."directus_fields" WHERE "id" = 47;

DELETE FROM "public"."directus_fields" WHERE "id" = 48;

DELETE FROM "public"."directus_fields" WHERE "id" = 49;

DELETE FROM "public"."directus_fields" WHERE "id" = 50;

DELETE FROM "public"."directus_fields" WHERE "id" = 51;

DELETE FROM "public"."directus_fields" WHERE "id" = 52;

DELETE FROM "public"."directus_fields" WHERE "id" = 53;

DELETE FROM "public"."directus_fields" WHERE "id" = 54;

DELETE FROM "public"."directus_fields" WHERE "id" = 55;

DELETE FROM "public"."directus_fields" WHERE "id" = 56;

DELETE FROM "public"."directus_fields" WHERE "id" = 57;

DELETE FROM "public"."directus_fields" WHERE "id" = 177;

DELETE FROM "public"."directus_fields" WHERE "id" = 58;

DELETE FROM "public"."directus_fields" WHERE "id" = 59;

DELETE FROM "public"."directus_fields" WHERE "id" = 60;

DELETE FROM "public"."directus_fields" WHERE "id" = 61;

DELETE FROM "public"."directus_fields" WHERE "id" = 62;

DELETE FROM "public"."directus_fields" WHERE "id" = 63;

DELETE FROM "public"."directus_fields" WHERE "id" = 64;

DELETE FROM "public"."directus_fields" WHERE "id" = 65;

DELETE FROM "public"."directus_fields" WHERE "id" = 66;

DELETE FROM "public"."directus_fields" WHERE "id" = 67;

DELETE FROM "public"."directus_fields" WHERE "id" = 68;

DELETE FROM "public"."directus_fields" WHERE "id" = 69;

DELETE FROM "public"."directus_fields" WHERE "id" = 70;

DELETE FROM "public"."directus_fields" WHERE "id" = 71;

DELETE FROM "public"."directus_fields" WHERE "id" = 72;

DELETE FROM "public"."directus_fields" WHERE "id" = 73;

DELETE FROM "public"."directus_fields" WHERE "id" = 74;

DELETE FROM "public"."directus_fields" WHERE "id" = 75;

DELETE FROM "public"."directus_fields" WHERE "id" = 76;

DELETE FROM "public"."directus_fields" WHERE "id" = 77;

DELETE FROM "public"."directus_fields" WHERE "id" = 78;

DELETE FROM "public"."directus_fields" WHERE "id" = 79;

DELETE FROM "public"."directus_fields" WHERE "id" = 80;

DELETE FROM "public"."directus_fields" WHERE "id" = 81;

DELETE FROM "public"."directus_fields" WHERE "id" = 82;

DELETE FROM "public"."directus_fields" WHERE "id" = 83;

DELETE FROM "public"."directus_fields" WHERE "id" = 84;

DELETE FROM "public"."directus_fields" WHERE "id" = 85;

DELETE FROM "public"."directus_fields" WHERE "id" = 86;

DELETE FROM "public"."directus_fields" WHERE "id" = 87;

DELETE FROM "public"."directus_fields" WHERE "id" = 88;

DELETE FROM "public"."directus_fields" WHERE "id" = 89;

DELETE FROM "public"."directus_fields" WHERE "id" = 90;

DELETE FROM "public"."directus_fields" WHERE "id" = 91;

DELETE FROM "public"."directus_fields" WHERE "id" = 92;

DELETE FROM "public"."directus_fields" WHERE "id" = 93;

DELETE FROM "public"."directus_fields" WHERE "id" = 94;

DELETE FROM "public"."directus_fields" WHERE "id" = 95;

DELETE FROM "public"."directus_fields" WHERE "id" = 96;

DELETE FROM "public"."directus_fields" WHERE "id" = 97;

DELETE FROM "public"."directus_fields" WHERE "id" = 98;

DELETE FROM "public"."directus_fields" WHERE "id" = 99;

DELETE FROM "public"."directus_fields" WHERE "id" = 100;

DELETE FROM "public"."directus_fields" WHERE "id" = 101;

DELETE FROM "public"."directus_fields" WHERE "id" = 102;

DELETE FROM "public"."directus_fields" WHERE "id" = 103;

DELETE FROM "public"."directus_fields" WHERE "id" = 104;

DELETE FROM "public"."directus_fields" WHERE "id" = 105;

DELETE FROM "public"."directus_fields" WHERE "id" = 106;

DELETE FROM "public"."directus_fields" WHERE "id" = 107;

DELETE FROM "public"."directus_fields" WHERE "id" = 108;

DELETE FROM "public"."directus_fields" WHERE "id" = 288;

DELETE FROM "public"."directus_fields" WHERE "id" = 109;

DELETE FROM "public"."directus_fields" WHERE "id" = 110;

DELETE FROM "public"."directus_fields" WHERE "id" = 111;

DELETE FROM "public"."directus_fields" WHERE "id" = 112;

DELETE FROM "public"."directus_fields" WHERE "id" = 113;

DELETE FROM "public"."directus_fields" WHERE "id" = 114;

DELETE FROM "public"."directus_fields" WHERE "id" = 115;

DELETE FROM "public"."directus_fields" WHERE "id" = 116;

DELETE FROM "public"."directus_fields" WHERE "id" = 117;

DELETE FROM "public"."directus_fields" WHERE "id" = 118;

DELETE FROM "public"."directus_fields" WHERE "id" = 119;

DELETE FROM "public"."directus_fields" WHERE "id" = 120;

DELETE FROM "public"."directus_fields" WHERE "id" = 121;

DELETE FROM "public"."directus_fields" WHERE "id" = 122;

DELETE FROM "public"."directus_fields" WHERE "id" = 123;

DELETE FROM "public"."directus_fields" WHERE "id" = 124;

DELETE FROM "public"."directus_fields" WHERE "id" = 125;

DELETE FROM "public"."directus_fields" WHERE "id" = 126;

DELETE FROM "public"."directus_fields" WHERE "id" = 127;

DELETE FROM "public"."directus_fields" WHERE "id" = 128;

DELETE FROM "public"."directus_fields" WHERE "id" = 129;

DELETE FROM "public"."directus_fields" WHERE "id" = 130;

DELETE FROM "public"."directus_fields" WHERE "id" = 131;

DELETE FROM "public"."directus_fields" WHERE "id" = 132;

DELETE FROM "public"."directus_fields" WHERE "id" = 133;

DELETE FROM "public"."directus_fields" WHERE "id" = 134;

DELETE FROM "public"."directus_fields" WHERE "id" = 135;

DELETE FROM "public"."directus_fields" WHERE "id" = 136;

DELETE FROM "public"."directus_fields" WHERE "id" = 137;

DELETE FROM "public"."directus_fields" WHERE "id" = 138;

DELETE FROM "public"."directus_fields" WHERE "id" = 139;

DELETE FROM "public"."directus_fields" WHERE "id" = 140;

DELETE FROM "public"."directus_fields" WHERE "id" = 141;

DELETE FROM "public"."directus_fields" WHERE "id" = 142;

DELETE FROM "public"."directus_fields" WHERE "id" = 143;

DELETE FROM "public"."directus_fields" WHERE "id" = 144;

DELETE FROM "public"."directus_fields" WHERE "id" = 145;

DELETE FROM "public"."directus_fields" WHERE "id" = 146;

DELETE FROM "public"."directus_fields" WHERE "id" = 147;

DELETE FROM "public"."directus_fields" WHERE "id" = 148;

DELETE FROM "public"."directus_fields" WHERE "id" = 149;

DELETE FROM "public"."directus_fields" WHERE "id" = 150;

DELETE FROM "public"."directus_fields" WHERE "id" = 151;

DELETE FROM "public"."directus_fields" WHERE "id" = 152;

DELETE FROM "public"."directus_fields" WHERE "id" = 153;

DELETE FROM "public"."directus_fields" WHERE "id" = 154;

DELETE FROM "public"."directus_fields" WHERE "id" = 155;

DELETE FROM "public"."directus_fields" WHERE "id" = 156;

DELETE FROM "public"."directus_fields" WHERE "id" = 157;

DELETE FROM "public"."directus_fields" WHERE "id" = 158;

DELETE FROM "public"."directus_fields" WHERE "id" = 159;

DELETE FROM "public"."directus_fields" WHERE "id" = 160;

DELETE FROM "public"."directus_fields" WHERE "id" = 161;

DELETE FROM "public"."directus_fields" WHERE "id" = 162;

DELETE FROM "public"."directus_fields" WHERE "id" = 163;

DELETE FROM "public"."directus_fields" WHERE "id" = 164;

DELETE FROM "public"."directus_fields" WHERE "id" = 165;

DELETE FROM "public"."directus_fields" WHERE "id" = 166;

DELETE FROM "public"."directus_fields" WHERE "id" = 167;

DELETE FROM "public"."directus_fields" WHERE "id" = 168;

DELETE FROM "public"."directus_fields" WHERE "id" = 169;

DELETE FROM "public"."directus_fields" WHERE "id" = 170;

DELETE FROM "public"."directus_fields" WHERE "id" = 171;

DELETE FROM "public"."directus_fields" WHERE "id" = 172;

DELETE FROM "public"."directus_fields" WHERE "id" = 173;

DELETE FROM "public"."directus_fields" WHERE "id" = 174;

DELETE FROM "public"."directus_fields" WHERE "id" = 175;

DELETE FROM "public"."directus_fields" WHERE "id" = 176;

DELETE FROM "public"."directus_fields" WHERE "id" = 178;

DELETE FROM "public"."directus_fields" WHERE "id" = 179;

DELETE FROM "public"."directus_fields" WHERE "id" = 180;

DELETE FROM "public"."directus_fields" WHERE "id" = 181;

DELETE FROM "public"."directus_fields" WHERE "id" = 182;

DELETE FROM "public"."directus_fields" WHERE "id" = 183;

DELETE FROM "public"."directus_fields" WHERE "id" = 184;

DELETE FROM "public"."directus_fields" WHERE "id" = 185;

DELETE FROM "public"."directus_fields" WHERE "id" = 186;

DELETE FROM "public"."directus_fields" WHERE "id" = 187;

DELETE FROM "public"."directus_fields" WHERE "id" = 188;

DELETE FROM "public"."directus_fields" WHERE "id" = 189;

DELETE FROM "public"."directus_fields" WHERE "id" = 190;

DELETE FROM "public"."directus_fields" WHERE "id" = 191;

DELETE FROM "public"."directus_fields" WHERE "id" = 192;

DELETE FROM "public"."directus_fields" WHERE "id" = 193;

DELETE FROM "public"."directus_fields" WHERE "id" = 194;

DELETE FROM "public"."directus_fields" WHERE "id" = 195;

DELETE FROM "public"."directus_fields" WHERE "id" = 196;

DELETE FROM "public"."directus_fields" WHERE "id" = 197;

DELETE FROM "public"."directus_fields" WHERE "id" = 198;

DELETE FROM "public"."directus_fields" WHERE "id" = 199;

DELETE FROM "public"."directus_fields" WHERE "id" = 200;

DELETE FROM "public"."directus_fields" WHERE "id" = 201;

DELETE FROM "public"."directus_fields" WHERE "id" = 202;

DELETE FROM "public"."directus_fields" WHERE "id" = 203;

DELETE FROM "public"."directus_fields" WHERE "id" = 204;

DELETE FROM "public"."directus_fields" WHERE "id" = 205;

DELETE FROM "public"."directus_fields" WHERE "id" = 206;

DELETE FROM "public"."directus_fields" WHERE "id" = 207;

DELETE FROM "public"."directus_fields" WHERE "id" = 208;

DELETE FROM "public"."directus_fields" WHERE "id" = 209;

DELETE FROM "public"."directus_fields" WHERE "id" = 210;

DELETE FROM "public"."directus_fields" WHERE "id" = 211;

DELETE FROM "public"."directus_fields" WHERE "id" = 212;

DELETE FROM "public"."directus_fields" WHERE "id" = 213;

DELETE FROM "public"."directus_fields" WHERE "id" = 214;

DELETE FROM "public"."directus_fields" WHERE "id" = 215;

DELETE FROM "public"."directus_fields" WHERE "id" = 216;

DELETE FROM "public"."directus_fields" WHERE "id" = 217;

DELETE FROM "public"."directus_fields" WHERE "id" = 218;

DELETE FROM "public"."directus_fields" WHERE "id" = 219;

DELETE FROM "public"."directus_fields" WHERE "id" = 220;

DELETE FROM "public"."directus_fields" WHERE "id" = 221;

DELETE FROM "public"."directus_fields" WHERE "id" = 222;

DELETE FROM "public"."directus_fields" WHERE "id" = 223;

DELETE FROM "public"."directus_fields" WHERE "id" = 224;

DELETE FROM "public"."directus_fields" WHERE "id" = 225;

DELETE FROM "public"."directus_fields" WHERE "id" = 226;

DELETE FROM "public"."directus_fields" WHERE "id" = 227;

DELETE FROM "public"."directus_fields" WHERE "id" = 228;

DELETE FROM "public"."directus_fields" WHERE "id" = 229;

DELETE FROM "public"."directus_fields" WHERE "id" = 230;

DELETE FROM "public"."directus_fields" WHERE "id" = 231;

DELETE FROM "public"."directus_fields" WHERE "id" = 232;

DELETE FROM "public"."directus_fields" WHERE "id" = 383;

DELETE FROM "public"."directus_fields" WHERE "id" = 233;

DELETE FROM "public"."directus_fields" WHERE "id" = 234;

DELETE FROM "public"."directus_fields" WHERE "id" = 235;

DELETE FROM "public"."directus_fields" WHERE "id" = 236;

DELETE FROM "public"."directus_fields" WHERE "id" = 237;

DELETE FROM "public"."directus_fields" WHERE "id" = 238;

DELETE FROM "public"."directus_fields" WHERE "id" = 239;

DELETE FROM "public"."directus_fields" WHERE "id" = 240;

DELETE FROM "public"."directus_fields" WHERE "id" = 241;

DELETE FROM "public"."directus_fields" WHERE "id" = 242;

DELETE FROM "public"."directus_fields" WHERE "id" = 243;

DELETE FROM "public"."directus_fields" WHERE "id" = 244;

DELETE FROM "public"."directus_fields" WHERE "id" = 245;

DELETE FROM "public"."directus_fields" WHERE "id" = 246;

DELETE FROM "public"."directus_fields" WHERE "id" = 247;

DELETE FROM "public"."directus_fields" WHERE "id" = 248;

DELETE FROM "public"."directus_fields" WHERE "id" = 249;

DELETE FROM "public"."directus_fields" WHERE "id" = 250;

DELETE FROM "public"."directus_fields" WHERE "id" = 251;

DELETE FROM "public"."directus_fields" WHERE "id" = 252;

DELETE FROM "public"."directus_fields" WHERE "id" = 253;

DELETE FROM "public"."directus_fields" WHERE "id" = 254;

DELETE FROM "public"."directus_fields" WHERE "id" = 255;

DELETE FROM "public"."directus_fields" WHERE "id" = 256;

DELETE FROM "public"."directus_fields" WHERE "id" = 257;

DELETE FROM "public"."directus_fields" WHERE "id" = 258;

DELETE FROM "public"."directus_fields" WHERE "id" = 259;

DELETE FROM "public"."directus_fields" WHERE "id" = 260;

DELETE FROM "public"."directus_fields" WHERE "id" = 261;

DELETE FROM "public"."directus_fields" WHERE "id" = 262;

DELETE FROM "public"."directus_fields" WHERE "id" = 263;

DELETE FROM "public"."directus_fields" WHERE "id" = 264;

DELETE FROM "public"."directus_fields" WHERE "id" = 265;

DELETE FROM "public"."directus_fields" WHERE "id" = 266;

DELETE FROM "public"."directus_fields" WHERE "id" = 267;

DELETE FROM "public"."directus_fields" WHERE "id" = 268;

DELETE FROM "public"."directus_fields" WHERE "id" = 269;

DELETE FROM "public"."directus_fields" WHERE "id" = 270;

DELETE FROM "public"."directus_fields" WHERE "id" = 271;

DELETE FROM "public"."directus_fields" WHERE "id" = 272;

DELETE FROM "public"."directus_fields" WHERE "id" = 273;

DELETE FROM "public"."directus_fields" WHERE "id" = 274;

DELETE FROM "public"."directus_fields" WHERE "id" = 275;

DELETE FROM "public"."directus_fields" WHERE "id" = 276;

DELETE FROM "public"."directus_fields" WHERE "id" = 277;

DELETE FROM "public"."directus_fields" WHERE "id" = 278;

DELETE FROM "public"."directus_fields" WHERE "id" = 279;

DELETE FROM "public"."directus_fields" WHERE "id" = 280;

DELETE FROM "public"."directus_fields" WHERE "id" = 281;

DELETE FROM "public"."directus_fields" WHERE "id" = 282;

DELETE FROM "public"."directus_fields" WHERE "id" = 283;

DELETE FROM "public"."directus_fields" WHERE "id" = 284;

DELETE FROM "public"."directus_fields" WHERE "id" = 285;

DELETE FROM "public"."directus_fields" WHERE "id" = 286;

DELETE FROM "public"."directus_fields" WHERE "id" = 287;

DELETE FROM "public"."directus_fields" WHERE "id" = 381;

DELETE FROM "public"."directus_fields" WHERE "id" = 289;

DELETE FROM "public"."directus_fields" WHERE "id" = 290;

DELETE FROM "public"."directus_fields" WHERE "id" = 291;

DELETE FROM "public"."directus_fields" WHERE "id" = 292;

DELETE FROM "public"."directus_fields" WHERE "id" = 293;

DELETE FROM "public"."directus_fields" WHERE "id" = 294;

DELETE FROM "public"."directus_fields" WHERE "id" = 295;

DELETE FROM "public"."directus_fields" WHERE "id" = 296;

DELETE FROM "public"."directus_fields" WHERE "id" = 297;

DELETE FROM "public"."directus_fields" WHERE "id" = 298;

DELETE FROM "public"."directus_fields" WHERE "id" = 299;

DELETE FROM "public"."directus_fields" WHERE "id" = 300;

DELETE FROM "public"."directus_fields" WHERE "id" = 301;

DELETE FROM "public"."directus_fields" WHERE "id" = 302;

DELETE FROM "public"."directus_fields" WHERE "id" = 303;

DELETE FROM "public"."directus_fields" WHERE "id" = 304;

DELETE FROM "public"."directus_fields" WHERE "id" = 305;

DELETE FROM "public"."directus_fields" WHERE "id" = 306;

DELETE FROM "public"."directus_fields" WHERE "id" = 307;

DELETE FROM "public"."directus_fields" WHERE "id" = 308;

DELETE FROM "public"."directus_fields" WHERE "id" = 309;

DELETE FROM "public"."directus_fields" WHERE "id" = 310;

DELETE FROM "public"."directus_fields" WHERE "id" = 311;

DELETE FROM "public"."directus_fields" WHERE "id" = 312;

DELETE FROM "public"."directus_fields" WHERE "id" = 313;

DELETE FROM "public"."directus_fields" WHERE "id" = 314;

DELETE FROM "public"."directus_fields" WHERE "id" = 315;

DELETE FROM "public"."directus_fields" WHERE "id" = 316;

DELETE FROM "public"."directus_fields" WHERE "id" = 317;

DELETE FROM "public"."directus_fields" WHERE "id" = 318;

DELETE FROM "public"."directus_fields" WHERE "id" = 319;

DELETE FROM "public"."directus_fields" WHERE "id" = 320;

DELETE FROM "public"."directus_fields" WHERE "id" = 321;

DELETE FROM "public"."directus_fields" WHERE "id" = 322;

DELETE FROM "public"."directus_fields" WHERE "id" = 323;

DELETE FROM "public"."directus_fields" WHERE "id" = 324;

DELETE FROM "public"."directus_fields" WHERE "id" = 325;

DELETE FROM "public"."directus_fields" WHERE "id" = 326;

DELETE FROM "public"."directus_fields" WHERE "id" = 327;

DELETE FROM "public"."directus_fields" WHERE "id" = 328;

DELETE FROM "public"."directus_fields" WHERE "id" = 329;

DELETE FROM "public"."directus_fields" WHERE "id" = 330;

DELETE FROM "public"."directus_fields" WHERE "id" = 331;

DELETE FROM "public"."directus_fields" WHERE "id" = 332;

DELETE FROM "public"."directus_fields" WHERE "id" = 333;

DELETE FROM "public"."directus_fields" WHERE "id" = 334;

DELETE FROM "public"."directus_fields" WHERE "id" = 335;

DELETE FROM "public"."directus_fields" WHERE "id" = 336;

DELETE FROM "public"."directus_fields" WHERE "id" = 337;

DELETE FROM "public"."directus_fields" WHERE "id" = 338;

DELETE FROM "public"."directus_fields" WHERE "id" = 382;

DELETE FROM "public"."directus_fields" WHERE "id" = 339;

DELETE FROM "public"."directus_fields" WHERE "id" = 340;

DELETE FROM "public"."directus_fields" WHERE "id" = 341;

DELETE FROM "public"."directus_fields" WHERE "id" = 342;

DELETE FROM "public"."directus_fields" WHERE "id" = 343;

DELETE FROM "public"."directus_fields" WHERE "id" = 344;

DELETE FROM "public"."directus_fields" WHERE "id" = 345;

DELETE FROM "public"."directus_fields" WHERE "id" = 346;

DELETE FROM "public"."directus_fields" WHERE "id" = 347;

DELETE FROM "public"."directus_fields" WHERE "id" = 348;

DELETE FROM "public"."directus_fields" WHERE "id" = 349;

DELETE FROM "public"."directus_fields" WHERE "id" = 350;

DELETE FROM "public"."directus_fields" WHERE "id" = 351;

DELETE FROM "public"."directus_fields" WHERE "id" = 352;

DELETE FROM "public"."directus_fields" WHERE "id" = 353;

DELETE FROM "public"."directus_fields" WHERE "id" = 354;

DELETE FROM "public"."directus_fields" WHERE "id" = 355;

DELETE FROM "public"."directus_fields" WHERE "id" = 356;

DELETE FROM "public"."directus_fields" WHERE "id" = 357;

DELETE FROM "public"."directus_fields" WHERE "id" = 358;

DELETE FROM "public"."directus_fields" WHERE "id" = 359;

DELETE FROM "public"."directus_fields" WHERE "id" = 360;

DELETE FROM "public"."directus_fields" WHERE "id" = 361;

DELETE FROM "public"."directus_fields" WHERE "id" = 362;

DELETE FROM "public"."directus_fields" WHERE "id" = 363;

DELETE FROM "public"."directus_fields" WHERE "id" = 364;

DELETE FROM "public"."directus_fields" WHERE "id" = 365;

DELETE FROM "public"."directus_fields" WHERE "id" = 366;

DELETE FROM "public"."directus_fields" WHERE "id" = 367;

DELETE FROM "public"."directus_fields" WHERE "id" = 368;

DELETE FROM "public"."directus_fields" WHERE "id" = 369;

DELETE FROM "public"."directus_fields" WHERE "id" = 370;

DELETE FROM "public"."directus_fields" WHERE "id" = 371;

DELETE FROM "public"."directus_fields" WHERE "id" = 372;

DELETE FROM "public"."directus_fields" WHERE "id" = 373;

DELETE FROM "public"."directus_fields" WHERE "id" = 374;

DELETE FROM "public"."directus_fields" WHERE "id" = 375;

DELETE FROM "public"."directus_fields" WHERE "id" = 376;

DELETE FROM "public"."directus_fields" WHERE "id" = 377;

DELETE FROM "public"."directus_fields" WHERE "id" = 378;

DELETE FROM "public"."directus_fields" WHERE "id" = 379;

DELETE FROM "public"."directus_fields" WHERE "id" = 380;

DELETE FROM "public"."directus_fields" WHERE "id" = 384;

DELETE FROM "public"."directus_fields" WHERE "id" = 385;

DELETE FROM "public"."directus_fields" WHERE "id" = 386;

DELETE FROM "public"."directus_fields" WHERE "id" = 387;

DELETE FROM "public"."directus_fields" WHERE "id" = 388;

DELETE FROM "public"."directus_fields" WHERE "id" = 389;

DELETE FROM "public"."directus_fields" WHERE "id" = 390;

DELETE FROM "public"."directus_fields" WHERE "id" = 391;

DELETE FROM "public"."directus_fields" WHERE "id" = 392;

DELETE FROM "public"."directus_fields" WHERE "id" = 393;

DELETE FROM "public"."directus_fields" WHERE "id" = 394;

DELETE FROM "public"."directus_fields" WHERE "id" = 395;

DELETE FROM "public"."directus_fields" WHERE "id" = 396;

DELETE FROM "public"."directus_fields" WHERE "id" = 397;

DELETE FROM "public"."directus_fields" WHERE "id" = 398;

DELETE FROM "public"."directus_fields" WHERE "id" = 399;

DELETE FROM "public"."directus_fields" WHERE "id" = 400;

DELETE FROM "public"."directus_fields" WHERE "id" = 401;

DELETE FROM "public"."directus_fields" WHERE "id" = 402;

DELETE FROM "public"."directus_fields" WHERE "id" = 403;

DELETE FROM "public"."directus_fields" WHERE "id" = 404;

DELETE FROM "public"."directus_fields" WHERE "id" = 405;

DELETE FROM "public"."directus_fields" WHERE "id" = 406;

DELETE FROM "public"."directus_fields" WHERE "id" = 407;

DELETE FROM "public"."directus_fields" WHERE "id" = 408;

DELETE FROM "public"."directus_fields" WHERE "id" = 409;

DELETE FROM "public"."directus_fields" WHERE "id" = 410;

DELETE FROM "public"."directus_fields" WHERE "id" = 411;

DELETE FROM "public"."directus_fields" WHERE "id" = 412;

DELETE FROM "public"."directus_fields" WHERE "id" = 413;

DELETE FROM "public"."directus_fields" WHERE "id" = 414;

DELETE FROM "public"."directus_fields" WHERE "id" = 415;

DELETE FROM "public"."directus_fields" WHERE "id" = 416;

DELETE FROM "public"."directus_fields" WHERE "id" = 417;

DELETE FROM "public"."directus_fields" WHERE "id" = 418;

DELETE FROM "public"."directus_fields" WHERE "id" = 419;

DELETE FROM "public"."directus_fields" WHERE "id" = 420;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

DELETE FROM "public"."directus_migrations" WHERE "version" = '20201028A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20201029A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20201029B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20201029C';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20201105A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20201105B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210225A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210304A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210312A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210331A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210415A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210416A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210422A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210506A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210510A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210518A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210519A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210521A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210525A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210608A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210626A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210716A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210721A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210802A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210803A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210805A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210805B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210811A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210831A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210903A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210907A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210910A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210920A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210924A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210927A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210927B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20210929A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211007A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211009A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211016A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211103A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211103B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211104A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211118A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211211A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20211230A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220303A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220308A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220314A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220322A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220323A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220325A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220325B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220402A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220429A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220429B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220429C';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220429D';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220614A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220801A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20220802A';

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 1;

DELETE FROM "public"."directus_relations" WHERE "id" = 2;

DELETE FROM "public"."directus_relations" WHERE "id" = 3;

DELETE FROM "public"."directus_relations" WHERE "id" = 4;

DELETE FROM "public"."directus_relations" WHERE "id" = 5;

DELETE FROM "public"."directus_relations" WHERE "id" = 6;

DELETE FROM "public"."directus_relations" WHERE "id" = 7;

DELETE FROM "public"."directus_relations" WHERE "id" = 8;

DELETE FROM "public"."directus_relations" WHERE "id" = 9;

DELETE FROM "public"."directus_relations" WHERE "id" = 10;

DELETE FROM "public"."directus_relations" WHERE "id" = 11;

DELETE FROM "public"."directus_relations" WHERE "id" = 12;

DELETE FROM "public"."directus_relations" WHERE "id" = 13;

DELETE FROM "public"."directus_relations" WHERE "id" = 14;

DELETE FROM "public"."directus_relations" WHERE "id" = 15;

DELETE FROM "public"."directus_relations" WHERE "id" = 16;

DELETE FROM "public"."directus_relations" WHERE "id" = 17;

DELETE FROM "public"."directus_relations" WHERE "id" = 18;

DELETE FROM "public"."directus_relations" WHERE "id" = 19;

DELETE FROM "public"."directus_relations" WHERE "id" = 20;

DELETE FROM "public"."directus_relations" WHERE "id" = 21;

DELETE FROM "public"."directus_relations" WHERE "id" = 22;

DELETE FROM "public"."directus_relations" WHERE "id" = 23;

DELETE FROM "public"."directus_relations" WHERE "id" = 24;

DELETE FROM "public"."directus_relations" WHERE "id" = 25;

DELETE FROM "public"."directus_relations" WHERE "id" = 26;

DELETE FROM "public"."directus_relations" WHERE "id" = 27;

DELETE FROM "public"."directus_relations" WHERE "id" = 28;

DELETE FROM "public"."directus_relations" WHERE "id" = 29;

DELETE FROM "public"."directus_relations" WHERE "id" = 30;

DELETE FROM "public"."directus_relations" WHERE "id" = 31;

DELETE FROM "public"."directus_relations" WHERE "id" = 32;

DELETE FROM "public"."directus_relations" WHERE "id" = 33;

DELETE FROM "public"."directus_relations" WHERE "id" = 34;

DELETE FROM "public"."directus_relations" WHERE "id" = 35;

DELETE FROM "public"."directus_relations" WHERE "id" = 36;

DELETE FROM "public"."directus_relations" WHERE "id" = 37;

DELETE FROM "public"."directus_relations" WHERE "id" = 38;

DELETE FROM "public"."directus_relations" WHERE "id" = 39;

DELETE FROM "public"."directus_relations" WHERE "id" = 40;

DELETE FROM "public"."directus_relations" WHERE "id" = 41;

DELETE FROM "public"."directus_relations" WHERE "id" = 42;

DELETE FROM "public"."directus_relations" WHERE "id" = 43;

DELETE FROM "public"."directus_relations" WHERE "id" = 44;

DELETE FROM "public"."directus_relations" WHERE "id" = 45;

DELETE FROM "public"."directus_relations" WHERE "id" = 46;

DELETE FROM "public"."directus_relations" WHERE "id" = 47;

DELETE FROM "public"."directus_relations" WHERE "id" = 48;

DELETE FROM "public"."directus_relations" WHERE "id" = 49;

DELETE FROM "public"."directus_relations" WHERE "id" = 50;

DELETE FROM "public"."directus_relations" WHERE "id" = 51;

DELETE FROM "public"."directus_relations" WHERE "id" = 52;

DELETE FROM "public"."directus_relations" WHERE "id" = 53;

DELETE FROM "public"."directus_relations" WHERE "id" = 54;

DELETE FROM "public"."directus_relations" WHERE "id" = 55;

DELETE FROM "public"."directus_relations" WHERE "id" = 56;

DELETE FROM "public"."directus_relations" WHERE "id" = 57;

DELETE FROM "public"."directus_relations" WHERE "id" = 58;

DELETE FROM "public"."directus_relations" WHERE "id" = 59;

DELETE FROM "public"."directus_relations" WHERE "id" = 60;

DELETE FROM "public"."directus_relations" WHERE "id" = 61;

DELETE FROM "public"."directus_relations" WHERE "id" = 62;

DELETE FROM "public"."directus_relations" WHERE "id" = 63;

DELETE FROM "public"."directus_relations" WHERE "id" = 64;

DELETE FROM "public"."directus_relations" WHERE "id" = 65;

DELETE FROM "public"."directus_relations" WHERE "id" = 66;

DELETE FROM "public"."directus_relations" WHERE "id" = 67;

DELETE FROM "public"."directus_relations" WHERE "id" = 68;

DELETE FROM "public"."directus_relations" WHERE "id" = 69;

DELETE FROM "public"."directus_relations" WHERE "id" = 70;

DELETE FROM "public"."directus_relations" WHERE "id" = 71;

DELETE FROM "public"."directus_relations" WHERE "id" = 72;

DELETE FROM "public"."directus_relations" WHERE "id" = 73;

DELETE FROM "public"."directus_relations" WHERE "id" = 74;

DELETE FROM "public"."directus_relations" WHERE "id" = 75;

DELETE FROM "public"."directus_relations" WHERE "id" = 76;

DELETE FROM "public"."directus_relations" WHERE "id" = 77;

DELETE FROM "public"."directus_relations" WHERE "id" = 78;

DELETE FROM "public"."directus_relations" WHERE "id" = 79;

DELETE FROM "public"."directus_relations" WHERE "id" = 80;

DELETE FROM "public"."directus_relations" WHERE "id" = 81;

DELETE FROM "public"."directus_relations" WHERE "id" = 82;

DELETE FROM "public"."directus_relations" WHERE "id" = 83;

DELETE FROM "public"."directus_relations" WHERE "id" = 84;

DELETE FROM "public"."directus_relations" WHERE "id" = 85;

DELETE FROM "public"."directus_relations" WHERE "id" = 86;

DELETE FROM "public"."directus_relations" WHERE "id" = 87;

DELETE FROM "public"."directus_relations" WHERE "id" = 88;

DELETE FROM "public"."directus_relations" WHERE "id" = 89;

DELETE FROM "public"."directus_relations" WHERE "id" = 90;

DELETE FROM "public"."directus_relations" WHERE "id" = 91;

DELETE FROM "public"."directus_relations" WHERE "id" = 92;

DELETE FROM "public"."directus_relations" WHERE "id" = 93;

DELETE FROM "public"."directus_relations" WHERE "id" = 94;

DELETE FROM "public"."directus_relations" WHERE "id" = 95;

DELETE FROM "public"."directus_relations" WHERE "id" = 96;

DELETE FROM "public"."directus_relations" WHERE "id" = 97;

DELETE FROM "public"."directus_relations" WHERE "id" = 98;

DELETE FROM "public"."directus_relations" WHERE "id" = 99;

DELETE FROM "public"."directus_relations" WHERE "id" = 100;

DELETE FROM "public"."directus_relations" WHERE "id" = 101;

DELETE FROM "public"."directus_relations" WHERE "id" = 102;

DELETE FROM "public"."directus_relations" WHERE "id" = 103;

DELETE FROM "public"."directus_relations" WHERE "id" = 104;

DELETE FROM "public"."directus_relations" WHERE "id" = 105;

DELETE FROM "public"."directus_relations" WHERE "id" = 106;

DELETE FROM "public"."directus_relations" WHERE "id" = 107;

DELETE FROM "public"."directus_relations" WHERE "id" = 108;

DELETE FROM "public"."directus_relations" WHERE "id" = 109;

DELETE FROM "public"."directus_relations" WHERE "id" = 110;

DELETE FROM "public"."directus_relations" WHERE "id" = 111;

DELETE FROM "public"."directus_relations" WHERE "id" = 112;

DELETE FROM "public"."directus_relations" WHERE "id" = 113;

DELETE FROM "public"."directus_relations" WHERE "id" = 114;

DELETE FROM "public"."directus_relations" WHERE "id" = 115;

DELETE FROM "public"."directus_relations" WHERE "id" = 116;

DELETE FROM "public"."directus_relations" WHERE "id" = 117;

DELETE FROM "public"."directus_relations" WHERE "id" = 118;

DELETE FROM "public"."directus_relations" WHERE "id" = 119;

DELETE FROM "public"."directus_relations" WHERE "id" = 120;

DELETE FROM "public"."directus_relations" WHERE "id" = 121;

DELETE FROM "public"."directus_relations" WHERE "id" = 122;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_roles" RECORDS ---

DELETE FROM "public"."directus_roles" WHERE "id" = 'e98ac1dc-b0bb-427f-9c30-359cdd12353e';

--- END SYNCHRONIZE TABLE "public"."directus_roles" RECORDS ---
