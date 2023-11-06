-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-06T13:16:51.198Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons"
	ALTER COLUMN "translations_required" SET NOT NULL;

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows"
	ALTER COLUMN "translations_required" SET NOT NULL;

--- END ALTER TABLE "public"."shows" ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-06T13:16:53.327Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons"
	ALTER COLUMN "translations_required" DROP NOT NULL;

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows"
	ALTER COLUMN "translations_required" DROP NOT NULL;

--- END ALTER TABLE "public"."shows" ---

