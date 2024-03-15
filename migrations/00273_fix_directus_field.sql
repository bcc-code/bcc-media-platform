-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-15T12:23:14.547Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 443;

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true) FROM "public"."directus_relations";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-15T12:23:16.239Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 443;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
