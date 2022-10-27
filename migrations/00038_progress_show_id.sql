-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-26T11:02:50.526Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."progress" ---

ALTER TABLE IF EXISTS "users"."progress" ADD COLUMN IF NOT EXISTS "show_id" int4 NULL  ;

COMMENT ON COLUMN "users"."progress"."show_id"  IS NULL;

ALTER TABLE IF EXISTS "users"."progress" ADD CONSTRAINT "progress_episode_id_fk" FOREIGN KEY (episode_id) REFERENCES episodes(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "progress_episode_id_fk" ON "users"."progress" IS NULL;

ALTER TABLE IF EXISTS "users"."progress" ADD CONSTRAINT "progress_show_id_fk" FOREIGN KEY (show_id) REFERENCES shows(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "progress_show_id_fk" ON "users"."progress" IS NULL;

--- END ALTER TABLE "users"."progress" ---
-- +goose Down
