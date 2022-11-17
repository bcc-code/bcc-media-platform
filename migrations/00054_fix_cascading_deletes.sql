-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-11T11:58:53.444Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections_entries" ---

ALTER TABLE IF EXISTS "public"."collections_entries" DROP CONSTRAINT IF EXISTS "collections_entries_collections_id_foreign";

ALTER TABLE IF EXISTS "public"."collections_entries"
	ALTER COLUMN "collections_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."collections_entries" ADD CONSTRAINT "collections_entries_collections_id_foreign" FOREIGN KEY (collections_id) REFERENCES collections(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "collections_entries_collections_id_foreign" ON "public"."collections_entries" IS NULL;
--- END ALTER TABLE "public"."collections_entries" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 215;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-11T11:58:54.755Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections_entries" ---

ALTER TABLE IF EXISTS "public"."collections_entries" DROP CONSTRAINT IF EXISTS "collections_entries_collections_id_foreign";

ALTER TABLE IF EXISTS "public"."collections_entries"
	ALTER COLUMN "collections_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."collections_entries" ADD CONSTRAINT "collections_entries_collections_id_foreign" FOREIGN KEY (collections_id) REFERENCES collections(id) ON DELETE SET NULL;

--- END ALTER TABLE "public"."collections_entries" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 215;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
