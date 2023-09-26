-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-26T08:40:56.854Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (920, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (921, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (922, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (923, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (924, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (925, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_persons', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (926, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_persons', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (927, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_persons', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (928, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_persons', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (929, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_persons', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (930, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (931, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (932, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (933, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (934, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'timedmetadata_translations', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-26T08:40:58.661Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 920;

DELETE FROM "public"."directus_permissions" WHERE "id" = 921;

DELETE FROM "public"."directus_permissions" WHERE "id" = 922;

DELETE FROM "public"."directus_permissions" WHERE "id" = 923;

DELETE FROM "public"."directus_permissions" WHERE "id" = 924;

DELETE FROM "public"."directus_permissions" WHERE "id" = 925;

DELETE FROM "public"."directus_permissions" WHERE "id" = 926;

DELETE FROM "public"."directus_permissions" WHERE "id" = 927;

DELETE FROM "public"."directus_permissions" WHERE "id" = 928;

DELETE FROM "public"."directus_permissions" WHERE "id" = 929;

DELETE FROM "public"."directus_permissions" WHERE "id" = 930;

DELETE FROM "public"."directus_permissions" WHERE "id" = 931;

DELETE FROM "public"."directus_permissions" WHERE "id" = 932;

DELETE FROM "public"."directus_permissions" WHERE "id" = 933;

DELETE FROM "public"."directus_permissions" WHERE "id" = 934;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
