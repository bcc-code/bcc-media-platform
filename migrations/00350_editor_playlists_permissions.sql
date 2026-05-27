-- +goose Up
--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "policy", "collection", "action", "permissions", "validation", "presets", "fields") VALUES (941, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'playlists', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "policy", "collection", "action", "permissions", "validation", "presets", "fields") VALUES (942, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'playlists', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "policy", "collection", "action", "permissions", "validation", "presets", "fields") VALUES (943, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'playlists', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "policy", "collection", "action", "permissions", "validation", "presets", "fields") VALUES (944, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'playlists', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "policy", "collection", "action", "permissions", "validation", "presets", "fields") VALUES (945, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'playlists', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

-- +goose Down
--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 941;

DELETE FROM "public"."directus_permissions" WHERE "id" = 942;

DELETE FROM "public"."directus_permissions" WHERE "id" = 943;

DELETE FROM "public"."directus_permissions" WHERE "id" = 944;

DELETE FROM "public"."directus_permissions" WHERE "id" = 945;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
