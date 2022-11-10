-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-10T12:12:30.974Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications" ADD COLUMN IF NOT EXISTS "standalone_related_collection_id" int4 NULL  ;

COMMENT ON COLUMN "public"."applications"."standalone_related_collection_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."applications" ADD CONSTRAINT "applications_standalone_related_collection_id_foreign" FOREIGN KEY (standalone_related_collection_id) REFERENCES collections(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "applications_standalone_related_collection_id_foreign" ON "public"."applications" IS NULL;

--- END ALTER TABLE "public"."applications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (692, 'applications', 'standalone_related_collection_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 13, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 510;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (213, 'applications', 'standalone_related_collection_id', 'collections', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-10T12:12:32.168Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications" DROP COLUMN IF EXISTS "standalone_related_collection_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."applications" DROP CONSTRAINT IF EXISTS "applications_standalone_related_collection_id_foreign";

--- END ALTER TABLE "public"."applications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 510;

DELETE FROM "public"."directus_fields" WHERE "id" = 692;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 213;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
