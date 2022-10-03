-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-03T09:53:33.665Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."shows_tags_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."shows_tags_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."shows_tags_id_seq" OWNER TO builder;
GRANT SELECT ON SEQUENCE "public"."shows_tags_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."shows_tags_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."shows_tags_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."shows_tags_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."shows_tags_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."seasons_tags_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."seasons_tags_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."seasons_tags_id_seq" OWNER TO builder;
GRANT SELECT ON SEQUENCE "public"."seasons_tags_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."seasons_tags_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."seasons_tags_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."seasons_tags_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."seasons_tags_id_seq" ---

--- BEGIN CREATE TABLE "public"."shows_tags" ---

CREATE TABLE IF NOT EXISTS "public"."shows_tags" (
	"id" int4 NOT NULL DEFAULT nextval('shows_tags_id_seq'::regclass) ,
	"shows_id" int4 NULL  ,
	"tags_id" int4 NULL  ,
	CONSTRAINT "shows_tags_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "shows_tags_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags(id) ON DELETE CASCADE ,
	CONSTRAINT "shows_tags_shows_id_foreign" FOREIGN KEY (shows_id) REFERENCES shows(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."shows_tags" OWNER TO builder;

GRANT SELECT ON TABLE "public"."shows_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."shows_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."shows_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."shows_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."shows_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."shows_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."shows_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

GRANT SELECT ON TABLE "public"."shows_tags" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."shows_tags"."id"  IS NULL;


COMMENT ON COLUMN "public"."shows_tags"."shows_id"  IS NULL;


COMMENT ON COLUMN "public"."shows_tags"."tags_id"  IS NULL;

COMMENT ON CONSTRAINT "shows_tags_pkey" ON "public"."shows_tags" IS NULL;


COMMENT ON CONSTRAINT "shows_tags_tags_id_foreign" ON "public"."shows_tags" IS NULL;


COMMENT ON CONSTRAINT "shows_tags_shows_id_foreign" ON "public"."shows_tags" IS NULL;

COMMENT ON TABLE "public"."shows_tags"  IS NULL;

--- END CREATE TABLE "public"."shows_tags" ---

--- BEGIN CREATE TABLE "public"."seasons_tags" ---

CREATE TABLE IF NOT EXISTS "public"."seasons_tags" (
	"id" int4 NOT NULL DEFAULT nextval('seasons_tags_id_seq'::regclass) ,
	"seasons_id" int4 NULL  ,
	"tags_id" int4 NULL  ,
	CONSTRAINT "seasons_tags_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "seasons_tags_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags(id) ON DELETE CASCADE ,
	CONSTRAINT "seasons_tags_seasons_id_foreign" FOREIGN KEY (seasons_id) REFERENCES seasons(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."seasons_tags" OWNER TO btv;

GRANT SELECT ON TABLE "public"."seasons_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."seasons_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."seasons_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."seasons_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."seasons_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."seasons_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."seasons_tags" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

GRANT SELECT ON TABLE "public"."seasons_tags" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."seasons_tags"."id"  IS NULL;


COMMENT ON COLUMN "public"."seasons_tags"."seasons_id"  IS NULL;


COMMENT ON COLUMN "public"."seasons_tags"."tags_id"  IS NULL;

COMMENT ON CONSTRAINT "seasons_tags_pkey" ON "public"."seasons_tags" IS NULL;


COMMENT ON CONSTRAINT "seasons_tags_tags_id_foreign" ON "public"."seasons_tags" IS NULL;


COMMENT ON CONSTRAINT "seasons_tags_seasons_id_foreign" ON "public"."seasons_tags" IS NULL;

COMMENT ON TABLE "public"."seasons_tags"  IS NULL;

--- END CREATE TABLE "public"."seasons_tags" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('shows_tags', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'shows', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('seasons_tags', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 2, 'seasons', 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (569, 'shows_tags', 'shows_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 276;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (574, 'seasons_tags', 'seasons_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (571, 'seasons', 'tags', 'm2m', NULL, NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (572, 'seasons_tags', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (573, 'tags', 'seasons', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (575, 'seasons_tags', 'tags_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (567, 'shows_tags', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (568, 'tags', 'shows', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (570, 'shows_tags', 'tags_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (566, 'shows', 'tags', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (172, 'shows_tags', 'tags_id', 'tags', 'shows', NULL, NULL, 'shows_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (173, 'shows_tags', 'shows_id', 'shows', 'tags', NULL, NULL, 'tags_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (174, 'seasons_tags', 'tags_id', 'tags', 'seasons', NULL, NULL, 'seasons_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (175, 'seasons_tags', 'seasons_id', 'seasons', 'tags', NULL, NULL, 'tags_id', NULL, 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-03T09:53:35.130Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "public"."shows_tags" ---

DROP TABLE IF EXISTS "public"."shows_tags";

--- END DROP TABLE "public"."shows_tags" ---

--- BEGIN DROP TABLE "public"."seasons_tags" ---

DROP TABLE IF EXISTS "public"."seasons_tags";

--- END DROP TABLE "public"."seasons_tags" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'shows_tags';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'seasons_tags';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 276;

DELETE FROM "public"."directus_fields" WHERE "id" = 569;

DELETE FROM "public"."directus_fields" WHERE "id" = 574;

DELETE FROM "public"."directus_fields" WHERE "id" = 571;

DELETE FROM "public"."directus_fields" WHERE "id" = 572;

DELETE FROM "public"."directus_fields" WHERE "id" = 573;

DELETE FROM "public"."directus_fields" WHERE "id" = 575;

DELETE FROM "public"."directus_fields" WHERE "id" = 567;

DELETE FROM "public"."directus_fields" WHERE "id" = 568;

DELETE FROM "public"."directus_fields" WHERE "id" = 570;

DELETE FROM "public"."directus_fields" WHERE "id" = 566;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 172;

DELETE FROM "public"."directus_relations" WHERE "id" = 173;

DELETE FROM "public"."directus_relations" WHERE "id" = 174;

DELETE FROM "public"."directus_relations" WHERE "id" = 175;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
