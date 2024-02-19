-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-19T09:08:56.679Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (936, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_assets', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (937, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_assets', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (938, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_assets', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (939, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_assets', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (940, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'episodes_assets', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-19T09:08:58.340Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 936;

DELETE FROM "public"."directus_permissions" WHERE "id" = 937;

DELETE FROM "public"."directus_permissions" WHERE "id" = 938;

DELETE FROM "public"."directus_permissions" WHERE "id" = 939;

DELETE FROM "public"."directus_permissions" WHERE "id" = 940;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
