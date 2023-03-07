-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-03T07:43:25.077Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."progress" ---

CREATE INDEX progress_profile_id_show_id_index ON users.progress USING btree (profile_id, show_id);

COMMENT ON INDEX "users"."progress_profile_id_show_id_index"  IS NULL;

--- END ALTER TABLE "users"."progress" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-03T07:43:26.674Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."progress" ---

DROP INDEX IF EXISTS progress_profile_id_show_id_index;

--- END ALTER TABLE "users"."progress" ---
