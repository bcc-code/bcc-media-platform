-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-08T08:42:48.656Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 841;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 794;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 822;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 810;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (803, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (804, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (805, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (806, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (807, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (808, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_relations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (809, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_relations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (810, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_relations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (811, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_relations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (812, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_relations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (813, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'questionalternatives', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (814, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'questionalternatives', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (815, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'questionalternatives', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (816, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'questionalternatives', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (817, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'questionalternatives', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (818, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (819, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (820, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (821, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (822, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (823, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (824, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (825, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (826, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (827, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks', 'read', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-08T08:42:50.217Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 822;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 841;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 810;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 794;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 803;

DELETE FROM "public"."directus_permissions" WHERE "id" = 804;

DELETE FROM "public"."directus_permissions" WHERE "id" = 805;

DELETE FROM "public"."directus_permissions" WHERE "id" = 806;

DELETE FROM "public"."directus_permissions" WHERE "id" = 807;

DELETE FROM "public"."directus_permissions" WHERE "id" = 808;

DELETE FROM "public"."directus_permissions" WHERE "id" = 809;

DELETE FROM "public"."directus_permissions" WHERE "id" = 810;

DELETE FROM "public"."directus_permissions" WHERE "id" = 811;

DELETE FROM "public"."directus_permissions" WHERE "id" = 812;

DELETE FROM "public"."directus_permissions" WHERE "id" = 813;

DELETE FROM "public"."directus_permissions" WHERE "id" = 814;

DELETE FROM "public"."directus_permissions" WHERE "id" = 815;

DELETE FROM "public"."directus_permissions" WHERE "id" = 816;

DELETE FROM "public"."directus_permissions" WHERE "id" = 817;

DELETE FROM "public"."directus_permissions" WHERE "id" = 818;

DELETE FROM "public"."directus_permissions" WHERE "id" = 819;

DELETE FROM "public"."directus_permissions" WHERE "id" = 820;

DELETE FROM "public"."directus_permissions" WHERE "id" = 821;

DELETE FROM "public"."directus_permissions" WHERE "id" = 822;

DELETE FROM "public"."directus_permissions" WHERE "id" = 823;

DELETE FROM "public"."directus_permissions" WHERE "id" = 824;

DELETE FROM "public"."directus_permissions" WHERE "id" = 825;

DELETE FROM "public"."directus_permissions" WHERE "id" = 826;

DELETE FROM "public"."directus_permissions" WHERE "id" = 827;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
