-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:01:24.824Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications"
    DROP CONSTRAINT IF EXISTS "applications_group_id_foreign";

ALTER TABLE IF EXISTS "public"."applications"
    ALTER COLUMN "group_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."applications"
    ADD CONSTRAINT "applications_group_id_foreign" FOREIGN KEY (group_id) REFERENCES applicationgroups (id);

COMMENT ON CONSTRAINT "applications_group_id_foreign" ON "public"."applications" IS NULL;

--- END ALTER TABLE "public"."applications" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:01:26.400Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."applications" ---

ALTER TABLE IF EXISTS "public"."applications"
    DROP CONSTRAINT IF EXISTS "applications_group_id_foreign";

ALTER TABLE IF EXISTS "public"."applications"
    ALTER COLUMN "group_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."applications"
    ADD CONSTRAINT "applications_group_id_foreign" FOREIGN KEY (group_id) REFERENCES applicationgroups (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "applications_group_id_foreign" ON "public"."applications" IS NULL;

--- END ALTER TABLE "public"."applications" ---
