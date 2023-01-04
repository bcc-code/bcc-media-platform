-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-03T12:29:05.283Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (863, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (864, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (865, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (866, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (867, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (868, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets_usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (869, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets_usergroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (870, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets_usergroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (871, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets_usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (872, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'targets_usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (874, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_targets', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (875, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_targets', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (873, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_targets', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (876, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_targets', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (877, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_targets', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-03T12:29:06.746Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 863;

DELETE FROM "public"."directus_permissions" WHERE "id" = 864;

DELETE FROM "public"."directus_permissions" WHERE "id" = 865;

DELETE FROM "public"."directus_permissions" WHERE "id" = 866;

DELETE FROM "public"."directus_permissions" WHERE "id" = 867;

DELETE FROM "public"."directus_permissions" WHERE "id" = 868;

DELETE FROM "public"."directus_permissions" WHERE "id" = 869;

DELETE FROM "public"."directus_permissions" WHERE "id" = 870;

DELETE FROM "public"."directus_permissions" WHERE "id" = 871;

DELETE FROM "public"."directus_permissions" WHERE "id" = 872;

DELETE FROM "public"."directus_permissions" WHERE "id" = 874;

DELETE FROM "public"."directus_permissions" WHERE "id" = 875;

DELETE FROM "public"."directus_permissions" WHERE "id" = 873;

DELETE FROM "public"."directus_permissions" WHERE "id" = 876;

DELETE FROM "public"."directus_permissions" WHERE "id" = 877;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
