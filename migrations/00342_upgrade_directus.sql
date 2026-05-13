-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2026-05-13T10:25:17.266Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."directus_users" ADD COLUMN IF NOT EXISTS "text_direction" varchar(255) NOT NULL DEFAULT 'auto'::character varying ;

ALTER TABLE IF EXISTS "public"."directus_activity" DROP COLUMN IF EXISTS "comment" CASCADE; --WARN: Drop column can occure in data loss!

CREATE INDEX IF NOT EXISTS directus_activity_timestamp_index ON public.directus_activity USING btree ("timestamp");

ALTER TABLE IF EXISTS "public"."directus_versions" ADD COLUMN IF NOT EXISTS "delta" json NULL  ;

CREATE INDEX IF NOT EXISTS directus_revisions_parent_index ON public.directus_revisions USING btree (parent);

CREATE INDEX IF NOT EXISTS directus_revisions_activity_index ON public.directus_revisions USING btree (activity);

CREATE INDEX IF NOT EXISTS timedmetadata_id_seconds_index ON public.timedmetadata USING btree (id, seconds);

CREATE TABLE IF NOT EXISTS "public"."directus_deployments" (
	"id" uuid NOT NULL  ,
	"provider" varchar(255) NOT NULL  ,
	"credentials" text NULL  ,
	"options" text NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	"webhook_ids" json NULL  ,
	"webhook_secret" varchar(255) NULL  ,
	"last_synced_at" timestamptz NULL  ,
	CONSTRAINT "directus_deployments_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_deployments_provider_unique" UNIQUE (provider) ,
	CONSTRAINT "directus_deployments_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS "public"."directus_deployment_projects" (
	"id" uuid NOT NULL  ,
	"deployment" uuid NOT NULL  ,
	"external_id" varchar(255) NOT NULL  ,
	"name" varchar(255) NOT NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	"url" varchar(255) NULL  ,
	"framework" varchar(255) NULL  ,
	"deployable" bool NOT NULL DEFAULT true ,
	CONSTRAINT "directus_deployment_projects_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_deployment_projects_deployment_foreign" FOREIGN KEY (deployment) REFERENCES directus_deployments(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_deployment_projects_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL ,
	CONSTRAINT "directus_deployment_projects_deployment_external_id_unique" UNIQUE (deployment, external_id)
);

ALTER TABLE IF EXISTS "public"."directus_fields" ADD COLUMN IF NOT EXISTS "searchable" bool NOT NULL DEFAULT true ;

CREATE TABLE IF NOT EXISTS "public"."directus_comments" (
	"id" uuid NOT NULL  ,
	"collection" varchar(64) NOT NULL  ,
	"item" varchar(255) NOT NULL  ,
	"comment" text NOT NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "directus_comments_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_comments_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL ,
	CONSTRAINT "directus_comments_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

CREATE INDEX IF NOT EXISTS mediaitems_translations_mediaitems_id_index ON public.mediaitems_translations USING btree (mediaitems_id);

-- +goose StatementBegin
DO $$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_constraint WHERE conname = 'goose_db_version_pkey'
	) THEN
		ALTER TABLE "public"."goose_db_version" ADD CONSTRAINT "goose_db_version_pkey" PRIMARY KEY (id);
	END IF;
END $$;
-- +goose StatementEnd

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "visual_editor_urls" json NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "project_id" uuid NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "mcp_enabled" bool NOT NULL DEFAULT false ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "mcp_allow_deletes" bool NOT NULL DEFAULT false ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "mcp_prompts_collection" varchar(255) NULL DEFAULT NULL::character varying ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "mcp_system_prompt_enabled" bool NOT NULL DEFAULT true ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "mcp_system_prompt" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "project_owner" varchar(255) NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "project_usage" varchar(255) NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "org_name" varchar(255) NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "product_updates" bool NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "project_status" varchar(255) NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_openai_api_key" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_anthropic_api_key" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_system_prompt" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_google_api_key" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_openai_compatible_api_key" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_openai_compatible_base_url" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_openai_compatible_name" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_openai_compatible_models" json NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_openai_compatible_headers" json NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_openai_allowed_models" json NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_anthropic_allowed_models" json NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "ai_google_allowed_models" json NULL  ;

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "collaborative_editing_enabled" bool NOT NULL DEFAULT false ;

CREATE TABLE IF NOT EXISTS "public"."directus_deployment_runs" (
	"id" uuid NOT NULL  ,
	"project" uuid NOT NULL  ,
	"external_id" varchar(255) NOT NULL  ,
	"target" varchar(255) NOT NULL  ,
	"date_created" timestamptz NULL DEFAULT CURRENT_TIMESTAMP ,
	"user_created" uuid NULL  ,
	"status" varchar(255) NULL  ,
	"url" varchar(255) NULL  ,
	"started_at" timestamptz NULL  ,
	"completed_at" timestamptz NULL  ,
	CONSTRAINT "directus_deployment_runs_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_deployment_runs_project_foreign" FOREIGN KEY (project) REFERENCES directus_deployment_projects(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_deployment_runs_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ON DELETE SET NULL
);

DROP TABLE IF EXISTS "public"."directus_webhooks";  --WARN: Drop table can occure in data loss!

UPDATE "public"."directus_fields" SET "searchable" = true;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240909A', 'Separate Comments', '2026-05-13T10:18:29.395Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240909B', 'Consolidate Content Versioning', '2026-05-13T10:18:29.554Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240924A', 'Migrate Legacy Comments', '2026-05-13T10:18:29.697Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240924B', 'Populate Versioning Deltas', '2026-05-13T10:18:29.708Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20250224A', 'Visual Editor', '2026-05-13T10:18:29.727Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20250609A', 'License Banner', '2026-05-13T10:18:29.740Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20250613A', 'Add Project ID', '2026-05-13T10:18:29.778Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20250718A', 'Add Direction', '2026-05-13T10:18:29.791Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20250813A', 'Add MCP', '2026-05-13T10:18:29.806Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20251012A', 'Add Field Searchable', '2026-05-13T10:18:29.823Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20251014A', 'Add Project Owner', '2026-05-13T10:18:30.029Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20251028A', 'Add Retention Indexes', '2026-05-13T10:18:30.912Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20251103A', 'Add AI Settings', '2026-05-13T10:18:30.917Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20251224A', 'Remove Webhooks', '2026-05-13T10:18:30.934Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260110A', 'Add AI Provider Settings', '2026-05-13T10:18:30.946Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260113A', 'Add Revisions Index', '2026-05-13T10:18:31.103Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260128A', 'Add Collaborative Editing', '2026-05-13T10:18:31.111Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260204A', 'Add Deployment', '2026-05-13T10:18:31.174Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20260211A', 'Add Deployment Webhooks', '2026-05-13T10:18:31.185Z');

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2026-05-13T10:25:18.889Z            ***/
/**********************************************************/

CREATE SEQUENCE IF NOT EXISTS "public"."directus_webhooks_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;


CREATE SEQUENCE IF NOT EXISTS "public"."webconfig_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;


DROP INDEX IF EXISTS "public"."directus_activity_timestamp_index";

DROP INDEX IF EXISTS "public"."directus_revisions_parent_index";

DROP INDEX IF EXISTS "public"."directus_revisions_activity_index";

DROP INDEX IF EXISTS "public"."timedmetadata_id_seconds_index";

DROP INDEX IF EXISTS "public"."mediaitems_translations_mediaitems_id_index";

ALTER TABLE IF EXISTS "public"."goose_db_version" DROP CONSTRAINT IF EXISTS "goose_db_version_pkey";

ALTER TABLE IF EXISTS "public"."directus_users" DROP COLUMN IF EXISTS "text_direction" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_activity" ADD COLUMN IF NOT EXISTS "comment" text NULL  ;

ALTER TABLE IF EXISTS "public"."directus_versions" DROP COLUMN IF EXISTS "delta" CASCADE; --WARN: Drop column can occure in data loss!

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
	"was_active_before_deprecation" bool NOT NULL DEFAULT false ,
	"migrated_flow" uuid NULL  ,
	CONSTRAINT "directus_webhooks_migrated_flow_foreign" FOREIGN KEY (migrated_flow) REFERENCES directus_flows(id) ON DELETE SET NULL ,
	CONSTRAINT "directus_webhooks_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."directus_fields" DROP COLUMN IF EXISTS "searchable" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "visual_editor_urls" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "project_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "mcp_enabled" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "mcp_allow_deletes" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "mcp_prompts_collection" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "mcp_system_prompt_enabled" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "mcp_system_prompt" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "project_owner" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "project_usage" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "org_name" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "product_updates" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "project_status" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_openai_api_key" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_anthropic_api_key" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_system_prompt" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_google_api_key" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_openai_compatible_api_key" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_openai_compatible_base_url" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_openai_compatible_name" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_openai_compatible_models" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_openai_compatible_headers" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_openai_allowed_models" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_anthropic_allowed_models" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "ai_google_allowed_models" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "collaborative_editing_enabled" CASCADE; --WARN: Drop column can occure in data loss!

DROP TABLE IF EXISTS "public"."directus_deployment_runs";  --WARN: Drop table can occure in data loss!

DROP TABLE IF EXISTS "public"."directus_deployment_projects";  --WARN: Drop table can occure in data loss!

DROP TABLE IF EXISTS "public"."directus_deployments";  --WARN: Drop table can occure in data loss!

DROP TABLE IF EXISTS "public"."directus_comments";  --WARN: Drop table can occure in data loss!

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240909A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240909B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240924A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240924B';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20250224A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20250609A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20250613A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20250718A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20250813A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20251012A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20251014A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20251028A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20251103A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20251224A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260110A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260113A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260128A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260204A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20260211A';

