-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-09-05T11:51:02.918Z            ***/
/**********************************************************/

SET session_replication_role = 'replica';

--- BEGIN CREATE TABLE "public"."directus_roles" ---

CREATE TABLE IF NOT EXISTS "public"."directus_roles" (
	"id" uuid NOT NULL  ,
	"name" varchar(100) NOT NULL  ,
	"icon" varchar(30) NOT NULL DEFAULT 'supervised_user_circle'::character varying ,
	"description" text NULL  ,
	"ip_access" text NULL  ,
	"enforce_tfa" bool NOT NULL DEFAULT false ,
	"admin_access" bool NOT NULL DEFAULT false ,
	"app_access" bool NOT NULL DEFAULT true ,
	CONSTRAINT "directus_roles_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."directus_roles" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_roles"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_roles"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_roles"."icon"  IS NULL;


COMMENT ON COLUMN "public"."directus_roles"."description"  IS NULL;


COMMENT ON COLUMN "public"."directus_roles"."ip_access"  IS NULL;


COMMENT ON COLUMN "public"."directus_roles"."enforce_tfa"  IS NULL;


COMMENT ON COLUMN "public"."directus_roles"."admin_access"  IS NULL;


COMMENT ON COLUMN "public"."directus_roles"."app_access"  IS NULL;

COMMENT ON CONSTRAINT "directus_roles_pkey" ON "public"."directus_roles" IS NULL;

COMMENT ON TABLE "public"."directus_roles"  IS NULL;

--- END CREATE TABLE "public"."directus_roles" ---

--- BEGIN CREATE TABLE "public"."directus_users" ---

CREATE TABLE IF NOT EXISTS "public"."directus_users" (
	"id" uuid NOT NULL  ,
	"first_name" varchar(50) NULL  ,
	"last_name" varchar(50) NULL  ,
	"email" varchar(128) NULL  ,
	"password" varchar(255) NULL  ,
	"location" varchar(255) NULL  ,
	"title" varchar(50) NULL  ,
	"description" text NULL  ,
	"tags" json NULL  ,
	"avatar" uuid NULL  ,
	"language" varchar(255) NULL DEFAULT NULL::character varying ,
	"theme" varchar(20) NULL DEFAULT 'auto'::character varying ,
	"tfa_secret" varchar(255) NULL  ,
	"status" varchar(16) NOT NULL DEFAULT 'active'::character varying ,
	"role" uuid NULL  ,
	"token" varchar(255) NULL  ,
	"last_access" timestamptz NULL  ,
	"last_page" varchar(255) NULL  ,
	"provider" varchar(128) NOT NULL DEFAULT 'default'::character varying ,
	"external_identifier" varchar(255) NULL  ,
	"auth_data" json NULL  ,
	"email_notifications" bool NULL DEFAULT true ,
	CONSTRAINT "directus_users_email_unique" UNIQUE (email) ,
	CONSTRAINT "directus_users_external_identifier_unique" UNIQUE (external_identifier) ,
	CONSTRAINT "directus_users_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_users_token_unique" UNIQUE (token) ,
	CONSTRAINT "directus_users_role_foreign" FOREIGN KEY (role) REFERENCES directus_roles(id) ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS directus_users_email_unique ON public.directus_users USING btree (email);


CREATE UNIQUE INDEX IF NOT EXISTS directus_users_external_identifier_unique ON public.directus_users USING btree (external_identifier);


CREATE UNIQUE INDEX IF NOT EXISTS directus_users_token_unique ON public.directus_users USING btree (token);

ALTER TABLE IF EXISTS "public"."directus_users" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_users"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."first_name"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."last_name"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."email"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."password"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."location"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."title"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."description"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."tags"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."avatar"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."language"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."theme"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."tfa_secret"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."status"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."role"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."token"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."last_access"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."last_page"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."provider"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."external_identifier"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."auth_data"  IS NULL;


COMMENT ON COLUMN "public"."directus_users"."email_notifications"  IS NULL;

COMMENT ON CONSTRAINT "directus_users_email_unique" ON "public"."directus_users" IS NULL;


COMMENT ON CONSTRAINT "directus_users_external_identifier_unique" ON "public"."directus_users" IS NULL;


COMMENT ON CONSTRAINT "directus_users_pkey" ON "public"."directus_users" IS NULL;


COMMENT ON CONSTRAINT "directus_users_token_unique" ON "public"."directus_users" IS NULL;


COMMENT ON CONSTRAINT "directus_users_role_foreign" ON "public"."directus_users" IS NULL;

COMMENT ON INDEX "public"."directus_users_email_unique"  IS NULL;


COMMENT ON INDEX "public"."directus_users_external_identifier_unique"  IS NULL;


COMMENT ON INDEX "public"."directus_users_token_unique"  IS NULL;

COMMENT ON TABLE "public"."directus_users"  IS NULL;

--- END CREATE TABLE "public"."directus_users" ---

--- BEGIN CREATE TABLE "public"."languages" ---

CREATE TABLE IF NOT EXISTS "public"."languages" (
	"code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"legacy_2_letter_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"legacy_3_letter_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"name" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "languages_pkey" PRIMARY KEY (code)
);

ALTER TABLE IF EXISTS "public"."languages" OWNER TO manager;


COMMENT ON COLUMN "public"."languages"."code"  IS NULL;


COMMENT ON COLUMN "public"."languages"."legacy_2_letter_code"  IS NULL;


COMMENT ON COLUMN "public"."languages"."legacy_3_letter_code"  IS NULL;


COMMENT ON COLUMN "public"."languages"."name"  IS NULL;

COMMENT ON CONSTRAINT "languages_pkey" ON "public"."languages" IS NULL;

COMMENT ON TABLE "public"."languages"  IS NULL;

--- END CREATE TABLE "public"."languages" ---
--- BEGIN CREATE SEQUENCE "public"."ageratings_translations_id_seq" ---

CREATE SEQUENCE IF NOT EXISTS "public"."ageratings_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."ageratings_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."ageratings_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."ageratings_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."appconfig_id_seq" ---

CREATE SEQUENCE IF NOT EXISTS "public"."appconfig_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."appconfig_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."appconfig_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."appconfig_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."assetfiles_id_seq" ---

CREATE SEQUENCE IF NOT EXISTS "public"."assetfiles_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."assetfiles_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."assetfiles_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."assetfiles_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."assets_id_seq" ---

CREATE SEQUENCE IF NOT EXISTS "public"."assets_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."assets_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."assets_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."assets_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."assetstreams_audio_languages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."assetstreams_audio_languages_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."assetstreams_audio_languages_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."assetstreams_audio_languages_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."assetstreams_audio_languages_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."assetstreams_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."assetstreams_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."assetstreams_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."assetstreams_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."assetstreams_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."assetstreams_subtitle_languages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."assetstreams_subtitle_languages_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."assetstreams_subtitle_languages_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."assetstreams_subtitle_languages_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."assetstreams_subtitle_languages_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."calendarentries_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."calendarentries_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."calendarentries_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."calendarentries_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."calendarentries_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."calendarentries_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."calendarentries_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."calendarentries_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."calendarentries_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."calendarentries_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."calendarevent_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."calendarevent_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."calendarevent_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."calendarevent_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."calendarevent_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."categories_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."categories_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."categories_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."categories_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."categories_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."categories_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."categories_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."categories_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."categories_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."categories_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."collections_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."collections_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."collections_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."collections_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."collections_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."collections_items_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."collections_items_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."collections_items_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."collections_items_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."collections_items_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_activity_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_activity_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_activity_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_activity_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_activity_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_fields_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_fields_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_fields_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_fields_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_fields_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_notifications_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_notifications_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_notifications_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_notifications_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_notifications_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_permissions_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_permissions_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_permissions_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_permissions_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_permissions_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_presets_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_presets_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_presets_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_presets_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_presets_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_relations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_relations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_relations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_relations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_relations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_revisions_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_revisions_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_revisions_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_revisions_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_revisions_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_settings_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_settings_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_settings_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_settings_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_settings_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."directus_webhooks_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."directus_webhooks_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."directus_webhooks_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."directus_webhooks_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."directus_webhooks_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."episodes_categories_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_categories_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."episodes_categories_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."episodes_categories_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_categories_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."episodes_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."episodes_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."episodes_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."episodes_tags_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_tags_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."episodes_tags_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."episodes_tags_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_tags_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."episodes_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."episodes_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."episodes_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."episodes_usergroups_download_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_usergroups_download_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."episodes_usergroups_download_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."episodes_usergroups_download_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_usergroups_download_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."episodes_usergroups_earlyaccess_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_usergroups_earlyaccess_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."episodes_usergroups_earlyaccess_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."episodes_usergroups_earlyaccess_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_usergroups_earlyaccess_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."episodes_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_usergroups_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."episodes_usergroups_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."episodes_usergroups_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."events_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."events_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."events_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."events_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."events_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."events_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."events_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."events_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."events_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."events_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faq_categories_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faq_categories_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faq_categories_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."faq_categories_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faq_categories_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faq_categories_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faq_categories_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faq_categories_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."faq_categories_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faq_categories_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faqs_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqs_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faqs_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."faqs_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faqs_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faqs_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqs_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faqs_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."faqs_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faqs_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faqs_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqs_usergroups_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faqs_usergroups_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."faqs_usergroups_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faqs_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."globalconfig_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."globalconfig_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."globalconfig_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."globalconfig_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."globalconfig_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."lists_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."lists_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."lists_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."lists_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."lists_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."lists_relations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."lists_relations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."lists_relations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."lists_relations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."lists_relations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."maintenancemessage_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."maintenancemessage_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."maintenancemessage_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."maintenancemessage_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."maintenancemessage_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."maintenancemessage_messagetemplates_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."messagetemplates_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."messagetemplates_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."messagetemplates_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."messagetemplates_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."messagetemplates_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."messagetemplates_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."messagetemplates_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."messagetemplates_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."messagetemplates_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."messagetemplates_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."pages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."pages_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."pages_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."pages_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."pages_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."pages_translations_id_seq" ---

CREATE SEQUENCE IF NOT EXISTS "public"."pages_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."pages_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."pages_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."pages_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."seasons_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."seasons_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."seasons_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."seasons_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."seasons_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."seasons_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."seasons_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."seasons_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."seasons_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."seasons_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."seasons_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."seasons_usergroups_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."seasons_usergroups_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."seasons_usergroups_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."seasons_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."sections_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."sections_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."sections_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."sections_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."sections_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."sections_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."sections_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."sections_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."sections_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."sections_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."sections_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."sections_usergroups_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."sections_usergroups_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."sections_usergroups_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."sections_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."shows_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."shows_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."shows_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."shows_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."shows_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."shows_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."shows_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."shows_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."shows_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."shows_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."shows_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."shows_usergroups_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."shows_usergroups_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."shows_usergroups_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."shows_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."tags_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."tags_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."tags_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."tags_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."tags_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."tags_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."tags_translations_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."tags_translations_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."tags_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."tags_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."tvguideentry_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."tvguideentry_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."tvguideentry_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."tvguideentry_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."tvguideentry_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."webconfig_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."webconfig_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."webconfig_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."webconfig_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."webconfig_id_seq" ---

--- BEGIN CREATE TABLE "public"."episodes" ---

CREATE TABLE IF NOT EXISTS "public"."episodes" (
	"agerating_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"asset_id" int4 NULL  ,
	"available_from" timestamp NULL  ,
	"available_to" timestamp NULL  ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"episode_number" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('episodes_id_seq'::regclass) ,
	"image_file_id" uuid NULL  ,
	"legacy_description_id" int4 NULL  ,
	"legacy_extra_description_id" int4 NULL  ,
	"legacy_id" int4 NULL  ,
	"legacy_program_id" int4 NULL  ,
	"legacy_tags_id" int4 NULL  ,
	"legacy_title_id" int4 NULL  ,
	"migration_data" json NULL  ,
	"publish_date" timestamp NOT NULL  ,
	"season_id" int4 NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"type" varchar(255) NOT NULL DEFAULT 'episode'::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL
);

	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_legacy_id_unique" UNIQUE (legacy_id);
	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_legacy_program_id_unique" UNIQUE (legacy_program_id);
	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_pkey" PRIMARY KEY (id);

CREATE UNIQUE INDEX IF NOT EXISTS episodes_legacy_id_unique ON public.episodes USING btree (legacy_id);


CREATE UNIQUE INDEX IF NOT EXISTS episodes_legacy_program_id_unique ON public.episodes USING btree (legacy_program_id);

ALTER TABLE IF EXISTS "public"."episodes" OWNER TO manager;


COMMENT ON COLUMN "public"."episodes"."agerating_code"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."asset_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."available_from"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."available_to"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."episode_number"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."image_file_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."legacy_description_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."legacy_extra_description_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."legacy_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."legacy_program_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."legacy_tags_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."legacy_title_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."migration_data"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."publish_date"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."season_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."status"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."type"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."episodes"."user_updated"  IS NULL;


COMMENT ON INDEX "public"."episodes_legacy_id_unique"  IS NULL;


COMMENT ON INDEX "public"."episodes_legacy_program_id_unique"  IS NULL;

COMMENT ON TABLE "public"."episodes"  IS NULL;

--- END CREATE TABLE "public"."episodes" ---

--- BEGIN CREATE TABLE "public"."calendarentries" ---

CREATE TABLE IF NOT EXISTS "public"."calendarentries" (
	"date_created" timestamptz NULL  ,
	"date_updated" timestamptz NULL  ,
	"end" timestamp NOT NULL  ,
	"episode_id" int4 NULL  ,
	"event_id" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('calendarentries_id_seq'::regclass) ,
	"image" uuid NULL  ,
	"image_from_link" bool NOT NULL DEFAULT true ,
	"link_type" varchar(255) NULL DEFAULT NULL::character varying ,
	"season_id" int4 NULL  ,
	"show_id" int4 NULL  ,
	"start" timestamp NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "calendarentries_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "calendarentries_episode_id_foreign" FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE SET NULL
);


ALTER TABLE IF EXISTS "public"."calendarentries" OWNER TO manager;


COMMENT ON COLUMN "public"."calendarentries"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."end"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."episode_id"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."event_id"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."id"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."image"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."image_from_link"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."link_type"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."season_id"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."show_id"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."start"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."status"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries"."user_updated"  IS NULL;


COMMENT ON TABLE "public"."calendarentries"  IS NULL;

--- END CREATE TABLE "public"."calendarentries" ---


--- BEGIN CREATE TABLE "public"."appconfig" ---

CREATE TABLE IF NOT EXISTS "public"."appconfig" (
	"app_version" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"date_updated" timestamptz NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('appconfig_id_seq'::regclass) ,
	"user_updated" uuid NOT NULL  ,
	CONSTRAINT "appconfig_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "appconfig_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."appconfig" OWNER TO manager;


COMMENT ON COLUMN "public"."appconfig"."app_version"  IS NULL;


COMMENT ON COLUMN "public"."appconfig"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."appconfig"."id"  IS NULL;


COMMENT ON COLUMN "public"."appconfig"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "appconfig_pkey" ON "public"."appconfig" IS NULL;


COMMENT ON CONSTRAINT "appconfig_user_updated_foreign" ON "public"."appconfig" IS NULL;

COMMENT ON TABLE "public"."appconfig"  IS NULL;

--- END CREATE TABLE "public"."appconfig" ---

--- BEGIN CREATE TABLE "public"."assets" ---

CREATE TABLE IF NOT EXISTS "public"."assets" (
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"duration" int4 NOT NULL  ,
	"encoding_version" varchar(255) NULL DEFAULT NULL::character varying ,
	"id" int4 NOT NULL DEFAULT nextval('assets_id_seq'::regclass) ,
	"legacy_id" int4 NULL  ,
	"main_storage_path" text NULL  ,
	"mediabanken_id" varchar(255) NULL DEFAULT NULL::character varying ,
	"name" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"status" varchar(255) NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "assets_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "assets_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "assets_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."assets" OWNER TO manager;


COMMENT ON COLUMN "public"."assets"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."assets"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."assets"."duration"  IS NULL;


COMMENT ON COLUMN "public"."assets"."encoding_version"  IS NULL;


COMMENT ON COLUMN "public"."assets"."id"  IS NULL;


COMMENT ON COLUMN "public"."assets"."legacy_id"  IS NULL;


COMMENT ON COLUMN "public"."assets"."main_storage_path"  IS NULL;


COMMENT ON COLUMN "public"."assets"."mediabanken_id"  IS NULL;


COMMENT ON COLUMN "public"."assets"."name"  IS NULL;


COMMENT ON COLUMN "public"."assets"."status"  IS NULL;


COMMENT ON COLUMN "public"."assets"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."assets"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "assets_pkey" ON "public"."assets" IS NULL;


COMMENT ON CONSTRAINT "assets_user_created_foreign" ON "public"."assets" IS NULL;


COMMENT ON CONSTRAINT "assets_user_updated_foreign" ON "public"."assets" IS NULL;

COMMENT ON TABLE "public"."assets"  IS NULL;

--- END CREATE TABLE "public"."assets" ---

--- BEGIN CREATE TABLE "public"."assetstreams" ---

CREATE TABLE IF NOT EXISTS "public"."assetstreams" (
	"asset_id" int4 NOT NULL  ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"encryption_key_id" varchar(255) NULL DEFAULT NULL::character varying ,
	"extra_metadata" json NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('assetstreams_id_seq'::regclass) ,
	"legacy_videourl_id" int4 NULL  ,
	"path" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"service" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"type" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"url" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "assetstreams_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "assetstreams_asset_id_foreign" FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE ,
	CONSTRAINT "assetstreams_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "assetstreams_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."assetstreams" OWNER TO manager;


COMMENT ON COLUMN "public"."assetstreams"."asset_id"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."encryption_key_id"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."extra_metadata"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."id"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."legacy_videourl_id"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."path"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."service"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."status"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."type"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."url"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "assetstreams_pkey" ON "public"."assetstreams" IS NULL;


COMMENT ON CONSTRAINT "assetstreams_asset_id_foreign" ON "public"."assetstreams" IS NULL;


COMMENT ON CONSTRAINT "assetstreams_user_created_foreign" ON "public"."assetstreams" IS NULL;


COMMENT ON CONSTRAINT "assetstreams_user_updated_foreign" ON "public"."assetstreams" IS NULL;

COMMENT ON TABLE "public"."assetstreams"  IS NULL;

--- END CREATE TABLE "public"."assetstreams" ---

--- BEGIN CREATE TABLE "public"."assetstreams_audio_languages" ---

CREATE TABLE IF NOT EXISTS "public"."assetstreams_audio_languages" (
	"assetstreams_id" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('assetstreams_audio_languages_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "assetstreams_audio_languages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "assetstreams_audio_languages_assetstreams_id_foreign" FOREIGN KEY (assetstreams_id) REFERENCES assetstreams(id) ON DELETE CASCADE ,
	CONSTRAINT "assetstreams_audio_languages_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code)
);

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages" OWNER TO manager;


COMMENT ON COLUMN "public"."assetstreams_audio_languages"."assetstreams_id"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams_audio_languages"."id"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams_audio_languages"."languages_code"  IS NULL;

COMMENT ON CONSTRAINT "assetstreams_audio_languages_pkey" ON "public"."assetstreams_audio_languages" IS NULL;


COMMENT ON CONSTRAINT "assetstreams_audio_languages_assetstreams_id_foreign" ON "public"."assetstreams_audio_languages" IS NULL;


COMMENT ON CONSTRAINT "assetstreams_audio_languages_languages_code_foreign" ON "public"."assetstreams_audio_languages" IS NULL;

COMMENT ON TABLE "public"."assetstreams_audio_languages"  IS NULL;

--- END CREATE TABLE "public"."assetstreams_audio_languages" ---

--- BEGIN CREATE TABLE "public"."assetstreams_subtitle_languages" ---

CREATE TABLE IF NOT EXISTS "public"."assetstreams_subtitle_languages" (
	"assetstreams_id" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('assetstreams_subtitle_languages_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "assetstreams_subtitle_languages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "assetstreams_subtitle_languages_assetstreams_id_foreign" FOREIGN KEY (assetstreams_id) REFERENCES assetstreams(id) ON DELETE CASCADE ,
	CONSTRAINT "assetstreams_subtitle_languages_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code)
);

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages" OWNER TO manager;


COMMENT ON COLUMN "public"."assetstreams_subtitle_languages"."assetstreams_id"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams_subtitle_languages"."id"  IS NULL;


COMMENT ON COLUMN "public"."assetstreams_subtitle_languages"."languages_code"  IS NULL;

COMMENT ON CONSTRAINT "assetstreams_subtitle_languages_pkey" ON "public"."assetstreams_subtitle_languages" IS NULL;


COMMENT ON CONSTRAINT "assetstreams_subtitle_languages_assetstreams_id_foreign" ON "public"."assetstreams_subtitle_languages" IS NULL;


COMMENT ON CONSTRAINT "assetstreams_subtitle_languages_languages_code_foreign" ON "public"."assetstreams_subtitle_languages" IS NULL;

COMMENT ON TABLE "public"."assetstreams_subtitle_languages"  IS NULL;

--- END CREATE TABLE "public"."assetstreams_subtitle_languages" ---

--- BEGIN CREATE TABLE "public"."calendarentries_translations" ---

CREATE TABLE IF NOT EXISTS "public"."calendarentries_translations" (
	"calendarentries_id" int4 NULL  ,
	"description" varchar(255) NULL DEFAULT NULL::character varying ,
	"id" int4 NOT NULL DEFAULT nextval('calendarentries_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "calendarentries_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "calendarentries_translations_calendarentries_id_foreign" FOREIGN KEY (calendarentries_id) REFERENCES calendarentries(id) ON DELETE CASCADE ,
	CONSTRAINT "calendarentries_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."calendarentries_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."calendarentries_translations"."calendarentries_id"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."calendarentries_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "calendarentries_translations_pkey" ON "public"."calendarentries_translations" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_translations_calendarentries_id_foreign" ON "public"."calendarentries_translations" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_translations_languages_code_foreign" ON "public"."calendarentries_translations" IS NULL;

COMMENT ON TABLE "public"."calendarentries_translations"  IS NULL;

--- END CREATE TABLE "public"."calendarentries_translations" ---

--- BEGIN CREATE TABLE "public"."calendarevent" ---

CREATE TABLE IF NOT EXISTS "public"."calendarevent" (
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"end" timestamp NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('calendarevent_id_seq'::regclass) ,
	"start" timestamp NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "calendarevent_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "calendarevent_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "calendarevent_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."calendarevent" OWNER TO manager;


COMMENT ON COLUMN "public"."calendarevent"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."end"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."id"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."start"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."status"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."title"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "calendarevent_pkey" ON "public"."calendarevent" IS NULL;


COMMENT ON CONSTRAINT "calendarevent_user_created_foreign" ON "public"."calendarevent" IS NULL;


COMMENT ON CONSTRAINT "calendarevent_user_updated_foreign" ON "public"."calendarevent" IS NULL;

COMMENT ON TABLE "public"."calendarevent"  IS NULL;

--- END CREATE TABLE "public"."calendarevent" ---

--- BEGIN CREATE TABLE "public"."categories" ---

CREATE TABLE IF NOT EXISTS "public"."categories" (
	"appear_in_search" bool NULL DEFAULT false ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('categories_id_seq'::regclass) ,
	"legacy_id" int4 NULL  ,
	"parent_id" int4 NULL  ,
	"sort" int4 NULL  ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "categories_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "categories_parent_id_foreign" FOREIGN KEY (parent_id) REFERENCES categories(id) ,
	CONSTRAINT "categories_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "categories_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."categories" OWNER TO manager;


COMMENT ON COLUMN "public"."categories"."appear_in_search"  IS NULL;


COMMENT ON COLUMN "public"."categories"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."categories"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."categories"."id"  IS NULL;


COMMENT ON COLUMN "public"."categories"."legacy_id"  IS NULL;


COMMENT ON COLUMN "public"."categories"."parent_id"  IS NULL;


COMMENT ON COLUMN "public"."categories"."sort"  IS NULL;


COMMENT ON COLUMN "public"."categories"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."categories"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "categories_pkey" ON "public"."categories" IS NULL;


COMMENT ON CONSTRAINT "categories_parent_id_foreign" ON "public"."categories" IS NULL;


COMMENT ON CONSTRAINT "categories_user_created_foreign" ON "public"."categories" IS NULL;


COMMENT ON CONSTRAINT "categories_user_updated_foreign" ON "public"."categories" IS NULL;

COMMENT ON TABLE "public"."categories"  IS NULL;

--- END CREATE TABLE "public"."categories" ---

--- BEGIN CREATE TABLE "public"."ageratings" ---

CREATE TABLE IF NOT EXISTS "public"."ageratings" (
	"code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"sort" int4 NULL  ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "ageratings_pkey" PRIMARY KEY (code)
);

ALTER TABLE IF EXISTS "public"."ageratings" OWNER TO manager;


COMMENT ON COLUMN "public"."ageratings"."code"  IS NULL;


COMMENT ON COLUMN "public"."ageratings"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."ageratings"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."ageratings"."sort"  IS NULL;


COMMENT ON COLUMN "public"."ageratings"."title"  IS NULL;

COMMENT ON CONSTRAINT "ageratings_pkey" ON "public"."ageratings" IS NULL;

COMMENT ON TABLE "public"."ageratings"  IS NULL;

--- END CREATE TABLE "public"."ageratings" ---

--- BEGIN CREATE TABLE "public"."assetfiles" ---

CREATE TABLE IF NOT EXISTS "public"."assetfiles" (
	"asset_id" int4 NOT NULL  ,
	"audio_language_id" varchar(255) NULL DEFAULT NULL::character varying ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"extra_metadata" json NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('assetfiles_id_seq'::regclass) ,
	"mime_type" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"path" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"storage" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"subtitle_language_id" varchar(255) NULL DEFAULT NULL::character varying ,
	"type" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "assetfiles_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "assetfiles_asset_id_foreign" FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE ,
	CONSTRAINT "assetfiles_audio_language_id_foreign" FOREIGN KEY (audio_language_id) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "assetfiles_subtitle_language_id_foreign" FOREIGN KEY (subtitle_language_id) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "assetfiles_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "assetfiles_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."assetfiles" OWNER TO manager;


COMMENT ON COLUMN "public"."assetfiles"."asset_id"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."audio_language_id"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."extra_metadata"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."id"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."mime_type"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."path"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."storage"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."subtitle_language_id"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."type"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."assetfiles"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "assetfiles_pkey" ON "public"."assetfiles" IS NULL;


COMMENT ON CONSTRAINT "assetfiles_asset_id_foreign" ON "public"."assetfiles" IS NULL;


COMMENT ON CONSTRAINT "assetfiles_audio_language_id_foreign" ON "public"."assetfiles" IS NULL;


COMMENT ON CONSTRAINT "assetfiles_subtitle_language_id_foreign" ON "public"."assetfiles" IS NULL;


COMMENT ON CONSTRAINT "assetfiles_user_created_foreign" ON "public"."assetfiles" IS NULL;


COMMENT ON CONSTRAINT "assetfiles_user_updated_foreign" ON "public"."assetfiles" IS NULL;

COMMENT ON TABLE "public"."assetfiles"  IS NULL;

--- END CREATE TABLE "public"."assetfiles" ---


--- BEGIN CREATE TABLE "public"."directus_collections" ---

CREATE TABLE IF NOT EXISTS "public"."directus_collections" (
	"collection" varchar(64) NOT NULL  ,
	"icon" varchar(30) NULL  ,
	"note" text NULL  ,
	"display_template" varchar(255) NULL  ,
	"hidden" bool NOT NULL DEFAULT false ,
	"singleton" bool NOT NULL DEFAULT false ,
	"translations" json NULL  ,
	"archive_field" varchar(64) NULL  ,
	"archive_app_filter" bool NOT NULL DEFAULT true ,
	"archive_value" varchar(255) NULL  ,
	"unarchive_value" varchar(255) NULL  ,
	"sort_field" varchar(64) NULL  ,
	"accountability" varchar(255) NULL DEFAULT 'all'::character varying ,
	"color" varchar(255) NULL  ,
	"item_duplication_fields" json NULL  ,
	"sort" int4 NULL  ,
	"group" varchar(64) NULL  ,
	"collapse" varchar(255) NOT NULL DEFAULT 'open'::character varying ,
	CONSTRAINT "directus_collections_pkey" PRIMARY KEY (collection) ,
	CONSTRAINT "directus_collections_group_foreign" FOREIGN KEY ("group") REFERENCES directus_collections(collection)
);

ALTER TABLE IF EXISTS "public"."directus_collections" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_collections"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."icon"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."note"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."display_template"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."hidden"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."singleton"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."translations"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."archive_field"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."archive_app_filter"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."archive_value"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."unarchive_value"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."sort_field"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."accountability"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."color"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."item_duplication_fields"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."sort"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."group"  IS NULL;


COMMENT ON COLUMN "public"."directus_collections"."collapse"  IS NULL;

COMMENT ON CONSTRAINT "directus_collections_pkey" ON "public"."directus_collections" IS NULL;


COMMENT ON CONSTRAINT "directus_collections_group_foreign" ON "public"."directus_collections" IS NULL;

COMMENT ON TABLE "public"."directus_collections"  IS NULL;

--- END CREATE TABLE "public"."directus_collections" ---

--- BEGIN CREATE TABLE "public"."directus_activity" ---

CREATE TABLE IF NOT EXISTS "public"."directus_activity" (
	"id" int4 NOT NULL DEFAULT nextval('directus_activity_id_seq'::regclass) ,
	"action" varchar(45) NOT NULL  ,
	"user" uuid NULL  ,
	"timestamp" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"ip" varchar(50) NULL  ,
	"user_agent" varchar(255) NULL  ,
	"collection" varchar(64) NOT NULL  ,
	"item" varchar(255) NOT NULL  ,
	"comment" text NULL  ,
	CONSTRAINT "directus_activity_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."directus_activity" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_activity"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_activity"."action"  IS NULL;


COMMENT ON COLUMN "public"."directus_activity"."user"  IS NULL;


COMMENT ON COLUMN "public"."directus_activity"."timestamp"  IS NULL;


COMMENT ON COLUMN "public"."directus_activity"."ip"  IS NULL;


COMMENT ON COLUMN "public"."directus_activity"."user_agent"  IS NULL;


COMMENT ON COLUMN "public"."directus_activity"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_activity"."item"  IS NULL;


COMMENT ON COLUMN "public"."directus_activity"."comment"  IS NULL;

COMMENT ON CONSTRAINT "directus_activity_pkey" ON "public"."directus_activity" IS NULL;

COMMENT ON TABLE "public"."directus_activity"  IS NULL;

--- END CREATE TABLE "public"."directus_activity" ---

--- BEGIN CREATE TABLE "public"."categories_translations" ---

CREATE TABLE IF NOT EXISTS "public"."categories_translations" (
	"categories_id" int4 NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('categories_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"name" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "categories_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "categories_translations_categories_id_foreign" FOREIGN KEY (categories_id) REFERENCES categories(id) ,
	CONSTRAINT "categories_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code)
);

ALTER TABLE IF EXISTS "public"."categories_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."categories_translations"."categories_id"  IS NULL;


COMMENT ON COLUMN "public"."categories_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."categories_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."categories_translations"."name"  IS NULL;

COMMENT ON CONSTRAINT "categories_translations_pkey" ON "public"."categories_translations" IS NULL;


COMMENT ON CONSTRAINT "categories_translations_categories_id_foreign" ON "public"."categories_translations" IS NULL;


COMMENT ON CONSTRAINT "categories_translations_languages_code_foreign" ON "public"."categories_translations" IS NULL;

COMMENT ON TABLE "public"."categories_translations"  IS NULL;

--- END CREATE TABLE "public"."categories_translations" ---

--- BEGIN CREATE TABLE "public"."directus_fields" ---

CREATE TABLE IF NOT EXISTS "public"."directus_fields" (
	"id" int4 NOT NULL DEFAULT nextval('directus_fields_id_seq'::regclass) ,
	"collection" varchar(64) NOT NULL  ,
	"field" varchar(64) NOT NULL  ,
	"special" varchar(64) NULL  ,
	"interface" varchar(64) NULL  ,
	"options" json NULL  ,
	"display" varchar(64) NULL  ,
	"display_options" json NULL  ,
	"readonly" bool NOT NULL DEFAULT false ,
	"hidden" bool NOT NULL DEFAULT false ,
	"sort" int4 NULL  ,
	"width" varchar(30) NULL DEFAULT 'full'::character varying ,
	"translations" json NULL  ,
	"note" text NULL  ,
	"conditions" json NULL  ,
	"required" bool NULL DEFAULT false ,
	"group" varchar(64) NULL  ,
	"validation" json NULL  ,
	"validation_message" text NULL  ,
	CONSTRAINT "directus_fields_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."directus_fields" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_fields"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."field"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."special"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."interface"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."options"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."display"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."display_options"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."readonly"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."hidden"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."sort"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."width"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."translations"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."note"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."conditions"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."required"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."group"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."validation"  IS NULL;


COMMENT ON COLUMN "public"."directus_fields"."validation_message"  IS NULL;

COMMENT ON CONSTRAINT "directus_fields_pkey" ON "public"."directus_fields" IS NULL;

COMMENT ON TABLE "public"."directus_fields"  IS NULL;

--- END CREATE TABLE "public"."directus_fields" ---

--- BEGIN CREATE TABLE "public"."directus_dashboards" ---

CREATE TABLE IF NOT EXISTS "public"."directus_dashboards" (
	"id" uuid NOT NULL  ,
	"name" varchar(255) NOT NULL  ,
	"icon" varchar(30) NOT NULL DEFAULT 'dashboard'::character varying ,
	"note" text NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	"color" varchar(255) NULL  ,
	CONSTRAINT "directus_dashboards_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_dashboards_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."directus_dashboards" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_dashboards"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_dashboards"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_dashboards"."icon"  IS NULL;


COMMENT ON COLUMN "public"."directus_dashboards"."note"  IS NULL;


COMMENT ON COLUMN "public"."directus_dashboards"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_dashboards"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_dashboards"."color"  IS NULL;

COMMENT ON CONSTRAINT "directus_dashboards_pkey" ON "public"."directus_dashboards" IS NULL;


COMMENT ON CONSTRAINT "directus_dashboards_user_created_foreign" ON "public"."directus_dashboards" IS NULL;

COMMENT ON TABLE "public"."directus_dashboards"  IS NULL;

--- END CREATE TABLE "public"."directus_dashboards" ---

--- BEGIN CREATE TABLE "public"."directus_migrations" ---

CREATE TABLE IF NOT EXISTS "public"."directus_migrations" (
	"version" varchar(255) NOT NULL  ,
	"name" varchar(255) NOT NULL  ,
	"timestamp" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	CONSTRAINT "directus_migrations_pkey" PRIMARY KEY (version)
);

ALTER TABLE IF EXISTS "public"."directus_migrations" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_migrations"."version"  IS NULL;


COMMENT ON COLUMN "public"."directus_migrations"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_migrations"."timestamp"  IS NULL;

COMMENT ON CONSTRAINT "directus_migrations_pkey" ON "public"."directus_migrations" IS NULL;

COMMENT ON TABLE "public"."directus_migrations"  IS NULL;

--- END CREATE TABLE "public"."directus_migrations" ---

--- BEGIN CREATE TABLE "public"."directus_folders" ---

CREATE TABLE IF NOT EXISTS "public"."directus_folders" (
	"id" uuid NOT NULL  ,
	"name" varchar(255) NOT NULL  ,
	"parent" uuid NULL  ,
	CONSTRAINT "directus_folders_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_folders_parent_foreign" FOREIGN KEY (parent) REFERENCES directus_folders(id)
);

ALTER TABLE IF EXISTS "public"."directus_folders" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_folders"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_folders"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_folders"."parent"  IS NULL;

COMMENT ON CONSTRAINT "directus_folders_pkey" ON "public"."directus_folders" IS NULL;


COMMENT ON CONSTRAINT "directus_folders_parent_foreign" ON "public"."directus_folders" IS NULL;

COMMENT ON TABLE "public"."directus_folders"  IS NULL;

--- END CREATE TABLE "public"."directus_folders" ---
--- BEGIN CREATE TABLE "public"."directus_files" ---

CREATE TABLE IF NOT EXISTS "public"."directus_files" (
	"id" uuid NOT NULL  ,
	"storage" varchar(255) NOT NULL  ,
	"filename_disk" varchar(255) NULL  ,
	"filename_download" varchar(255) NOT NULL  ,
	"title" varchar(255) NULL  ,
	"type" varchar(255) NULL  ,
	"folder" uuid NULL  ,
	"uploaded_by" uuid NULL  ,
	"uploaded_on" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"modified_by" uuid NULL  ,
	"modified_on" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"charset" varchar(50) NULL  ,
	"filesize" int8 NULL  ,
	"width" int4 NULL  ,
	"height" int4 NULL  ,
	"duration" int4 NULL  ,
	"embed" varchar(200) NULL  ,
	"description" text NULL  ,
	"location" text NULL  ,
	"tags" text NULL  ,
	"metadata" json NULL  ,
	CONSTRAINT "directus_files_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_files_folder_foreign" FOREIGN KEY (folder) REFERENCES directus_folders(id) ON DELETE SET NULL ,
	CONSTRAINT "directus_files_modified_by_foreign" FOREIGN KEY (modified_by) REFERENCES directus_users(id) ,
	CONSTRAINT "directus_files_uploaded_by_foreign" FOREIGN KEY (uploaded_by) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."directus_files" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_files"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."storage"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."filename_disk"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."filename_download"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."title"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."type"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."folder"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."uploaded_by"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."uploaded_on"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."modified_by"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."modified_on"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."charset"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."filesize"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."width"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."height"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."duration"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."embed"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."description"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."location"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."tags"  IS NULL;


COMMENT ON COLUMN "public"."directus_files"."metadata"  IS NULL;

COMMENT ON CONSTRAINT "directus_files_pkey" ON "public"."directus_files" IS NULL;


COMMENT ON CONSTRAINT "directus_files_folder_foreign" ON "public"."directus_files" IS NULL;


COMMENT ON CONSTRAINT "directus_files_modified_by_foreign" ON "public"."directus_files" IS NULL;


COMMENT ON CONSTRAINT "directus_files_uploaded_by_foreign" ON "public"."directus_files" IS NULL;

COMMENT ON TABLE "public"."directus_files"  IS NULL;

--- END CREATE TABLE "public"."directus_files" ---


--- BEGIN CREATE TABLE "public"."directus_flows" ---

CREATE TABLE IF NOT EXISTS "public"."directus_flows" (
	"id" uuid NOT NULL  ,
	"name" varchar(255) NOT NULL  ,
	"icon" varchar(30) NULL  ,
	"color" varchar(255) NULL  ,
	"description" text NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'active'::character varying ,
	"trigger" varchar(255) NULL  ,
	"accountability" varchar(255) NULL DEFAULT 'all'::character varying ,
	"options" json NULL  ,
	"operation" uuid NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	CONSTRAINT "directus_flows_operation_unique" UNIQUE (operation) ,
	CONSTRAINT "directus_flows_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_flows_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS directus_flows_operation_unique ON public.directus_flows USING btree (operation);

ALTER TABLE IF EXISTS "public"."directus_flows" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_flows"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."icon"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."color"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."description"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."status"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."trigger"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."accountability"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."options"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."operation"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_flows"."user_created"  IS NULL;

COMMENT ON CONSTRAINT "directus_flows_operation_unique" ON "public"."directus_flows" IS NULL;


COMMENT ON CONSTRAINT "directus_flows_pkey" ON "public"."directus_flows" IS NULL;


COMMENT ON CONSTRAINT "directus_flows_user_created_foreign" ON "public"."directus_flows" IS NULL;

COMMENT ON INDEX "public"."directus_flows_operation_unique"  IS NULL;

COMMENT ON TABLE "public"."directus_flows"  IS NULL;

--- END CREATE TABLE "public"."directus_flows" ---

--- BEGIN CREATE TABLE "public"."directus_panels" ---

CREATE TABLE IF NOT EXISTS "public"."directus_panels" (
	"id" uuid NOT NULL  ,
	"dashboard" uuid NOT NULL  ,
	"name" varchar(255) NULL  ,
	"icon" varchar(30) NULL DEFAULT NULL::character varying ,
	"color" varchar(10) NULL  ,
	"show_header" bool NOT NULL DEFAULT false ,
	"note" text NULL  ,
	"type" varchar(255) NOT NULL  ,
	"position_x" int4 NOT NULL  ,
	"position_y" int4 NOT NULL  ,
	"width" int4 NOT NULL  ,
	"height" int4 NOT NULL  ,
	"options" json NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	CONSTRAINT "directus_panels_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_panels_dashboard_foreign" FOREIGN KEY (dashboard) REFERENCES directus_dashboards(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_panels_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."directus_panels" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_panels"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."dashboard"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."icon"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."color"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."show_header"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."note"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."type"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."position_x"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."position_y"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."width"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."height"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."options"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_panels"."user_created"  IS NULL;

COMMENT ON CONSTRAINT "directus_panels_pkey" ON "public"."directus_panels" IS NULL;


COMMENT ON CONSTRAINT "directus_panels_dashboard_foreign" ON "public"."directus_panels" IS NULL;


COMMENT ON CONSTRAINT "directus_panels_user_created_foreign" ON "public"."directus_panels" IS NULL;

COMMENT ON TABLE "public"."directus_panels"  IS NULL;

--- END CREATE TABLE "public"."directus_panels" ---

--- BEGIN CREATE TABLE "public"."directus_presets" ---

CREATE TABLE IF NOT EXISTS "public"."directus_presets" (
	"id" int4 NOT NULL DEFAULT nextval('directus_presets_id_seq'::regclass) ,
	"bookmark" varchar(255) NULL  ,
	"user" uuid NULL  ,
	"role" uuid NULL  ,
	"collection" varchar(64) NULL  ,
	"search" varchar(100) NULL  ,
	"layout" varchar(100) NULL DEFAULT 'tabular'::character varying ,
	"layout_query" json NULL  ,
	"layout_options" json NULL  ,
	"refresh_interval" int4 NULL  ,
	"filter" json NULL  ,
	"icon" varchar(30) NOT NULL DEFAULT 'bookmark_outline'::character varying ,
	"color" varchar(255) NULL  ,
	CONSTRAINT "directus_presets_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_presets_role_foreign" FOREIGN KEY (role) REFERENCES directus_roles(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_presets_user_foreign" FOREIGN KEY ("user") REFERENCES directus_users(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."directus_presets" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_presets"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."bookmark"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."user"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."role"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."search"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."layout"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."layout_query"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."layout_options"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."refresh_interval"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."filter"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."icon"  IS NULL;


COMMENT ON COLUMN "public"."directus_presets"."color"  IS NULL;

COMMENT ON CONSTRAINT "directus_presets_pkey" ON "public"."directus_presets" IS NULL;


COMMENT ON CONSTRAINT "directus_presets_role_foreign" ON "public"."directus_presets" IS NULL;


COMMENT ON CONSTRAINT "directus_presets_user_foreign" ON "public"."directus_presets" IS NULL;

COMMENT ON TABLE "public"."directus_presets"  IS NULL;

--- END CREATE TABLE "public"."directus_presets" ---

--- BEGIN CREATE TABLE "public"."directus_revisions" ---

CREATE TABLE IF NOT EXISTS "public"."directus_revisions" (
	"id" int4 NOT NULL DEFAULT nextval('directus_revisions_id_seq'::regclass) ,
	"activity" int4 NOT NULL  ,
	"collection" varchar(64) NOT NULL  ,
	"item" varchar(255) NOT NULL  ,
	"data" json NULL  ,
	"delta" json NULL  ,
	"parent" int4 NULL  ,
	CONSTRAINT "directus_revisions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_revisions_activity_foreign" FOREIGN KEY (activity) REFERENCES directus_activity(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_revisions_parent_foreign" FOREIGN KEY (parent) REFERENCES directus_revisions(id)
);

ALTER TABLE IF EXISTS "public"."directus_revisions" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_revisions"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_revisions"."activity"  IS NULL;


COMMENT ON COLUMN "public"."directus_revisions"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_revisions"."item"  IS NULL;


COMMENT ON COLUMN "public"."directus_revisions"."data"  IS NULL;


COMMENT ON COLUMN "public"."directus_revisions"."delta"  IS NULL;


COMMENT ON COLUMN "public"."directus_revisions"."parent"  IS NULL;

COMMENT ON CONSTRAINT "directus_revisions_pkey" ON "public"."directus_revisions" IS NULL;


COMMENT ON CONSTRAINT "directus_revisions_activity_foreign" ON "public"."directus_revisions" IS NULL;


COMMENT ON CONSTRAINT "directus_revisions_parent_foreign" ON "public"."directus_revisions" IS NULL;

COMMENT ON TABLE "public"."directus_revisions"  IS NULL;

--- END CREATE TABLE "public"."directus_revisions" ---

--- BEGIN CREATE TABLE "public"."directus_relations" ---

CREATE TABLE IF NOT EXISTS "public"."directus_relations" (
	"id" int4 NOT NULL DEFAULT nextval('directus_relations_id_seq'::regclass) ,
	"many_collection" varchar(64) NOT NULL  ,
	"many_field" varchar(64) NOT NULL  ,
	"one_collection" varchar(64) NULL  ,
	"one_field" varchar(64) NULL  ,
	"one_collection_field" varchar(64) NULL  ,
	"one_allowed_collections" text NULL  ,
	"junction_field" varchar(64) NULL  ,
	"sort_field" varchar(64) NULL  ,
	"one_deselect_action" varchar(255) NOT NULL DEFAULT 'nullify'::character varying ,
	CONSTRAINT "directus_relations_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."directus_relations" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_relations"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."many_collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."many_field"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."one_collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."one_field"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."one_collection_field"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."one_allowed_collections"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."junction_field"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."sort_field"  IS NULL;


COMMENT ON COLUMN "public"."directus_relations"."one_deselect_action"  IS NULL;

COMMENT ON CONSTRAINT "directus_relations_pkey" ON "public"."directus_relations" IS NULL;

COMMENT ON TABLE "public"."directus_relations"  IS NULL;

--- END CREATE TABLE "public"."directus_relations" ---

--- BEGIN CREATE TABLE "public"."directus_shares" ---

CREATE TABLE IF NOT EXISTS "public"."directus_shares" (
	"id" uuid NOT NULL  ,
	"name" varchar(255) NULL  ,
	"collection" varchar(64) NULL  ,
	"item" varchar(255) NULL  ,
	"role" uuid NULL  ,
	"password" varchar(255) NULL  ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_start" timestamptz NULL  ,
	"date_end" timestamptz NULL  ,
	"times_used" int4 NULL DEFAULT 0 ,
	"max_uses" int4 NULL  ,
	CONSTRAINT "directus_shares_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_shares_collection_foreign" FOREIGN KEY (collection) REFERENCES directus_collections(collection) ON DELETE CASCADE ,
	CONSTRAINT "directus_shares_role_foreign" FOREIGN KEY (role) REFERENCES directus_roles(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_shares_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."directus_shares" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_shares"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."item"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."role"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."password"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."date_start"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."date_end"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."times_used"  IS NULL;


COMMENT ON COLUMN "public"."directus_shares"."max_uses"  IS NULL;

COMMENT ON CONSTRAINT "directus_shares_pkey" ON "public"."directus_shares" IS NULL;


COMMENT ON CONSTRAINT "directus_shares_collection_foreign" ON "public"."directus_shares" IS NULL;


COMMENT ON CONSTRAINT "directus_shares_role_foreign" ON "public"."directus_shares" IS NULL;


COMMENT ON CONSTRAINT "directus_shares_user_created_foreign" ON "public"."directus_shares" IS NULL;

COMMENT ON TABLE "public"."directus_shares"  IS NULL;

--- END CREATE TABLE "public"."directus_shares" ---

--- BEGIN CREATE TABLE "public"."directus_sessions" ---

CREATE TABLE IF NOT EXISTS "public"."directus_sessions" (
	"token" varchar(64) NOT NULL  ,
	"user" uuid NULL  ,
	"expires" timestamptz NOT NULL  ,
	"ip" varchar(255) NULL  ,
	"user_agent" varchar(255) NULL  ,
	"share" uuid NULL  ,
	CONSTRAINT "directus_sessions_pkey" PRIMARY KEY (token) ,
	CONSTRAINT "directus_sessions_share_foreign" FOREIGN KEY (share) REFERENCES directus_shares(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_sessions_user_foreign" FOREIGN KEY ("user") REFERENCES directus_users(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."directus_sessions" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_sessions"."token"  IS NULL;


COMMENT ON COLUMN "public"."directus_sessions"."user"  IS NULL;


COMMENT ON COLUMN "public"."directus_sessions"."expires"  IS NULL;


COMMENT ON COLUMN "public"."directus_sessions"."ip"  IS NULL;


COMMENT ON COLUMN "public"."directus_sessions"."user_agent"  IS NULL;


COMMENT ON COLUMN "public"."directus_sessions"."share"  IS NULL;

COMMENT ON CONSTRAINT "directus_sessions_pkey" ON "public"."directus_sessions" IS NULL;


COMMENT ON CONSTRAINT "directus_sessions_share_foreign" ON "public"."directus_sessions" IS NULL;


COMMENT ON CONSTRAINT "directus_sessions_user_foreign" ON "public"."directus_sessions" IS NULL;

COMMENT ON TABLE "public"."directus_sessions"  IS NULL;

--- END CREATE TABLE "public"."directus_sessions" ---

--- BEGIN CREATE TABLE "public"."directus_settings" ---

CREATE TABLE IF NOT EXISTS "public"."directus_settings" (
	"id" int4 NOT NULL DEFAULT nextval('directus_settings_id_seq'::regclass) ,
	"project_name" varchar(100) NOT NULL DEFAULT 'Directus'::character varying ,
	"project_url" varchar(255) NULL  ,
	"project_color" varchar(50) NULL DEFAULT NULL::character varying ,
	"project_logo" uuid NULL  ,
	"public_foreground" uuid NULL  ,
	"public_background" uuid NULL  ,
	"public_note" text NULL  ,
	"auth_login_attempts" int4 NULL DEFAULT 25 ,
	"auth_password_policy" varchar(100) NULL  ,
	"storage_asset_transform" varchar(7) NULL DEFAULT 'all'::character varying ,
	"storage_asset_presets" json NULL  ,
	"custom_css" text NULL  ,
	"storage_default_folder" uuid NULL  ,
	"basemaps" json NULL  ,
	"mapbox_key" varchar(255) NULL  ,
	"module_bar" json NULL  ,
	"project_descriptor" varchar(100) NULL  ,
	"translation_strings" json NULL  ,
	"default_language" varchar(255) NOT NULL DEFAULT 'en-US'::character varying ,
	"custom_aspect_ratios" json NULL  ,
	CONSTRAINT "directus_settings_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_settings_project_logo_foreign" FOREIGN KEY (project_logo) REFERENCES directus_files(id) ,
	CONSTRAINT "directus_settings_public_background_foreign" FOREIGN KEY (public_background) REFERENCES directus_files(id) ,
	CONSTRAINT "directus_settings_public_foreground_foreign" FOREIGN KEY (public_foreground) REFERENCES directus_files(id) ,
	CONSTRAINT "directus_settings_storage_default_folder_foreign" FOREIGN KEY (storage_default_folder) REFERENCES directus_folders(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."directus_settings" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_settings"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."project_name"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."project_url"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."project_color"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."project_logo"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."public_foreground"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."public_background"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."public_note"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."auth_login_attempts"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."auth_password_policy"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."storage_asset_transform"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."storage_asset_presets"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."custom_css"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."storage_default_folder"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."basemaps"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."mapbox_key"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."module_bar"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."project_descriptor"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."translation_strings"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."default_language"  IS NULL;


COMMENT ON COLUMN "public"."directus_settings"."custom_aspect_ratios"  IS NULL;

COMMENT ON CONSTRAINT "directus_settings_pkey" ON "public"."directus_settings" IS NULL;


COMMENT ON CONSTRAINT "directus_settings_project_logo_foreign" ON "public"."directus_settings" IS NULL;


COMMENT ON CONSTRAINT "directus_settings_public_background_foreign" ON "public"."directus_settings" IS NULL;


COMMENT ON CONSTRAINT "directus_settings_public_foreground_foreign" ON "public"."directus_settings" IS NULL;


COMMENT ON CONSTRAINT "directus_settings_storage_default_folder_foreign" ON "public"."directus_settings" IS NULL;

COMMENT ON TABLE "public"."directus_settings"  IS NULL;

--- END CREATE TABLE "public"."directus_settings" ---

--- BEGIN CREATE TABLE "public"."directus_notifications" ---

CREATE TABLE IF NOT EXISTS "public"."directus_notifications" (
	"id" int4 NOT NULL DEFAULT nextval('directus_notifications_id_seq'::regclass) ,
	"timestamp" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"status" varchar(255) NULL DEFAULT 'inbox'::character varying ,
	"recipient" uuid NOT NULL  ,
	"sender" uuid NULL  ,
	"subject" varchar(255) NOT NULL  ,
	"message" text NULL  ,
	"collection" varchar(64) NULL  ,
	"item" varchar(255) NULL  ,
	CONSTRAINT "directus_notifications_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_notifications_recipient_foreign" FOREIGN KEY (recipient) REFERENCES directus_users(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_notifications_sender_foreign" FOREIGN KEY (sender) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."directus_notifications" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_notifications"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_notifications"."timestamp"  IS NULL;


COMMENT ON COLUMN "public"."directus_notifications"."status"  IS NULL;


COMMENT ON COLUMN "public"."directus_notifications"."recipient"  IS NULL;


COMMENT ON COLUMN "public"."directus_notifications"."sender"  IS NULL;


COMMENT ON COLUMN "public"."directus_notifications"."subject"  IS NULL;


COMMENT ON COLUMN "public"."directus_notifications"."message"  IS NULL;


COMMENT ON COLUMN "public"."directus_notifications"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_notifications"."item"  IS NULL;

COMMENT ON CONSTRAINT "directus_notifications_pkey" ON "public"."directus_notifications" IS NULL;


COMMENT ON CONSTRAINT "directus_notifications_recipient_foreign" ON "public"."directus_notifications" IS NULL;


COMMENT ON CONSTRAINT "directus_notifications_sender_foreign" ON "public"."directus_notifications" IS NULL;

COMMENT ON TABLE "public"."directus_notifications"  IS NULL;

--- END CREATE TABLE "public"."directus_notifications" ---

--- BEGIN CREATE TABLE "public"."directus_operations" ---

CREATE TABLE IF NOT EXISTS "public"."directus_operations" (
	"id" uuid NOT NULL  ,
	"name" varchar(255) NULL  ,
	"key" varchar(255) NOT NULL  ,
	"type" varchar(255) NOT NULL  ,
	"position_x" int4 NOT NULL  ,
	"position_y" int4 NOT NULL  ,
	"options" json NULL  ,
	"resolve" uuid NULL  ,
	"reject" uuid NULL  ,
	"flow" uuid NOT NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	CONSTRAINT "directus_operations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_operations_reject_unique" UNIQUE (reject) ,
	CONSTRAINT "directus_operations_resolve_unique" UNIQUE (resolve) ,
	CONSTRAINT "directus_operations_flow_foreign" FOREIGN KEY (flow) REFERENCES directus_flows(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_operations_reject_foreign" FOREIGN KEY (reject) REFERENCES directus_operations(id) ,
	CONSTRAINT "directus_operations_resolve_foreign" FOREIGN KEY (resolve) REFERENCES directus_operations(id) ,
	CONSTRAINT "directus_operations_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS directus_operations_reject_unique ON public.directus_operations USING btree (reject);


CREATE UNIQUE INDEX IF NOT EXISTS directus_operations_resolve_unique ON public.directus_operations USING btree (resolve);

ALTER TABLE IF EXISTS "public"."directus_operations" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_operations"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."key"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."type"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."position_x"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."position_y"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."options"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."resolve"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."reject"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."flow"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."directus_operations"."user_created"  IS NULL;

COMMENT ON CONSTRAINT "directus_operations_pkey" ON "public"."directus_operations" IS NULL;


COMMENT ON CONSTRAINT "directus_operations_reject_unique" ON "public"."directus_operations" IS NULL;


COMMENT ON CONSTRAINT "directus_operations_resolve_unique" ON "public"."directus_operations" IS NULL;


COMMENT ON CONSTRAINT "directus_operations_flow_foreign" ON "public"."directus_operations" IS NULL;


COMMENT ON CONSTRAINT "directus_operations_reject_foreign" ON "public"."directus_operations" IS NULL;


COMMENT ON CONSTRAINT "directus_operations_resolve_foreign" ON "public"."directus_operations" IS NULL;


COMMENT ON CONSTRAINT "directus_operations_user_created_foreign" ON "public"."directus_operations" IS NULL;

COMMENT ON INDEX "public"."directus_operations_reject_unique"  IS NULL;


COMMENT ON INDEX "public"."directus_operations_resolve_unique"  IS NULL;

COMMENT ON TABLE "public"."directus_operations"  IS NULL;

--- END CREATE TABLE "public"."directus_operations" ---


--- BEGIN CREATE TABLE "public"."directus_webhooks" ---

CREATE TABLE IF NOT EXISTS "public"."directus_webhooks" (
	"id" int4 NOT NULL DEFAULT nextval('directus_webhooks_id_seq'::regclass) ,
	"name" varchar(255) NOT NULL  ,
	"method" varchar(10) NOT NULL DEFAULT 'POST'::character varying ,
	"url" varchar(255) NOT NULL  ,
	"status" varchar(10) NOT NULL DEFAULT 'active'::character varying ,
	"data" bool NOT NULL DEFAULT true ,
	"actions" varchar(100) NOT NULL  ,
	"collections" varchar(255) NOT NULL  ,
	"headers" json NULL  ,
	CONSTRAINT "directus_webhooks_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."directus_webhooks" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_webhooks"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_webhooks"."name"  IS NULL;


COMMENT ON COLUMN "public"."directus_webhooks"."method"  IS NULL;


COMMENT ON COLUMN "public"."directus_webhooks"."url"  IS NULL;


COMMENT ON COLUMN "public"."directus_webhooks"."status"  IS NULL;


COMMENT ON COLUMN "public"."directus_webhooks"."data"  IS NULL;


COMMENT ON COLUMN "public"."directus_webhooks"."actions"  IS NULL;


COMMENT ON COLUMN "public"."directus_webhooks"."collections"  IS NULL;


COMMENT ON COLUMN "public"."directus_webhooks"."headers"  IS NULL;

COMMENT ON CONSTRAINT "directus_webhooks_pkey" ON "public"."directus_webhooks" IS NULL;

COMMENT ON TABLE "public"."directus_webhooks"  IS NULL;

--- END CREATE TABLE "public"."directus_webhooks" ---

--- BEGIN CREATE TABLE "public"."shows" ---

CREATE TABLE IF NOT EXISTS "public"."shows" (
	"agerating_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"available_from" timestamp NULL  ,
	"available_to" timestamp NULL  ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('shows_id_seq'::regclass) ,
	"image_file_id" uuid NULL  ,
	"legacy_description_id" int4 NULL  ,
	"legacy_id" int4 NULL  ,
	"legacy_title_id" int4 NULL  ,
	"publish_date" timestamp NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"type" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "shows_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "shows_agerating_code_foreign" FOREIGN KEY (agerating_code) REFERENCES ageratings(code) ON DELETE SET NULL ,
	CONSTRAINT "shows_image_file_id_foreign" FOREIGN KEY (image_file_id) REFERENCES directus_files(id) ON DELETE SET NULL ,
	CONSTRAINT "shows_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "shows_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."shows" OWNER TO manager;


COMMENT ON COLUMN "public"."shows"."agerating_code"  IS NULL;


COMMENT ON COLUMN "public"."shows"."available_from"  IS NULL;


COMMENT ON COLUMN "public"."shows"."available_to"  IS NULL;


COMMENT ON COLUMN "public"."shows"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."shows"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."shows"."id"  IS NULL;


COMMENT ON COLUMN "public"."shows"."image_file_id"  IS NULL;


COMMENT ON COLUMN "public"."shows"."legacy_description_id"  IS NULL;


COMMENT ON COLUMN "public"."shows"."legacy_id"  IS NULL;


COMMENT ON COLUMN "public"."shows"."legacy_title_id"  IS NULL;


COMMENT ON COLUMN "public"."shows"."publish_date"  IS NULL;


COMMENT ON COLUMN "public"."shows"."status"  IS NULL;


COMMENT ON COLUMN "public"."shows"."type"  IS NULL;


COMMENT ON COLUMN "public"."shows"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."shows"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "shows_pkey" ON "public"."shows" IS NULL;


COMMENT ON CONSTRAINT "shows_agerating_code_foreign" ON "public"."shows" IS NULL;


COMMENT ON CONSTRAINT "shows_image_file_id_foreign" ON "public"."shows" IS NULL;


COMMENT ON CONSTRAINT "shows_user_created_foreign" ON "public"."shows" IS NULL;


COMMENT ON CONSTRAINT "shows_user_updated_foreign" ON "public"."shows" IS NULL;

COMMENT ON TABLE "public"."shows"  IS NULL;

--- END CREATE TABLE "public"."shows" ---
--- BEGIN CREATE TABLE "public"."seasons" ---

CREATE TABLE IF NOT EXISTS "public"."seasons" (
	"agerating_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"available_from" timestamp NULL  ,
	"available_to" timestamp NULL  ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('seasons_id_seq'::regclass) ,
	"image_file_id" uuid NULL  ,
	"legacy_description_id" int4 NULL  ,
	"legacy_id" int4 NULL  ,
	"legacy_title_id" int4 NULL  ,
	"publish_date" timestamp NOT NULL  ,
	"season_number" int4 NOT NULL  ,
	"show_id" int4 NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "seasons_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "seasons_agerating_code_foreign" FOREIGN KEY (agerating_code) REFERENCES ageratings(code) ON DELETE SET NULL ,
	CONSTRAINT "seasons_image_file_id_foreign" FOREIGN KEY (image_file_id) REFERENCES directus_files(id) ON DELETE SET NULL ,
	CONSTRAINT "seasons_show_id_foreign" FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE ,
	CONSTRAINT "seasons_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "seasons_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."seasons" OWNER TO manager;


COMMENT ON COLUMN "public"."seasons"."agerating_code"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."available_from"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."available_to"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."id"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."image_file_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."legacy_description_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."legacy_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."legacy_title_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."publish_date"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."season_number"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."show_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."status"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."seasons"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "seasons_pkey" ON "public"."seasons" IS NULL;


COMMENT ON CONSTRAINT "seasons_agerating_code_foreign" ON "public"."seasons" IS NULL;


COMMENT ON CONSTRAINT "seasons_image_file_id_foreign" ON "public"."seasons" IS NULL;


COMMENT ON CONSTRAINT "seasons_show_id_foreign" ON "public"."seasons" IS NULL;


COMMENT ON CONSTRAINT "seasons_user_created_foreign" ON "public"."seasons" IS NULL;


COMMENT ON CONSTRAINT "seasons_user_updated_foreign" ON "public"."seasons" IS NULL;

COMMENT ON TABLE "public"."seasons"  IS NULL;

--- END CREATE TABLE "public"."seasons" ---

--- BEGIN CREATE TABLE "public"."usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."usergroups" (
	"code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"emails" text NULL  ,
	"name" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"sort" int4 NULL  ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "usergroups_pkey" PRIMARY KEY (code) ,
	CONSTRAINT "usergroups_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "usergroups_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."usergroups" OWNER TO manager;


COMMENT ON COLUMN "public"."usergroups"."code"  IS NULL;


COMMENT ON COLUMN "public"."usergroups"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."usergroups"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."usergroups"."emails"  IS NULL;


COMMENT ON COLUMN "public"."usergroups"."name"  IS NULL;


COMMENT ON COLUMN "public"."usergroups"."sort"  IS NULL;


COMMENT ON COLUMN "public"."usergroups"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."usergroups"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "usergroups_pkey" ON "public"."usergroups" IS NULL;


COMMENT ON CONSTRAINT "usergroups_user_created_foreign" ON "public"."usergroups" IS NULL;


COMMENT ON CONSTRAINT "usergroups_user_updated_foreign" ON "public"."usergroups" IS NULL;

COMMENT ON TABLE "public"."usergroups"  IS NULL;

--- END CREATE TABLE "public"."usergroups" ---

--- BEGIN CREATE TABLE "public"."episodes_usergroups_download" ---

CREATE TABLE IF NOT EXISTS "public"."episodes_usergroups_download" (
	"episodes_id" int4 NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('episodes_usergroups_download_id_seq'::regclass) ,
	"usergroups_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	CONSTRAINT "episodes_usergroups_download_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "episodes_usergroups_download_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE ,
	CONSTRAINT "episodes_usergroups_download_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."episodes_usergroups_download" OWNER TO manager;


COMMENT ON COLUMN "public"."episodes_usergroups_download"."episodes_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups_download"."id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups_download"."usergroups_code"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups_download"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups_download"."date_updated"  IS NULL;

COMMENT ON CONSTRAINT "episodes_usergroups_download_pkey" ON "public"."episodes_usergroups_download" IS NULL;


COMMENT ON CONSTRAINT "episodes_usergroups_download_episodes_id_foreign" ON "public"."episodes_usergroups_download" IS NULL;


COMMENT ON CONSTRAINT "episodes_usergroups_download_usergroups_code_foreign" ON "public"."episodes_usergroups_download" IS NULL;

COMMENT ON TABLE "public"."episodes_usergroups_download"  IS NULL;

--- END CREATE TABLE "public"."episodes_usergroups_download" ---


--- BEGIN CREATE TABLE "public"."episodes_usergroups_earlyaccess" ---

CREATE TABLE IF NOT EXISTS "public"."episodes_usergroups_earlyaccess" (
	"episodes_id" int4 NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('episodes_usergroups_earlyaccess_id_seq'::regclass) ,
	"usergroups_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	CONSTRAINT "episodes_usergroups_earlyaccess_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "episodes_usergroups_earlyaccess_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE ,
	CONSTRAINT "episodes_usergroups_earlyaccess_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."episodes_usergroups_earlyaccess" OWNER TO manager;


COMMENT ON COLUMN "public"."episodes_usergroups_earlyaccess"."episodes_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups_earlyaccess"."id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups_earlyaccess"."usergroups_code"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups_earlyaccess"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups_earlyaccess"."date_updated"  IS NULL;

COMMENT ON CONSTRAINT "episodes_usergroups_earlyaccess_pkey" ON "public"."episodes_usergroups_earlyaccess" IS NULL;


COMMENT ON CONSTRAINT "episodes_usergroups_earlyaccess_episodes_id_foreign" ON "public"."episodes_usergroups_earlyaccess" IS NULL;


COMMENT ON CONSTRAINT "episodes_usergroups_earlyaccess_usergroups_code_foreign" ON "public"."episodes_usergroups_earlyaccess" IS NULL;

COMMENT ON TABLE "public"."episodes_usergroups_earlyaccess"  IS NULL;

--- END CREATE TABLE "public"."episodes_usergroups_earlyaccess" ---

--- BEGIN CREATE TABLE "public"."episodes_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."episodes_usergroups" (
	"episodes_id" int4 NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('episodes_usergroups_id_seq'::regclass) ,
	"type" varchar(255) NULL DEFAULT NULL::character varying ,
	"usergroups_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	CONSTRAINT "episodes_usergroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "episodes_usergroups_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE ,
	CONSTRAINT "episodes_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."episodes_usergroups" OWNER TO manager;


COMMENT ON COLUMN "public"."episodes_usergroups"."episodes_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups"."type"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups"."usergroups_code"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."episodes_usergroups"."date_updated"  IS NULL;

COMMENT ON CONSTRAINT "episodes_usergroups_pkey" ON "public"."episodes_usergroups" IS NULL;


COMMENT ON CONSTRAINT "episodes_usergroups_episodes_id_foreign" ON "public"."episodes_usergroups" IS NULL;


COMMENT ON CONSTRAINT "episodes_usergroups_usergroups_code_foreign" ON "public"."episodes_usergroups" IS NULL;

COMMENT ON TABLE "public"."episodes_usergroups"  IS NULL;

--- END CREATE TABLE "public"."episodes_usergroups" ---


--- BEGIN CREATE TABLE "public"."faq_categories" ---

CREATE TABLE IF NOT EXISTS "public"."faq_categories" (
	"id" int4 NOT NULL DEFAULT nextval('faq_categories_id_seq'::regclass) ,
	"sort" int4 NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	CONSTRAINT "faq_categories_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."faq_categories" OWNER TO manager;


COMMENT ON COLUMN "public"."faq_categories"."id"  IS NULL;


COMMENT ON COLUMN "public"."faq_categories"."sort"  IS NULL;


COMMENT ON COLUMN "public"."faq_categories"."status"  IS NULL;

COMMENT ON CONSTRAINT "faq_categories_pkey" ON "public"."faq_categories" IS NULL;

COMMENT ON TABLE "public"."faq_categories"  IS NULL;

--- END CREATE TABLE "public"."faq_categories" ---

--- BEGIN CREATE TABLE "public"."faqs" ---

CREATE TABLE IF NOT EXISTS "public"."faqs" (
	"category" int4 NOT NULL  ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('faqs_id_seq'::regclass) ,
	"sort" int4 NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NOT NULL  ,
	"user_updated" uuid NOT NULL  ,
	CONSTRAINT "faqs_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "faqs_category_foreign" FOREIGN KEY (category) REFERENCES faq_categories(id) ,
	CONSTRAINT "faqs_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "faqs_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."faqs" OWNER TO manager;


COMMENT ON COLUMN "public"."faqs"."category"  IS NULL;


COMMENT ON COLUMN "public"."faqs"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."faqs"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."faqs"."id"  IS NULL;


COMMENT ON COLUMN "public"."faqs"."sort"  IS NULL;


COMMENT ON COLUMN "public"."faqs"."status"  IS NULL;


COMMENT ON COLUMN "public"."faqs"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."faqs"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "faqs_pkey" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_category_foreign" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_user_created_foreign" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_user_updated_foreign" ON "public"."faqs" IS NULL;

COMMENT ON TABLE "public"."faqs"  IS NULL;

--- END CREATE TABLE "public"."faqs" ---

--- BEGIN CREATE TABLE "public"."faqs_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."faqs_usergroups" (
	"faqs_id" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('faqs_usergroups_id_seq'::regclass) ,
	"usergroups_code" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "faqs_usergroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "faqs_usergroups_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs(id) ,
	CONSTRAINT "faqs_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code)
);

ALTER TABLE IF EXISTS "public"."faqs_usergroups" OWNER TO manager;


COMMENT ON COLUMN "public"."faqs_usergroups"."faqs_id"  IS NULL;


COMMENT ON COLUMN "public"."faqs_usergroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."faqs_usergroups"."usergroups_code"  IS NULL;

COMMENT ON CONSTRAINT "faqs_usergroups_pkey" ON "public"."faqs_usergroups" IS NULL;


COMMENT ON CONSTRAINT "faqs_usergroups_faqs_id_foreign" ON "public"."faqs_usergroups" IS NULL;


COMMENT ON CONSTRAINT "faqs_usergroups_usergroups_code_foreign" ON "public"."faqs_usergroups" IS NULL;

COMMENT ON TABLE "public"."faqs_usergroups"  IS NULL;

--- END CREATE TABLE "public"."faqs_usergroups" ---

--- BEGIN CREATE TABLE "public"."events" ---

CREATE TABLE IF NOT EXISTS "public"."events" (
	"date_created" timestamptz NULL  ,
	"date_updated" timestamptz NULL  ,
	"end" timestamp NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('events_id_seq'::regclass) ,
	"start" timestamp NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "events_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "events_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "events_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."events" OWNER TO manager;


COMMENT ON COLUMN "public"."events"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."events"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."events"."end"  IS NULL;


COMMENT ON COLUMN "public"."events"."id"  IS NULL;


COMMENT ON COLUMN "public"."events"."start"  IS NULL;


COMMENT ON COLUMN "public"."events"."status"  IS NULL;


COMMENT ON COLUMN "public"."events"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."events"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "events_pkey" ON "public"."events" IS NULL;


COMMENT ON CONSTRAINT "events_user_created_foreign" ON "public"."events" IS NULL;


COMMENT ON CONSTRAINT "events_user_updated_foreign" ON "public"."events" IS NULL;

COMMENT ON TABLE "public"."events"  IS NULL;

--- END CREATE TABLE "public"."events" ---

--- BEGIN CREATE TABLE "public"."events_translations" ---

CREATE TABLE IF NOT EXISTS "public"."events_translations" (
	"description" varchar(255) NULL DEFAULT NULL::character varying ,
	"events_id" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('events_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "events_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "events_translations_events_id_foreign" FOREIGN KEY (events_id) REFERENCES events(id) ON DELETE SET NULL ,
	CONSTRAINT "events_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."events_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."events_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."events_translations"."events_id"  IS NULL;


COMMENT ON COLUMN "public"."events_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."events_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."events_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "events_translations_pkey" ON "public"."events_translations" IS NULL;


COMMENT ON CONSTRAINT "events_translations_events_id_foreign" ON "public"."events_translations" IS NULL;


COMMENT ON CONSTRAINT "events_translations_languages_code_foreign" ON "public"."events_translations" IS NULL;

COMMENT ON TABLE "public"."events_translations"  IS NULL;

--- END CREATE TABLE "public"."events_translations" ---

--- BEGIN CREATE TABLE "public"."episodes_categories" ---

CREATE TABLE IF NOT EXISTS "public"."episodes_categories" (
	"categories_id" int4 NOT NULL  ,
	"episodes_id" int4 NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('episodes_categories_id_seq'::regclass) ,
	CONSTRAINT "episodes_categories_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "episodes_categories_categories_id_foreign" FOREIGN KEY (categories_id) REFERENCES categories(id) ON DELETE CASCADE ,
	CONSTRAINT "episodes_categories_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."episodes_categories" OWNER TO manager;


COMMENT ON COLUMN "public"."episodes_categories"."categories_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_categories"."episodes_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_categories"."id"  IS NULL;

COMMENT ON CONSTRAINT "episodes_categories_pkey" ON "public"."episodes_categories" IS NULL;


COMMENT ON CONSTRAINT "episodes_categories_categories_id_foreign" ON "public"."episodes_categories" IS NULL;


COMMENT ON CONSTRAINT "episodes_categories_episodes_id_foreign" ON "public"."episodes_categories" IS NULL;

COMMENT ON TABLE "public"."episodes_categories"  IS NULL;

--- END CREATE TABLE "public"."episodes_categories" ---


--- BEGIN CREATE TABLE "public"."tags" ---

CREATE TABLE IF NOT EXISTS "public"."tags" (
	"code" varchar(255) NULL DEFAULT NULL::character varying ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('tags_id_seq'::regclass) ,
	"name" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "tags_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "tags_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "tags_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."tags" OWNER TO manager;


COMMENT ON COLUMN "public"."tags"."code"  IS NULL;


COMMENT ON COLUMN "public"."tags"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."tags"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."tags"."id"  IS NULL;


COMMENT ON COLUMN "public"."tags"."name"  IS NULL;


COMMENT ON COLUMN "public"."tags"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."tags"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "tags_pkey" ON "public"."tags" IS NULL;


COMMENT ON CONSTRAINT "tags_user_created_foreign" ON "public"."tags" IS NULL;


COMMENT ON CONSTRAINT "tags_user_updated_foreign" ON "public"."tags" IS NULL;

COMMENT ON TABLE "public"."tags"  IS NULL;

--- END CREATE TABLE "public"."tags" ---

--- BEGIN CREATE TABLE "public"."tags_translations" ---

CREATE TABLE IF NOT EXISTS "public"."tags_translations" (
	"id" int4 NOT NULL DEFAULT nextval('tags_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"name" varchar(255) NULL DEFAULT NULL::character varying ,
	"tags_id" int4 NULL  ,
	CONSTRAINT "tags_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "tags_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "tags_translations_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."tags_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."tags_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."tags_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."tags_translations"."name"  IS NULL;


COMMENT ON COLUMN "public"."tags_translations"."tags_id"  IS NULL;

COMMENT ON CONSTRAINT "tags_translations_pkey" ON "public"."tags_translations" IS NULL;


COMMENT ON CONSTRAINT "tags_translations_languages_code_foreign" ON "public"."tags_translations" IS NULL;


COMMENT ON CONSTRAINT "tags_translations_tags_id_foreign" ON "public"."tags_translations" IS NULL;

COMMENT ON TABLE "public"."tags_translations"  IS NULL;

--- END CREATE TABLE "public"."tags_translations" ---
--- BEGIN CREATE TABLE "public"."episodes_tags" ---

CREATE TABLE IF NOT EXISTS "public"."episodes_tags" (
	"episodes_id" int4 NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('episodes_tags_id_seq'::regclass) ,
	"tags_id" int4 NOT NULL  ,
	CONSTRAINT "episodes_tags_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "episodes_tags_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE ,
	CONSTRAINT "episodes_tags_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."episodes_tags" OWNER TO manager;


COMMENT ON COLUMN "public"."episodes_tags"."episodes_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_tags"."id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_tags"."tags_id"  IS NULL;

COMMENT ON CONSTRAINT "episodes_tags_pkey" ON "public"."episodes_tags" IS NULL;


COMMENT ON CONSTRAINT "episodes_tags_episodes_id_foreign" ON "public"."episodes_tags" IS NULL;


COMMENT ON CONSTRAINT "episodes_tags_tags_id_foreign" ON "public"."episodes_tags" IS NULL;

COMMENT ON TABLE "public"."episodes_tags"  IS NULL;

--- END CREATE TABLE "public"."episodes_tags" ---

--- BEGIN CREATE TABLE "public"."episodes_translations" ---

CREATE TABLE IF NOT EXISTS "public"."episodes_translations" (
	"description" text NULL  ,
	"episodes_id" int4 NOT NULL  ,
	"extra_description" text NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('episodes_translations_id_seq'::regclass) ,
	"is_primary" bool NOT NULL DEFAULT true ,
	"languages_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "episodes_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "episodes_translations_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE ,
	CONSTRAINT "episodes_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."episodes_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."episodes_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."episodes_translations"."episodes_id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_translations"."extra_description"  IS NULL;


COMMENT ON COLUMN "public"."episodes_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."episodes_translations"."is_primary"  IS NULL;


COMMENT ON COLUMN "public"."episodes_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."episodes_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "episodes_translations_pkey" ON "public"."episodes_translations" IS NULL;


COMMENT ON CONSTRAINT "episodes_translations_episodes_id_foreign" ON "public"."episodes_translations" IS NULL;


COMMENT ON CONSTRAINT "episodes_translations_languages_code_foreign" ON "public"."episodes_translations" IS NULL;

COMMENT ON TABLE "public"."episodes_translations"  IS NULL;

--- END CREATE TABLE "public"."episodes_translations" ---

--- BEGIN CREATE TABLE "public"."faqs_translations" ---

CREATE TABLE IF NOT EXISTS "public"."faqs_translations" (
	"answer" text NULL  ,
	"faqs_id" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('faqs_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"question" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "faqs_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "faqs_translations_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs(id) ON DELETE CASCADE ,
	CONSTRAINT "faqs_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."faqs_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."faqs_translations"."answer"  IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."faqs_id"  IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."question"  IS NULL;

COMMENT ON CONSTRAINT "faqs_translations_pkey" ON "public"."faqs_translations" IS NULL;


COMMENT ON CONSTRAINT "faqs_translations_faqs_id_foreign" ON "public"."faqs_translations" IS NULL;


COMMENT ON CONSTRAINT "faqs_translations_languages_code_foreign" ON "public"."faqs_translations" IS NULL;

COMMENT ON TABLE "public"."faqs_translations"  IS NULL;

--- END CREATE TABLE "public"."faqs_translations" ---

--- BEGIN CREATE TABLE "public"."globalconfig" ---

CREATE TABLE IF NOT EXISTS "public"."globalconfig" (
	"date_updated" timestamptz NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('globalconfig_id_seq'::regclass) ,
	"live_online" bool NULL DEFAULT false ,
	"npaw_enabled" bool NULL DEFAULT false ,
	"user_updated" uuid NOT NULL  ,
	CONSTRAINT "globalconfig_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "globalconfig_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."globalconfig" OWNER TO manager;


COMMENT ON COLUMN "public"."globalconfig"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."globalconfig"."id"  IS NULL;


COMMENT ON COLUMN "public"."globalconfig"."live_online"  IS NULL;


COMMENT ON COLUMN "public"."globalconfig"."npaw_enabled"  IS NULL;


COMMENT ON COLUMN "public"."globalconfig"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "globalconfig_pkey" ON "public"."globalconfig" IS NULL;


COMMENT ON CONSTRAINT "globalconfig_user_updated_foreign" ON "public"."globalconfig" IS NULL;

COMMENT ON TABLE "public"."globalconfig"  IS NULL;

--- END CREATE TABLE "public"."globalconfig" ---

--- BEGIN CREATE TABLE "public"."lists" ---

CREATE TABLE IF NOT EXISTS "public"."lists" (
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('lists_id_seq'::regclass) ,
	"legacy_category_id" int4 NULL  ,
	"legacy_name_id" int4 NULL  ,
	"name" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "lists_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "lists_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "lists_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."lists" OWNER TO manager;


COMMENT ON COLUMN "public"."lists"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."lists"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."lists"."id"  IS NULL;


COMMENT ON COLUMN "public"."lists"."legacy_category_id"  IS NULL;


COMMENT ON COLUMN "public"."lists"."legacy_name_id"  IS NULL;


COMMENT ON COLUMN "public"."lists"."name"  IS NULL;


COMMENT ON COLUMN "public"."lists"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."lists"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "lists_pkey" ON "public"."lists" IS NULL;


COMMENT ON CONSTRAINT "lists_user_created_foreign" ON "public"."lists" IS NULL;


COMMENT ON CONSTRAINT "lists_user_updated_foreign" ON "public"."lists" IS NULL;

COMMENT ON TABLE "public"."lists"  IS NULL;

--- END CREATE TABLE "public"."lists" ---

--- BEGIN CREATE TABLE "public"."lists_relations" ---

CREATE TABLE IF NOT EXISTS "public"."lists_relations" (
	"collection" varchar(255) NULL DEFAULT NULL::character varying ,
	"id" int4 NOT NULL DEFAULT nextval('lists_relations_id_seq'::regclass) ,
	"item" varchar(255) NULL DEFAULT NULL::character varying ,
	"lists_id" int4 NULL  ,
	"sort" int4 NULL  ,
	CONSTRAINT "lists_relations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "lists_relations_lists_id_foreign" FOREIGN KEY (lists_id) REFERENCES lists(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."lists_relations" OWNER TO manager;


COMMENT ON COLUMN "public"."lists_relations"."collection"  IS NULL;


COMMENT ON COLUMN "public"."lists_relations"."id"  IS NULL;


COMMENT ON COLUMN "public"."lists_relations"."item"  IS NULL;


COMMENT ON COLUMN "public"."lists_relations"."lists_id"  IS NULL;


COMMENT ON COLUMN "public"."lists_relations"."sort"  IS NULL;

COMMENT ON CONSTRAINT "lists_relations_pkey" ON "public"."lists_relations" IS NULL;


COMMENT ON CONSTRAINT "lists_relations_lists_id_foreign" ON "public"."lists_relations" IS NULL;

COMMENT ON TABLE "public"."lists_relations"  IS NULL;

--- END CREATE TABLE "public"."lists_relations" ---

--- BEGIN CREATE TABLE "public"."materialized_views_meta" ---

CREATE TABLE IF NOT EXISTS "public"."materialized_views_meta" (
	"view_name" text NOT NULL  ,
	"last_refreshed" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	CONSTRAINT "materialized_views_meta_pk" PRIMARY KEY (view_name)
);

ALTER TABLE IF EXISTS "public"."materialized_views_meta" OWNER TO manager;


COMMENT ON COLUMN "public"."materialized_views_meta"."view_name"  IS NULL;


COMMENT ON COLUMN "public"."materialized_views_meta"."last_refreshed"  IS NULL;

COMMENT ON CONSTRAINT "materialized_views_meta_pk" ON "public"."materialized_views_meta" IS NULL;

COMMENT ON TABLE "public"."materialized_views_meta"  IS NULL;

--- END CREATE TABLE "public"."materialized_views_meta" ---



--- BEGIN CREATE TABLE "public"."maintenancemessage" ---

CREATE TABLE IF NOT EXISTS "public"."maintenancemessage" (
	"active" bool NULL DEFAULT false ,
	"date_updated" timestamptz NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('maintenancemessage_id_seq'::regclass) ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "maintenancemessage_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "maintenancemessage_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."maintenancemessage" OWNER TO manager;


COMMENT ON COLUMN "public"."maintenancemessage"."active"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage"."id"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "maintenancemessage_pkey" ON "public"."maintenancemessage" IS NULL;


COMMENT ON CONSTRAINT "maintenancemessage_user_updated_foreign" ON "public"."maintenancemessage" IS NULL;

COMMENT ON TABLE "public"."maintenancemessage"  IS NULL;

--- END CREATE TABLE "public"."maintenancemessage" ---

--- BEGIN CREATE TABLE "public"."seasons_translations" ---

CREATE TABLE IF NOT EXISTS "public"."seasons_translations" (
	"description" text NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('seasons_translations_id_seq'::regclass) ,
	"is_primary" bool NOT NULL DEFAULT false ,
	"languages_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"legacy_description_id" int4 NULL  ,
	"legacy_title_id" int4 NULL  ,
	"seasons_id" int4 NOT NULL  ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "seasons_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "seasons_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "seasons_translations_seasons_id_foreign" FOREIGN KEY (seasons_id) REFERENCES seasons(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."seasons_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."seasons_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."seasons_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."seasons_translations"."is_primary"  IS NULL;


COMMENT ON COLUMN "public"."seasons_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."seasons_translations"."legacy_description_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons_translations"."legacy_title_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons_translations"."seasons_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "seasons_translations_pkey" ON "public"."seasons_translations" IS NULL;


COMMENT ON CONSTRAINT "seasons_translations_languages_code_foreign" ON "public"."seasons_translations" IS NULL;


COMMENT ON CONSTRAINT "seasons_translations_seasons_id_foreign" ON "public"."seasons_translations" IS NULL;

COMMENT ON TABLE "public"."seasons_translations"  IS NULL;

--- END CREATE TABLE "public"."seasons_translations" ---

--- BEGIN CREATE TABLE "public"."seasons_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."seasons_usergroups" (
	"id" int4 NOT NULL DEFAULT nextval('seasons_usergroups_id_seq'::regclass) ,
	"seasons_id" int4 NOT NULL  ,
	"usergroups_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "seasons_usergroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "seasons_usergroups_seasons_id_foreign" FOREIGN KEY (seasons_id) REFERENCES seasons(id) ,
	CONSTRAINT "seasons_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code)
);

ALTER TABLE IF EXISTS "public"."seasons_usergroups" OWNER TO manager;


COMMENT ON COLUMN "public"."seasons_usergroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."seasons_usergroups"."seasons_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons_usergroups"."usergroups_code"  IS NULL;

COMMENT ON CONSTRAINT "seasons_usergroups_pkey" ON "public"."seasons_usergroups" IS NULL;


COMMENT ON CONSTRAINT "seasons_usergroups_seasons_id_foreign" ON "public"."seasons_usergroups" IS NULL;


COMMENT ON CONSTRAINT "seasons_usergroups_usergroups_code_foreign" ON "public"."seasons_usergroups" IS NULL;

COMMENT ON TABLE "public"."seasons_usergroups"  IS NULL;

--- END CREATE TABLE "public"."seasons_usergroups" ---


--- BEGIN CREATE TABLE "public"."messagetemplates" ---

CREATE TABLE IF NOT EXISTS "public"."messagetemplates" (
	"date_created" timestamptz NULL  ,
	"date_updated" timestamptz NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('messagetemplates_id_seq'::regclass) ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"type" varchar(255) NOT NULL DEFAULT 'error'::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "messagetemplates_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "messagetemplates_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "messagetemplates_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."messagetemplates" OWNER TO manager;


COMMENT ON COLUMN "public"."messagetemplates"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates"."id"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates"."status"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates"."type"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "messagetemplates_pkey" ON "public"."messagetemplates" IS NULL;


COMMENT ON CONSTRAINT "messagetemplates_user_created_foreign" ON "public"."messagetemplates" IS NULL;


COMMENT ON CONSTRAINT "messagetemplates_user_updated_foreign" ON "public"."messagetemplates" IS NULL;

COMMENT ON TABLE "public"."messagetemplates"  IS NULL;

--- END CREATE TABLE "public"."messagetemplates" ---

--- BEGIN CREATE TABLE "public"."messagetemplates_translations" ---

CREATE TABLE IF NOT EXISTS "public"."messagetemplates_translations" (
	"details" text NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('messagetemplates_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"message" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"messagetemplates_id" int4 NULL  ,
	CONSTRAINT "messagetemplates_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "messagetemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "messagetemplates_translations_messagetemplates_id_foreign" FOREIGN KEY (messagetemplates_id) REFERENCES messagetemplates(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."messagetemplates_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."messagetemplates_translations"."details"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates_translations"."message"  IS NULL;


COMMENT ON COLUMN "public"."messagetemplates_translations"."messagetemplates_id"  IS NULL;

COMMENT ON CONSTRAINT "messagetemplates_translations_pkey" ON "public"."messagetemplates_translations" IS NULL;


COMMENT ON CONSTRAINT "messagetemplates_translations_languages_code_foreign" ON "public"."messagetemplates_translations" IS NULL;


COMMENT ON CONSTRAINT "messagetemplates_translations_messagetemplates_id_foreign" ON "public"."messagetemplates_translations" IS NULL;

COMMENT ON TABLE "public"."messagetemplates_translations"  IS NULL;

--- END CREATE TABLE "public"."messagetemplates_translations" ---

--- BEGIN CREATE TABLE "public"."sections" ---

CREATE TABLE IF NOT EXISTS "public"."sections" (
	"collection_id" int4 NULL  ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('sections_id_seq'::regclass) ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	"page_id" int4 NULL  ,
	"sort" int4 NULL  ,
	"style" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "sections_pkey" PRIMARY KEY (id)
);


COMMENT ON TABLE "public"."sections"  IS NULL;

--- END CREATE TABLE "public"."sections" ---

--- BEGIN CREATE TABLE "public"."sections_translations" ---

CREATE TABLE IF NOT EXISTS "public"."sections_translations" (
	"id" int4 NOT NULL DEFAULT nextval('sections_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"sections_id" int4 NULL  ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	"description" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "sections_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "sections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "sections_translations_sections_id_foreign" FOREIGN KEY (sections_id) REFERENCES sections(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."sections_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."sections_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."sections_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."sections_translations"."sections_id"  IS NULL;


COMMENT ON COLUMN "public"."sections_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."sections_translations"."description"  IS NULL;

COMMENT ON CONSTRAINT "sections_translations_pkey" ON "public"."sections_translations" IS NULL;


COMMENT ON CONSTRAINT "sections_translations_languages_code_foreign" ON "public"."sections_translations" IS NULL;


COMMENT ON CONSTRAINT "sections_translations_sections_id_foreign" ON "public"."sections_translations" IS NULL;

COMMENT ON TABLE "public"."sections_translations"  IS NULL;

--- END CREATE TABLE "public"."sections_translations" ---

--- BEGIN CREATE TABLE "public"."sections_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."sections_usergroups" (
	"id" int4 NOT NULL DEFAULT nextval('sections_usergroups_id_seq'::regclass) ,
	"sections_id" int4 NOT NULL  ,
	"usergroups_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "sections_usergroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "sections_usergroups_sections_id_foreign" FOREIGN KEY (sections_id) REFERENCES sections(id) ON DELETE CASCADE ,
	CONSTRAINT "sections_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."sections_usergroups" OWNER TO manager;


COMMENT ON COLUMN "public"."sections_usergroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."sections_usergroups"."sections_id"  IS NULL;


COMMENT ON COLUMN "public"."sections_usergroups"."usergroups_code"  IS NULL;

COMMENT ON CONSTRAINT "sections_usergroups_pkey" ON "public"."sections_usergroups" IS NULL;


COMMENT ON CONSTRAINT "sections_usergroups_sections_id_foreign" ON "public"."sections_usergroups" IS NULL;


COMMENT ON CONSTRAINT "sections_usergroups_usergroups_code_foreign" ON "public"."sections_usergroups" IS NULL;

COMMENT ON TABLE "public"."sections_usergroups"  IS NULL;

--- END CREATE TABLE "public"."sections_usergroups" ---

--- BEGIN CREATE TABLE "public"."shows_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."shows_usergroups" (
	"id" int4 NOT NULL DEFAULT nextval('shows_usergroups_id_seq'::regclass) ,
	"shows_id" int4 NOT NULL  ,
	"usergroups_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "shows_usergroups_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "shows_usergroups_shows_id_foreign" FOREIGN KEY (shows_id) REFERENCES shows(id) ,
	CONSTRAINT "shows_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code)
);

ALTER TABLE IF EXISTS "public"."shows_usergroups" OWNER TO manager;


COMMENT ON COLUMN "public"."shows_usergroups"."id"  IS NULL;


COMMENT ON COLUMN "public"."shows_usergroups"."shows_id"  IS NULL;


COMMENT ON COLUMN "public"."shows_usergroups"."usergroups_code"  IS NULL;

COMMENT ON CONSTRAINT "shows_usergroups_pkey" ON "public"."shows_usergroups" IS NULL;


COMMENT ON CONSTRAINT "shows_usergroups_shows_id_foreign" ON "public"."shows_usergroups" IS NULL;


COMMENT ON CONSTRAINT "shows_usergroups_usergroups_code_foreign" ON "public"."shows_usergroups" IS NULL;

COMMENT ON TABLE "public"."shows_usergroups"  IS NULL;

--- END CREATE TABLE "public"."shows_usergroups" ---


--- BEGIN CREATE TABLE "public"."tvguideentry" ---

CREATE TABLE IF NOT EXISTS "public"."tvguideentry" (
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"description" varchar(255) NULL DEFAULT NULL::character varying ,
	"end" timestamp NULL  ,
	"event" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('tvguideentry_id_seq'::regclass) ,
	"image" uuid NULL  ,
	"start" timestamp NULL  ,
	"status" varchar(255) NULL DEFAULT 'published'::character varying ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	"use_image_from_link" bool NOT NULL DEFAULT true ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "tvguideentry_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "tvguideentry_event_foreign" FOREIGN KEY (event) REFERENCES calendarevent(id) ON DELETE SET NULL ,
	CONSTRAINT "tvguideentry_image_foreign" FOREIGN KEY (image) REFERENCES directus_files(id) ON DELETE SET NULL ,
	CONSTRAINT "tvguideentry_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "tvguideentry_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."tvguideentry" OWNER TO manager;


COMMENT ON COLUMN "public"."tvguideentry"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."description"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."end"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."event"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."id"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."image"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."start"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."status"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."title"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."use_image_from_link"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "tvguideentry_pkey" ON "public"."tvguideentry" IS NULL;


COMMENT ON CONSTRAINT "tvguideentry_event_foreign" ON "public"."tvguideentry" IS NULL;


COMMENT ON CONSTRAINT "tvguideentry_image_foreign" ON "public"."tvguideentry" IS NULL;


COMMENT ON CONSTRAINT "tvguideentry_user_created_foreign" ON "public"."tvguideentry" IS NULL;


COMMENT ON CONSTRAINT "tvguideentry_user_updated_foreign" ON "public"."tvguideentry" IS NULL;

COMMENT ON TABLE "public"."tvguideentry"  IS NULL;

--- END CREATE TABLE "public"."tvguideentry" ---

--- BEGIN CREATE TABLE "public"."webconfig" ---

CREATE TABLE IF NOT EXISTS "public"."webconfig" (
	"date_updated" timestamptz NOT NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('webconfig_id_seq'::regclass) ,
	"user_updated" uuid NOT NULL  ,
	CONSTRAINT "webconfig_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "webconfig_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."webconfig" OWNER TO manager;


COMMENT ON COLUMN "public"."webconfig"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."webconfig"."id"  IS NULL;


COMMENT ON COLUMN "public"."webconfig"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "webconfig_pkey" ON "public"."webconfig" IS NULL;


COMMENT ON CONSTRAINT "webconfig_user_updated_foreign" ON "public"."webconfig" IS NULL;

COMMENT ON TABLE "public"."webconfig"  IS NULL;

--- END CREATE TABLE "public"."webconfig" ---

--- BEGIN CREATE TABLE "public"."shows_translations" ---

CREATE TABLE IF NOT EXISTS "public"."shows_translations" (
	"description" text NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('shows_translations_id_seq'::regclass) ,
	"is_primary" bool NOT NULL DEFAULT false ,
	"languages_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"legacy_description_id" int4 NULL  ,
	"legacy_tags" varchar(255) NULL DEFAULT NULL::character varying ,
	"legacy_tags_id" int4 NULL  ,
	"legacy_title_id" int8 NULL  ,
	"shows_id" int4 NOT NULL  ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "shows_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "shows_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "shows_translations_shows_id_foreign" FOREIGN KEY (shows_id) REFERENCES shows(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."shows_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."shows_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."is_primary"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."legacy_description_id"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."legacy_tags"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."legacy_tags_id"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."legacy_title_id"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."shows_id"  IS NULL;


COMMENT ON COLUMN "public"."shows_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "shows_translations_pkey" ON "public"."shows_translations" IS NULL;


COMMENT ON CONSTRAINT "shows_translations_languages_code_foreign" ON "public"."shows_translations" IS NULL;


COMMENT ON CONSTRAINT "shows_translations_shows_id_foreign" ON "public"."shows_translations" IS NULL;

COMMENT ON TABLE "public"."shows_translations"  IS NULL;

--- END CREATE TABLE "public"."shows_translations" ---

--- BEGIN CREATE TABLE "public"."ageratings_translations" ---

CREATE TABLE IF NOT EXISTS "public"."ageratings_translations" (
	"ageratings_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"description" varchar(255) NULL DEFAULT NULL::character varying ,
	"id" int4 NOT NULL DEFAULT nextval('ageratings_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "ageratings_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "ageratings_translations_ageratings_code_foreign" FOREIGN KEY (ageratings_code) REFERENCES ageratings(code) ,
	CONSTRAINT "ageratings_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code)
);

ALTER TABLE IF EXISTS "public"."ageratings_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."ageratings_translations"."ageratings_code"  IS NULL;


COMMENT ON COLUMN "public"."ageratings_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."ageratings_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."ageratings_translations"."languages_code"  IS NULL;

COMMENT ON CONSTRAINT "ageratings_translations_pkey" ON "public"."ageratings_translations" IS NULL;


COMMENT ON CONSTRAINT "ageratings_translations_ageratings_code_foreign" ON "public"."ageratings_translations" IS NULL;


COMMENT ON CONSTRAINT "ageratings_translations_languages_code_foreign" ON "public"."ageratings_translations" IS NULL;

COMMENT ON TABLE "public"."ageratings_translations"  IS NULL;

--- END CREATE TABLE "public"."ageratings_translations" ---


--- BEGIN CREATE TABLE "public"."collections" ---

CREATE TABLE IF NOT EXISTS "public"."collections" (
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('collections_id_seq'::regclass) ,
	"sort" int4 NULL  ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	"collection" varchar(255) NULL DEFAULT 'pages'::character varying ,
	"episodes_query_filter" json NULL  ,
	"filter_type" varchar(255) NULL DEFAULT 'select'::character varying ,
	"name" varchar(255) NULL DEFAULT NULL::character varying ,
	"pages_query_filter" json NULL  ,
	"seasons_query_filter" json NULL  ,
	"shows_query_filter" json NULL  ,
	CONSTRAINT "collections_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "collections_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "collections_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

ALTER TABLE IF EXISTS "public"."collections" OWNER TO manager;


COMMENT ON COLUMN "public"."collections"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."collections"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."collections"."id"  IS NULL;


COMMENT ON COLUMN "public"."collections"."sort"  IS NULL;


COMMENT ON COLUMN "public"."collections"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."collections"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."collections"."collection"  IS NULL;


COMMENT ON COLUMN "public"."collections"."episodes_query_filter"  IS NULL;


COMMENT ON COLUMN "public"."collections"."filter_type"  IS NULL;


COMMENT ON COLUMN "public"."collections"."name"  IS NULL;


COMMENT ON COLUMN "public"."collections"."pages_query_filter"  IS NULL;


COMMENT ON COLUMN "public"."collections"."seasons_query_filter"  IS NULL;


COMMENT ON COLUMN "public"."collections"."shows_query_filter"  IS NULL;

COMMENT ON CONSTRAINT "collections_pkey" ON "public"."collections" IS NULL;


COMMENT ON CONSTRAINT "collections_user_created_foreign" ON "public"."collections" IS NULL;


COMMENT ON CONSTRAINT "collections_user_updated_foreign" ON "public"."collections" IS NULL;

COMMENT ON TABLE "public"."collections"  IS NULL;

--- END CREATE TABLE "public"."collections" ---

--- BEGIN CREATE TABLE "public"."collections_items" ---

CREATE TABLE IF NOT EXISTS "public"."collections_items" (
	"collection_id" int4 NULL  ,
	"date_created" timestamptz NULL  ,
	"date_updated" timestamptz NULL  ,
	"episode_id" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('collections_items_id_seq'::regclass) ,
	"page_id" int4 NULL  ,
	"season_id" int4 NULL  ,
	"show_id" int4 NULL  ,
	"sort" int4 NULL  ,
	"type" varchar(255) NULL DEFAULT NULL::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "collections_items_pkey" PRIMARY KEY (id)
);


--- END CREATE TABLE "public"."collections_items" ---

--- BEGIN CREATE TABLE "public"."pages" ---

CREATE TABLE IF NOT EXISTS "public"."pages" (
	"code" varchar(255) NULL DEFAULT NULL::character varying ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"id" int4 NOT NULL DEFAULT nextval('pages_id_seq'::regclass) ,
	"sort" int4 NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	"collection" varchar(255) NULL DEFAULT NULL::character varying ,
	"episode_id" int4 NULL  ,
	"season_id" int4 NULL  ,
	"show_id" int4 NULL  ,
	"type" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "pages_code_unique" UNIQUE (code) ,
	CONSTRAINT "pages_collection_unique" UNIQUE (collection) ,
	CONSTRAINT "pages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "pages_episode_id_foreign" FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE SET NULL ,
	CONSTRAINT "pages_season_id_foreign" FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE SET NULL ,
	CONSTRAINT "pages_show_id_foreign" FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE SET NULL ,
	CONSTRAINT "pages_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "pages_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

CREATE UNIQUE INDEX IF NOT EXISTS pages_code_unique ON public.pages USING btree (code);


CREATE UNIQUE INDEX IF NOT EXISTS pages_collection_unique ON public.pages USING btree (collection);

ALTER TABLE IF EXISTS "public"."pages" OWNER TO manager;


COMMENT ON COLUMN "public"."pages"."code"  IS NULL;


COMMENT ON COLUMN "public"."pages"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."pages"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."pages"."id"  IS NULL;


COMMENT ON COLUMN "public"."pages"."sort"  IS NULL;


COMMENT ON COLUMN "public"."pages"."status"  IS NULL;


COMMENT ON COLUMN "public"."pages"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."pages"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."pages"."collection"  IS NULL;


COMMENT ON COLUMN "public"."pages"."episode_id"  IS NULL;


COMMENT ON COLUMN "public"."pages"."season_id"  IS NULL;


COMMENT ON COLUMN "public"."pages"."show_id"  IS NULL;


COMMENT ON COLUMN "public"."pages"."type"  IS NULL;

COMMENT ON CONSTRAINT "pages_code_unique" ON "public"."pages" IS NULL;


COMMENT ON CONSTRAINT "pages_collection_unique" ON "public"."pages" IS NULL;


COMMENT ON CONSTRAINT "pages_pkey" ON "public"."pages" IS NULL;


COMMENT ON CONSTRAINT "pages_episode_id_foreign" ON "public"."pages" IS NULL;


COMMENT ON CONSTRAINT "pages_season_id_foreign" ON "public"."pages" IS NULL;


COMMENT ON CONSTRAINT "pages_show_id_foreign" ON "public"."pages" IS NULL;


COMMENT ON CONSTRAINT "pages_user_created_foreign" ON "public"."pages" IS NULL;


COMMENT ON CONSTRAINT "pages_user_updated_foreign" ON "public"."pages" IS NULL;

COMMENT ON INDEX "public"."pages_code_unique"  IS NULL;


COMMENT ON INDEX "public"."pages_collection_unique"  IS NULL;

COMMENT ON TABLE "public"."pages"  IS NULL;

--- END CREATE TABLE "public"."pages" ---

--- BEGIN CREATE TABLE "public"."pages_translations" ---

CREATE TABLE IF NOT EXISTS "public"."pages_translations" (
	"description" varchar(255) NULL DEFAULT NULL::character varying ,
	"id" int4 NOT NULL DEFAULT nextval('pages_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"pages_id" int4 NULL  ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "pages_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "pages_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "pages_translations_pages_id_foreign" FOREIGN KEY (pages_id) REFERENCES pages(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."pages_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."pages_translations"."description"  IS NULL;


COMMENT ON COLUMN "public"."pages_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."pages_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."pages_translations"."pages_id"  IS NULL;


COMMENT ON COLUMN "public"."pages_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "pages_translations_pkey" ON "public"."pages_translations" IS NULL;


COMMENT ON CONSTRAINT "pages_translations_languages_code_foreign" ON "public"."pages_translations" IS NULL;


COMMENT ON CONSTRAINT "pages_translations_pages_id_foreign" ON "public"."pages_translations" IS NULL;

COMMENT ON TABLE "public"."pages_translations"  IS NULL;

--- END CREATE TABLE "public"."pages_translations" ---

--- BEGIN CREATE TABLE "public"."directus_permissions" ---

CREATE TABLE IF NOT EXISTS "public"."directus_permissions" (
	"id" int4 NOT NULL DEFAULT nextval('directus_permissions_id_seq'::regclass) ,
	"role" uuid NULL  ,
	"collection" varchar(64) NOT NULL  ,
	"action" varchar(10) NOT NULL  ,
	"permissions" json NULL  ,
	"validation" json NULL  ,
	"presets" json NULL  ,
	"fields" text NULL  ,
	CONSTRAINT "directus_permissions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_permissions_role_foreign" FOREIGN KEY (role) REFERENCES directus_roles(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."directus_permissions" OWNER TO manager;


COMMENT ON COLUMN "public"."directus_permissions"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_permissions"."role"  IS NULL;


COMMENT ON COLUMN "public"."directus_permissions"."collection"  IS NULL;


COMMENT ON COLUMN "public"."directus_permissions"."action"  IS NULL;


COMMENT ON COLUMN "public"."directus_permissions"."permissions"  IS NULL;


COMMENT ON COLUMN "public"."directus_permissions"."validation"  IS NULL;


COMMENT ON COLUMN "public"."directus_permissions"."presets"  IS NULL;


COMMENT ON COLUMN "public"."directus_permissions"."fields"  IS NULL;

COMMENT ON CONSTRAINT "directus_permissions_pkey" ON "public"."directus_permissions" IS NULL;


COMMENT ON CONSTRAINT "directus_permissions_role_foreign" ON "public"."directus_permissions" IS NULL;

COMMENT ON TABLE "public"."directus_permissions"  IS NULL;

--- END CREATE TABLE "public"."directus_permissions" ---

--- BEGIN CREATE TABLE "public"."faq_categories_translations" ---

CREATE TABLE IF NOT EXISTS "public"."faq_categories_translations" (
	"faq_categories_id" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('faq_categories_translations_id_seq'::regclass) ,
	"languages_code" varchar(255) NULL DEFAULT NULL::character varying ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	CONSTRAINT "faq_categories_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "faq_categories_translations_faq_categories_id_foreign" FOREIGN KEY (faq_categories_id) REFERENCES faq_categories(id) ON DELETE CASCADE ,
	CONSTRAINT "faq_categories_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."faq_categories_translations" OWNER TO manager;


COMMENT ON COLUMN "public"."faq_categories_translations"."faq_categories_id"  IS NULL;


COMMENT ON COLUMN "public"."faq_categories_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."faq_categories_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."faq_categories_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "faq_categories_translations_pkey" ON "public"."faq_categories_translations" IS NULL;


COMMENT ON CONSTRAINT "faq_categories_translations_faq_categories_id_foreign" ON "public"."faq_categories_translations" IS NULL;


COMMENT ON CONSTRAINT "faq_categories_translations_languages_code_foreign" ON "public"."faq_categories_translations" IS NULL;

COMMENT ON TABLE "public"."faq_categories_translations"  IS NULL;

--- END CREATE TABLE "public"."faq_categories_translations" ---

--- BEGIN CREATE TABLE "public"."maintenancemessage_messagetemplates" ---

CREATE TABLE IF NOT EXISTS "public"."maintenancemessage_messagetemplates" (
	"id" int4 NOT NULL DEFAULT nextval('maintenancemessage_messagetemplates_id_seq'::regclass) ,
	"maintenancemessage_id" int4 NULL  ,
	"messagetemplates_id" int4 NULL  ,
	"sort" int4 NULL  ,
	CONSTRAINT "maintenancemessage_messagetemplates_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "maintenancemessage_messagetemplates_mainte__6b993ed9_foreign" FOREIGN KEY (maintenancemessage_id) REFERENCES maintenancemessage(id) ON DELETE SET NULL ,
	CONSTRAINT "maintenancemessage_messagetemplates_messag__488cfa1b_foreign" FOREIGN KEY (messagetemplates_id) REFERENCES messagetemplates(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."maintenancemessage_messagetemplates" OWNER TO manager;


COMMENT ON COLUMN "public"."maintenancemessage_messagetemplates"."id"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage_messagetemplates"."maintenancemessage_id"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage_messagetemplates"."messagetemplates_id"  IS NULL;


COMMENT ON COLUMN "public"."maintenancemessage_messagetemplates"."sort"  IS NULL;

COMMENT ON CONSTRAINT "maintenancemessage_messagetemplates_pkey" ON "public"."maintenancemessage_messagetemplates" IS NULL;


COMMENT ON CONSTRAINT "maintenancemessage_messagetemplates_mainte__6b993ed9_foreign" ON "public"."maintenancemessage_messagetemplates" IS NULL;


COMMENT ON CONSTRAINT "maintenancemessage_messagetemplates_messag__488cfa1b_foreign" ON "public"."maintenancemessage_messagetemplates" IS NULL;

COMMENT ON TABLE "public"."maintenancemessage_messagetemplates"  IS NULL;

--- END CREATE TABLE "public"."maintenancemessage_messagetemplates" ---

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION public.nametolowercase()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
	NEW.Name = lower(NEW.Name);
	RETURN NEW;
END;
$function$
;
-- +goose StatementEnd
ALTER FUNCTION "public"."nametolowercase"() OWNER TO manager;

COMMENT ON FUNCTION "public"."nametolowercase"()  IS NULL;

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION public.update_access(view character varying)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    lr timestamptz;
BEGIN
    SELECT last_refreshed INTO lr FROM materialized_views_meta WHERE view_name = view;
    IF (
            lr IS NULL OR
            (SELECT MAX(date_updated) FROM shows) > lr OR
            (SELECT MAX(date_updated) FROM seasons) > lr OR
            (SELECT MAX(date_updated) FROM episodes) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups_download) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups_earlyaccess) > (lr)) THEN
        RAISE NOTICE 'Refreshing view';
        CASE
            WHEN view = 'episodes_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY episodes_access;
            WHEN view = 'seasons_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY seasons_access;
            WHEN view = 'shows_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY shows_access;
            ELSE
                RAISE EXCEPTION 'Invalid view';
        END CASE;
        INSERT INTO materialized_views_meta (last_refreshed, view_name)
        VALUES (NOW(), view)
        ON CONFLICT(view_name) DO UPDATE set last_refreshed = now();
        RETURN true;
    END IF;
    RETURN false;
END
$function$
;
-- +goose StatementEnd
ALTER FUNCTION "public"."update_access"(character varying) OWNER TO manager;

COMMENT ON FUNCTION "public"."update_access"(character varying)  IS NULL;

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('ageratings', 'child_care', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 1, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('calendar', 'calendar_month', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#FFC23B', NULL, 3, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('appconfig', 'app_settings_alt', NULL, NULL, false, true, '[{"language":"en-US","translation":"App","singular":"App","plural":"App"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 3, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('FAQ', 'folder', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#6BFFE1', NULL, 5, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assetfiles', 'file_present', 'Downloadable videos, subtitles, etc.', '{{storage}}/{{path}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 3, 'asset_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('config', 'settings', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#2ECDA7', NULL, 7, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assets', 'snippet_folder', NULL, '{{name}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'asset_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assetstreams', 'stream', NULL, '{{service}}/{{path}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'asset_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('calendarentries', 'edit_calendar', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'calendar', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('calendarentries_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'calendarentries', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('calendarevent', 'event', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'calendar', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('categories', 'bookmarks', NULL, '{{translations}}', true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 6, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('categories_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'categories', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('collections', 'collections_bookmark', NULL, '{{name}}', false, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, '["content","legacy_order_by","list_id","show_episodes_in_section","show_id","sort","translations"]', 3, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('collections_items', NULL, NULL, '{{page_id.translations}}{{show_id.translations}}{{season_id.translations}}{{episode_id.translations}}', true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 5, 'collections', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes', 'slow_motion_video', NULL, '{{season_id.show_id.translations}} - {{translations}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, '["agerating_code","available_from","available_to","description","image","publish_at","season_id","status","title"]', 3, 'main_content', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_tags', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 3, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_usergroups_download', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 4, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('events', 'event', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'calendar', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('events_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'events', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faq_categories', 'folder', NULL, '{{translations.title}}', false, false, NULL, 'status', true, 'archived', 'draft', 'sort', 'all', NULL, NULL, 2, 'FAQ', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faq_categories_translations', 'import_export', NULL, '{{title}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'faq_categories', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('asset_management', 'folder_copy', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 4, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faqs', 'question_mark', NULL, '{{translations.question}}', false, false, NULL, 'status', true, 'archived', 'draft', 'sort', 'all', NULL, NULL, 1, 'FAQ', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faqs_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'faqs', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('faqs_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'faqs', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assetstreams_audio_languages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 13, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('assetstreams_subtitle_languages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 14, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenance_messages', 'warning_amber', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 6, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('globalconfig', 'cloud_done', NULL, NULL, false, true, '[{"language":"en-US","translation":"Global","singular":"Global","plural":"Global"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenancemessage', 'sd_card_alert', NULL, NULL, false, true, '[{"language":"en-US","translation":"Messages","singular":"Messages","plural":"Messages"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'maintenance_messages', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('messagetemplates_translations', 'import_export', NULL, '{{message}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'messagetemplates', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('ageratings_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 8, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_categories', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 11, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('maintenancemessage_messagetemplates', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 16, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('lists_relations', 'import_export', NULL, '{{item:shows.translations}}{{item:episodes.translations}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 12, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('main_content', 'perm_media', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#2ECDA7', NULL, 1, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('page_management', 'pages', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#FFA439', NULL, 2, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('pages_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'pages', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('seasons', 'format_list_numbered', NULL, '{{translations}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'main_content', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('seasons_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'seasons', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sections', 'view_list', NULL, '{{id}} - {{translations}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sections_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'sections', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sections_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'sections', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('shows', 'tv', NULL, '{{id}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'main_content', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('shows_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'shows', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tags', 'label', NULL, '{{name}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 5, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tvguideentry', 'calendar_view_day', NULL, '{{title}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'calendar', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tags_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'tags', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('usergroups', 'groups', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 5, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('webconfig', 'desktop_windows', NULL, NULL, true, true, '[{"language":"en-US","translation":"Web","singular":"Web","plural":"Web"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 4, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('materialized_views_meta', NULL, NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 15, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('seasons_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 9, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('shows_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 10, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('episodes_usergroups_earlyaccess', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 5, 'episodes', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('languages', 'language', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 6, 'config', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('lists', 'format_list_numbered', 'Manually selected and ordered shows/episodes.', '{{name}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 4, 'page_management', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('messagetemplates', 'bookmarks', NULL, '{{translations}}', false, false, '[{"language":"en-US","translation":"Templates","singular":"Template","plural":"Templates"}]', 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'maintenance_messages', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('pages', 'pages', NULL, '{{code}} - {{translations}}', false, false, NULL, 'status', true, 'archived', 'draft', 'sort', 'all', NULL, NULL, 1, 'page_management', 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1, 'ageratings', 'code', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (4, 'ageratings', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (5, 'ageratings', 'title', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (6, 'ageratings', 'translations', 'translations', 'translations', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (7, 'ageratings_translations', 'ageratings_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (8, 'ageratings_translations', 'description', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (9, 'ageratings_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (10, 'ageratings_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (11, 'assetfiles', 'asset_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (12, 'assetfiles', 'audio_language_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', NULL, NULL, false, false, 12, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (15, 'assetfiles', 'extra_metadata', 'cast-json', 'input-code', NULL, NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (16, 'assetfiles', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (17, 'assetfiles', 'mime_type', NULL, 'input', '{"iconLeft":"category"}', NULL, NULL, false, false, 5, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (18, 'assetfiles', 'path', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (19, 'assetfiles', 'storage', NULL, 'select-radio', '{"choices":[{"text":"az_vods1","value":"az_vods1"},{"text":"s3_assets","value":"s3_assets"}]}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (20, 'assetfiles', 'subtitle_language_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', NULL, NULL, false, false, 13, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (21, 'assetfiles', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Video","value":"video"},{"text":"Audio","value":"audio"},{"text":"Subtitle","value":"subtitle"}]}', NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (22, 'assetfiles', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (23, 'assetfiles', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (26, 'assets', 'duration', NULL, 'input', '{"iconLeft":"timer"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (27, 'assets', 'encoding_version', NULL, 'select-dropdown', '{"choices":[{"text":"btv","value":"btv"},{"text":"azure_media_services","value":"azure_media_services"}]}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (29, 'assets', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (30, 'assets', 'legacy_id', NULL, 'input', NULL, NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (31, 'assets', 'main_storage_path', NULL, 'input', NULL, NULL, NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (32, 'assets', 'mediabanken_id', NULL, 'input', '{"iconLeft":"grid_3x3"}', NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (33, 'assets', 'name', NULL, 'input', '{"placeholder":null}', NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (34, 'assets', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"Draft","value":"draft"},{"text":"Published","value":"published"},{"text":"Archived","value":"archived"}],"icon":"visibility"}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (36, 'assets', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (37, 'assets', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (38, 'assetstreams', 'asset_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 14, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (39, 'assetstreams', 'audio_languages', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 12, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (42, 'assetstreams', 'encryption_key_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (43, 'assetstreams', 'extra_metadata', 'cast-json', 'input-code', '{"language":"JSON"}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (44, 'assetstreams', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (45, 'assetstreams', 'legacy_videourl_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (46, 'assetstreams', 'path', NULL, 'input', NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (47, 'assetstreams', 'service', NULL, 'select-radio', '{"choices":[{"text":"mediapackage","value":"mediapackage"},{"text":"azure_media_services","value":"azure_media_services"}]}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (48, 'assetstreams', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (49, 'assetstreams', 'subtitle_languages', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 13, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (50, 'assetstreams', 'type', NULL, 'select-radio', '{"choices":[{"text":"hls-cmaf","value":"hls-cmaf"},{"text":"dash","value":"dash"},{"text":"hls-ts","value":"hls-ts"}]}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (51, 'assetstreams', 'url', NULL, 'input', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (52, 'assetstreams', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (53, 'assetstreams', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (54, 'assetstreams_audio_languages', 'assetstreams_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (55, 'assetstreams_audio_languages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (56, 'assetstreams_audio_languages', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (57, 'assetstreams_subtitle_languages', 'assetstreams_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (58, 'assetstreams_subtitle_languages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (59, 'assetstreams_subtitle_languages', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (62, 'calendarevent', 'end', NULL, 'datetime', NULL, NULL, NULL, false, false, 9, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (63, 'calendarevent', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (64, 'calendarevent', 'start', NULL, 'datetime', NULL, NULL, NULL, false, false, 8, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (28, 'assets', 'files', 'o2m', 'list-o2m', '{"enableCreate":false,"template":"{{storage}}/{{path}}"}', NULL, NULL, false, false, 14, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (35, 'assets', 'streams', 'o2m', 'list-o2m', '{"template":"{{service}}/{{path}}"}', 'related-values', NULL, false, false, 15, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (65, 'calendarevent', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (66, 'calendarevent', 'title', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (67, 'calendarevent', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (68, 'calendarevent', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (69, 'categories', 'appear_in_search', 'cast-boolean', 'boolean', '{"label":"Appear in search"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (179, 'lists', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (180, 'lists', 'legacy_category_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (72, 'categories', 'episodes', 'm2m', 'list-m2m', '{"enableCreate":false,"template":"{{episodes_id.translations}}"}', 'related-values', '{"template":"{{episodes_id.translations}}"}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (73, 'categories', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (74, 'categories', 'legacy_id', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (75, 'categories', 'parent_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (76, 'categories', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (77, 'categories', 'subcategories', 'o2m', 'list-o2m-tree-view', NULL, NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (78, 'categories', 'translations', 'translations', 'translations', '{"languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{name}}","userLanguage":true}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (79, 'categories', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (80, 'categories', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (81, 'categories_translations', 'categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (82, 'categories_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (83, 'categories_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (84, 'categories_translations', 'name', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (89, 'collections', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (118, 'episodes', 'agerating_code', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 5, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (119, 'episodes', 'asset_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (121, 'episodes', 'available_from', NULL, 'datetime', NULL, NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (122, 'episodes', 'available_to', NULL, 'datetime', '{}', NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (123, 'episodes', 'categories', 'm2m', 'list-m2m', NULL, NULL, NULL, false, true, 9, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (187, 'lists_relations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (85, 'collections', 'config', 'alias,group,no-data', 'group-detail', '{"headerIcon":"settings"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (120, 'episodes', 'availability', 'alias,group,no-data', 'group-detail', '{"headerIcon":"visibility"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (94, 'collections', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (97, 'collections', 'used_in_sections', 'o2m', 'list-o2m', '{"template":"{{translations}}"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (98, 'collections', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (126, 'episodes', 'download_usergroups', 'm2m', 'list-m2m', '{"enableCreate":false,"template":"{{usergroups_code.name}}"}', NULL, NULL, false, false, 5, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (127, 'episodes', 'earlyaccess_usergroups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (128, 'episodes', 'episode_number', NULL, 'input', '{"iconLeft":"numbers"}', NULL, NULL, false, false, 3, 'half', NULL, 'For showing "S1:E2" and for sorting.', '[{"name":"Hide when standalone","rule":{"_and":[{"type":{"_eq":"standalone"}}]},"hidden":true}]', false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (130, 'episodes', 'image_file_id', 'file', 'file-image', '{"crop":false,"folder":null}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (131, 'episodes', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (132, 'episodes', 'legacy_extra_description_id', NULL, 'input', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (133, 'episodes', 'legacy_id', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (134, 'episodes', 'legacy_program_id', NULL, 'input', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (135, 'episodes', 'legacy_tags_id', NULL, 'input', NULL, NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (136, 'episodes', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (138, 'episodes', 'migration_data', 'cast-json', 'input-code', '{}', NULL, NULL, true, false, 1, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (139, 'episodes', 'publish_date', NULL, 'datetime', NULL, NULL, NULL, false, false, 4, 'half', NULL, NULL, NULL, true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (140, 'episodes', 'season_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', NULL, NULL, false, false, 2, 'half', NULL, NULL, '[{"name":"Hide when standalone","rule":{"_and":[{"type":{"_eq":"standalone"}}]},"hidden":true}]', false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (142, 'episodes', 'tags', 'm2m', 'list-m2m', '{"template":"{{tags_id.name}}"}', 'related-values', '{"template":"{{tags_id.name}}"}', false, false, 8, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (146, 'episodes', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Episode","value":"episode"},{"text":"Standalone","value":"standalone"}],"icon":"build"}', NULL, NULL, false, false, 1, 'full', NULL, NULL, '[{"name":"Disable when season is set","rule":{"_and":[{"season_id":{"_nnull":true}}]},"readonly":true},{"name":"Disable when episode number is set","rule":{"_and":[{"episode_number":{"_nnull":true}}]},"readonly":true},{"name":"Disable when created","rule":{"_and":[{"id":{"_nnull":true}}]},"readonly":true}]', true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (149, 'episodes', 'usergroups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (150, 'episodes_categories', 'categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (151, 'episodes_categories', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (152, 'episodes_categories', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (153, 'episodes_tags', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (154, 'episodes_tags', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (155, 'episodes_tags', 'tags_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (156, 'episodes_translations', 'description', NULL, 'input', '{"iconLeft":"description"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (157, 'episodes_translations', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (158, 'episodes_translations', 'extra_description', NULL, 'input', '{"iconLeft":"description"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (159, 'episodes_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (160, 'episodes_translations', 'is_primary', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, true, 8, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (161, 'episodes_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (162, 'episodes_translations', 'title', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (163, 'episodes_usergroups', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (164, 'episodes_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (165, 'episodes_usergroups', 'type', NULL, 'select-radio', '{"choices":[{"text":"Availability","value":"availability"},{"text":"Early Access","value":"early-access"}]}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (166, 'episodes_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (167, 'episodes_usergroups_download', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (168, 'episodes_usergroups_download', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (169, 'episodes_usergroups_download', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (170, 'episodes_usergroups_earlyaccess', 'episodes_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (171, 'episodes_usergroups_earlyaccess', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (172, 'episodes_usergroups_earlyaccess', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (173, 'languages', 'code', NULL, NULL, NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (174, 'languages', 'legacy_2_letter_code', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (175, 'languages', 'legacy_3_letter_code', NULL, 'input', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (176, 'languages', 'name', NULL, NULL, NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (181, 'lists', 'legacy_name_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (182, 'lists', 'name', NULL, 'input', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (184, 'lists', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (185, 'lists', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (186, 'lists_relations', 'collection', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (137, 'episodes', 'metadata', 'alias,group,no-data', 'group-detail', '{"headerIcon":"display_settings"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (144, 'episodes', 'translatable_details', 'alias,group,no-data', 'group-detail', '{"headerIcon":"text_snippet"}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (147, 'episodes', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (148, 'episodes', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (125, 'episodes', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (143, 'episodes', 'technical_details', 'alias,group,no-data', 'group-detail', '{"headerIcon":"code","start":"closed"}', NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (145, 'episodes', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 1, 'full', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (129, 'episodes', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (188, 'lists_relations', 'item', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (189, 'lists_relations', 'lists_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (190, 'lists_relations', 'sort', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (194, 'pages', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (202, 'seasons', 'agerating_code', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (203, 'seasons', 'availability', 'alias,group,no-data', 'group-detail', '{"headerIcon":"visibility"}', NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (204, 'seasons', 'available_from', NULL, 'datetime', NULL, NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (205, 'seasons', 'available_to', NULL, 'datetime', NULL, NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (209, 'seasons', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (210, 'seasons', 'image_file_id', 'file', 'file-image', '{"crop":false,"folder":"00000000-0000-0000-0000-000000000000"}', NULL, NULL, false, false, 3, 'full', '[{"language":null,"translation":"Image file"}]', NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (211, 'seasons', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (212, 'seasons', 'legacy_id', NULL, 'input', NULL, NULL, NULL, true, false, 1, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (213, 'seasons', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (214, 'seasons', 'metadata', 'alias,group,no-data', 'group-detail', '{"headerIcon":"display_settings"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (215, 'seasons', 'publish_date', NULL, 'datetime', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (216, 'seasons', 'related', 'alias,group,no-data', 'group-detail', '{"headerIcon":"share"}', NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (217, 'seasons', 'season_number', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'half', NULL, 'Used for "S1:E2" and for sorting.', NULL, true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (219, 'seasons', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (220, 'seasons', 'technical_details', 'alias,group,no-data', 'group-detail', '{"headerIcon":"code","start":"closed"}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (222, 'seasons', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (223, 'seasons', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (224, 'seasons', 'usergroups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (225, 'seasons_translations', 'description', NULL, 'input', '{"iconLeft":"description","placeholder":null}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (226, 'seasons_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (227, 'seasons_translations', 'is_primary', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (228, 'seasons_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (229, 'seasons_translations', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (230, 'seasons_translations', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (231, 'seasons_translations', 'seasons_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (232, 'seasons_translations', 'title', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (233, 'seasons_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (234, 'seasons_usergroups', 'seasons_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (235, 'seasons_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (238, 'sections', 'configuration', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (242, 'sections', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (221, 'seasons', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (191, 'pages', 'code', NULL, 'input', '{"iconLeft":"tag"}', NULL, NULL, false, false, 3, 'full', NULL, NULL, '[{"name":"Disable when system page","rule":{"_and":[{"system_page":{"_eq":true}}]},"readonly":true}]', true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (197, 'pages', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (200, 'pages', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (201, 'pages', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (218, 'seasons', 'show_id', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, false, 1, 'half', '[{"language":"en-US","translation":"Show"}]', NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (208, 'seasons', 'episodes', 'o2m', 'list-o2m', '{"filter":{"_and":[{"type":{"_eq":"episode"}}]}}', NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'related', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (245, 'sections', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (251, 'sections', 'usergroups', 'm2m', 'list-m2m', '{}', NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'Visibility', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (252, 'sections_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (257, 'sections_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (258, 'sections_usergroups', 'sections_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (259, 'sections_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (260, 'shows', 'agerating_code', 'm2o', 'select-dropdown-m2o', '{"template":"{{title}}"}', NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (261, 'shows', 'availability', 'alias,group,no-data', 'group-detail', '{"headerIcon":"visibility"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (262, 'shows', 'available_from', NULL, 'datetime', NULL, NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (263, 'shows', 'available_to', NULL, 'datetime', NULL, NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (266, 'shows', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (267, 'shows', 'image_file_id', 'file', 'file-image', '{"crop":false,"folder":"00000000-0000-0000-0000-000000000000"}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (268, 'shows', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, true, false, 3, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (269, 'shows', 'legacy_id', NULL, 'input', NULL, NULL, NULL, true, false, 1, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (270, 'shows', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, true, false, 2, 'full', NULL, NULL, NULL, false, 'technical_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (271, 'shows', 'metadata', 'alias,group,no-data', 'group-detail', '{"headerIcon":"display_settings"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (272, 'shows', 'publish_date', NULL, 'datetime', '{}', NULL, NULL, false, false, 2, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (273, 'shows', 'related', 'alias,group,no-data', 'group-detail', '{"headerIcon":"share"}', NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (275, 'shows', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (276, 'shows', 'technical_details', 'alias,group,no-data', 'group-detail', '{"headerIcon":"code","start":"closed"}', NULL, NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (278, 'shows', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Series","value":"series"},{"text":"Event","value":"event"}]}', NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, true, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (279, 'shows', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (280, 'shows', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (281, 'shows', 'usergroups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, 'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (282, 'shows_translations', 'description', NULL, 'input', '{"iconLeft":"description"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (283, 'shows_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (284, 'shows_translations', 'is_primary', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, true, 7, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (285, 'shows_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (286, 'shows_translations', 'legacy_description_id', NULL, 'input', NULL, NULL, NULL, false, true, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (287, 'shows_translations', 'legacy_tags', NULL, 'input', NULL, NULL, NULL, false, true, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (288, 'shows_translations', 'legacy_tags_id', NULL, 'input', NULL, NULL, NULL, false, true, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (289, 'shows_translations', 'legacy_title_id', NULL, 'input', NULL, NULL, NULL, false, true, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (290, 'shows_translations', 'shows_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (291, 'shows_translations', 'title', NULL, 'input', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (292, 'shows_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (293, 'shows_usergroups', 'shows_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (294, 'shows_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (299, 'tags', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (277, 'shows', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (246, 'sections', 'translatable_details', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (247, 'sections', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code","userLanguage":true}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 1, 'full', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (249, 'sections', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 1, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (253, 'sections_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (274, 'shows', 'seasons', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'related', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (305, 'tvguideentry', 'description', NULL, 'input', '{"iconLeft":"description"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (306, 'tvguideentry', 'end', NULL, 'datetime', NULL, NULL, NULL, false, false, 11, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (307, 'tvguideentry', 'event', 'm2o', 'select-dropdown-m2o', '{"template":"{{title}}"}', NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (308, 'tvguideentry', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (309, 'tvguideentry', 'image', 'file', 'file-image', '{"crop":false}', NULL, NULL, false, false, 14, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (311, 'tvguideentry', 'start', NULL, 'datetime', NULL, NULL, NULL, false, false, 10, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (312, 'tvguideentry', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (313, 'tvguideentry', 'title', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (314, 'tvguideentry', 'use_image_from_link', 'cast-boolean', 'boolean', '{"label":"Use image from link"}', NULL, NULL, false, false, 13, 'full', NULL, 'Will use the image from the linked episode if it has one.', NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (315, 'tvguideentry', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (316, 'tvguideentry', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (321, 'usergroups', 'code', NULL, 'input', NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (324, 'usergroups', 'emails', NULL, 'input-multiline', '{"clear":true,"font":"monospace","placeholder":"admin@brunstad.tv","softLength":0,"trim":true}', 'formatted-value', '{"format":true}', false, false, NULL, 'full', NULL, 'One per line', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (325, 'usergroups', 'episode_earlyaccess', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (326, 'usergroups', 'name', NULL, 'input', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (327, 'usergroups', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (328, 'usergroups', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (329, 'usergroups', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (422, 'calendarentries', 'start', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 9, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (2, 'ageratings', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3, 'ageratings', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (13, 'assetfiles', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (14, 'assetfiles', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (24, 'assets', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (25, 'assets', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (40, 'assetstreams', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (41, 'assetstreams', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 10, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (60, 'calendarevent', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (61, 'calendarevent', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (70, 'categories', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (71, 'categories', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (330, 'episodes_usergroups', 'date_created', 'date-created', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (331, 'episodes_usergroups', 'date_updated', 'date-created,date-updated', NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (332, 'episodes_usergroups_download', 'date_created', 'date-created', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (333, 'episodes_usergroups_download', 'date_updated', 'date-created,date-updated', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (334, 'episodes_usergroups_earlyaccess', 'date_created', 'date-created', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (335, 'episodes_usergroups_earlyaccess', 'date_updated', 'date-created,date-updated', NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (177, 'lists', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (178, 'lists', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (206, 'seasons', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (207, 'seasons', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (264, 'shows', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (265, 'shows', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (322, 'usergroups', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (323, 'usergroups', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (87, 'collections', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (124, 'episodes', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (192, 'pages', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (303, 'tvguideentry', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (304, 'tvguideentry', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (141, 'episodes', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}],"icon":"visibility"}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (336, 'collections_items', 'collection_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 7, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (337, 'collections_items', 'config', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (338, 'collections_items', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (339, 'collections_items', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (340, 'collections_items', 'episode_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 5, 'half', NULL, NULL, '[{"name":"Hidden if not Episode","rule":{"_and":[{"type":{"_neq":"episode"}}]},"hidden":true,"options":{}},{"name":"Required if Episode","rule":{"_and":[{"type":{"_eq":"episode"}}]},"required":true,"options":{}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (341, 'collections_items', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (342, 'collections_items', 'page_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 2, 'half', NULL, NULL, '[{"name":"Hidden if not Page","rule":{"_and":[{"type":{"_neq":"page"}}]},"hidden":true,"options":{}},{"name":"Required if Page","rule":{"_and":[{"type":{"_eq":"page"}}]},"readonly":false,"required":true,"options":{}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (343, 'collections_items', 'season_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4, 'half', NULL, NULL, '[{"name":"Hidden if not Season","rule":{"_and":[{"type":{"_neq":"season"}}]},"hidden":true,"options":{}},{"name":"Required if Season","rule":{"_and":[{"type":{"_eq":"season"}}]},"required":true,"options":{}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (344, 'collections_items', 'show_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'half', NULL, NULL, '[{"name":"Hidden if not Show","rule":{"_and":[{"type":{"_neq":"show"}}]},"hidden":true,"options":{}},{"name":"Required if Show","rule":{"_and":[{"type":{"_eq":"show"}}]},"required":true,"options":{}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (345, 'collections_items', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (346, 'collections_items', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Page","value":"page"},{"text":"Show","value":"show"},{"text":"Season","value":"season"},{"text":"Episode","value":"episode"}]}', NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (347, 'collections_items', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (348, 'collections_items', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (349, 'faq_categories', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (350, 'faq_categories', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (475, 'globalconfig', 'live_online', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, NULL, 'half', NULL, 'Is there a livestream running?', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (476, 'globalconfig', 'npaw_enabled', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, false, NULL, 'half', NULL, 'Is NPAW data collection active?', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (477, 'globalconfig', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (351, 'faq_categories', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (352, 'faq_categories', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (353, 'faq_categories_translations', 'faq_categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (354, 'faq_categories_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (355, 'faq_categories_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (356, 'faq_categories_translations', 'title', NULL, 'input', '{"iconLeft":"category"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (357, 'faqs', 'category', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', 'related-values', '{"template":"{{translations.title}}"}', false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (358, 'faqs', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (359, 'faqs', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (360, 'faqs', 'groups', 'm2m', 'list-m2m', '{"enableCreate":false}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (361, 'faqs', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (362, 'faqs', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (363, 'faqs', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (364, 'faqs', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code"}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{question}}","userLanguage":true}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (365, 'faqs', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (366, 'faqs', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (296, 'tags', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (297, 'tags', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (367, 'faqs_translations', 'answer', NULL, 'input-rich-text-html', '{"placeholder":"This is the answer!","toolbar":["blockquote","bold","bullist","code","customImage","customLink","customMedia","italic","numlist","removeformat","underline"],"trim":true}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (368, 'faqs_translations', 'faqs_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (369, 'faqs_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (370, 'faqs_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (372, 'faqs_usergroups', 'faqs_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (373, 'faqs_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (374, 'faqs_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (375, 'pages_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (376, 'pages_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (377, 'pages_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (378, 'pages_translations', 'pages_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (379, 'pages_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (380, 'tags_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (381, 'tags_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (382, 'tags_translations', 'name', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (383, 'tags_translations', 'tags_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (88, 'collections', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (99, 'collections', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (384, 'collections', 'collection', NULL, 'select-dropdown', '{"choices":[{"text":"Pages","value":"pages"},{"text":"Shows","value":"shows"},{"text":"Seasons","value":"seasons"},{"text":"Episodes","value":"episodes"}],"icon":"list_alt","placeholder":"Shows... seasons"}', NULL, NULL, false, false, 2, 'half', '[{"language":"en-US","translation":"Collection"}]', NULL, '[{"name":"Hidden if not Query","rule":{"_and":[{"filter_type":{"_neq":"query"}}]},"hidden":true,"options":{"allowOther":false,"allowNone":false}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (385, 'collections', 'episodes_query_filter', 'cast-json', 'query-builder', '{"fieldCollection":"episodes"}', NULL, NULL, false, false, 7, 'full', NULL, NULL, '[{"name":"Hidden if not Episodes","rule":{"_and":[{"_or":[{"collection":{"_neq":"episodes"}},{"filter_type":{"_neq":"query"}}]}]},"hidden":true,"options":{"fieldCollection":""}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (386, 'collections', 'filter_type', NULL, 'select-dropdown', '{"choices":[{"text":"Select","value":"select"},{"text":"Query","value":"query"}]}', NULL, NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (387, 'collections', 'items', 'o2m', 'list-o2m', '{"enableSelect":false}', NULL, NULL, false, false, 8, 'full', NULL, NULL, '[{"name":"Hidden if not Select","rule":{"_and":[{"filter_type":{"_neq":"select"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true,"limit":15}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (388, 'collections', 'meta', 'alias,group,no-data', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (389, 'collections', 'name', NULL, 'input', NULL, 'raw', NULL, false, false, 3, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (390, 'collections', 'pages_query_filter', 'cast-json', 'query-builder', '{"fieldCollection":"pages"}', NULL, NULL, false, false, 4, 'full', NULL, NULL, '[{"name":"Hidden if not Pages","rule":{"_and":[{"_or":[{"collection":{"_neq":"pages"}},{"filter_type":{"_neq":"query"}}]}]},"hidden":true,"options":{"fieldCollection":""}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (391, 'collections', 'seasons_query_filter', 'cast-json', 'query-builder', '{"fieldCollection":"seasons"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, '[{"name":"Hidden if not Seasons","rule":{"_and":[{"_or":[{"collection":{"_neq":"seasons"}},{"filter_type":{"_neq":"query"}}]}]},"hidden":true,"options":{"fieldCollection":""}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (392, 'collections', 'shows_query_filter', 'cast-json', 'query-builder', '{"fieldCollection":"shows"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, '[{"name":"Hidden if not Shows","rule":{"_and":[{"_or":[{"collection":{"_neq":"shows"}},{"filter_type":{"_neq":"query"}}]}]},"options":{"fieldCollection":""},"hidden":true}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (193, 'pages', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (478, 'webconfig', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (479, 'webconfig', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (480, 'webconfig', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (198, 'pages', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 4, 'full', NULL, NULL, '[{"name":"Disable when system page","rule":{"_and":[{"system_page":{"_eq":true}}]},"readonly":true}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (393, 'pages', 'collection', NULL, 'select-dropdown', '{"choices":[{"text":"Shows","value":"shows"},{"text":"Seasons","value":"seasons"},{"text":"Episodes","value":"episodes"}]}', NULL, NULL, false, false, 5, 'half', NULL, NULL, '[{"name":"Hidden when not Default","rule":{"_and":[{"type":{"_neq":"default"}}]},"hidden":true,"options":{"allowOther":false,"allowNone":false}},{"name":"Required when Default","rule":{"_and":[{"type":{"_eq":"default"}}]},"readonly":false,"required":true,"options":{"allowOther":false,"allowNone":false}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (394, 'pages', 'episode_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', 'related-values', '{"template":"{{translations}}"}', false, false, 3, 'half', '[{"language":"en-US","translation":"Episode"}]', NULL, '[{"name":"Hide when not Episode","rule":{"_and":[{"type":{"_neq":"episode"}}]},"hidden":true,"options":{}},{"name":"Required when Episode","rule":{"_and":[{"type":{"_eq":"episode"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (395, 'pages', 'meta', 'alias,group,no-data', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (396, 'pages', 'relations', 'alias,group,no-data', 'group-detail', '{"headerColor":null,"headerIcon":"article"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (397, 'pages', 'season_id', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, false, 4, 'half', '[{"language":"en-US","translation":"Season"}]', NULL, '[{"name":"Hidden if not Season","rule":{"_and":[{"type":{"_neq":"season"}}]},"hidden":true,"options":{}},{"name":"Required if Season","rule":{"_and":[{"type":{"_eq":"season"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (398, 'pages', 'show_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{translations}}"}', 'related-values', '{"template":"{{translations}}"}', false, false, 2, 'half', '[{"language":"en-US","translation":"Show"}]', NULL, '[{"name":"Hide when not Show","rule":{"_and":[{"type":{"_neq":"show"}}]},"hidden":true,"options":{}},{"name":"Required when Show","rule":{"_and":[{"type":{"_eq":"show"}}]},"required":true,"options":{}}]', false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (399, 'pages', 'translatable_details', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (400, 'pages', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code","userLanguage":true}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 1, 'full', NULL, NULL, NULL, false, 'translatable_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (401, 'pages', 'type', NULL, 'select-dropdown', '{"allowNone":true,"choices":[{"text":"Custom","value":"custom"},{"text":"Default","value":"default"},{"text":"Show","value":"show"},{"text":"Season","value":"season"},{"text":"Episode","value":"episode"}],"icon":"abc"}', 'formatted-value', NULL, false, false, 1, 'half', NULL, NULL, NULL, true, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (236, 'sections', 'Visibility', 'alias,group,no-data', 'group-detail', '{"headerIcon":"visibility"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (237, 'sections', 'collection_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', 'related-values', '{"template":"{{name}}"}', false, false, 4, 'full', '[{"language":"en-US","translation":"Collection"}]', NULL, NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (239, 'sections', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 2, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (240, 'sections', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (250, 'sections', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (402, 'sections', 'meta', 'alias,group,no-data', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (403, 'sections', 'page_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{code}} - {{translations}}"}', 'related-values', NULL, false, false, 1, 'full', '[{"language":"en-US","translation":"Page"}]', NULL, NULL, true, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (404, 'sections', 'sort', NULL, NULL, NULL, NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (405, 'sections', 'style', NULL, 'select-dropdown', '{"choices":[{"text":"Slider","value":"carousel"},{"text":"Cards","value":"cards"}]}', 'raw', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (255, 'sections_translations', 'sections_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (256, 'sections_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (406, 'sections_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (295, 'tags', 'code', NULL, 'input', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, '{"_and":[{"code":{"_regex":"[a-z_]+"}}]}', NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (298, 'tags', 'episodes', 'm2m', 'list-m2m', NULL, 'related-values', '{"template":"{{episodes_id.translations}}"}', false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (300, 'tags', 'name', NULL, 'input', '{"iconLeft":"title","placeholder":null}', 'raw', NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (301, 'tags', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 1, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (302, 'tags', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, 'meta', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (407, 'tags', 'meta', 'alias,group,no-data', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (408, 'tags', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (409, 'pages', 'sections', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, 'relations', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (410, 'calendarentries', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (411, 'calendarentries', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (412, 'calendarentries', 'end', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 10, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (413, 'calendarentries', 'episode_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 2, 'half', NULL, NULL, '[{"name":"Hidden if not Episode","rule":{"_and":[{"link_type":{"_neq":"episode"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (414, 'calendarentries', 'event_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (415, 'calendarentries', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (416, 'calendarentries', 'image', 'file', 'file-image', '{"crop":false}', 'image', NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (417, 'calendarentries', 'image_from_link', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (418, 'calendarentries', 'link', 'alias,group,no-data', 'group-detail', NULL, NULL, NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (419, 'calendarentries', 'link_type', NULL, 'select-dropdown', '{"allowNone":true,"choices":[{"text":"Episode","value":"episode"},{"text":"Season","value":"season"},{"text":"Show","value":"show"}]}', 'formatted-value', NULL, false, false, 1, 'half', NULL, NULL, NULL, false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (420, 'calendarentries', 'season_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'half', NULL, NULL, '[{"name":"Hidden if not Season","rule":{"_and":[{"link_type":{"_neq":"season"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (421, 'calendarentries', 'show_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4, 'half', NULL, NULL, '[{"name":"Hidden if not Show","rule":{"_and":[{"link_type":{"_neq":"show"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'link', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (423, 'calendarentries', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (424, 'calendarentries', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (425, 'calendarentries', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (426, 'calendarentries', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (427, 'calendarentries_translations', 'calendarentries_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (428, 'calendarentries_translations', 'description', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (429, 'calendarentries_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (430, 'calendarentries_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (431, 'calendarentries_translations', 'title', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (432, 'events', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (433, 'events', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (434, 'events', 'end', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 9, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (435, 'events', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (436, 'events', 'start', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 8, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (437, 'events', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (438, 'events', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code","userLanguage":true}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{title}}","userLanguage":true}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (439, 'events', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (440, 'events', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (441, 'events_translations', 'description', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (442, 'events_translations', 'events_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (443, 'events_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (444, 'events_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (445, 'events_translations', 'title', NULL, 'input', '{"iconLeft":"abc"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (447, 'maintenancemessage', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (448, 'maintenancemessage', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (449, 'maintenancemessage', 'messages', 'm2m', 'list-m2m', '{"template":"{{messagetemplates_id.translations}}"}', 'related-values', '{"template":"{{messagetemplates_id.translations}}"}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (450, 'maintenancemessage', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (451, 'maintenancemessage_messagetemplates', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (452, 'maintenancemessage_messagetemplates', 'maintenancemessage_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (453, 'maintenancemessage_messagetemplates', 'messagetemplates_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (454, 'maintenancemessage_messagetemplates', 'sort', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (455, 'messagetemplates', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (456, 'messagetemplates', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (457, 'messagetemplates', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (458, 'messagetemplates', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (459, 'messagetemplates', 'translations', 'translations', 'translations', '{"defaultLanguage":"no","languageField":"code","userLanguage":true}', 'translations', '{"defaultLanguage":"no","languageField":"code","template":"{{message}}","userLanguage":true}', false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (460, 'messagetemplates', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Warning","value":"warning"},{"text":"Error","value":"error"},{"text":"Info","value":"info"}]}', 'labels', NULL, false, false, 7, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (461, 'messagetemplates', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (462, 'messagetemplates', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (463, 'messagetemplates_translations', 'details', NULL, 'input-rich-text-html', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (464, 'messagetemplates_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (465, 'messagetemplates_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (466, 'messagetemplates_translations', 'message', NULL, 'input', NULL, 'formatted-value', NULL, false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (467, 'messagetemplates_translations', 'messagetemplates_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (468, 'assets', 'preview', 'alias,no-data', 'video-preview', NULL, NULL, NULL, false, false, 13, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (371, 'faqs_translations', 'question', NULL, 'input', '{"iconLeft":"question_mark","placeholder":"What is a question?"}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (469, 'appconfig', 'app_version', NULL, 'input', '{"iconLeft":"get_app"}', 'formatted-value', NULL, false, false, NULL, 'half', NULL, 'Minimum required app version', NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (470, 'appconfig', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (471, 'appconfig', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (472, 'appconfig', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (473, 'globalconfig', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (474, 'globalconfig', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (183, 'lists', 'relations', 'm2a', 'list-m2a', '{}', 'related-values', '{"template":"{{item:shows}}{{item:episodes}}{{item:shows.translations}}"}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (446, 'maintenancemessage', 'active', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201028A', 'Remove Collection Foreign Keys', '2022-06-21T12:16:56.433Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201029A', 'Remove System Relations', '2022-06-21T12:16:56.448Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201029B', 'Remove System Collections', '2022-06-21T12:16:56.461Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201029C', 'Remove System Fields', '2022-06-21T12:16:56.486Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201105A', 'Add Cascade System Relations', '2022-06-21T12:16:56.614Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20201105B', 'Change Webhook URL Type', '2022-06-21T12:16:56.636Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210225A', 'Add Relations Sort Field', '2022-06-21T12:16:56.653Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210304A', 'Remove Locked Fields', '2022-06-21T12:16:56.666Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210312A', 'Webhooks Collections Text', '2022-06-21T12:16:56.684Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210331A', 'Add Refresh Interval', '2022-06-21T12:16:56.697Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210415A', 'Make Filesize Nullable', '2022-06-21T12:16:56.717Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210416A', 'Add Collections Accountability', '2022-06-21T12:16:56.732Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210422A', 'Remove Files Interface', '2022-06-21T12:16:56.746Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210506A', 'Rename Interfaces', '2022-06-21T12:16:56.849Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210510A', 'Restructure Relations', '2022-06-21T12:16:56.909Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210518A', 'Add Foreign Key Constraints', '2022-06-21T12:16:56.935Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210519A', 'Add System Fk Triggers', '2022-06-21T12:16:57.003Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210521A', 'Add Collections Icon Color', '2022-06-21T12:16:57.036Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210525A', 'Add Insights', '2022-06-21T12:16:57.100Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210608A', 'Add Deep Clone Config', '2022-06-21T12:16:57.113Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210626A', 'Change Filesize Bigint', '2022-06-21T12:16:57.148Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210716A', 'Add Conditions to Fields', '2022-06-21T12:16:57.163Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210721A', 'Add Default Folder', '2022-06-21T12:16:57.182Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210802A', 'Replace Groups', '2022-06-21T12:16:57.203Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210803A', 'Add Required to Fields', '2022-06-21T12:16:57.219Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210805A', 'Update Groups', '2022-06-21T12:16:57.234Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210805B', 'Change Image Metadata Structure', '2022-06-21T12:16:57.251Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210811A', 'Add Geometry Config', '2022-06-21T12:16:57.268Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210831A', 'Remove Limit Column', '2022-06-21T12:16:57.281Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210903A', 'Add Auth Provider', '2022-06-21T12:16:57.328Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210907A', 'Webhooks Collections Not Null', '2022-06-21T12:16:57.352Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210910A', 'Move Module Setup', '2022-06-21T12:16:57.375Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210920A', 'Webhooks URL Not Null', '2022-06-21T12:16:57.413Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210924A', 'Add Collection Organization', '2022-06-21T12:16:57.431Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210927A', 'Replace Fields Group', '2022-06-21T12:16:57.460Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210927B', 'Replace M2M Interface', '2022-06-21T12:16:57.472Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20210929A', 'Rename Login Action', '2022-06-21T12:16:57.483Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211007A', 'Update Presets', '2022-06-21T12:16:57.508Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211009A', 'Add Auth Data', '2022-06-21T12:16:57.519Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211016A', 'Add Webhook Headers', '2022-06-21T12:16:57.533Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211103A', 'Set Unique to User Token', '2022-06-21T12:16:57.552Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211103B', 'Update Special Geometry', '2022-06-21T12:16:57.565Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211104A', 'Remove Collections Listing', '2022-06-21T12:16:57.579Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211118A', 'Add Notifications', '2022-06-21T12:16:57.617Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211211A', 'Add Shares', '2022-06-21T12:16:57.671Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20211230A', 'Add Project Descriptor', '2022-06-21T12:16:57.722Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220303A', 'Remove Default Project Color', '2022-06-21T12:16:57.746Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220308A', 'Add Bookmark Icon and Color', '2022-06-21T12:16:57.760Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220314A', 'Add Translation Strings', '2022-06-21T12:16:57.774Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220322A', 'Rename Field Typecast Flags', '2022-06-21T12:16:57.787Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220323A', 'Add Field Validation', '2022-06-21T12:16:57.800Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220325A', 'Fix Typecast Flags', '2022-06-21T12:16:57.825Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220325B', 'Add Default Language', '2022-06-21T12:16:57.857Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220402A', 'Remove Default Value Panel Icon', '2022-06-21T12:16:57.879Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220429A', 'Add Flows', '2022-07-07T13:58:00.739Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220429B', 'Add Color to Insights Icon', '2022-07-07T13:58:00.761Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220429C', 'Drop Non Null from IP of Activity', '2022-07-07T13:58:00.778Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220429D', 'Drop Non Null from Sender of Notifications', '2022-07-07T13:58:00.790Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220614A', 'Rename Hook Trigger to Event', '2022-07-07T13:58:00.826Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9001', 'Fill Date Created and Updated', '2022-07-07T13:58:00.957Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9002', 'Episodesaccess Materialized View', '2022-07-07T13:58:01.060Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9003', 'Fix Update Materialized View', '2022-07-07T13:58:01.072Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9004', 'Fix Update Materialized View Owner', '2022-07-07T13:58:01.086Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9005', 'New Views for Access', '2022-07-13T12:24:14.619Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9006', 'Views for Expanded Items', '2022-07-13T12:24:14.643Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9007', 'Force Tags Lowercase', '2022-07-29T09:11:07.793Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220801A', 'Update Notifications Timestamp Column', '2022-08-19T06:46:21.079Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20220802A', 'Add Custom Aspect Ratios', '2022-08-19T06:46:21.100Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9008', 'Add Tags to Episodes Expanded', '2022-08-19T06:46:21.129Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('9009', 'Add Legacy ID to Views', '2022-08-19T06:46:21.159Z');

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (698, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_items', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (702, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_items', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (26, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (27, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (28, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (29, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (30, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (390, 'a1b64719-0091-4db7-bdd1-19efb143e273', 'usergroups', 'read', '{"_and":[{"code":{"_contains":"fktb"}}]}', NULL, NULL, 'code,name,user_created,sort,date_created,user_updated,emails,date_updated');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (391, 'a1b64719-0091-4db7-bdd1-19efb143e273', 'usergroups', 'update', '{"_and":[{"code":{"_contains":"fktb"}}]}', NULL, NULL, 'user_created,sort,date_created,user_updated,name,date_updated,emails');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (36, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'assets', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (37, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'assets', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (38, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'assets', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (41, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (42, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (43, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (44, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (25, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'ageratings', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (45, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'usergroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (46, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (47, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (48, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (49, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'usergroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (60, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (61, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (62, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (63, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (64, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (65, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (66, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_usergroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (67, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_usergroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (68, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (69, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (70, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (71, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (72, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (73, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (74, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (75, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (76, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (77, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (78, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (79, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (80, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_usergroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (81, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (82, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_usergroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (83, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (84, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (85, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (86, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (87, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (88, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (89, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (90, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (91, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (96, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (102, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (104, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (105, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (114, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (115, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists_relations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (120, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (128, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'languages', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (130, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_earlyaccess', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (144, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (145, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (152, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_tags', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (158, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_categories', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (160, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (699, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_items', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (193, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (196, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (202, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (92, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (97, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (103, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (106, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (113, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (116, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists_relations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (123, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (125, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'languages', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (133, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_earlyaccess', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (138, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_download', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (139, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_download', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (140, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (146, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (154, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_tags', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (155, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_categories', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (700, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_items', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (192, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (198, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (203, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (204, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (93, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (98, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_usergroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (101, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (108, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (110, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (119, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists_relations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (122, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (127, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'languages', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (132, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_earlyaccess', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (137, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_download', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (143, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (149, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (151, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_tags', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (157, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_categories', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (163, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (164, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (701, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_items', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (94, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'sections', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (95, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (109, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (112, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (117, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists_relations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (121, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (129, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'languages', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (134, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_earlyaccess', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (135, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_download', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (142, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (148, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (153, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_tags', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (156, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_categories', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (162, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (191, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (197, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (201, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (99, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_usergroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (100, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (107, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (111, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (118, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists_relations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (124, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (126, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'languages', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (131, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_earlyaccess', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (136, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups_download', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (141, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (147, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (150, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_tags', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (159, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_categories', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (161, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (190, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (194, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (195, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (199, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (200, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (272, 'e3bf46db-28f3-4ce0-9999-2ab474d69e92', 'usergroups', 'update', '{"_and":[{"code":{"_contains":"kids"}}]}', NULL, NULL, 'name,sort,date_created,date_updated,emails,user_updated,user_created');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (235, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'assetfiles', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (239, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'assetfiles', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (238, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'assetfiles', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (241, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_files', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (242, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_files', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (243, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_files', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (244, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_files', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (245, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_files', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (288, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_notifications', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (270, 'e3bf46db-28f3-4ce0-9999-2ab474d69e92', 'usergroups', 'read', '{"_and":[{"code":{"_contains":"kids"}}]}', '{}', NULL, 'code,name,sort,user_created,date_created,user_updated,date_updated,emails');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (273, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_dashboards', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (274, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_dashboards', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (275, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_dashboards', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (276, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_dashboards', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (277, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_dashboards', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (278, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_folders', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (279, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_folders', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (280, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_folders', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (281, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_folders', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (282, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_folders', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (283, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_panels', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (284, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_panels', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (285, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_panels', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (286, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_panels', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (287, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_panels', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (289, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_notifications', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (290, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_notifications', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (291, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_notifications', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (292, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_notifications', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (293, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_revisions', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (294, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_revisions', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (295, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_revisions', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (296, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_revisions', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (297, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_revisions', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (298, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_users', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (299, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_users', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (300, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_users', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (301, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_users', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (302, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'directus_users', 'share', '{}', '{}', NULL, '*');

SELECT setval(pg_get_serial_sequence('"public"."directus_permissions"', 'id'), max("id"), true) FROM "public"."directus_permissions";

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (1, 'ageratings_translations', 'ageratings_code', 'ageratings', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (2, 'ageratings_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'ageratings_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (3, 'assetfiles', 'asset_id', 'assets', 'files', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (4, 'assetfiles', 'audio_language_id', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (5, 'assetfiles', 'subtitle_language_id', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (6, 'assetfiles', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (7, 'assetfiles', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (8, 'assets', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (9, 'assets', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (10, 'assetstreams', 'asset_id', 'assets', 'streams', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (11, 'assetstreams', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (12, 'assetstreams', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (13, 'assetstreams_audio_languages', 'assetstreams_id', 'assetstreams', 'audio_languages', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (14, 'assetstreams_audio_languages', 'languages_code', 'languages', NULL, NULL, NULL, 'assetstreams_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (15, 'assetstreams_subtitle_languages', 'assetstreams_id', 'assetstreams', 'subtitle_languages', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (16, 'assetstreams_subtitle_languages', 'languages_code', 'languages', NULL, NULL, NULL, 'assetstreams_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (17, 'calendarevent', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (18, 'calendarevent', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (19, 'categories', 'parent_id', 'categories', 'subcategories', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (20, 'categories', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (21, 'categories', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (22, 'categories_translations', 'categories_id', 'categories', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (23, 'categories_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'categories_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (26, 'collections', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (27, 'collections', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (38, 'episodes', 'agerating_code', 'ageratings', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (39, 'episodes', 'asset_id', 'assets', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (40, 'episodes', 'image_file_id', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (42, 'episodes', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (43, 'episodes', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (44, 'episodes_categories', 'categories_id', 'categories', 'episodes', NULL, NULL, 'episodes_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (45, 'episodes_categories', 'episodes_id', 'episodes', 'categories', NULL, NULL, 'categories_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (46, 'episodes_tags', 'episodes_id', 'episodes', 'tags', NULL, NULL, 'tags_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (47, 'episodes_tags', 'tags_id', 'tags', 'episodes', NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (48, 'episodes_translations', 'episodes_id', 'episodes', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (49, 'episodes_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (52, 'episodes_usergroups_download', 'episodes_id', 'episodes', 'download_usergroups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (53, 'episodes_usergroups_download', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (54, 'episodes_usergroups_earlyaccess', 'episodes_id', 'episodes', 'earlyaccess_usergroups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (55, 'episodes_usergroups_earlyaccess', 'usergroups_code', 'usergroups', 'episode_earlyaccess', NULL, NULL, 'episodes_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (56, 'lists', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (57, 'lists', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (58, 'lists_relations', 'item', NULL, NULL, 'collection', 'episodes,shows', 'lists_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (59, 'lists_relations', 'lists_id', 'lists', 'relations', NULL, NULL, 'item', 'sort', 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (60, 'pages', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (61, 'pages', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (62, 'seasons', 'agerating_code', 'ageratings', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (63, 'seasons', 'image_file_id', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (64, 'seasons', 'show_id', 'shows', 'seasons', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (65, 'seasons', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (66, 'seasons', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (67, 'seasons_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'seasons_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (68, 'seasons_translations', 'seasons_id', 'seasons', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (69, 'seasons_usergroups', 'seasons_id', 'seasons', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (70, 'seasons_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'seasons_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (71, 'sections', 'collection_id', 'collections', 'used_in_sections', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (73, 'sections', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (74, 'sections', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (77, 'sections_usergroups', 'sections_id', 'sections', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (78, 'sections_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'sections_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (79, 'shows', 'agerating_code', 'ageratings', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (80, 'shows', 'image_file_id', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (81, 'shows', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (82, 'shows', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (83, 'shows_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'shows_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (84, 'shows_translations', 'shows_id', 'shows', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (85, 'shows_usergroups', 'shows_id', 'shows', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (86, 'shows_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'shows_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (87, 'tags', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (88, 'tags', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (89, 'tvguideentry', 'event', 'calendarevent', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (90, 'tvguideentry', 'image', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (91, 'tvguideentry', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (92, 'tvguideentry', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (95, 'usergroups', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (96, 'usergroups', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (97, 'collections_items', 'collection_id', 'collections', 'items', NULL, NULL, NULL, 'sort', 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (98, 'collections_items', 'episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (99, 'collections_items', 'page_id', 'pages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (100, 'collections_items', 'season_id', 'seasons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (101, 'collections_items', 'show_id', 'shows', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (102, 'collections_items', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (103, 'collections_items', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (41, 'episodes', 'season_id', 'seasons', 'episodes', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (50, 'episodes_usergroups', 'episodes_id', 'episodes', 'usergroups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (51, 'episodes_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'episodes_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (104, 'faq_categories_translations', 'faq_categories_id', 'faq_categories', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (105, 'faq_categories_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'faq_categories_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (106, 'faqs', 'category', 'faq_categories', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (107, 'faqs', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (108, 'faqs', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (109, 'faqs_translations', 'faqs_id', 'faqs', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (110, 'faqs_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'faqs_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (111, 'faqs_usergroups', 'faqs_id', 'faqs', 'groups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (112, 'faqs_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'faqs_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (113, 'pages', 'episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (114, 'pages', 'season_id', 'seasons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (115, 'pages', 'show_id', 'shows', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (116, 'pages_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'pages_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (117, 'pages_translations', 'pages_id', 'pages', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (118, 'sections', 'page_id', 'pages', 'sections', NULL, NULL, NULL, 'sort', 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (75, 'sections_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'sections_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (76, 'sections_translations', 'sections_id', 'sections', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (119, 'tags_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'tags_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (120, 'tags_translations', 'tags_id', 'tags', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (121, 'calendarentries', 'episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (122, 'calendarentries', 'event_id', 'events', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (123, 'calendarentries', 'image', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (124, 'calendarentries', 'season_id', 'seasons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (125, 'calendarentries', 'show_id', 'shows', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (126, 'calendarentries', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (127, 'calendarentries', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (128, 'calendarentries_translations', 'calendarentries_id', 'calendarentries', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (129, 'calendarentries_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'calendarentries_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (130, 'events', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (131, 'events', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (132, 'events_translations', 'events_id', 'events', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (133, 'events_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'events_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (134, 'maintenancemessage', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (135, 'maintenancemessage_messagetemplates', 'maintenancemessage_id', 'maintenancemessage', 'messages', NULL, NULL, 'messagetemplates_id', 'sort', 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (136, 'maintenancemessage_messagetemplates', 'messagetemplates_id', 'messagetemplates', NULL, NULL, NULL, 'maintenancemessage_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (137, 'messagetemplates', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (138, 'messagetemplates', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (139, 'messagetemplates_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'messagetemplates_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (140, 'messagetemplates_translations', 'messagetemplates_id', 'messagetemplates', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (141, 'appconfig', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (142, 'globalconfig', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (143, 'webconfig', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true) FROM "public"."directus_relations";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_roles" RECORDS ---

INSERT INTO "public"."directus_roles" ("id", "name", "icon", "description", "ip_access", "enforce_tfa", "admin_access", "app_access")  VALUES ('aeeb3066-3a3d-48d2-b922-8ea359d1fc16', 'Administrator', 'verified', '$t:admin_description', NULL, false, true, true);

INSERT INTO "public"."directus_roles" ("id", "name", "icon", "description", "ip_access", "enforce_tfa", "admin_access", "app_access")  VALUES ('156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'Editor', 'supervised_user_circle', 'Standard access, minus technical stuff', NULL, false, false, true);

INSERT INTO "public"."directus_roles" ("id", "name", "icon", "description", "ip_access", "enforce_tfa", "admin_access", "app_access")  VALUES ('e3bf46db-28f3-4ce0-9999-2ab474d69e92', 'Kids early access manager', 'supervised_user_circle', NULL, NULL, false, false, true);

INSERT INTO "public"."directus_roles" ("id", "name", "icon", "description", "ip_access", "enforce_tfa", "admin_access", "app_access")  VALUES ('a1b64719-0091-4db7-bdd1-19efb143e273', 'FKTB early access manager', 'supervised_user_circle', NULL, NULL, false, false, true);

--- END SYNCHRONIZE TABLE "public"."directus_roles" RECORDS ---

	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_agerating_code_foreign" FOREIGN KEY (agerating_code) REFERENCES ageratings(code) ON DELETE SET NULL;
	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_asset_id_foreign" FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE SET NULL;
	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_image_file_id_foreign" FOREIGN KEY (image_file_id) REFERENCES directus_files(id) ON DELETE SET NULL;
	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_season_id_foreign" FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE CASCADE;
	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id);
	ALTER TABLE ONLY public.episodes ADD CONSTRAINT "episodes_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id);

COMMENT ON CONSTRAINT "episodes_legacy_id_unique" ON "public"."episodes" IS NULL;


COMMENT ON CONSTRAINT "episodes_legacy_program_id_unique" ON "public"."episodes" IS NULL;


COMMENT ON CONSTRAINT "episodes_pkey" ON "public"."episodes" IS NULL;


COMMENT ON CONSTRAINT "episodes_agerating_code_foreign" ON "public"."episodes" IS NULL;


COMMENT ON CONSTRAINT "episodes_asset_id_foreign" ON "public"."episodes" IS NULL;


COMMENT ON CONSTRAINT "episodes_image_file_id_foreign" ON "public"."episodes" IS NULL;


COMMENT ON CONSTRAINT "episodes_season_id_foreign" ON "public"."episodes" IS NULL;


COMMENT ON CONSTRAINT "episodes_user_created_foreign" ON "public"."episodes" IS NULL;


COMMENT ON CONSTRAINT "episodes_user_updated_foreign" ON "public"."episodes" IS NULL;

ALTER TABLE ONLY public.calendarentries	ADD CONSTRAINT "calendarentries_event_id_foreign" FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.calendarentries	ADD CONSTRAINT "calendarentries_image_foreign" FOREIGN KEY (image) REFERENCES directus_files(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.calendarentries	ADD CONSTRAINT "calendarentries_season_id_foreign" FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.calendarentries	ADD CONSTRAINT "calendarentries_show_id_foreign" FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.calendarentries	ADD CONSTRAINT "calendarentries_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id);
ALTER TABLE ONLY public.calendarentries	ADD CONSTRAINT "calendarentries_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id);

COMMENT ON CONSTRAINT "calendarentries_pkey" ON "public"."calendarentries" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_episode_id_foreign" ON "public"."calendarentries" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_event_id_foreign" ON "public"."calendarentries" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_image_foreign" ON "public"."calendarentries" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_season_id_foreign" ON "public"."calendarentries" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_show_id_foreign" ON "public"."calendarentries" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_user_created_foreign" ON "public"."calendarentries" IS NULL;


COMMENT ON CONSTRAINT "calendarentries_user_updated_foreign" ON "public"."calendarentries" IS NULL;

	ALTER TABLE ONLY public.sections ADD CONSTRAINT "sections_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE SET NULL;
	ALTER TABLE ONLY public.sections ADD CONSTRAINT "sections_page_id_foreign" FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE;
	ALTER TABLE ONLY public.sections ADD CONSTRAINT "sections_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id);
	ALTER TABLE ONLY public.sections ADD CONSTRAINT "sections_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id);
ALTER TABLE IF EXISTS "public"."sections" OWNER TO manager;


COMMENT ON COLUMN "public"."sections"."collection_id"  IS NULL;


COMMENT ON COLUMN "public"."sections"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."sections"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."sections"."id"  IS NULL;


COMMENT ON COLUMN "public"."sections"."status"  IS NULL;


COMMENT ON COLUMN "public"."sections"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."sections"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."sections"."page_id"  IS NULL;


COMMENT ON COLUMN "public"."sections"."sort"  IS NULL;


COMMENT ON COLUMN "public"."sections"."style"  IS NULL;

COMMENT ON CONSTRAINT "sections_pkey" ON "public"."sections" IS NULL;


COMMENT ON CONSTRAINT "sections_collection_id_foreign" ON "public"."sections" IS NULL;


COMMENT ON CONSTRAINT "sections_page_id_foreign" ON "public"."sections" IS NULL;


COMMENT ON CONSTRAINT "sections_user_created_foreign" ON "public"."sections" IS NULL;


COMMENT ON CONSTRAINT "sections_user_updated_foreign" ON "public"."sections" IS NULL;

	ALTER TABLE ONLY public.collections_items ADD CONSTRAINT "collections_items_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE;
	ALTER TABLE ONLY public.collections_items ADD CONSTRAINT "collections_items_episode_id_foreign" FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE SET NULL;
	ALTER TABLE ONLY public.collections_items ADD CONSTRAINT "collections_items_page_id_foreign" FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE SET NULL;
	ALTER TABLE ONLY public.collections_items ADD CONSTRAINT "collections_items_season_id_foreign" FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE SET NULL;
	ALTER TABLE ONLY public.collections_items ADD CONSTRAINT "collections_items_show_id_foreign" FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE SET NULL;
	ALTER TABLE ONLY public.collections_items ADD CONSTRAINT "collections_items_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id);
	ALTER TABLE ONLY public.collections_items ADD CONSTRAINT "collections_items_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id);

ALTER TABLE IF EXISTS "public"."collections_items" OWNER TO manager;


COMMENT ON COLUMN "public"."collections_items"."collection_id"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."episode_id"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."id"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."page_id"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."season_id"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."show_id"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."sort"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."type"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."collections_items"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "collections_items_pkey" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_collection_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_episode_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_page_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_season_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_show_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_user_created_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_user_updated_foreign" ON "public"."collections_items" IS NULL;

COMMENT ON TABLE "public"."collections_items"  IS NULL;
SET session_replication_role = 'origin';
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-09-05T11:51:03.381Z            ***/
/**********************************************************/

--- BEGIN CREATE SEQUENCE "public"."goose_db_version_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."goose_db_version_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."goose_db_version_id_seq" OWNER TO manager;

COMMENT ON SEQUENCE "public"."goose_db_version_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."goose_db_version_id_seq" ---

--- BEGIN CREATE TABLE "public"."goose_db_version" ---

CREATE TABLE IF NOT EXISTS "public"."goose_db_version" (
	"id" int4 NOT NULL DEFAULT nextval('goose_db_version_id_seq'::regclass) ,
	"version_id" int8 NOT NULL  ,
	"is_applied" bool NOT NULL  ,
	"tstamp" timestamp NULL DEFAULT now() ,
	CONSTRAINT "goose_db_version_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."goose_db_version" OWNER TO manager;


COMMENT ON COLUMN "public"."goose_db_version"."id"  IS NULL;


COMMENT ON COLUMN "public"."goose_db_version"."version_id"  IS NULL;


COMMENT ON COLUMN "public"."goose_db_version"."is_applied"  IS NULL;


COMMENT ON COLUMN "public"."goose_db_version"."tstamp"  IS NULL;

COMMENT ON CONSTRAINT "goose_db_version_pkey" ON "public"."goose_db_version" IS NULL;

COMMENT ON TABLE "public"."goose_db_version"  IS NULL;

--- END CREATE TABLE "public"."goose_db_version" ---

--- BEGIN DROP TABLE "public"."appconfig" ---

DROP TABLE IF EXISTS "public"."appconfig";

--- END DROP TABLE "public"."appconfig" ---

--- BEGIN DROP TABLE "public"."assets" ---

DROP TABLE IF EXISTS "public"."assets";

--- END DROP TABLE "public"."assets" ---

--- BEGIN DROP TABLE "public"."assetstreams" ---

DROP TABLE IF EXISTS "public"."assetstreams";

--- END DROP TABLE "public"."assetstreams" ---

--- BEGIN DROP TABLE "public"."assetstreams_audio_languages" ---

DROP TABLE IF EXISTS "public"."assetstreams_audio_languages";

--- END DROP TABLE "public"."assetstreams_audio_languages" ---

--- BEGIN DROP TABLE "public"."assetstreams_subtitle_languages" ---

DROP TABLE IF EXISTS "public"."assetstreams_subtitle_languages";

--- END DROP TABLE "public"."assetstreams_subtitle_languages" ---

--- BEGIN DROP TABLE "public"."calendarentries_translations" ---

DROP TABLE IF EXISTS "public"."calendarentries_translations";

--- END DROP TABLE "public"."calendarentries_translations" ---

--- BEGIN DROP TABLE "public"."calendarevent" ---

DROP TABLE IF EXISTS "public"."calendarevent";

--- END DROP TABLE "public"."calendarevent" ---

--- BEGIN DROP TABLE "public"."categories" ---

DROP TABLE IF EXISTS "public"."categories";

--- END DROP TABLE "public"."categories" ---

--- BEGIN DROP TABLE "public"."ageratings" ---

DROP TABLE IF EXISTS "public"."ageratings";

--- END DROP TABLE "public"."ageratings" ---

--- BEGIN DROP TABLE "public"."assetfiles" ---

DROP TABLE IF EXISTS "public"."assetfiles";

--- END DROP TABLE "public"."assetfiles" ---

--- BEGIN DROP TABLE "public"."calendarentries" ---

DROP TABLE IF EXISTS "public"."calendarentries";

--- END DROP TABLE "public"."calendarentries" ---

--- BEGIN DROP TABLE "public"."directus_collections" ---

DROP TABLE IF EXISTS "public"."directus_collections";

--- END DROP TABLE "public"."directus_collections" ---

--- BEGIN DROP TABLE "public"."directus_activity" ---

DROP TABLE IF EXISTS "public"."directus_activity";

--- END DROP TABLE "public"."directus_activity" ---

--- BEGIN DROP TABLE "public"."categories_translations" ---

DROP TABLE IF EXISTS "public"."categories_translations";

--- END DROP TABLE "public"."categories_translations" ---

--- BEGIN DROP TABLE "public"."directus_fields" ---

DROP TABLE IF EXISTS "public"."directus_fields";

--- END DROP TABLE "public"."directus_fields" ---

--- BEGIN DROP TABLE "public"."directus_dashboards" ---

DROP TABLE IF EXISTS "public"."directus_dashboards";

--- END DROP TABLE "public"."directus_dashboards" ---

--- BEGIN DROP TABLE "public"."directus_migrations" ---

DROP TABLE IF EXISTS "public"."directus_migrations";

--- END DROP TABLE "public"."directus_migrations" ---

--- BEGIN DROP TABLE "public"."directus_files" ---

DROP TABLE IF EXISTS "public"."directus_files";

--- END DROP TABLE "public"."directus_files" ---

--- BEGIN DROP TABLE "public"."directus_folders" ---

DROP TABLE IF EXISTS "public"."directus_folders";

--- END DROP TABLE "public"."directus_folders" ---

--- BEGIN DROP TABLE "public"."directus_flows" ---

DROP TABLE IF EXISTS "public"."directus_flows";

--- END DROP TABLE "public"."directus_flows" ---

--- BEGIN DROP TABLE "public"."directus_panels" ---

DROP TABLE IF EXISTS "public"."directus_panels";

--- END DROP TABLE "public"."directus_panels" ---

--- BEGIN DROP TABLE "public"."directus_roles" ---

DROP TABLE IF EXISTS "public"."directus_roles";

--- END DROP TABLE "public"."directus_roles" ---

--- BEGIN DROP TABLE "public"."directus_presets" ---

DROP TABLE IF EXISTS "public"."directus_presets";

--- END DROP TABLE "public"."directus_presets" ---

--- BEGIN DROP TABLE "public"."directus_revisions" ---

DROP TABLE IF EXISTS "public"."directus_revisions";

--- END DROP TABLE "public"."directus_revisions" ---

--- BEGIN DROP TABLE "public"."directus_relations" ---

DROP TABLE IF EXISTS "public"."directus_relations";

--- END DROP TABLE "public"."directus_relations" ---

--- BEGIN DROP TABLE "public"."directus_sessions" ---

DROP TABLE IF EXISTS "public"."directus_sessions";

--- END DROP TABLE "public"."directus_sessions" ---

--- BEGIN DROP TABLE "public"."directus_settings" ---

DROP TABLE IF EXISTS "public"."directus_settings";

--- END DROP TABLE "public"."directus_settings" ---

--- BEGIN DROP TABLE "public"."directus_notifications" ---

DROP TABLE IF EXISTS "public"."directus_notifications";

--- END DROP TABLE "public"."directus_notifications" ---

--- BEGIN DROP TABLE "public"."directus_operations" ---

DROP TABLE IF EXISTS "public"."directus_operations";

--- END DROP TABLE "public"."directus_operations" ---

--- BEGIN DROP TABLE "public"."directus_shares" ---

DROP TABLE IF EXISTS "public"."directus_shares";

--- END DROP TABLE "public"."directus_shares" ---

--- BEGIN DROP TABLE "public"."directus_users" ---

DROP TABLE IF EXISTS "public"."directus_users";

--- END DROP TABLE "public"."directus_users" ---

--- BEGIN DROP TABLE "public"."directus_webhooks" ---

DROP TABLE IF EXISTS "public"."directus_webhooks";

--- END DROP TABLE "public"."directus_webhooks" ---

--- BEGIN DROP TABLE "public"."seasons" ---

DROP TABLE IF EXISTS "public"."seasons";

--- END DROP TABLE "public"."seasons" ---

--- BEGIN DROP TABLE "public"."shows" ---

DROP TABLE IF EXISTS "public"."shows";

--- END DROP TABLE "public"."shows" ---

--- BEGIN DROP TABLE "public"."episodes_usergroups_download" ---

DROP TABLE IF EXISTS "public"."episodes_usergroups_download";

--- END DROP TABLE "public"."episodes_usergroups_download" ---

--- BEGIN DROP TABLE "public"."episodes" ---

DROP TABLE IF EXISTS "public"."episodes";

--- END DROP TABLE "public"."episodes" ---

--- BEGIN DROP TABLE "public"."episodes_usergroups_earlyaccess" ---

DROP TABLE IF EXISTS "public"."episodes_usergroups_earlyaccess";

--- END DROP TABLE "public"."episodes_usergroups_earlyaccess" ---

--- BEGIN DROP TABLE "public"."episodes_usergroups" ---

DROP TABLE IF EXISTS "public"."episodes_usergroups";

--- END DROP TABLE "public"."episodes_usergroups" ---

--- BEGIN DROP TABLE "public"."events_translations" ---

DROP TABLE IF EXISTS "public"."events_translations";

--- END DROP TABLE "public"."events_translations" ---

--- BEGIN DROP TABLE "public"."faq_categories" ---

DROP TABLE IF EXISTS "public"."faq_categories";

--- END DROP TABLE "public"."faq_categories" ---

--- BEGIN DROP TABLE "public"."faqs" ---

DROP TABLE IF EXISTS "public"."faqs";

--- END DROP TABLE "public"."faqs" ---

--- BEGIN DROP TABLE "public"."faqs_usergroups" ---

DROP TABLE IF EXISTS "public"."faqs_usergroups";

--- END DROP TABLE "public"."faqs_usergroups" ---

--- BEGIN DROP TABLE "public"."events" ---

DROP TABLE IF EXISTS "public"."events";

--- END DROP TABLE "public"."events" ---

--- BEGIN DROP TABLE "public"."episodes_categories" ---

DROP TABLE IF EXISTS "public"."episodes_categories";

--- END DROP TABLE "public"."episodes_categories" ---

--- BEGIN DROP TABLE "public"."episodes_tags" ---

DROP TABLE IF EXISTS "public"."episodes_tags";

--- END DROP TABLE "public"."episodes_tags" ---

--- BEGIN DROP TABLE "public"."episodes_translations" ---

DROP TABLE IF EXISTS "public"."episodes_translations";

--- END DROP TABLE "public"."episodes_translations" ---

--- BEGIN DROP TABLE "public"."faqs_translations" ---

DROP TABLE IF EXISTS "public"."faqs_translations";

--- END DROP TABLE "public"."faqs_translations" ---

--- BEGIN DROP TABLE "public"."globalconfig" ---

DROP TABLE IF EXISTS "public"."globalconfig";

--- END DROP TABLE "public"."globalconfig" ---

--- BEGIN DROP TABLE "public"."lists" ---

DROP TABLE IF EXISTS "public"."lists";

--- END DROP TABLE "public"."lists" ---

--- BEGIN DROP TABLE "public"."lists_relations" ---

DROP TABLE IF EXISTS "public"."lists_relations";

--- END DROP TABLE "public"."lists_relations" ---

--- BEGIN DROP TABLE "public"."materialized_views_meta" ---

DROP TABLE IF EXISTS "public"."materialized_views_meta";

--- END DROP TABLE "public"."materialized_views_meta" ---

--- BEGIN DROP TABLE "public"."messagetemplates_translations" ---

DROP TABLE IF EXISTS "public"."messagetemplates_translations";

--- END DROP TABLE "public"."messagetemplates_translations" ---

--- BEGIN DROP TABLE "public"."pages_translations" ---

DROP TABLE IF EXISTS "public"."pages_translations";

--- END DROP TABLE "public"."pages_translations" ---

--- BEGIN DROP TABLE "public"."maintenancemessage" ---

DROP TABLE IF EXISTS "public"."maintenancemessage";

--- END DROP TABLE "public"."maintenancemessage" ---

--- BEGIN DROP TABLE "public"."seasons_translations" ---

DROP TABLE IF EXISTS "public"."seasons_translations";

--- END DROP TABLE "public"."seasons_translations" ---

--- BEGIN DROP TABLE "public"."seasons_usergroups" ---

DROP TABLE IF EXISTS "public"."seasons_usergroups";

--- END DROP TABLE "public"."seasons_usergroups" ---

--- BEGIN DROP TABLE "public"."sections_translations" ---

DROP TABLE IF EXISTS "public"."sections_translations";

--- END DROP TABLE "public"."sections_translations" ---

--- BEGIN DROP TABLE "public"."messagetemplates" ---

DROP TABLE IF EXISTS "public"."messagetemplates";

--- END DROP TABLE "public"."messagetemplates" ---

--- BEGIN DROP TABLE "public"."sections" ---

DROP TABLE IF EXISTS "public"."sections";

--- END DROP TABLE "public"."sections" ---

--- BEGIN DROP TABLE "public"."sections_usergroups" ---

DROP TABLE IF EXISTS "public"."sections_usergroups";

--- END DROP TABLE "public"."sections_usergroups" ---

--- BEGIN DROP TABLE "public"."shows_usergroups" ---

DROP TABLE IF EXISTS "public"."shows_usergroups";

--- END DROP TABLE "public"."shows_usergroups" ---

--- BEGIN DROP TABLE "public"."usergroups" ---

DROP TABLE IF EXISTS "public"."usergroups";

--- END DROP TABLE "public"."usergroups" ---

--- BEGIN DROP TABLE "public"."tvguideentry" ---

DROP TABLE IF EXISTS "public"."tvguideentry";

--- END DROP TABLE "public"."tvguideentry" ---

--- BEGIN DROP TABLE "public"."webconfig" ---

DROP TABLE IF EXISTS "public"."webconfig";

--- END DROP TABLE "public"."webconfig" ---

--- BEGIN DROP TABLE "public"."shows_translations" ---

DROP TABLE IF EXISTS "public"."shows_translations";

--- END DROP TABLE "public"."shows_translations" ---

--- BEGIN DROP TABLE "public"."tags_translations" ---

DROP TABLE IF EXISTS "public"."tags_translations";

--- END DROP TABLE "public"."tags_translations" ---

--- BEGIN DROP TABLE "public"."tags" ---

DROP TABLE IF EXISTS "public"."tags";

--- END DROP TABLE "public"."tags" ---

--- BEGIN DROP TABLE "public"."ageratings_translations" ---

DROP TABLE IF EXISTS "public"."ageratings_translations";

--- END DROP TABLE "public"."ageratings_translations" ---

--- BEGIN DROP TABLE "public"."languages" ---

DROP TABLE IF EXISTS "public"."languages";

--- END DROP TABLE "public"."languages" ---

--- BEGIN DROP TABLE "public"."collections" ---

DROP TABLE IF EXISTS "public"."collections";

--- END DROP TABLE "public"."collections" ---

--- BEGIN DROP TABLE "public"."collections_items" ---

DROP TABLE IF EXISTS "public"."collections_items";

--- END DROP TABLE "public"."collections_items" ---

--- BEGIN DROP TABLE "public"."pages" ---

DROP TABLE IF EXISTS "public"."pages";

--- END DROP TABLE "public"."pages" ---

--- BEGIN DROP TABLE "public"."directus_permissions" ---

DROP TABLE IF EXISTS "public"."directus_permissions";

--- END DROP TABLE "public"."directus_permissions" ---

--- BEGIN DROP TABLE "public"."faq_categories_translations" ---

DROP TABLE IF EXISTS "public"."faq_categories_translations";

--- END DROP TABLE "public"."faq_categories_translations" ---

--- BEGIN DROP TABLE "public"."maintenancemessage_messagetemplates" ---

DROP TABLE IF EXISTS "public"."maintenancemessage_messagetemplates";

--- END DROP TABLE "public"."maintenancemessage_messagetemplates" ---

--- BEGIN DROP VIEW "public"."episodes_availability" ---

DROP VIEW IF EXISTS "public"."episodes_availability";
--- END DROP VIEW "public"."episodes_availability" ---

--- BEGIN DROP VIEW "public"."episodes_roles" ---

DROP VIEW IF EXISTS "public"."episodes_roles";
--- END DROP VIEW "public"."episodes_roles" ---

--- BEGIN DROP VIEW "public"."episodes_access_view" ---

DROP VIEW IF EXISTS "public"."episodes_access_view";
--- END DROP VIEW "public"."episodes_access_view" ---

--- BEGIN DROP VIEW "public"."episodes_expanded" ---

DROP VIEW IF EXISTS "public"."episodes_expanded";
--- END DROP VIEW "public"."episodes_expanded" ---

--- BEGIN DROP VIEW "public"."seasons_availability" ---

DROP VIEW IF EXISTS "public"."seasons_availability";
--- END DROP VIEW "public"."seasons_availability" ---

--- BEGIN DROP VIEW "public"."seasons_roles" ---

DROP VIEW IF EXISTS "public"."seasons_roles";
--- END DROP VIEW "public"."seasons_roles" ---

--- BEGIN DROP VIEW "public"."seasons_access_view" ---

DROP VIEW IF EXISTS "public"."seasons_access_view";
--- END DROP VIEW "public"."seasons_access_view" ---

--- BEGIN DROP VIEW "public"."seasons_expanded" ---

DROP VIEW IF EXISTS "public"."seasons_expanded";
--- END DROP VIEW "public"."seasons_expanded" ---

--- BEGIN DROP VIEW "public"."shows_availability" ---

DROP VIEW IF EXISTS "public"."shows_availability";
--- END DROP VIEW "public"."shows_availability" ---

--- BEGIN DROP VIEW "public"."shows_roles" ---

DROP VIEW IF EXISTS "public"."shows_roles";
--- END DROP VIEW "public"."shows_roles" ---

--- BEGIN DROP VIEW "public"."shows_access_view" ---

DROP VIEW IF EXISTS "public"."shows_access_view";
--- END DROP VIEW "public"."shows_access_view" ---

--- BEGIN DROP VIEW "public"."shows_expanded" ---

DROP VIEW IF EXISTS "public"."shows_expanded";
--- END DROP VIEW "public"."shows_expanded" ---

--- BEGIN DROP MATERIALIZED VIEW "public"."episodes_access" ---

DROP MATERIALIZED VIEW IF EXISTS "public"."episodes_access";
--- END DROP MATERIALIZED VIEW "public"."episodes_access" ---

--- BEGIN DROP MATERIALIZED VIEW "public"."seasons_access" ---

DROP MATERIALIZED VIEW IF EXISTS "public"."seasons_access";
--- END DROP MATERIALIZED VIEW "public"."seasons_access" ---

--- BEGIN DROP MATERIALIZED VIEW "public"."shows_access" ---

DROP MATERIALIZED VIEW IF EXISTS "public"."shows_access";
--- END DROP MATERIALIZED VIEW "public"."shows_access" ---

--- BEGIN DROP FUNCTION "public"."nametolowercase"() ---

DROP FUNCTION IF EXISTS "public"."nametolowercase"();

--- END DROP FUNCTION "public"."nametolowercase"() ---

--- BEGIN DROP FUNCTION "public"."update_access"(character varying) ---

DROP FUNCTION IF EXISTS "public"."update_access"(character varying);

--- END DROP FUNCTION "public"."update_access"(character varying) ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--ERROR: Table "public"."directus_collections" not found on SOURCE database for comparison!

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--ERROR: Table "public"."directus_fields" not found on SOURCE database for comparison!

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

--ERROR: Table "public"."directus_migrations" not found on SOURCE database for comparison!

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--ERROR: Table "public"."directus_permissions" not found on SOURCE database for comparison!

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--ERROR: Table "public"."directus_relations" not found on SOURCE database for comparison!

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_roles" RECORDS ---

--ERROR: Table "public"."directus_roles" not found on SOURCE database for comparison!

--- END SYNCHRONIZE TABLE "public"."directus_roles" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_webhooks" RECORDS ---

--ERROR: Table "public"."directus_webhooks" not found on SOURCE database for comparison!

--- END SYNCHRONIZE TABLE "public"."directus_webhooks" RECORDS ---
