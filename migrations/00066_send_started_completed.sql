-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-18T07:07:17.452Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" ADD COLUMN IF NOT EXISTS "send_started" timestamp NULL  ;

COMMENT ON COLUMN "public"."notifications"."send_started"  IS NULL;

ALTER TABLE IF EXISTS "public"."notifications" ADD COLUMN IF NOT EXISTS "send_completed" timestamp NULL  ;

COMMENT ON COLUMN "public"."notifications"."send_completed"  IS NULL;

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (735, 'notifications', 'send_started', NULL, 'datetime', NULL, 'datetime', NULL, true, false, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (736, 'notifications', 'send_completed', NULL, NULL, NULL, NULL, NULL, true, false, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-18T07:07:18.804Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "send_started" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."notifications" DROP COLUMN IF EXISTS "send_completed" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 735;

DELETE FROM "public"."directus_fields" WHERE "id" = 736;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
