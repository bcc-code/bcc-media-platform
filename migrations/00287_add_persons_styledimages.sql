-- +goose Up

--- BEGIN CREATE TABLE "public"."persons_styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."persons_styledimages" (
	"id" int4 NOT NULL DEFAULT nextval('persons_styledimages_id_seq'::regclass) ,
	"persons_id" uuid NOT NULL  ,
	"styledimages_id" uuid NOT NULL  ,
	CONSTRAINT "persons_styledimages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "persons_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages(id) ON DELETE CASCADE ,
	CONSTRAINT "persons_styledimages_persons_id_foreign" FOREIGN KEY (persons_id) REFERENCES persons(id) ON DELETE CASCADE 
);

GRANT SELECT ON TABLE "public"."persons_styledimages" TO api, background_worker, directus;
GRANT INSERT ON TABLE "public"."persons_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."persons_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."persons_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."persons_styledimages"."id"  IS NULL;
COMMENT ON COLUMN "public"."persons_styledimages"."persons_id"  IS NULL;
COMMENT ON COLUMN "public"."persons_styledimages"."styledimages_id"  IS NULL;

COMMENT ON CONSTRAINT "persons_styledimages_pkey" ON "public"."persons_styledimages" IS NULL;
COMMENT ON CONSTRAINT "persons_styledimages_styledimages_id_foreign" ON "public"."persons_styledimages" IS NULL;
COMMENT ON CONSTRAINT "persons_styledimages_persons_id_foreign" ON "public"."persons_styledimages" IS NULL;

COMMENT ON TABLE "public"."persons_styledimages"  IS NULL;

--- END CREATE TABLE "public"."persons_styledimages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3024, 'persons', 'images', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3025, 'persons_styledimages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3026, 'persons_styledimages', 'persons_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3027, 'persons_styledimages', 'styledimages_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('persons_styledimages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (471, 'persons_styledimages', 'styledimages_id', 'styledimages', NULL, NULL, NULL, 'persons_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (472, 'persons_styledimages', 'persons_id', 'persons', 'images', NULL, NULL, 'styledimages_id', NULL, 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---


-- +goose Down

--- BEGIN DROP TABLE "public"."persons_styledimages" ---

DROP TABLE IF EXISTS "public"."persons_styledimages";

--- END DROP TABLE "public"."persons_styledimages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'persons_styledimages';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 3024;

DELETE FROM "public"."directus_fields" WHERE "id" = 3025;

DELETE FROM "public"."directus_fields" WHERE "id" = 3026;

DELETE FROM "public"."directus_fields" WHERE "id" = 3027;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 471;

DELETE FROM "public"."directus_relations" WHERE "id" = 472;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
