-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-08T12:13:13.935Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."targets" ---

ALTER TABLE IF EXISTS "public"."targets" ADD COLUMN IF NOT EXISTS "applicationgroup_id" uuid NULL  ;

COMMENT ON COLUMN "public"."targets"."applicationgroup_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."targets" ADD CONSTRAINT "targets_applicationgroup_id_foreign" FOREIGN KEY (applicationgroup_id) REFERENCES applicationgroups(id);

COMMENT ON CONSTRAINT "targets_applicationgroup_id_foreign" ON "public"."targets" IS NULL;

--- END ALTER TABLE "public"."targets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1443, 'targets', 'applicationgroup_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{label}}","enableCreate":false}', 'related-values', NULL, false, false, 5, 'full', NULL, 'Defaults to the default application', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 974;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 975;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 976;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 977;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (434, 'targets', 'applicationgroup_id', 'applicationgroups', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-08T12:13:15.650Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."targets" ---

ALTER TABLE IF EXISTS "public"."targets" DROP COLUMN IF EXISTS "applicationgroup_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."targets" DROP CONSTRAINT IF EXISTS "targets_applicationgroup_id_foreign";

--- END ALTER TABLE "public"."targets" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 974;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 975;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 976;

UPDATE "public"."directus_fields" SET "sort" = NULL WHERE "id" = 977;

DELETE FROM "public"."directus_fields" WHERE "id" = 1443;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 434;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
