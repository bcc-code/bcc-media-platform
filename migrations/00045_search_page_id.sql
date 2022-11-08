-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-08T08:13:29.245Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications" ADD COLUMN IF NOT EXISTS "search_page_id" int4 NULL  ;

COMMENT ON COLUMN "public"."applications"."search_page_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."applications" ADD CONSTRAINT "applications_search_page_id_foreign" FOREIGN KEY (search_page_id) REFERENCES pages(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "applications_search_page_id_foreign" ON "public"."applications" IS NULL;

--- END ALTER TABLE "public"."applications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (690, 'applications', 'search_page_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 510;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (212, 'applications', 'search_page_id', 'pages', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-08T08:13:30.467Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications" DROP COLUMN IF EXISTS "search_page_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."applications" DROP CONSTRAINT IF EXISTS "applications_search_page_id_foreign";

--- END ALTER TABLE "public"."applications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 510;

DELETE FROM "public"."directus_fields" WHERE "id" = 690;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 212;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
