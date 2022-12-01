-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-01T08:30:03.744Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"limit":100,"filter":{"_and":[{"_and":[{"page_id":{"_null":true}}]}]}}' WHERE "id" = 409;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (773, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (774, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (775, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (776, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (777, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (778, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (779, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (780, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (781, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (782, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (783, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (784, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (785, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (786, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (787, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notificationtemplates_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (788, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'redirects', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (789, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'redirects', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (790, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'redirects', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (791, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'redirects', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (792, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'redirects', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (793, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (794, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (795, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (796, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (797, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_translations', 'read', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-01T08:30:05.148Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"limit":100}' WHERE "id" = 409;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 773;

DELETE FROM "public"."directus_permissions" WHERE "id" = 774;

DELETE FROM "public"."directus_permissions" WHERE "id" = 775;

DELETE FROM "public"."directus_permissions" WHERE "id" = 776;

DELETE FROM "public"."directus_permissions" WHERE "id" = 777;

DELETE FROM "public"."directus_permissions" WHERE "id" = 778;

DELETE FROM "public"."directus_permissions" WHERE "id" = 779;

DELETE FROM "public"."directus_permissions" WHERE "id" = 780;

DELETE FROM "public"."directus_permissions" WHERE "id" = 781;

DELETE FROM "public"."directus_permissions" WHERE "id" = 782;

DELETE FROM "public"."directus_permissions" WHERE "id" = 783;

DELETE FROM "public"."directus_permissions" WHERE "id" = 784;

DELETE FROM "public"."directus_permissions" WHERE "id" = 785;

DELETE FROM "public"."directus_permissions" WHERE "id" = 786;

DELETE FROM "public"."directus_permissions" WHERE "id" = 787;

DELETE FROM "public"."directus_permissions" WHERE "id" = 788;

DELETE FROM "public"."directus_permissions" WHERE "id" = 789;

DELETE FROM "public"."directus_permissions" WHERE "id" = 790;

DELETE FROM "public"."directus_permissions" WHERE "id" = 791;

DELETE FROM "public"."directus_permissions" WHERE "id" = 792;

DELETE FROM "public"."directus_permissions" WHERE "id" = 793;

DELETE FROM "public"."directus_permissions" WHERE "id" = 794;

DELETE FROM "public"."directus_permissions" WHERE "id" = 795;

DELETE FROM "public"."directus_permissions" WHERE "id" = 796;

DELETE FROM "public"."directus_permissions" WHERE "id" = 797;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
