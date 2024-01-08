-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-08T12:37:41.272Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" ADD COLUMN IF NOT EXISTS "applicationgroup_id" uuid NULL  ;

COMMENT ON COLUMN "public"."notifications"."applicationgroup_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD CONSTRAINT "notifications_applicationgroup_id_foreign" FOREIGN KEY (applicationgroup_id) REFERENCES applicationgroups(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "notifications_applicationgroup_id_foreign" ON "public"."notifications" IS NULL;

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1444, 'notifications', 'applicationgroup_id', 'm2o', NULL, NULL, 'related-values', '{"template":"{{label}}"}', false, false, 11, 'full', NULL, 'Defaults to the default application', NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (435, 'notifications', 'applicationgroup_id', 'applicationgroups', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-08T12:37:42.913Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "applicationgroup_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."notifications" DROP CONSTRAINT IF EXISTS "notifications_applicationgroup_id_foreign";

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 1444;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 435;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
