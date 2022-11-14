-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-14T13:28:06.112Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}}' WHERE "collection" = 'shows';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}}' WHERE "collection" = 'episodes';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}}' WHERE "collection" = 'seasons';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (744, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (749, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (754, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (759, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (738, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_entries', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (740, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_entries', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (739, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_entries', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (741, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_entries', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (742, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'collections_entries', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (743, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (745, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (746, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (747, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (748, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (750, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (751, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (752, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'events_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (753, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (755, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (756, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (757, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (758, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (760, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (761, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (762, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'calendarentries_translations', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-14T13:28:07.466Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}} | {{translations}}' WHERE "collection" = 'episodes';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}} | {{translations}}' WHERE "collection" = 'seasons';

UPDATE "public"."directus_collections" SET "display_template" = '{{id}} - {{label}} | {{translations}}' WHERE "collection" = 'shows';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 744;

DELETE FROM "public"."directus_permissions" WHERE "id" = 749;

DELETE FROM "public"."directus_permissions" WHERE "id" = 754;

DELETE FROM "public"."directus_permissions" WHERE "id" = 759;

DELETE FROM "public"."directus_permissions" WHERE "id" = 738;

DELETE FROM "public"."directus_permissions" WHERE "id" = 740;

DELETE FROM "public"."directus_permissions" WHERE "id" = 739;

DELETE FROM "public"."directus_permissions" WHERE "id" = 741;

DELETE FROM "public"."directus_permissions" WHERE "id" = 742;

DELETE FROM "public"."directus_permissions" WHERE "id" = 743;

DELETE FROM "public"."directus_permissions" WHERE "id" = 745;

DELETE FROM "public"."directus_permissions" WHERE "id" = 746;

DELETE FROM "public"."directus_permissions" WHERE "id" = 747;

DELETE FROM "public"."directus_permissions" WHERE "id" = 748;

DELETE FROM "public"."directus_permissions" WHERE "id" = 750;

DELETE FROM "public"."directus_permissions" WHERE "id" = 751;

DELETE FROM "public"."directus_permissions" WHERE "id" = 752;

DELETE FROM "public"."directus_permissions" WHERE "id" = 753;

DELETE FROM "public"."directus_permissions" WHERE "id" = 755;

DELETE FROM "public"."directus_permissions" WHERE "id" = 756;

DELETE FROM "public"."directus_permissions" WHERE "id" = 757;

DELETE FROM "public"."directus_permissions" WHERE "id" = 758;

DELETE FROM "public"."directus_permissions" WHERE "id" = 760;

DELETE FROM "public"."directus_permissions" WHERE "id" = 761;

DELETE FROM "public"."directus_permissions" WHERE "id" = 762;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
