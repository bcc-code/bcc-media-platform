-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-20T10:02:22.503Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."timedmetadata_persons_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."timedmetadata_persons_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."timedmetadata_persons_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."timedmetadata_persons_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."timedmetadata_persons_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."timedmetadata_persons_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."timedmetadata_persons_id_seq" ---

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata" DROP COLUMN IF EXISTS "person_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."timedmetadata" DROP CONSTRAINT IF EXISTS "timedmetadata_person_id_foreign";

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN CREATE TABLE "public"."timedmetadata_persons" ---

CREATE TABLE IF NOT EXISTS "public"."timedmetadata_persons" (
	"id" int4 NOT NULL DEFAULT nextval('timedmetadata_persons_id_seq'::regclass) ,
	"timedmetadata_id" uuid NOT NULL  ,
	"persons_id" uuid NOT NULL  ,
	CONSTRAINT "timedmetadata_persons_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "timedmetadata_persons_persons_id_foreign" FOREIGN KEY (persons_id) REFERENCES persons(id) ON DELETE CASCADE ,
	CONSTRAINT "timedmetadata_persons_timedmetadata_id_foreign" FOREIGN KEY (timedmetadata_id) REFERENCES timedmetadata(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."timedmetadata_persons" TO directus, background_worker, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."timedmetadata_persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."timedmetadata_persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."timedmetadata_persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."timedmetadata_persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."timedmetadata_persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."timedmetadata_persons" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."timedmetadata_persons"."id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_persons"."timedmetadata_id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_persons"."persons_id"  IS NULL;

COMMENT ON CONSTRAINT "timedmetadata_persons_pkey" ON "public"."timedmetadata_persons" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_persons_persons_id_foreign" ON "public"."timedmetadata_persons" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_persons_timedmetadata_id_foreign" ON "public"."timedmetadata_persons" IS NULL;

COMMENT ON TABLE "public"."timedmetadata_persons"  IS NULL;

--- END CREATE TABLE "public"."timedmetadata_persons" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1343, 'timedmetadata_persons', 'persons_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1340, 'timedmetadata', 'persons', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 6, 'half', NULL, NULL, '[{"name":"hide if not person","rule":{"_and":[{"chapter_type":{"_nin":["testimony","appeal","speech"]}}]},"hidden":true,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"junctionFieldLocation":"bottom","allowDuplicates":false,"enableSearchFilter":false,"enableLink":false}}]', false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1341, 'timedmetadata_persons', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1342, 'timedmetadata_persons', 'timedmetadata_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1233;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1296;

DELETE FROM "public"."directus_fields" WHERE "id" = 1312;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url")  VALUES ('timedmetadata_persons', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (407, 'timedmetadata_persons', 'persons_id', 'persons', NULL, NULL, NULL, 'timedmetadata_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (408, 'timedmetadata_persons', 'timedmetadata_id', 'timedmetadata', 'persons', NULL, NULL, 'persons_id', NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 400;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-20T10:02:24.410Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

ALTER TABLE IF EXISTS "public"."timedmetadata" ADD COLUMN IF NOT EXISTS "person_id" uuid NULL  ;

COMMENT ON COLUMN "public"."timedmetadata"."person_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata" ADD CONSTRAINT "timedmetadata_person_id_foreign" FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "timedmetadata_person_id_foreign" ON "public"."timedmetadata" IS NULL;

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN DROP TABLE "public"."timedmetadata_persons" ---

DROP TABLE IF EXISTS "public"."timedmetadata_persons";

--- END DROP TABLE "public"."timedmetadata_persons" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'timedmetadata_persons';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1233;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1296;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1312, 'timedmetadata', 'person_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 5, 'half', NULL, 'Can be used in "title" with for example: {{person.name}}', '[{"name":"hide if not person","rule":{"_and":[{"chapter_type":{"_nin":["speech","testimony"]}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'details', NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 1343;

DELETE FROM "public"."directus_fields" WHERE "id" = 1340;

DELETE FROM "public"."directus_fields" WHERE "id" = 1341;

DELETE FROM "public"."directus_fields" WHERE "id" = 1342;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (400, 'timedmetadata', 'person_id', 'persons', NULL, NULL, NULL, NULL, NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 407;

DELETE FROM "public"."directus_relations" WHERE "id" = 408;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
