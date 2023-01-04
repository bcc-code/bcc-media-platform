-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-03T12:26:47.055Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (833, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (834, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (835, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (837, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (836, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (838, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements_images', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (839, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements_images', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (840, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements_images', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (841, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements_images', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (842, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievements_images', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (843, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementgroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (844, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementgroups', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (845, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementgroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (846, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementgroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (847, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementgroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (848, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementconditions', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (849, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementconditions', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (850, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementconditions', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (851, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementconditions', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (852, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'achievementconditions', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (853, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_images', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (854, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_images', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (855, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_images', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (856, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_images', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (857, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lessons_images', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (858, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics_images', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (859, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics_images', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (860, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics_images', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (861, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics_images', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (862, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'studytopics_images', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-03T12:26:48.460Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 833;

DELETE FROM "public"."directus_permissions" WHERE "id" = 834;

DELETE FROM "public"."directus_permissions" WHERE "id" = 835;

DELETE FROM "public"."directus_permissions" WHERE "id" = 837;

DELETE FROM "public"."directus_permissions" WHERE "id" = 836;

DELETE FROM "public"."directus_permissions" WHERE "id" = 838;

DELETE FROM "public"."directus_permissions" WHERE "id" = 839;

DELETE FROM "public"."directus_permissions" WHERE "id" = 840;

DELETE FROM "public"."directus_permissions" WHERE "id" = 841;

DELETE FROM "public"."directus_permissions" WHERE "id" = 842;

DELETE FROM "public"."directus_permissions" WHERE "id" = 843;

DELETE FROM "public"."directus_permissions" WHERE "id" = 844;

DELETE FROM "public"."directus_permissions" WHERE "id" = 845;

DELETE FROM "public"."directus_permissions" WHERE "id" = 846;

DELETE FROM "public"."directus_permissions" WHERE "id" = 847;

DELETE FROM "public"."directus_permissions" WHERE "id" = 848;

DELETE FROM "public"."directus_permissions" WHERE "id" = 849;

DELETE FROM "public"."directus_permissions" WHERE "id" = 850;

DELETE FROM "public"."directus_permissions" WHERE "id" = 851;

DELETE FROM "public"."directus_permissions" WHERE "id" = 852;

DELETE FROM "public"."directus_permissions" WHERE "id" = 853;

DELETE FROM "public"."directus_permissions" WHERE "id" = 854;

DELETE FROM "public"."directus_permissions" WHERE "id" = 855;

DELETE FROM "public"."directus_permissions" WHERE "id" = 856;

DELETE FROM "public"."directus_permissions" WHERE "id" = 857;

DELETE FROM "public"."directus_permissions" WHERE "id" = 858;

DELETE FROM "public"."directus_permissions" WHERE "id" = 859;

DELETE FROM "public"."directus_permissions" WHERE "id" = 860;

DELETE FROM "public"."directus_permissions" WHERE "id" = 861;

DELETE FROM "public"."directus_permissions" WHERE "id" = 862;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
