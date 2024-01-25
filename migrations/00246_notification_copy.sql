-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-25T08:24:37.996Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "item_duplication_fields" = '["template_id","schedule_at","action","deep_link","targets.targets_id","applicationgroup_id"]' WHERE "collection" = 'notifications';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-01-25T08:24:39.655Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "item_duplication_fields" = '["template_id","schedule_at","action","deep_link","targets.targets_id"]' WHERE "collection" = 'notifications';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
