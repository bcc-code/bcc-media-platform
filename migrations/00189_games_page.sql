-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-05T07:38:35.615Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications" ADD COLUMN IF NOT EXISTS "games_page_id" int4 NULL  ;

COMMENT ON COLUMN "public"."applications"."games_page_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."applications" ADD CONSTRAINT "applications_games_page_id_foreign" FOREIGN KEY (games_page_id) REFERENCES pages(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "applications_games_page_id_foreign" ON "public"."applications" IS NULL;

--- END ALTER TABLE "public"."applications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 692;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1223, 'applications', 'games_page_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'half', NULL, NULL, NULL, false, 'content', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (376, 'applications', 'games_page_id', 'pages', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-05T07:38:37.520Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications" DROP COLUMN IF EXISTS "games_page_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."applications" DROP CONSTRAINT IF EXISTS "applications_games_page_id_foreign";

--- END ALTER TABLE "public"."applications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 692;

DELETE FROM "public"."directus_fields" WHERE "id" = 1223;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 376;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
