-- +goose Up
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-05-07T19:46:30.089Z                 ***/
/***************************************************************/


--- BEGIN DROP TABLE "public"."timedmetadata_contributions" ---

DROP TABLE IF EXISTS "public"."timedmetadata_contributions";

--- END DROP TABLE "public"."timedmetadata_contributions" ---

--- BEGIN DROP TABLE "public"."mediaitems_contributions" ---

DROP TABLE IF EXISTS "public"."mediaitems_contributions";

--- END DROP TABLE "public"."mediaitems_contributions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1516;

DELETE FROM "public"."directus_fields" WHERE "id" = 1513;

DELETE FROM "public"."directus_fields" WHERE "id" = 1514;

DELETE FROM "public"."directus_fields" WHERE "id" = 1515;

DELETE FROM "public"."directus_fields" WHERE "id" = 1518;

DELETE FROM "public"."directus_fields" WHERE "id" = 1519;

DELETE FROM "public"."directus_fields" WHERE "id" = 1520;

DELETE FROM "public"."directus_fields" WHERE "id" = 1517;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3038, 'mediaitems', 'contributions', 'o2m', 'list-o2m', '{"template":"{{type}}{{person_id}}","layout":"table","fields":["person_id.name","type"],"tableSpacing":"compact","enableSelect":false}', NULL, NULL, false, false, 16, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3033, 'contributions', 'timedmetadata_id', 'm2o', 'select-dropdown-m2o', '{}', NULL, NULL, false, true, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3035, 'timedmetadata', 'contributions', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 13, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3032, 'contributions', 'mediaitem_id', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 3023;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1511;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'timedmetadata_contributions';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'mediaitems_contributions';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 467;

DELETE FROM "public"."directus_relations" WHERE "id" = 468;

DELETE FROM "public"."directus_relations" WHERE "id" = 469;

DELETE FROM "public"."directus_relations" WHERE "id" = 470;


INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (476, 'contributions', 'timedmetadata_id', 'timedmetadata', 'contributions', NULL, NULL, 'contributions_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (475, 'contributions', 'mediaitem_id', 'mediaitems', 'contributions', NULL, NULL, NULL, NULL, 'nullify');


--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---


--- BEGIN ALTER TABLE "public"."contributions" ---

ALTER TABLE IF EXISTS "public"."contributions" ADD COLUMN IF NOT EXISTS "mediaitem_id" uuid NULL  ;

COMMENT ON COLUMN "public"."contributions"."mediaitem_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."contributions" ADD COLUMN IF NOT EXISTS "timedmetadata_id" uuid NULL  ;

COMMENT ON COLUMN "public"."contributions"."timedmetadata_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."contributions" ADD CONSTRAINT "contributions_timedmetadata_id_foreign" FOREIGN KEY (timedmetadata_id) REFERENCES timedmetadata(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "contributions_timedmetadata_id_foreign" ON "public"."contributions" IS NULL;

ALTER TABLE IF EXISTS "public"."contributions" ADD CONSTRAINT "contributions_mediaitem_id_foreign" FOREIGN KEY (mediaitem_id) REFERENCES mediaitems(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "contributions_mediaitem_id_foreign" ON "public"."contributions" IS NULL;

--- END ALTER TABLE "public"."contributions" ---

-- +goose Down
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-05-07T19:46:32.748Z                 ***/
/***************************************************************/


--- BEGIN ALTER TABLE "public"."contributions" ---

ALTER TABLE IF EXISTS "public"."contributions" DROP COLUMN IF EXISTS "mediaitem_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."contributions" DROP COLUMN IF EXISTS "timedmetadata_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."contributions" DROP CONSTRAINT IF EXISTS "contributions_timedmetadata_id_foreign";

ALTER TABLE IF EXISTS "public"."contributions" DROP CONSTRAINT IF EXISTS "contributions_mediaitem_id_foreign";

--- END ALTER TABLE "public"."contributions" ---

--- BEGIN CREATE TABLE "public"."timedmetadata_contributions" ---

CREATE TABLE IF NOT EXISTS "public"."timedmetadata_contributions" (
	"id" int4 NOT NULL DEFAULT nextval('timedmetadata_contributions_id_seq'::regclass) ,
	"timedmetadata_id" uuid NULL  ,
	"contributions_id" int4 NULL  ,
	CONSTRAINT "timedmetadata_contributions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "timedmetadata_contributions_contributions_id_foreign" FOREIGN KEY (contributions_id) REFERENCES contributions(id) ON DELETE CASCADE ,
	CONSTRAINT "timedmetadata_contributions_timedmetadata_id_foreign" FOREIGN KEY (timedmetadata_id) REFERENCES timedmetadata(id) ON DELETE CASCADE 
);

GRANT SELECT ON TABLE "public"."timedmetadata_contributions" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."timedmetadata_contributions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."timedmetadata_contributions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."timedmetadata_contributions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."timedmetadata_contributions"."id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_contributions"."timedmetadata_id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_contributions"."contributions_id"  IS NULL;

COMMENT ON CONSTRAINT "timedmetadata_contributions_contributions_id_foreign" ON "public"."timedmetadata_contributions" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_contributions_pkey" ON "public"."timedmetadata_contributions" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_contributions_timedmetadata_id_foreign" ON "public"."timedmetadata_contributions" IS NULL;

COMMENT ON TABLE "public"."timedmetadata_contributions"  IS NULL;

--- END CREATE TABLE "public"."timedmetadata_contributions" ---

--- BEGIN CREATE TABLE "public"."mediaitems_contributions" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_contributions" (
	"id" int4 NOT NULL DEFAULT nextval('mediaitems_contributions_id_seq'::regclass) ,
	"mediaitems_id" uuid NULL  ,
	"contributions_id" int4 NULL  ,
	CONSTRAINT "mediaitems_contributions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "mediaitems_contributions_contributions_id_foreign" FOREIGN KEY (contributions_id) REFERENCES contributions(id) ON DELETE SET NULL ,
	CONSTRAINT "mediaitems_contributions_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems(id) ON DELETE SET NULL 
);

GRANT SELECT ON TABLE "public"."mediaitems_contributions" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_contributions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_contributions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_contributions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_contributions"."id"  IS NULL;


COMMENT ON COLUMN "public"."mediaitems_contributions"."mediaitems_id"  IS NULL;


COMMENT ON COLUMN "public"."mediaitems_contributions"."contributions_id"  IS NULL;

COMMENT ON CONSTRAINT "mediaitems_contributions_contributions_id_foreign" ON "public"."mediaitems_contributions" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_contributions_mediaitems_id_foreign" ON "public"."mediaitems_contributions" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_contributions_pkey" ON "public"."mediaitems_contributions" IS NULL;

COMMENT ON TABLE "public"."mediaitems_contributions"  IS NULL;

--- END CREATE TABLE "public"."mediaitems_contributions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('timedmetadata_contributions', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('mediaitems_contributions', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 3023;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1516, 'timedmetadata_contributions', 'contributions_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1513, 'timedmetadata', 'contributions', 'm2m', 'list-m2m', '{"tableSpacing":"compact","layout":"table","fields":["contributions_id.person.name","contributions_id.speech"]}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1514, 'timedmetadata_contributions', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1515, 'timedmetadata_contributions', 'timedmetadata_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1518, 'mediaitems_contributions', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1519, 'mediaitems_contributions', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1520, 'mediaitems_contributions', 'contributions_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1511;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1517, 'mediaitems', 'contributions', 'm2m', 'list-m2m', '{"layout":"table","tableSpacing":"compact"}', NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 3038;

DELETE FROM "public"."directus_fields" WHERE "id" = 3033;

DELETE FROM "public"."directus_fields" WHERE "id" = 3035;

DELETE FROM "public"."directus_fields" WHERE "id" = 3032;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (467, 'timedmetadata_contributions', 'contributions_id', 'contributions', NULL, NULL, NULL, 'timedmetadata_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (468, 'timedmetadata_contributions', 'timedmetadata_id', 'timedmetadata', 'contributions', NULL, NULL, 'contributions_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (469, 'mediaitems_contributions', 'contributions_id', 'contributions', NULL, NULL, NULL, 'mediaitems_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (470, 'mediaitems_contributions', 'mediaitems_id', 'mediaitems', 'contributions', NULL, NULL, 'contributions_id', NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 476;

DELETE FROM "public"."directus_relations" WHERE "id" = 475;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
