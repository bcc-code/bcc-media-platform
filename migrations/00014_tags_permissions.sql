-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-04T08:34:21.852Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (1, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (2, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (3, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (4, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (5, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'pages_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (6, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_tags', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (7, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_tags', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (8, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_tags', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (9, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_tags', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (10, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'shows_tags', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (11, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (12, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (13, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (14, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (15, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tags_translations', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-04T08:34:23.028Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 1;

DELETE FROM "public"."directus_permissions" WHERE "id" = 2;

DELETE FROM "public"."directus_permissions" WHERE "id" = 3;

DELETE FROM "public"."directus_permissions" WHERE "id" = 4;

DELETE FROM "public"."directus_permissions" WHERE "id" = 5;

DELETE FROM "public"."directus_permissions" WHERE "id" = 6;

DELETE FROM "public"."directus_permissions" WHERE "id" = 7;

DELETE FROM "public"."directus_permissions" WHERE "id" = 8;

DELETE FROM "public"."directus_permissions" WHERE "id" = 9;

DELETE FROM "public"."directus_permissions" WHERE "id" = 10;

DELETE FROM "public"."directus_permissions" WHERE "id" = 11;

DELETE FROM "public"."directus_permissions" WHERE "id" = 12;

DELETE FROM "public"."directus_permissions" WHERE "id" = 13;

DELETE FROM "public"."directus_permissions" WHERE "id" = 14;

DELETE FROM "public"."directus_permissions" WHERE "id" = 15;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
