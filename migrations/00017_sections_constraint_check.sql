-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-03T12:02:55.744Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "one_item" CHECK ((((show_id IS NOT NULL) AND (season_id IS NULL) AND (episode_id IS NULL)) OR ((season_id IS NOT NULL) AND (show_id IS NULL) AND (episode_id IS NULL)) OR ((episode_id IS NOT NULL) AND (show_id IS NULL) AND (season_id IS NULL))));

COMMENT ON CONSTRAINT "one_item" ON "public"."images" IS NULL;

--- END ALTER TABLE "public"."images" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-03T12:02:56.929Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "one_item";

--- END ALTER TABLE "public"."images" ---
