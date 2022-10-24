-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-20T13:28:20.351Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (16, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'images', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (17, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'images', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (18, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'images', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (19, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'images', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (20, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'images', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (21, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (22, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (23, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (24, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (32, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (33, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (34, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (31, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (35, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (39, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (40, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (50, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'links_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (51, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (52, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (53, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (54, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages_messagetemplates', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (55, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages_messagetemplates', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (56, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages_messagetemplates', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (57, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages_messagetemplates', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (58, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messages_messagetemplates', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (728, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (59, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (704, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (705, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (706, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (707, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (708, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (709, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (710, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (711, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (712, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'messagetemplates_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (713, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (714, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (715, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (716, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (717, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (718, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (719, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (720, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (721, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (722, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'notifications_translations', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (723, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_tags', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (724, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_tags', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (725, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_tags', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (726, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_tags', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (727, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'seasons_tags', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (729, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (730, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (731, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (732, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (733, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications_usergroups', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (734, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications_usergroups', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (735, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications_usergroups', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (736, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications_usergroups', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (737, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'applications_usergroups', 'read', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-20T13:28:22.097Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 16;

DELETE FROM "public"."directus_permissions" WHERE "id" = 17;

DELETE FROM "public"."directus_permissions" WHERE "id" = 18;

DELETE FROM "public"."directus_permissions" WHERE "id" = 19;

DELETE FROM "public"."directus_permissions" WHERE "id" = 20;

DELETE FROM "public"."directus_permissions" WHERE "id" = 21;

DELETE FROM "public"."directus_permissions" WHERE "id" = 22;

DELETE FROM "public"."directus_permissions" WHERE "id" = 23;

DELETE FROM "public"."directus_permissions" WHERE "id" = 24;

DELETE FROM "public"."directus_permissions" WHERE "id" = 32;

DELETE FROM "public"."directus_permissions" WHERE "id" = 33;

DELETE FROM "public"."directus_permissions" WHERE "id" = 34;

DELETE FROM "public"."directus_permissions" WHERE "id" = 31;

DELETE FROM "public"."directus_permissions" WHERE "id" = 35;

DELETE FROM "public"."directus_permissions" WHERE "id" = 39;

DELETE FROM "public"."directus_permissions" WHERE "id" = 40;

DELETE FROM "public"."directus_permissions" WHERE "id" = 50;

DELETE FROM "public"."directus_permissions" WHERE "id" = 51;

DELETE FROM "public"."directus_permissions" WHERE "id" = 52;

DELETE FROM "public"."directus_permissions" WHERE "id" = 53;

DELETE FROM "public"."directus_permissions" WHERE "id" = 54;

DELETE FROM "public"."directus_permissions" WHERE "id" = 55;

DELETE FROM "public"."directus_permissions" WHERE "id" = 56;

DELETE FROM "public"."directus_permissions" WHERE "id" = 57;

DELETE FROM "public"."directus_permissions" WHERE "id" = 58;

DELETE FROM "public"."directus_permissions" WHERE "id" = 728;

DELETE FROM "public"."directus_permissions" WHERE "id" = 59;

DELETE FROM "public"."directus_permissions" WHERE "id" = 704;

DELETE FROM "public"."directus_permissions" WHERE "id" = 705;

DELETE FROM "public"."directus_permissions" WHERE "id" = 706;

DELETE FROM "public"."directus_permissions" WHERE "id" = 707;

DELETE FROM "public"."directus_permissions" WHERE "id" = 708;

DELETE FROM "public"."directus_permissions" WHERE "id" = 709;

DELETE FROM "public"."directus_permissions" WHERE "id" = 710;

DELETE FROM "public"."directus_permissions" WHERE "id" = 711;

DELETE FROM "public"."directus_permissions" WHERE "id" = 712;

DELETE FROM "public"."directus_permissions" WHERE "id" = 713;

DELETE FROM "public"."directus_permissions" WHERE "id" = 714;

DELETE FROM "public"."directus_permissions" WHERE "id" = 715;

DELETE FROM "public"."directus_permissions" WHERE "id" = 716;

DELETE FROM "public"."directus_permissions" WHERE "id" = 717;

DELETE FROM "public"."directus_permissions" WHERE "id" = 718;

DELETE FROM "public"."directus_permissions" WHERE "id" = 719;

DELETE FROM "public"."directus_permissions" WHERE "id" = 720;

DELETE FROM "public"."directus_permissions" WHERE "id" = 721;

DELETE FROM "public"."directus_permissions" WHERE "id" = 722;

DELETE FROM "public"."directus_permissions" WHERE "id" = 723;

DELETE FROM "public"."directus_permissions" WHERE "id" = 724;

DELETE FROM "public"."directus_permissions" WHERE "id" = 725;

DELETE FROM "public"."directus_permissions" WHERE "id" = 726;

DELETE FROM "public"."directus_permissions" WHERE "id" = 727;

DELETE FROM "public"."directus_permissions" WHERE "id" = 729;

DELETE FROM "public"."directus_permissions" WHERE "id" = 730;

DELETE FROM "public"."directus_permissions" WHERE "id" = 731;

DELETE FROM "public"."directus_permissions" WHERE "id" = 732;

DELETE FROM "public"."directus_permissions" WHERE "id" = 733;

DELETE FROM "public"."directus_permissions" WHERE "id" = 734;

DELETE FROM "public"."directus_permissions" WHERE "id" = 735;

DELETE FROM "public"."directus_permissions" WHERE "id" = 736;

DELETE FROM "public"."directus_permissions" WHERE "id" = 737;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---
