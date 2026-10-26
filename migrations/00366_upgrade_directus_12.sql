-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2026-10-26T07:26:31.978Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."directus_collections" ADD COLUMN IF NOT EXISTS "status" varchar(255) NOT NULL DEFAULT 'active'::character varying ;

ALTER TABLE IF EXISTS "public"."directus_collections" ADD COLUMN IF NOT EXISTS "autosave_revision_interval" float4 NULL  ;

ALTER TABLE IF EXISTS "public"."directus_folders" ADD COLUMN IF NOT EXISTS "type" varchar(255) NOT NULL DEFAULT 'files'::character varying ;

ALTER TABLE IF EXISTS "public"."directus_flows" ADD COLUMN IF NOT EXISTS "folder" uuid NULL  ;

-- +goose StatementBegin
DO $$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_constraint WHERE conname = 'directus_flows_folder_foreign'
	) THEN
		ALTER TABLE "public"."directus_flows" ADD CONSTRAINT "directus_flows_folder_foreign" FOREIGN KEY (folder) REFERENCES directus_folders(id) ON DELETE SET NULL;
	END IF;
END $$;
-- +goose StatementEnd

CREATE TABLE IF NOT EXISTS "public"."directus_oauth_clients" (
	"client_id" varchar(255) NOT NULL  ,
	"client_name" varchar(200) NOT NULL  ,
	"redirect_uris" json NOT NULL  ,
	"grant_types" json NOT NULL  ,
	"token_endpoint_auth_method" varchar(255) NOT NULL DEFAULT 'none'::character varying ,
	"client_secret_hash" varchar(64) NULL  ,
	"registration_type" varchar(10) NOT NULL DEFAULT 'dcr'::character varying ,
	"client_uri" text NULL  ,
	"logo_uri" text NULL  ,
	"tos_uri" text NULL  ,
	"policy_uri" text NULL  ,
	"metadata_fetched_at" timestamptz NULL  ,
	"metadata_expires_at" timestamptz NULL  ,
	"metadata_etag" varchar(255) NULL  ,
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	CONSTRAINT "directus_oauth_clients_pkey" PRIMARY KEY (client_id) 
);

CREATE INDEX IF NOT EXISTS directus_oauth_clients_date_created_index ON public.directus_oauth_clients USING btree (date_created);

ALTER TABLE IF EXISTS "public"."directus_versions"
	ALTER COLUMN "item" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."directus_sessions" ADD COLUMN IF NOT EXISTS "oauth_client" varchar(255) NULL  ;

-- +goose StatementBegin
DO $$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_constraint WHERE conname = 'directus_sessions_oauth_client_foreign'
	) THEN
		ALTER TABLE "public"."directus_sessions" ADD CONSTRAINT "directus_sessions_oauth_client_foreign" FOREIGN KEY (oauth_client) REFERENCES directus_oauth_clients(client_id) ON DELETE CASCADE;
	END IF;
END $$;
-- +goose StatementEnd

CREATE INDEX IF NOT EXISTS directus_sessions_oauth_client_index ON public.directus_sessions USING btree (oauth_client);

CREATE TABLE IF NOT EXISTS "public"."directus_oauth_codes" (
	"id" uuid NOT NULL  ,
	"code_hash" varchar(64) NOT NULL  ,
	"client" varchar(255) NOT NULL  ,
	"user" uuid NOT NULL  ,
	"redirect_uri" varchar(255) NOT NULL  ,
	"resource" varchar(255) NOT NULL  ,
	"code_challenge" varchar(128) NOT NULL  ,
	"code_challenge_method" varchar(10) NOT NULL  ,
	"scope" varchar(255) NULL  ,
	"expires_at" timestamptz NOT NULL  ,
	"used_at" timestamptz NULL  ,
	CONSTRAINT "directus_oauth_codes_client_foreign" FOREIGN KEY (client) REFERENCES directus_oauth_clients(client_id) ON DELETE CASCADE ,
	CONSTRAINT "directus_oauth_codes_code_hash_unique" UNIQUE (code_hash) ,
	CONSTRAINT "directus_oauth_codes_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_oauth_codes_user_foreign" FOREIGN KEY ("user") REFERENCES directus_users(id) ON DELETE CASCADE 
);

CREATE INDEX IF NOT EXISTS directus_oauth_codes_expires_at_index ON public.directus_oauth_codes USING btree (expires_at);

CREATE INDEX IF NOT EXISTS directus_oauth_codes_used_at_index ON public.directus_oauth_codes USING btree (used_at);

CREATE TABLE IF NOT EXISTS "public"."directus_oauth_tokens" (
	"id" uuid NOT NULL  ,
	"client" varchar(255) NOT NULL  ,
	"user" uuid NOT NULL  ,
	"session" varchar(64) NOT NULL  ,
	"previous_session" varchar(64) NULL  ,
	"resource" varchar(255) NOT NULL  ,
	"code_hash" varchar(64) NOT NULL  ,
	"scope" varchar(255) NULL  ,
	"expires_at" timestamptz NOT NULL  ,
	"date_created" timestamptz NOT NULL  ,
	CONSTRAINT "directus_oauth_tokens_client_foreign" FOREIGN KEY (client) REFERENCES directus_oauth_clients(client_id) ON DELETE CASCADE ,
	CONSTRAINT "directus_oauth_tokens_client_user_unique" UNIQUE (client, "user") ,
	CONSTRAINT "directus_oauth_tokens_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_oauth_tokens_user_foreign" FOREIGN KEY ("user") REFERENCES directus_users(id) ON DELETE CASCADE 
);

CREATE INDEX IF NOT EXISTS directus_oauth_tokens_session_index ON public.directus_oauth_tokens USING btree (session);

CREATE INDEX IF NOT EXISTS directus_oauth_tokens_previous_session_index ON public.directus_oauth_tokens USING btree (previous_session);

CREATE INDEX IF NOT EXISTS directus_oauth_tokens_code_hash_index ON public.directus_oauth_tokens USING btree (code_hash);

CREATE INDEX IF NOT EXISTS directus_oauth_tokens_expires_at_index ON public.directus_oauth_tokens USING btree (expires_at);

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_translation_default_model" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_translation_glossary" json NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_translation_style_guide" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "license_key" varchar(255) NULL DEFAULT NULL::character varying ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "license_token" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "mcp_oauth_enabled" bool NOT NULL DEFAULT false ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "mcp_oauth_dcr_enabled" bool NOT NULL DEFAULT false ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "mcp_oauth_cimd_enabled" bool NOT NULL DEFAULT false ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "default_save_action" varchar(255) NOT NULL DEFAULT 'save-and-quit'::character varying ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "preview_base_url" varchar(255) NULL  ;

CREATE TABLE IF NOT EXISTS "public"."directus_oauth_consents" (
	"id" uuid NOT NULL  ,
	"user" uuid NOT NULL  ,
	"client" varchar(255) NOT NULL  ,
	"redirect_uri" varchar(255) NOT NULL  ,
	"scope" varchar(255) NULL  ,
	"date_created" timestamptz NOT NULL  ,
	"date_updated" timestamptz NOT NULL  ,
	CONSTRAINT "directus_oauth_consents_client_foreign" FOREIGN KEY (client) REFERENCES directus_oauth_clients(client_id) ON DELETE CASCADE ,
	CONSTRAINT "directus_oauth_consents_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_oauth_consents_user_client_redirect_uri_unique" UNIQUE ("user", client, redirect_uri) ,
	CONSTRAINT "directus_oauth_consents_user_foreign" FOREIGN KEY ("user") REFERENCES directus_users(id) ON DELETE CASCADE 
);

CREATE INDEX IF NOT EXISTS directus_oauth_consents_client_index ON public.directus_oauth_consents USING btree (client);

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260217A', 'Null Item Versions', '2026-10-26T07:25:36.512Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260312A', 'Add AI Translation Settings', '2026-10-26T07:25:36.533Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260507A', 'Add Licensing', '2026-10-26T07:25:36.556Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260512A', 'Add Autosave Revision Interval', '2026-10-26T07:25:36.572Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260512B', 'Add MCP Oauth', '2026-10-26T07:25:36.686Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260727A', 'Add Default Save Action', '2026-10-26T07:25:36.709Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260818A', 'Add Flow Folders', '2026-10-26T07:25:36.738Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260909A', 'Add Flows Module', '2026-10-26T07:25:36.758Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260924A', 'Add Preview Base URL', '2026-10-26T07:25:36.776Z');

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_oauth_clients" TO directus;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_oauth_codes" TO directus;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_oauth_tokens" TO directus;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_oauth_consents" TO directus;

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2026-10-26T07:26:35.334Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."directus_collections" DROP COLUMN IF EXISTS "status" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_collections" DROP COLUMN IF EXISTS "autosave_revision_interval" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_folders" DROP COLUMN IF EXISTS "type" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_flows" DROP COLUMN IF EXISTS "folder" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_flows" DROP CONSTRAINT IF EXISTS "directus_flows_folder_foreign";

ALTER TABLE IF EXISTS "public"."directus_versions"
	ALTER COLUMN "item" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."directus_sessions" DROP COLUMN IF EXISTS "oauth_client" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_sessions" DROP CONSTRAINT IF EXISTS "directus_sessions_oauth_client_foreign";

DROP INDEX IF EXISTS directus_sessions_oauth_client_index;

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_translation_default_model" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_translation_glossary" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_translation_style_guide" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "license_key" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "license_token" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "mcp_oauth_enabled" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "mcp_oauth_dcr_enabled" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "mcp_oauth_cimd_enabled" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "default_save_action" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "preview_base_url" CASCADE; --WARN: Drop column can occure in data loss!

DROP TABLE IF EXISTS "public"."directus_oauth_consents";  --WARN: Drop table can occure in data loss!

DROP TABLE IF EXISTS "public"."directus_oauth_tokens";  --WARN: Drop table can occure in data loss!

DROP TABLE IF EXISTS "public"."directus_oauth_codes";  --WARN: Drop table can occure in data loss!

DROP TABLE IF EXISTS "public"."directus_oauth_clients";  --WARN: Drop table can occure in data loss!

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260217A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260312A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260507A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260512A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260512B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260727A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260818A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260909A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260924A';

