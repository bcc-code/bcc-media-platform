-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-08T09:38:04.550Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."events_translations" ---

CREATE UNIQUE INDEX events_translations_events_id_languages_code_uindex ON public.events_translations USING btree (events_id, languages_code);

COMMENT ON INDEX "public"."events_translations_events_id_languages_code_uindex"  IS NULL;

DROP INDEX IF EXISTS events_translations_events_id_languages_code_index;

--- END ALTER TABLE "public"."events_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-02-08T09:38:06.313Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."events_translations" ---

CREATE INDEX events_translations_events_id_languages_code_index ON public.events_translations USING btree (events_id, languages_code);

COMMENT ON INDEX "public"."events_translations_events_id_languages_code_index"  IS NULL;

DROP INDEX IF EXISTS events_translations_events_id_languages_code_uindex;

--- END ALTER TABLE "public"."events_translations" ---
