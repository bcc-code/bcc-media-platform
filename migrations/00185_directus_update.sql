-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-02T09:41:27.675Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."directus_collections" ---

ALTER TABLE IF EXISTS "public"."directus_collections" ADD COLUMN IF NOT EXISTS "preview_url" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."directus_collections"."preview_url"  IS NULL;

--- END ALTER TABLE "public"."directus_collections" ---

--- BEGIN CREATE TABLE "public"."directus_translations" ---

CREATE TABLE IF NOT EXISTS "public"."directus_translations" (
	"id" uuid NOT NULL  ,
	"language" varchar(255) NOT NULL  ,
	"key" varchar(255) NOT NULL  ,
	"value" text NOT NULL  ,
	CONSTRAINT "directus_translations_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."directus_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."directus_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."directus_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."directus_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."directus_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."directus_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."directus_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."directus_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."directus_translations"."language"  IS NULL;


COMMENT ON COLUMN "public"."directus_translations"."key"  IS NULL;


COMMENT ON COLUMN "public"."directus_translations"."value"  IS NULL;

COMMENT ON CONSTRAINT "directus_translations_pkey" ON "public"."directus_translations" IS NULL;

COMMENT ON TABLE "public"."directus_translations"  IS NULL;

--- END CREATE TABLE "public"."directus_translations" ---

--- BEGIN ALTER TABLE "public"."directus_presets" ---

ALTER TABLE IF EXISTS "public"."directus_presets"
	ALTER COLUMN "icon" DROP NOT NULL,
	ALTER COLUMN "icon" SET DEFAULT 'bookmark'::character varying;

--- END ALTER TABLE "public"."directus_presets" ---

--- BEGIN ALTER TABLE "public"."directus_settings" ---

ALTER TABLE IF EXISTS "public"."directus_settings" DROP COLUMN IF EXISTS "translation_strings" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_settings" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20230401A', 'Update Material Icons', '2023-06-02T09:39:21.452Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20230525A', 'Add Preview Settings', '2023-06-02T09:39:21.456Z');

INSERT INTO "public"."directus_migrations" ("version", "name", "timestamp")  VALUES ('20230526A', 'Migrate Translation Strings', '2023-06-02T09:39:21.469Z');

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-02T09:41:29.282Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."directus_collections" ---

ALTER TABLE IF EXISTS "public"."directus_collections" DROP COLUMN IF EXISTS "preview_url" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."directus_collections" ---

--- BEGIN ALTER TABLE "public"."directus_presets" ---

ALTER TABLE IF EXISTS "public"."directus_presets"
	ALTER COLUMN "icon" SET NOT NULL,
	ALTER COLUMN "icon" SET DEFAULT 'bookmark_outline'::character varying;

--- END ALTER TABLE "public"."directus_presets" ---

--- BEGIN ALTER TABLE "public"."directus_settings" ---

ALTER TABLE IF EXISTS "public"."directus_settings" ADD COLUMN IF NOT EXISTS "translation_strings" json NULL  ;

COMMENT ON COLUMN "public"."directus_settings"."translation_strings"  IS NULL;

--- END ALTER TABLE "public"."directus_settings" ---

--- BEGIN DROP TABLE "public"."directus_translations" ---

DROP TABLE IF EXISTS "public"."directus_translations";

--- END DROP TABLE "public"."directus_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---

DELETE FROM "public"."directus_migrations" WHERE "version" = '20230401A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20230525A';

DELETE FROM "public"."directus_migrations" WHERE "version" = '20230526A';

--- END SYNCHRONIZE TABLE "public"."directus_migrations" RECORDS ---
