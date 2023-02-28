-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-28T14:17:45.441Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

CREATE UNIQUE INDEX notificationtemplates_translations_notificationtemplates_id_lan ON public.notificationtemplates_translations USING btree (notificationtemplates_id, languages_code);

COMMENT ON INDEX "public"."notificationtemplates_translations_notificationtemplates_id_lan"  IS NULL;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."surveys_translations" ---

CREATE UNIQUE INDEX surveys_translations_surveys_id_languages_code_uindex ON public.surveys_translations USING btree (surveys_id, languages_code);

COMMENT ON INDEX "public"."surveys_translations_surveys_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."surveys_translations" ---

--- BEGIN ALTER TABLE "public"."surveyquestions_translations" ---

CREATE UNIQUE INDEX surveyquestions_translations_surveyquestions_id_languages_code_ ON public.surveyquestions_translations USING btree (surveyquestions_id, languages_code);

COMMENT ON INDEX "public"."surveyquestions_translations_surveyquestions_id_languages_code_"  IS NULL;

--- END ALTER TABLE "public"."surveyquestions_translations" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

CREATE UNIQUE INDEX links_translations_links_id_languages_code_uindex ON public.links_translations USING btree (links_id, languages_code);

COMMENT ON INDEX "public"."links_translations_links_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

CREATE UNIQUE INDEX achievementgroups_translations_achievementgroups_id_languages_c ON public.achievementgroups_translations USING btree (achievementgroups_id, languages_code);

COMMENT ON INDEX "public"."achievementgroups_translations_achievementgroups_id_languages_c"  IS NULL;

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

CREATE UNIQUE INDEX achievements_translations_achievements_id_languages_code_uindex ON public.achievements_translations USING btree (achievements_id, languages_code);

COMMENT ON INDEX "public"."achievements_translations_achievements_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

CREATE UNIQUE INDEX studytopics_translations_studytopics_id_languages_code_uindex ON public.studytopics_translations USING btree (studytopics_id, languages_code);

COMMENT ON INDEX "public"."studytopics_translations_studytopics_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

CREATE UNIQUE INDEX tasks_translations_tasks_id_languages_code_uindex ON public.tasks_translations USING btree (tasks_id, languages_code);

COMMENT ON INDEX "public"."tasks_translations_tasks_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

CREATE UNIQUE INDEX lessons_translations_lessons_id_languages_code_uindex ON public.lessons_translations USING btree (lessons_id, languages_code);

COMMENT ON INDEX "public"."lessons_translations_lessons_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN ALTER TABLE "public"."questionalternatives_translations" ---

CREATE UNIQUE INDEX questionalternatives_translations_questionalternatives_id_langu ON public.questionalternatives_translations USING btree (questionalternatives_id, languages_code);

COMMENT ON INDEX "public"."questionalternatives_translations_questionalternatives_id_langu"  IS NULL;

--- END ALTER TABLE "public"."questionalternatives_translations" ---

--- BEGIN ALTER TABLE "public"."episodes_translations" ---

CREATE UNIQUE INDEX episodes_translations_episodes_id_languages_code_uindex ON public.episodes_translations USING btree (episodes_id, languages_code);

COMMENT ON INDEX "public"."episodes_translations_episodes_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."episodes_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

CREATE UNIQUE INDEX messagetemplates_translations_messagetemplates_id_languages_cod ON public.messagetemplates_translations USING btree (messagetemplates_id, languages_code);

COMMENT ON INDEX "public"."messagetemplates_translations_messagetemplates_id_languages_cod"  IS NULL;

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."seasons_translations" ---

ALTER TABLE IF EXISTS "public"."seasons_translations" DROP CONSTRAINT IF EXISTS "seasons_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."seasons_translations"
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."seasons_translations" ADD CONSTRAINT "seasons_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "seasons_translations_languages_code_foreign" ON "public"."seasons_translations" IS NULL;

CREATE UNIQUE INDEX seasons_translations_seasons_id_languages_code_uindex ON public.seasons_translations USING btree (seasons_id, languages_code);

COMMENT ON INDEX "public"."seasons_translations_seasons_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."seasons_translations" ---

--- BEGIN ALTER TABLE "public"."sections_translations" ---

ALTER TABLE IF EXISTS "public"."sections_translations" DROP CONSTRAINT IF EXISTS "sections_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."sections_translations"
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."sections_translations" ADD CONSTRAINT "sections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code);

COMMENT ON CONSTRAINT "sections_translations_languages_code_foreign" ON "public"."sections_translations" IS NULL;

CREATE UNIQUE INDEX sections_translations_sections_id_languages_code_uindex ON public.sections_translations USING btree (sections_id, languages_code);

COMMENT ON INDEX "public"."sections_translations_sections_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."sections_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-28T14:17:47.023Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes_translations" ---

DROP INDEX IF EXISTS episodes_translations_episodes_id_languages_code_uindex;

--- END ALTER TABLE "public"."episodes_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

DROP INDEX IF EXISTS messagetemplates_translations_messagetemplates_id_languages_cod;

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."seasons_translations" ---

ALTER TABLE IF EXISTS "public"."seasons_translations" DROP CONSTRAINT IF EXISTS "seasons_translations_languages_code_foreign";

DROP INDEX IF EXISTS seasons_translations_seasons_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."seasons_translations"
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."seasons_translations" ADD CONSTRAINT "seasons_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "seasons_translations_languages_code_foreign" ON "public"."seasons_translations" IS NULL;

--- END ALTER TABLE "public"."seasons_translations" ---

--- BEGIN ALTER TABLE "public"."sections_translations" ---

ALTER TABLE IF EXISTS "public"."sections_translations" DROP CONSTRAINT IF EXISTS "sections_translations_languages_code_foreign";

DROP INDEX IF EXISTS sections_translations_sections_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."sections_translations"
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."sections_translations" ADD CONSTRAINT "sections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code);

COMMENT ON CONSTRAINT "sections_translations_languages_code_foreign" ON "public"."sections_translations" IS NULL;

--- END ALTER TABLE "public"."sections_translations" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

DROP INDEX IF EXISTS links_translations_links_id_languages_code_uindex;

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

DROP INDEX IF EXISTS tasks_translations_tasks_id_languages_code_uindex;

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

DROP INDEX IF EXISTS notificationtemplates_translations_notificationtemplates_id_lan;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

DROP INDEX IF EXISTS studytopics_translations_studytopics_id_languages_code_uindex;

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

DROP INDEX IF EXISTS lessons_translations_lessons_id_languages_code_uindex;

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN ALTER TABLE "public"."questionalternatives_translations" ---

DROP INDEX IF EXISTS questionalternatives_translations_questionalternatives_id_langu;

--- END ALTER TABLE "public"."questionalternatives_translations" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

DROP INDEX IF EXISTS achievementgroups_translations_achievementgroups_id_languages_c;

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

DROP INDEX IF EXISTS achievements_translations_achievements_id_languages_code_uindex;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."surveys_translations" ---

DROP INDEX IF EXISTS surveys_translations_surveys_id_languages_code_uindex;

--- END ALTER TABLE "public"."surveys_translations" ---

--- BEGIN ALTER TABLE "public"."surveyquestions_translations" ---

DROP INDEX IF EXISTS surveyquestions_translations_surveyquestions_id_languages_code_;

--- END ALTER TABLE "public"."surveyquestions_translations" ---
