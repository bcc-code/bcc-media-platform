-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-30T10:17:19.498Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

UPDATE "public"."episodes" e SET production_date = e.publish_date;

ALTER TABLE IF EXISTS "public"."episodes"
	ALTER COLUMN "production_date" SET NOT NULL;

--- END ALTER TABLE "public"."episodes" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-30T10:17:20.812Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes" ---

ALTER TABLE IF EXISTS "public"."episodes"
	ALTER COLUMN "production_date" DROP NOT NULL;

--- END ALTER TABLE "public"."episodes" ---
