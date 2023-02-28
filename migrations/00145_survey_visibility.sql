-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-24T12:40:03.717Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."surveys_targets_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."surveys_targets_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."surveys_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."surveys_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."surveys_targets_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."surveys_targets_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."surveys_targets_id_seq" ---

--- BEGIN ALTER TABLE "public"."surveys" ---

ALTER TABLE IF EXISTS "public"."surveys" ADD COLUMN IF NOT EXISTS "from" timestamp NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."surveys"."from"  IS NULL;

ALTER TABLE IF EXISTS "public"."surveys" ADD COLUMN IF NOT EXISTS "to" timestamp NOT NULL  ; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."surveys"."to"  IS NULL;

--- END ALTER TABLE "public"."surveys" ---

--- BEGIN CREATE TABLE "public"."surveys_targets" ---

CREATE TABLE IF NOT EXISTS "public"."surveys_targets" (
	"id" int4 NOT NULL DEFAULT nextval('surveys_targets_id_seq'::regclass) ,
	"surveys_id" uuid NOT NULL  ,
	"targets_id" uuid NOT NULL  ,
	CONSTRAINT "surveys_targets_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "surveys_targets_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets(id) ON DELETE CASCADE ,
	CONSTRAINT "surveys_targets_surveys_id_foreign" FOREIGN KEY (surveys_id) REFERENCES surveys(id) ON DELETE CASCADE
);

GRANT ALL ON TABLE "public"."surveys_targets" TO directus;
GRANT SELECT ON TABLE "public"."surveys_targets" TO api, background_worker;

COMMENT ON COLUMN "public"."surveys_targets"."id"  IS NULL;


COMMENT ON COLUMN "public"."surveys_targets"."surveys_id"  IS NULL;


COMMENT ON COLUMN "public"."surveys_targets"."targets_id"  IS NULL;

COMMENT ON CONSTRAINT "surveys_targets_pkey" ON "public"."surveys_targets" IS NULL;


COMMENT ON CONSTRAINT "surveys_targets_targets_id_foreign" ON "public"."surveys_targets" IS NULL;


COMMENT ON CONSTRAINT "surveys_targets_surveys_id_foreign" ON "public"."surveys_targets" IS NULL;

COMMENT ON TABLE "public"."surveys_targets"  IS NULL;

--- END CREATE TABLE "public"."surveys_targets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('surveys_targets', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1066;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1082, 'surveys', 'from', NULL, 'custom-datepicker', NULL, 'datetime', '{"format":"short"}', false, false, 1, 'half', NULL, 'Visible from', NULL, false, 'visibility', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1068;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1084, 'surveys', 'visibility', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, false, 9, 'full', NULL, 'When should this survey be visible?', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1083, 'surveys', 'to', NULL, 'custom-datepicker', NULL, 'datetime', NULL, false, false, 2, 'half', NULL, 'Visible to', NULL, false, 'visibility', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1092, 'surveys_targets', 'targets_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1089, 'surveys', 'targets', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1090, 'surveys_targets', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1091, 'surveys_targets', 'surveys_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (333, 'surveys_targets', 'targets_id', 'targets', NULL, NULL, NULL, 'surveys_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (334, 'surveys_targets', 'surveys_id', 'surveys', 'targets', NULL, NULL, 'targets_id', NULL, 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-24T12:40:05.256Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."surveys" ---

ALTER TABLE IF EXISTS "public"."surveys" DROP COLUMN IF EXISTS "from" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."surveys" DROP COLUMN IF EXISTS "to" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."surveys" ---

--- BEGIN DROP TABLE "public"."surveys_targets" ---

DROP TABLE IF EXISTS "public"."surveys_targets";

--- END DROP TABLE "public"."surveys_targets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'surveys_targets';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1066;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1068;

DELETE FROM "public"."directus_fields" WHERE "id" = 1082;

DELETE FROM "public"."directus_fields" WHERE "id" = 1084;

DELETE FROM "public"."directus_fields" WHERE "id" = 1083;

DELETE FROM "public"."directus_fields" WHERE "id" = 1092;

DELETE FROM "public"."directus_fields" WHERE "id" = 1089;

DELETE FROM "public"."directus_fields" WHERE "id" = 1090;

DELETE FROM "public"."directus_fields" WHERE "id" = 1091;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 333;

DELETE FROM "public"."directus_relations" WHERE "id" = 334;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
