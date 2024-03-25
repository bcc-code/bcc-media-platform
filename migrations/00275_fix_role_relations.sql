-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-25T10:29:45.152Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups_earlyaccess" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" DROP CONSTRAINT IF EXISTS "mediaitems_usergroups_earlyaccess_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" ADD CONSTRAINT "mediaitems_usergroups_earlyaccess_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "mediaitems_usergroups_earlyaccess_usergroups_code_foreign" ON "public"."mediaitems_usergroups_earlyaccess" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" DROP CONSTRAINT IF EXISTS "mediaitems_usergroups_earlyaccess_mediaitems_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" ADD CONSTRAINT "mediaitems_usergroups_earlyaccess_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "mediaitems_usergroups_earlyaccess_mediaitems_id_foreign" ON "public"."mediaitems_usergroups_earlyaccess" IS NULL;

--- END ALTER TABLE "public"."mediaitems_usergroups_earlyaccess" ---

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups_download" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" DROP CONSTRAINT IF EXISTS "mediaitems_usergroups_download_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" ADD CONSTRAINT "mediaitems_usergroups_download_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "mediaitems_usergroups_download_usergroups_code_foreign" ON "public"."mediaitems_usergroups_download" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" DROP CONSTRAINT IF EXISTS "mediaitems_usergroups_download_mediaitems_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" ADD CONSTRAINT "mediaitems_usergroups_download_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "mediaitems_usergroups_download_mediaitems_id_foreign" ON "public"."mediaitems_usergroups_download" IS NULL;

--- END ALTER TABLE "public"."mediaitems_usergroups_download" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 454;

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 452;

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 448;

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true) FROM "public"."directus_relations";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-25T10:29:46.670Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups_download" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" DROP CONSTRAINT IF EXISTS "mediaitems_usergroups_download_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" ADD CONSTRAINT "mediaitems_usergroups_download_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_usergroups_download_usergroups_code_foreign" ON "public"."mediaitems_usergroups_download" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" DROP CONSTRAINT IF EXISTS "mediaitems_usergroups_download_mediaitems_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" ADD CONSTRAINT "mediaitems_usergroups_download_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_usergroups_download_mediaitems_id_foreign" ON "public"."mediaitems_usergroups_download" IS NULL;

--- END ALTER TABLE "public"."mediaitems_usergroups_download" ---

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups_earlyaccess" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" DROP CONSTRAINT IF EXISTS "mediaitems_usergroups_earlyaccess_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" ADD CONSTRAINT "mediaitems_usergroups_earlyaccess_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_usergroups_earlyaccess_usergroups_code_foreign" ON "public"."mediaitems_usergroups_earlyaccess" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" DROP CONSTRAINT IF EXISTS "mediaitems_usergroups_earlyaccess_mediaitems_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" ADD CONSTRAINT "mediaitems_usergroups_earlyaccess_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_usergroups_earlyaccess_mediaitems_id_foreign" ON "public"."mediaitems_usergroups_earlyaccess" IS NULL;

--- END ALTER TABLE "public"."mediaitems_usergroups_earlyaccess" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 448;

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 454;

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 452;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
