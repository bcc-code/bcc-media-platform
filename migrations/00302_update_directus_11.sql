-- +goose Up

--- BEGIN ALTER TABLE "public"."directus_roles" ---
ALTER TABLE IF EXISTS "public"."directus_roles"
	ALTER COLUMN "icon" SET DATA TYPE varchar(64) USING "icon"::varchar(64);
ALTER TABLE IF EXISTS "public"."directus_roles" ADD COLUMN IF NOT EXISTS "parent" uuid NULL  ;
COMMENT ON COLUMN "public"."directus_roles"."parent"  IS NULL;

-- BCCM NOTE: The following columns moved to directus_policies and the correct data is inserted raw further down here, so we can drop them safely.
ALTER TABLE IF EXISTS "public"."directus_roles" DROP COLUMN IF EXISTS "ip_access" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."directus_roles" DROP COLUMN IF EXISTS "enforce_tfa" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."directus_roles" DROP COLUMN IF EXISTS "admin_access" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."directus_roles" DROP COLUMN IF EXISTS "app_access" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_roles" ADD CONSTRAINT "directus_roles_parent_foreign" FOREIGN KEY (parent) REFERENCES directus_roles(id);
COMMENT ON CONSTRAINT "directus_roles_parent_foreign" ON "public"."directus_roles" IS NULL;
--- END ALTER TABLE "public"."directus_roles" ---

--- BEGIN CREATE TABLE "public"."directus_policies" ---
CREATE TABLE IF NOT EXISTS "public"."directus_policies" (
	"id" uuid NOT NULL  ,
	"name" varchar(100) NOT NULL  ,
	"icon" varchar(64) NOT NULL DEFAULT 'badge'::character varying ,
	"description" text NULL  ,
	"ip_access" text NULL  ,
	"enforce_tfa" bool NOT NULL DEFAULT false ,
	"admin_access" bool NOT NULL DEFAULT false ,
	"app_access" bool NOT NULL DEFAULT false ,
	CONSTRAINT "directus_policies_pkey" PRIMARY KEY (id) 
);
ALTER TABLE IF EXISTS "public"."directus_policies" OWNER TO manager;
GRANT SELECT ON TABLE "public"."directus_policies" TO directus;
COMMENT ON COLUMN "public"."directus_policies"."id"  IS NULL;
COMMENT ON COLUMN "public"."directus_policies"."name"  IS NULL;
COMMENT ON COLUMN "public"."directus_policies"."icon"  IS NULL;
COMMENT ON COLUMN "public"."directus_policies"."description"  IS NULL;
COMMENT ON COLUMN "public"."directus_policies"."ip_access"  IS NULL;
COMMENT ON COLUMN "public"."directus_policies"."enforce_tfa"  IS NULL;
COMMENT ON COLUMN "public"."directus_policies"."admin_access"  IS NULL;
COMMENT ON COLUMN "public"."directus_policies"."app_access"  IS NULL;
COMMENT ON CONSTRAINT "directus_policies_pkey" ON "public"."directus_policies" IS NULL;
COMMENT ON TABLE "public"."directus_policies"  IS NULL;

INSERT INTO public.directus_policies VALUES ('156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'Editor', 'supervised_user_circle', 'Standard access, minus technical stuff', NULL, false, false, true);
INSERT INTO public.directus_policies VALUES ('e3bf46db-28f3-4ce0-9999-2ab474d69e92', 'Kids early access manager', 'supervised_user_circle', NULL, NULL, false, false, true);
INSERT INTO public.directus_policies VALUES ('a1b64719-0091-4db7-bdd1-19efb143e273', 'FKTB early access manager', 'supervised_user_circle', NULL, NULL, false, false, true);
INSERT INTO public.directus_policies VALUES ('aeeb3066-3a3d-48d2-b922-8ea359d1fc16', 'Administrator', 'verified', '$t:admin_policy_description', NULL, false, true, true);
-- Bccm note: This one is new.
INSERT INTO public.directus_policies VALUES ('abf8a154-5b1c-4a46-ac9c-7300570f4f17', '$t:public_label', 'public', '$t:public_description', NULL, false, false, false);

--- END CREATE TABLE "public"."directus_policies" ---

--- BEGIN ALTER TABLE "public"."directus_flows" ---
ALTER TABLE IF EXISTS "public"."directus_flows"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(64) USING "icon"::varchar(64);
--- END ALTER TABLE "public"."directus_flows" ---

--- BEGIN ALTER TABLE "public"."directus_collections" ---
ALTER TABLE IF EXISTS "public"."directus_collections"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(64) USING "icon"::varchar(64);
--- END ALTER TABLE "public"."directus_collections" ---

--- BEGIN ALTER TABLE "public"."directus_files" ---
ALTER TABLE IF EXISTS "public"."directus_files" ADD COLUMN IF NOT EXISTS "created_on" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ;
COMMENT ON COLUMN "public"."directus_files"."created_on"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_files" ADD COLUMN IF NOT EXISTS "focal_point_x" int4 NULL  ;
COMMENT ON COLUMN "public"."directus_files"."focal_point_x"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_files" ADD COLUMN IF NOT EXISTS "focal_point_y" int4 NULL  ;
COMMENT ON COLUMN "public"."directus_files"."focal_point_y"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_files" ADD COLUMN IF NOT EXISTS "tus_id" varchar(64) NULL  ;
COMMENT ON COLUMN "public"."directus_files"."tus_id"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_files" ADD COLUMN IF NOT EXISTS "tus_data" json NULL  ;
COMMENT ON COLUMN "public"."directus_files"."tus_data"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_files"
	ALTER COLUMN "uploaded_on" DROP NOT NULL,
	ALTER COLUMN "uploaded_on" DROP DEFAULT ;
--- END ALTER TABLE "public"."directus_files" ---

--- BEGIN ALTER TABLE "public"."directus_dashboards" ---
ALTER TABLE IF EXISTS "public"."directus_dashboards"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(64) USING "icon"::varchar(64);
--- END ALTER TABLE "public"."directus_dashboards" ---

--- BEGIN ALTER TABLE "public"."directus_activity" ---
ALTER TABLE IF EXISTS "public"."directus_activity"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "user_agent" SET DATA TYPE text USING "user_agent"::text;
--- END ALTER TABLE "public"."directus_activity" ---

--- BEGIN CREATE TABLE "public"."directus_access" ---
CREATE TABLE IF NOT EXISTS "public"."directus_access" (
	"id" uuid NOT NULL  ,
	"role" uuid NULL  ,
	"user" uuid NULL  ,
	"policy" uuid NOT NULL  ,
	"sort" int4 NULL  ,
	CONSTRAINT "directus_access_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "directus_access_role_foreign" FOREIGN KEY (role) REFERENCES directus_roles(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_access_user_foreign" FOREIGN KEY ("user") REFERENCES directus_users(id) ON DELETE CASCADE ,
	CONSTRAINT "directus_access_policy_foreign" FOREIGN KEY (policy) REFERENCES directus_policies(id) ON DELETE CASCADE 
);
ALTER TABLE IF EXISTS "public"."directus_access" OWNER TO manager;
GRANT SELECT ON TABLE "public"."directus_access" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
COMMENT ON COLUMN "public"."directus_access"."id"  IS NULL;
COMMENT ON COLUMN "public"."directus_access"."role"  IS NULL;
COMMENT ON COLUMN "public"."directus_access"."user"  IS NULL;
COMMENT ON COLUMN "public"."directus_access"."policy"  IS NULL;
COMMENT ON COLUMN "public"."directus_access"."sort"  IS NULL;
COMMENT ON CONSTRAINT "directus_access_pkey" ON "public"."directus_access" IS NULL;
COMMENT ON CONSTRAINT "directus_access_role_foreign" ON "public"."directus_access" IS NULL;
COMMENT ON CONSTRAINT "directus_access_user_foreign" ON "public"."directus_access" IS NULL;
COMMENT ON CONSTRAINT "directus_access_policy_foreign" ON "public"."directus_access" IS NULL;
COMMENT ON TABLE "public"."directus_access"  IS NULL;
INSERT INTO public.directus_access VALUES ('426d7c2b-eac1-4f9c-a0fa-d1edf986918d', 'aeeb3066-3a3d-48d2-b922-8ea359d1fc16', NULL, 'aeeb3066-3a3d-48d2-b922-8ea359d1fc16', 1);
INSERT INTO public.directus_access VALUES ('d8b6901d-6ca9-4504-b7bd-2d32846f9127', '156d86ef-4c0e-4886-8bee-3a3c346fdb23', NULL, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 1);
INSERT INTO public.directus_access VALUES ('c9e8f50a-66b0-40e6-aa55-c2e156783c11', 'e3bf46db-28f3-4ce0-9999-2ab474d69e92', NULL, 'e3bf46db-28f3-4ce0-9999-2ab474d69e92', 1);
INSERT INTO public.directus_access VALUES ('27280041-26f9-429a-9cf3-f3996e004bef', 'a1b64719-0091-4db7-bdd1-19efb143e273', NULL, 'a1b64719-0091-4db7-bdd1-19efb143e273', 1);
INSERT INTO public.directus_access VALUES ('f8a93cd5-ebfc-4e79-ac5e-b5f493dd2a98', NULL, NULL, 'abf8a154-5b1c-4a46-ac9c-7300570f4f17', 1);
--- END CREATE TABLE "public"."directus_access" ---

--- BEGIN ALTER TABLE "public"."directus_webhooks" ---
ALTER TABLE IF EXISTS "public"."directus_webhooks" ADD COLUMN IF NOT EXISTS "was_active_before_deprecation" bool NOT NULL DEFAULT false ;
COMMENT ON COLUMN "public"."directus_webhooks"."was_active_before_deprecation"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_webhooks" ADD COLUMN IF NOT EXISTS "migrated_flow" uuid NULL  ;
COMMENT ON COLUMN "public"."directus_webhooks"."migrated_flow"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_webhooks" ADD CONSTRAINT "directus_webhooks_migrated_flow_foreign" FOREIGN KEY (migrated_flow) REFERENCES directus_flows(id) ON DELETE SET NULL;
COMMENT ON CONSTRAINT "directus_webhooks_migrated_flow_foreign" ON "public"."directus_webhooks" IS NULL;
--- END ALTER TABLE "public"."directus_webhooks" ---

--- BEGIN ALTER TABLE "public"."directus_permissions" ---
ALTER TABLE IF EXISTS "public"."directus_permissions" ADD COLUMN IF NOT EXISTS "policy" uuid NULL;
COMMENT ON COLUMN "public"."directus_permissions"."policy"  IS NULL;
UPDATE "public"."directus_permissions" SET "policy" = "role";
ALTER TABLE IF EXISTS "public"."directus_permissions" ALTER COLUMN "policy" SET NOT NULL;
-- BCCM Note: This is ok since we are pointing to the policy instead of the role (a new policy has been created 1:1 for the role with same id)
ALTER TABLE IF EXISTS "public"."directus_permissions" DROP COLUMN IF EXISTS "role" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."directus_permissions" ADD CONSTRAINT "directus_permissions_policy_foreign" FOREIGN KEY (policy) REFERENCES directus_policies(id) ON DELETE CASCADE;
COMMENT ON CONSTRAINT "directus_permissions_policy_foreign" ON "public"."directus_permissions" IS NULL;
ALTER TABLE IF EXISTS "public"."directus_permissions" DROP CONSTRAINT IF EXISTS "directus_permissions_role_foreign";
--- END ALTER TABLE "public"."directus_permissions" ---

--- BEGIN ALTER TABLE "public"."directus_settings" ---
ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "report_error_url" varchar(255) NULL  ;
COMMENT ON COLUMN "public"."directus_settings"."report_error_url"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "report_bug_url" varchar(255) NULL  ;
COMMENT ON COLUMN "public"."directus_settings"."report_bug_url"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "report_feature_url" varchar(255) NULL  ;
COMMENT ON COLUMN "public"."directus_settings"."report_feature_url"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "public_registration" bool NOT NULL DEFAULT false ;
COMMENT ON COLUMN "public"."directus_settings"."public_registration"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "public_registration_verify_email" bool NOT NULL DEFAULT true ;
COMMENT ON COLUMN "public"."directus_settings"."public_registration_verify_email"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "public_registration_role" uuid NULL  ;
COMMENT ON COLUMN "public"."directus_settings"."public_registration_role"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "public_registration_email_filter" json NULL  ;
COMMENT ON COLUMN "public"."directus_settings"."public_registration_email_filter"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_settings" ADD CONSTRAINT "directus_settings_public_registration_role_foreign" FOREIGN KEY (public_registration_role) REFERENCES directus_roles(id) ON DELETE SET NULL;
COMMENT ON CONSTRAINT "directus_settings_public_registration_role_foreign" ON "public"."directus_settings" IS NULL;
--- END ALTER TABLE "public"."directus_settings" ---

--- BEGIN ALTER TABLE "public"."directus_sessions" ---
ALTER TABLE IF EXISTS "public"."directus_sessions"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "user_agent" SET DATA TYPE text USING "user_agent"::text;
ALTER TABLE IF EXISTS "public"."directus_sessions" ADD COLUMN IF NOT EXISTS "next_token" varchar(64) NULL  ;
COMMENT ON COLUMN "public"."directus_sessions"."next_token"  IS NULL;
--- END ALTER TABLE "public"."directus_sessions" ---

--- BEGIN ALTER TABLE "public"."directus_panels" ---
ALTER TABLE IF EXISTS "public"."directus_panels"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(64) USING "icon"::varchar(64);
--- END ALTER TABLE "public"."directus_panels" ---

--- BEGIN ALTER TABLE "public"."directus_presets" ---
ALTER TABLE IF EXISTS "public"."directus_presets"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(64) USING "icon"::varchar(64);
--- END ALTER TABLE "public"."directus_presets" ---

--- BEGIN ALTER TABLE "public"."directus_extensions" ---
ALTER TABLE IF EXISTS "public"."directus_extensions" ADD COLUMN IF NOT EXISTS "id" uuid NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!
COMMENT ON COLUMN "public"."directus_extensions"."id"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_extensions" ADD COLUMN IF NOT EXISTS "folder" varchar(255) NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!
COMMENT ON COLUMN "public"."directus_extensions"."folder"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_extensions" ADD COLUMN IF NOT EXISTS "source" varchar(255) NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!
COMMENT ON COLUMN "public"."directus_extensions"."source"  IS NULL;
ALTER TABLE IF EXISTS "public"."directus_extensions" ADD COLUMN IF NOT EXISTS "bundle" uuid NULL  ;
COMMENT ON COLUMN "public"."directus_extensions"."bundle"  IS NULL;

-- BCCM Note: This table is empty so this doesnt matter
ALTER TABLE IF EXISTS "public"."directus_extensions" DROP COLUMN IF EXISTS "name" CASCADE; --WARN: Drop column can occure in data loss!
ALTER TABLE IF EXISTS "public"."directus_extensions" DROP CONSTRAINT IF EXISTS "directus_extensions_pkey";
ALTER TABLE IF EXISTS "public"."directus_extensions" ADD CONSTRAINT "directus_extensions_pkey" PRIMARY KEY (id);
COMMENT ON CONSTRAINT "directus_extensions_pkey" ON "public"."directus_extensions" IS NULL;
--- END ALTER TABLE "public"."directus_extensions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20231215A', 'Add Focalpoints', '2024-09-28T19:48:20.749Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240122A', 'Add Report URL Fields', '2024-09-28T19:48:20.752Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240204A', 'Marketplace', '2024-09-28T19:48:20.769Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240305A', 'Change Useragent Type', '2024-09-28T19:48:20.776Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240311A', 'Deprecate Webhooks', '2024-09-28T19:48:20.781Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240422A', 'Public Registration', '2024-09-28T19:48:20.784Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240515A', 'Add Session Window', '2024-09-28T19:48:20.785Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240701A', 'Add Tus Data', '2024-09-28T19:48:20.786Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240716A', 'Update Files Date Fields', '2024-09-28T19:48:20.789Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240806A', 'Permissions Policies', '2024-09-28T19:48:20.810Z');
INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20240817A', 'Update Icon Fields Length', '2024-09-28T19:48:20.819Z');
--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---




-- +goose Down
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-09-28T16:24:01.560Z                 ***/
/***************************************************************/

--- BEGIN ALTER TABLE "public"."directus_roles" ---

ALTER TABLE IF EXISTS "public"."directus_roles"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(30) USING "icon"::varchar(30);

ALTER TABLE IF EXISTS "public"."directus_roles" ADD COLUMN IF NOT EXISTS "ip_access" text NULL  ;

COMMENT ON COLUMN "public"."directus_roles"."ip_access"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_roles" ADD COLUMN IF NOT EXISTS "enforce_tfa" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "public"."directus_roles"."enforce_tfa"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_roles" ADD COLUMN IF NOT EXISTS "admin_access" bool NOT NULL DEFAULT false ;

COMMENT ON COLUMN "public"."directus_roles"."admin_access"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_roles" ADD COLUMN IF NOT EXISTS "app_access" bool NOT NULL DEFAULT true ;

COMMENT ON COLUMN "public"."directus_roles"."app_access"  IS NULL;

-- Bccm note: Add back the values we dropped
UPDATE "public"."directus_roles" SET 
    "ip_access" = NULL,
    "enforce_tfa" = false,
    "admin_access" = true,
    "app_access" = true
WHERE "id" = 'aeeb3066-3a3d-48d2-b922-8ea359d1fc16';
UPDATE "public"."directus_roles" SET 
    "ip_access" = NULL,
    "enforce_tfa" = false,
    "admin_access" = false,
    "app_access" = true
WHERE "id" = '156d86ef-4c0e-4886-8bee-3a3c346fdb23';
UPDATE "public"."directus_roles" SET 
    "ip_access" = NULL,
    "enforce_tfa" = false,
    "admin_access" = false,
    "app_access" = true
WHERE "id" = 'e3bf46db-28f3-4ce0-9999-2ab474d69e92';
UPDATE "public"."directus_roles" SET 
    "ip_access" = NULL,
    "enforce_tfa" = false,
    "admin_access" = false,
    "app_access" = true
WHERE "id" = 'a1b64719-0091-4db7-bdd1-19efb143e273';

ALTER TABLE IF EXISTS "public"."directus_roles" DROP COLUMN IF EXISTS "parent" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_roles" DROP CONSTRAINT IF EXISTS "directus_roles_parent_foreign";

--- END ALTER TABLE "public"."directus_roles" ---

--- BEGIN ALTER TABLE "public"."directus_collections" ---

ALTER TABLE IF EXISTS "public"."directus_collections"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(30) USING "icon"::varchar(30);

--- END ALTER TABLE "public"."directus_collections" ---

--- BEGIN ALTER TABLE "public"."directus_flows" ---

ALTER TABLE IF EXISTS "public"."directus_flows"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(30) USING "icon"::varchar(30);

--- END ALTER TABLE "public"."directus_flows" ---

--- BEGIN ALTER TABLE "public"."directus_dashboards" ---

ALTER TABLE IF EXISTS "public"."directus_dashboards"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(30) USING "icon"::varchar(30);

--- END ALTER TABLE "public"."directus_dashboards" ---

--- BEGIN ALTER TABLE "public"."directus_files" ---

ALTER TABLE IF EXISTS "public"."directus_files"
	ALTER COLUMN "uploaded_on" SET NOT NULL,
	ALTER COLUMN "uploaded_on" SET DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE IF EXISTS "public"."directus_files" DROP COLUMN IF EXISTS "created_on" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_files" DROP COLUMN IF EXISTS "focal_point_x" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_files" DROP COLUMN IF EXISTS "focal_point_y" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_files" DROP COLUMN IF EXISTS "tus_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_files" DROP COLUMN IF EXISTS "tus_data" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_files" ---

--- BEGIN ALTER TABLE "public"."directus_activity" ---

ALTER TABLE IF EXISTS "public"."directus_activity"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "user_agent" SET DATA TYPE varchar(255) USING "user_agent"::varchar(255);

--- END ALTER TABLE "public"."directus_activity" ---

--- BEGIN ALTER TABLE "public"."directus_permissions" ---

ALTER TABLE IF EXISTS "public"."directus_permissions" ADD COLUMN IF NOT EXISTS "role" uuid NULL  ;

COMMENT ON COLUMN "public"."directus_permissions"."role"  IS NULL;

UPDATE "public"."directus_permissions" SET "role" = "policy";

ALTER TABLE IF EXISTS "public"."directus_permissions" DROP COLUMN IF EXISTS "policy" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_permissions" ADD CONSTRAINT "directus_permissions_role_foreign" FOREIGN KEY (role) REFERENCES directus_roles(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "directus_permissions_role_foreign" ON "public"."directus_permissions" IS NULL;

ALTER TABLE IF EXISTS "public"."directus_permissions" DROP CONSTRAINT IF EXISTS "directus_permissions_policy_foreign";

--- END ALTER TABLE "public"."directus_permissions" ---

--- BEGIN ALTER TABLE "public"."directus_webhooks" ---

ALTER TABLE IF EXISTS "public"."directus_webhooks" DROP COLUMN IF EXISTS "was_active_before_deprecation" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_webhooks" DROP COLUMN IF EXISTS "migrated_flow" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_webhooks" DROP CONSTRAINT IF EXISTS "directus_webhooks_migrated_flow_foreign";

--- END ALTER TABLE "public"."directus_webhooks" ---

--- BEGIN ALTER TABLE "public"."directus_panels" ---

ALTER TABLE IF EXISTS "public"."directus_panels"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(30) USING "icon"::varchar(30);

--- END ALTER TABLE "public"."directus_panels" ---

--- BEGIN ALTER TABLE "public"."directus_presets" ---

ALTER TABLE IF EXISTS "public"."directus_presets"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "icon" SET DATA TYPE varchar(30) USING "icon"::varchar(30);

--- END ALTER TABLE "public"."directus_presets" ---

--- BEGIN ALTER TABLE "public"."directus_sessions" ---

ALTER TABLE IF EXISTS "public"."directus_sessions"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "user_agent" SET DATA TYPE varchar(255) USING "user_agent"::varchar(255);

ALTER TABLE IF EXISTS "public"."directus_sessions" DROP COLUMN IF EXISTS "next_token" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_sessions" ---

--- BEGIN ALTER TABLE "public"."directus_settings" ---

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "report_error_url" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "report_bug_url" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "report_feature_url" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "public_registration" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "public_registration_verify_email" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "public_registration_role" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "public_registration_email_filter" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_settings" DROP CONSTRAINT IF EXISTS "directus_settings_public_registration_role_foreign";

--- END ALTER TABLE "public"."directus_settings" ---

--- BEGIN ALTER TABLE "public"."directus_extensions" ---

ALTER TABLE IF EXISTS "public"."directus_extensions" ADD COLUMN IF NOT EXISTS "name" varchar(255) NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."directus_extensions"."name"  IS NULL;

ALTER TABLE IF EXISTS "public"."directus_extensions" DROP COLUMN IF EXISTS "id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_extensions" DROP COLUMN IF EXISTS "folder" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_extensions" DROP COLUMN IF EXISTS "source" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_extensions" DROP COLUMN IF EXISTS "bundle" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."directus_extensions" DROP CONSTRAINT IF EXISTS "directus_extensions_pkey";

ALTER TABLE IF EXISTS "public"."directus_extensions" ADD CONSTRAINT "directus_extensions_pkey" PRIMARY KEY (name);

COMMENT ON CONSTRAINT "directus_extensions_pkey" ON "public"."directus_extensions" IS NULL;

--- END ALTER TABLE "public"."directus_extensions" ---

--- BEGIN DROP TABLE "public"."directus_access" ---

DROP TABLE IF EXISTS "public"."directus_access";

--- END DROP TABLE "public"."directus_access" ---

--- BEGIN DROP TABLE "public"."directus_policies" ---

DROP TABLE IF EXISTS "public"."directus_policies";

--- END DROP TABLE "public"."directus_policies" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

DELETE FROM "public"."directus_migrations" WHERE "version" = '20231215A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240122A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240204A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240305A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240311A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240422A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240515A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240701A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240716A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240806A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20240817A';

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---
