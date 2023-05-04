-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-04T08:13:15.452Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (878, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (879, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (880, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (881, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (882, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (883, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (884, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs_usergroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (885, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs_usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (886, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs_usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (888, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs_usergroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (887, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqs_usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (889, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqcategories', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (890, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqcategories', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (891, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqcategories', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (892, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqcategories', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (893, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqcategories', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (894, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'faqcategories_translations', 'read', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-04T08:13:17.190Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 878;

DELETE FROM "public"."directus_permissions" WHERE "id" = 879;

DELETE FROM "public"."directus_permissions" WHERE "id" = 880;

DELETE FROM "public"."directus_permissions" WHERE "id" = 881;

DELETE FROM "public"."directus_permissions" WHERE "id" = 882;

DELETE FROM "public"."directus_permissions" WHERE "id" = 883;

DELETE FROM "public"."directus_permissions" WHERE "id" = 884;

DELETE FROM "public"."directus_permissions" WHERE "id" = 885;

DELETE FROM "public"."directus_permissions" WHERE "id" = 886;

DELETE FROM "public"."directus_permissions" WHERE "id" = 888;

DELETE FROM "public"."directus_permissions" WHERE "id" = 887;

DELETE FROM "public"."directus_permissions" WHERE "id" = 889;

DELETE FROM "public"."directus_permissions" WHERE "id" = 890;

DELETE FROM "public"."directus_permissions" WHERE "id" = 891;

DELETE FROM "public"."directus_permissions" WHERE "id" = 892;

DELETE FROM "public"."directus_permissions" WHERE "id" = 893;

DELETE FROM "public"."directus_permissions" WHERE "id" = 894;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
