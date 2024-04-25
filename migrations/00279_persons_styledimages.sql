-- +goose Up
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-04-24T10:12:41.199Z                 ***/
/***************************************************************/

--- BEGIN CREATE SEQUENCE "public"."persons_styledimages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."persons_styledimages_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."persons_styledimages_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."persons_styledimages_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."persons_styledimages_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."persons_styledimages_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."persons_styledimages_id_seq" ---

--- BEGIN CREATE TABLE "public"."persons_styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."persons_styledimages" (
	"id" int4 NOT NULL DEFAULT nextval('persons_styledimages_id_seq'::regclass) ,
	"persons_id" uuid NOT NULL  ,
	"styledimages_id" uuid NOT NULL  ,
	CONSTRAINT "persons_styledimages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "persons_styledimages_persons_id_foreign" FOREIGN KEY (persons_id) REFERENCES persons(id) ON DELETE CASCADE ,
	CONSTRAINT "persons_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages(id) ON DELETE CASCADE 
);

GRANT SELECT ON TABLE "public"."persons_styledimages" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."persons_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."persons_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."persons_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."persons_styledimages"."id"  IS NULL;


COMMENT ON COLUMN "public"."persons_styledimages"."persons_id"  IS NULL;


COMMENT ON COLUMN "public"."persons_styledimages"."styledimages_id"  IS NULL;

COMMENT ON CONSTRAINT "persons_styledimages_pkey" ON "public"."persons_styledimages" IS NULL;


COMMENT ON CONSTRAINT "persons_styledimages_persons_id_foreign" ON "public"."persons_styledimages" IS NULL;


COMMENT ON CONSTRAINT "persons_styledimages_styledimages_id_foreign" ON "public"."persons_styledimages" IS NULL;

COMMENT ON TABLE "public"."persons_styledimages"  IS NULL;

--- END CREATE TABLE "public"."persons_styledimages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3024, 'persons_styledimages', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3026, 'persons_styledimages', 'persons_id', 'm2o', 'select-dropdown-m2o', '{"enableCreate":false,"enableSelect":false}', NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3027, 'persons_styledimages', 'styledimages_id', 'm2o', 'select-dropdown-m2o', '{"enableCreate":false,"enableSelect":false}', NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('persons_styledimages', 'sync', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (472, 'persons_styledimages', 'persons_id', 'persons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (473, 'persons_styledimages', 'styledimages_id', 'styledimages', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-04-24T10:12:43.698Z                 ***/
/***************************************************************/

--- BEGIN DROP TABLE "public"."persons_styledimages" ---

DROP TABLE IF EXISTS "public"."persons_styledimages";

--- END DROP TABLE "public"."persons_styledimages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'persons_styledimages';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 3024;

DELETE FROM "public"."directus_fields" WHERE "id" = 3026;

DELETE FROM "public"."directus_fields" WHERE "id" = 3027;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 472;

DELETE FROM "public"."directus_relations" WHERE "id" = 473;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
