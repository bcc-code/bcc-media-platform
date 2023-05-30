-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-26T07:18:08.944Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" ADD COLUMN IF NOT EXISTS "related_collection_id" int4 NULL  ;

COMMENT ON COLUMN "public"."shows"."related_collection_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."shows" ADD CONSTRAINT "shows_related_collection_id_foreign" FOREIGN KEY (related_collection_id) REFERENCES collections(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "shows_related_collection_id_foreign" ON "public"."shows" IS NULL;

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1189, 'shows', 'related_collection_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', 'related-values', NULL, false, false, 16, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "sort" = 19 WHERE "id" = 276;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (362, 'shows', 'related_collection_id', 'collections', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-26T07:18:10.737Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows" DROP COLUMN IF EXISTS "related_collection_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."shows" DROP CONSTRAINT IF EXISTS "shows_related_collection_id_foreign";

--- END ALTER TABLE "public"."shows" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 273;

UPDATE "public"."directus_fields" SET "sort" = 16 WHERE "id" = 566;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 276;

DELETE FROM "public"."directus_fields" WHERE "id" = 1189;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 362;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
