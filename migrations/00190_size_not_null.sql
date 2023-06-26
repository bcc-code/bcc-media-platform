-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-05T11:24:31.559Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."assetfiles" ---

ALTER TABLE IF EXISTS "public"."assetfiles"
    ALTER COLUMN "size" SET DEFAULT 0,
	ALTER COLUMN "size" SET NOT NULL;

--- END ALTER TABLE "public"."assetfiles" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-05T11:24:33.096Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."assetfiles" ---

ALTER TABLE IF EXISTS "public"."assetfiles"
	ALTER COLUMN "size" DROP NOT NULL,
	ALTER COLUMN "size" DROP DEFAULT ;

--- END ALTER TABLE "public"."assetfiles" ---
