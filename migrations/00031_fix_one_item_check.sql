-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-19T12:16:09.560Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "one_item";

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "one_item" CHECK ((((show_id IS NOT NULL) AND (season_id IS NULL) AND (episode_id IS NULL) AND (page_id IS NULL) AND (link_id IS NULL)) OR ((season_id IS NOT NULL) AND (show_id IS NULL) AND (episode_id IS NULL) AND (page_id IS NULL) AND (link_id IS NULL)) OR ((episode_id IS NOT NULL) AND (show_id IS NULL) AND (season_id IS NULL) AND (page_id IS NULL) AND (link_id IS NULL)) OR ((episode_id IS NULL) AND (show_id IS NULL) AND (season_id IS NULL) AND (page_id IS NOT NULL) AND (link_id IS NULL)) OR ((episode_id IS NULL) AND (show_id IS NULL) AND (season_id IS NULL) AND (page_id IS NULL) AND (link_id IS NOT NULL))));

COMMENT ON CONSTRAINT "one_item" ON "public"."images" IS NULL;

--- END ALTER TABLE "public"."images" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-19T12:16:10.887Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "one_item";

DELETE FROM "public"."images" WHERE page_id IS NULL OR link_id IS NULL;

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "one_item" CHECK ((((show_id IS NOT NULL) AND (season_id IS NULL) AND (episode_id IS NULL)) OR ((season_id IS NOT NULL) AND (show_id IS NULL) AND (episode_id IS NULL)) OR ((episode_id IS NOT NULL) AND (show_id IS NULL) AND (season_id IS NULL))));

COMMENT ON CONSTRAINT "one_item" ON "public"."images" IS NULL;

--- END ALTER TABLE "public"."images" ---
