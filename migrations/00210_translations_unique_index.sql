-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T11:11:03.134Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."games_translations" ---

CREATE UNIQUE INDEX games_translations_games_id_languages_code_uindex ON public.games_translations USING btree (games_id, languages_code);

COMMENT ON INDEX "public"."games_translations_games_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."games_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

CREATE UNIQUE INDEX pages_translations_pages_id_languages_code_uindex ON public.pages_translations USING btree (pages_id, languages_code);

COMMENT ON INDEX "public"."pages_translations_pages_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN ALTER TABLE "public"."shows_translations" ---

CREATE UNIQUE INDEX shows_translations_languages_code_shows_id_uindex ON public.shows_translations USING btree (languages_code, shows_id);

COMMENT ON INDEX "public"."shows_translations_languages_code_shows_id_uindex"  IS NULL;

--- END ALTER TABLE "public"."shows_translations" ---

--- BEGIN ALTER TABLE "public"."events_translations" ---

CREATE INDEX events_translations_events_id_languages_code_index ON public.events_translations USING btree (events_id, languages_code);

COMMENT ON INDEX "public"."events_translations_events_id_languages_code_index"  IS NULL;

--- END ALTER TABLE "public"."events_translations" ---

--- BEGIN ALTER TABLE "public"."tags_translations" ---

CREATE UNIQUE INDEX tags_translations_languages_code_tags_id_uindex ON public.tags_translations USING btree (languages_code, tags_id);

COMMENT ON INDEX "public"."tags_translations_languages_code_tags_id_uindex"  IS NULL;

--- END ALTER TABLE "public"."tags_translations" ---

--- BEGIN ALTER TABLE "public"."faqcategories_translations" ---

CREATE UNIQUE INDEX faqcategories_translations_faqcategories_id_languages_code_uind ON public.faqcategories_translations USING btree (faqcategories_id, languages_code);

COMMENT ON INDEX "public"."faqcategories_translations_faqcategories_id_languages_code_uind"  IS NULL;

--- END ALTER TABLE "public"."faqcategories_translations" ---

--- BEGIN ALTER TABLE "public"."faqs_translations" ---

CREATE UNIQUE INDEX faqs_translations_faqs_id_languages_code_uindex ON public.faqs_translations USING btree (faqs_id, languages_code);

COMMENT ON INDEX "public"."faqs_translations_faqs_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."faqs_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T11:11:04.905Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."faqs_translations" ---

DROP INDEX IF EXISTS faqs_translations_faqs_id_languages_code_uindex;

--- END ALTER TABLE "public"."faqs_translations" ---

--- BEGIN ALTER TABLE "public"."faqcategories_translations" ---

DROP INDEX IF EXISTS faqcategories_translations_faqcategories_id_languages_code_uind;

--- END ALTER TABLE "public"."faqcategories_translations" ---

--- BEGIN ALTER TABLE "public"."events_translations" ---

DROP INDEX IF EXISTS events_translations_events_id_languages_code_index;

--- END ALTER TABLE "public"."events_translations" ---

--- BEGIN ALTER TABLE "public"."tags_translations" ---

DROP INDEX IF EXISTS tags_translations_languages_code_tags_id_uindex;

--- END ALTER TABLE "public"."tags_translations" ---

--- BEGIN ALTER TABLE "public"."games_translations" ---

DROP INDEX IF EXISTS games_translations_games_id_languages_code_uindex;

--- END ALTER TABLE "public"."games_translations" ---

--- BEGIN ALTER TABLE "public"."shows_translations" ---

DROP INDEX IF EXISTS shows_translations_languages_code_shows_id_uindex;

--- END ALTER TABLE "public"."shows_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

DROP INDEX IF EXISTS pages_translations_pages_id_languages_code_uindex;

--- END ALTER TABLE "public"."pages_translations" ---
