-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T09:01:50.293Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations" DROP CONSTRAINT IF EXISTS "notificationtemplates_translations_languages_code_foreign";

DROP INDEX IF EXISTS notificationtemplates_translations_notificationtemplates_id_lan;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations" ADD CONSTRAINT "notificationtemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "notificationtemplates_translations_languages_code_foreign" ON "public"."notificationtemplates_translations" IS NULL;

CREATE UNIQUE INDEX notificationtemplates_translations_notificationtemplates_id_lan ON public.notificationtemplates_translations USING btree (notificationtemplates_id, languages_code);

COMMENT ON INDEX "public"."notificationtemplates_translations_notificationtemplates_id_lan"  IS NULL;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."prompts_translations" ---

ALTER TABLE IF EXISTS "public"."prompts_translations" DROP CONSTRAINT IF EXISTS "prompts_translations_languages_code_foreign";

DROP INDEX IF EXISTS prompts_translations_prompts_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."prompts_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."prompts_translations" ADD CONSTRAINT "prompts_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "prompts_translations_languages_code_foreign" ON "public"."prompts_translations" IS NULL;

CREATE UNIQUE INDEX prompts_translations_prompts_id_languages_code_uindex ON public.prompts_translations USING btree (prompts_id, languages_code);

COMMENT ON INDEX "public"."prompts_translations_prompts_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."prompts_translations" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_translations" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_translations" DROP CONSTRAINT IF EXISTS "timedmetadata_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata_translations" ADD CONSTRAINT "timedmetadata_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "timedmetadata_translations_languages_code_foreign" ON "public"."timedmetadata_translations" IS NULL;

--- END ALTER TABLE "public"."timedmetadata_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

ALTER TABLE IF EXISTS "public"."pages_translations" DROP CONSTRAINT IF EXISTS "pages_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "languages_code" SET NOT NULL,
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."pages_translations" ADD CONSTRAINT "pages_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_translations_languages_code_foreign" ON "public"."pages_translations" IS NULL;

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN ALTER TABLE "public"."shows_translations" ---

ALTER TABLE IF EXISTS "public"."shows_translations" DROP CONSTRAINT IF EXISTS "shows_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."shows_translations"
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."shows_translations" ADD CONSTRAINT "shows_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "shows_translations_languages_code_foreign" ON "public"."shows_translations" IS NULL;

--- END ALTER TABLE "public"."shows_translations" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

ALTER TABLE IF EXISTS "public"."links_translations" DROP CONSTRAINT IF EXISTS "links_translations_languages_code_foreign";

DROP INDEX IF EXISTS links_translations_links_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."links_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."links_translations" ADD CONSTRAINT "links_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "links_translations_languages_code_foreign" ON "public"."links_translations" IS NULL;

CREATE UNIQUE INDEX links_translations_links_id_languages_code_uindex ON public.links_translations USING btree (links_id, languages_code);

COMMENT ON INDEX "public"."links_translations_links_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations" DROP CONSTRAINT IF EXISTS "achievements_translations_languages_code_foreign";

DROP INDEX IF EXISTS achievements_translations_achievements_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."achievements_translations"
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."achievements_translations" ADD CONSTRAINT "achievements_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code);

COMMENT ON CONSTRAINT "achievements_translations_languages_code_foreign" ON "public"."achievements_translations" IS NULL;

CREATE UNIQUE INDEX achievements_translations_achievements_id_languages_code_uindex ON public.achievements_translations USING btree (achievements_id, languages_code);

COMMENT ON INDEX "public"."achievements_translations_achievements_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

ALTER TABLE IF EXISTS "public"."tasks_translations" DROP CONSTRAINT IF EXISTS "tasks_translations_languages_code_foreign";

DROP INDEX IF EXISTS tasks_translations_tasks_id_languages_code_uindex;

DELETE FROM "public"."tasks_translations" WHERE "languages_code" IS NULL;

ALTER TABLE IF EXISTS "public"."tasks_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."tasks_translations" ADD CONSTRAINT "tasks_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tasks_translations_languages_code_foreign" ON "public"."tasks_translations" IS NULL;

CREATE UNIQUE INDEX tasks_translations_tasks_id_languages_code_uindex ON public.tasks_translations USING btree (tasks_id, languages_code);

COMMENT ON INDEX "public"."tasks_translations_tasks_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

ALTER TABLE IF EXISTS "public"."studytopics_translations" DROP CONSTRAINT IF EXISTS "studytopics_translations_languages_code_foreign";

DROP INDEX IF EXISTS studytopics_translations_studytopics_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."studytopics_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."studytopics_translations" ADD CONSTRAINT "studytopics_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "studytopics_translations_languages_code_foreign" ON "public"."studytopics_translations" IS NULL;

CREATE UNIQUE INDEX studytopics_translations_studytopics_id_languages_code_uindex ON public.studytopics_translations USING btree (studytopics_id, languages_code);

COMMENT ON INDEX "public"."studytopics_translations_studytopics_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

ALTER TABLE IF EXISTS "public"."lessons_translations" DROP CONSTRAINT IF EXISTS "lessons_translations_languages_code_foreign";

DROP INDEX IF EXISTS lessons_translations_lessons_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."lessons_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_translations" ADD CONSTRAINT "lessons_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lessons_translations_languages_code_foreign" ON "public"."lessons_translations" IS NULL;

CREATE UNIQUE INDEX lessons_translations_lessons_id_languages_code_uindex ON public.lessons_translations USING btree (lessons_id, languages_code);

COMMENT ON INDEX "public"."lessons_translations_lessons_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN ALTER TABLE "public"."questionalternatives_translations" ---

ALTER TABLE IF EXISTS "public"."questionalternatives_translations" DROP CONSTRAINT IF EXISTS "questionalternatives_translations_languages_code_foreign";

DROP INDEX IF EXISTS questionalternatives_translations_questionalternatives_id_langu;

ALTER TABLE IF EXISTS "public"."questionalternatives_translations"
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."questionalternatives_translations" ADD CONSTRAINT "questionalternatives_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "questionalternatives_translations_languages_code_foreign" ON "public"."questionalternatives_translations" IS NULL;

CREATE UNIQUE INDEX questionalternatives_translations_questionalternatives_id_langu ON public.questionalternatives_translations USING btree (questionalternatives_id, languages_code);

COMMENT ON INDEX "public"."questionalternatives_translations_questionalternatives_id_langu"  IS NULL;

--- END ALTER TABLE "public"."questionalternatives_translations" ---

--- BEGIN ALTER TABLE "public"."episodes_translations" ---

ALTER TABLE IF EXISTS "public"."episodes_translations" DROP CONSTRAINT IF EXISTS "episodes_translations_languages_code_foreign";

DROP INDEX IF EXISTS episodes_translations_episodes_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."episodes_translations"
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."episodes_translations" ADD CONSTRAINT "episodes_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "episodes_translations_languages_code_foreign" ON "public"."episodes_translations" IS NULL;

CREATE UNIQUE INDEX episodes_translations_episodes_id_languages_code_uindex ON public.episodes_translations USING btree (episodes_id, languages_code);

COMMENT ON INDEX "public"."episodes_translations_episodes_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."episodes_translations" ---

--- BEGIN ALTER TABLE "public"."tags_translations" ---

ALTER TABLE IF EXISTS "public"."tags_translations" DROP CONSTRAINT IF EXISTS "tags_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."tags_translations"
	ALTER COLUMN "languages_code" SET NOT NULL,
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."tags_translations" ADD CONSTRAINT "tags_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "tags_translations_languages_code_foreign" ON "public"."tags_translations" IS NULL;

--- END ALTER TABLE "public"."tags_translations" ---

--- BEGIN ALTER TABLE "public"."faqcategories_translations" ---

ALTER TABLE IF EXISTS "public"."faqcategories_translations" DROP CONSTRAINT IF EXISTS "faqcategories_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."faqcategories_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."faqcategories_translations" ADD CONSTRAINT "faqcategories_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqcategories_translations_languages_code_foreign" ON "public"."faqcategories_translations" IS NULL;

--- END ALTER TABLE "public"."faqcategories_translations" ---

--- BEGIN ALTER TABLE "public"."faqs_translations" ---

ALTER TABLE IF EXISTS "public"."faqs_translations" DROP CONSTRAINT IF EXISTS "faqs_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."faqs_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."faqs_translations" ADD CONSTRAINT "faqs_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqs_translations_languages_code_foreign" ON "public"."faqs_translations" IS NULL;

--- END ALTER TABLE "public"."faqs_translations" ---

--- BEGIN ALTER TABLE "public"."calendarentries_translations" ---

ALTER TABLE IF EXISTS "public"."calendarentries_translations" DROP CONSTRAINT IF EXISTS "calendarentries_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
	ALTER COLUMN "languages_code" SET NOT NULL,
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."calendarentries_translations" ADD CONSTRAINT "calendarentries_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "calendarentries_translations_languages_code_foreign" ON "public"."calendarentries_translations" IS NULL;

--- END ALTER TABLE "public"."calendarentries_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

ALTER TABLE IF EXISTS "public"."messagetemplates_translations" DROP CONSTRAINT IF EXISTS "messagetemplates_translations_languages_code_foreign";

DROP INDEX IF EXISTS messagetemplates_translations_messagetemplates_id_languages_cod;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
	ALTER COLUMN "languages_code" SET NOT NULL,
	ALTER COLUMN "languages_code" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations" ADD CONSTRAINT "messagetemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "messagetemplates_translations_languages_code_foreign" ON "public"."messagetemplates_translations" IS NULL;

CREATE UNIQUE INDEX messagetemplates_translations_messagetemplates_id_languages_cod ON public.messagetemplates_translations USING btree (messagetemplates_id, languages_code);

COMMENT ON INDEX "public"."messagetemplates_translations_messagetemplates_id_languages_cod"  IS NULL;

--- END ALTER TABLE "public"."messagetemplates_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T09:01:52.045Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes_translations" ---

ALTER TABLE IF EXISTS "public"."episodes_translations" DROP CONSTRAINT IF EXISTS "episodes_translations_languages_code_foreign";

DROP INDEX IF EXISTS episodes_translations_episodes_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."episodes_translations"
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."episodes_translations" ADD CONSTRAINT "episodes_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "episodes_translations_languages_code_foreign" ON "public"."episodes_translations" IS NULL;

CREATE UNIQUE INDEX episodes_translations_episodes_id_languages_code_uindex ON public.episodes_translations USING btree (episodes_id, languages_code);

COMMENT ON INDEX "public"."episodes_translations_episodes_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."episodes_translations" ---

--- BEGIN ALTER TABLE "public"."tags_translations" ---

ALTER TABLE IF EXISTS "public"."tags_translations" DROP CONSTRAINT IF EXISTS "tags_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."tags_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL,
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."tags_translations" ADD CONSTRAINT "tags_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "tags_translations_languages_code_foreign" ON "public"."tags_translations" IS NULL;

--- END ALTER TABLE "public"."tags_translations" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

ALTER TABLE IF EXISTS "public"."links_translations" DROP CONSTRAINT IF EXISTS "links_translations_languages_code_foreign";

DROP INDEX IF EXISTS links_translations_links_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."links_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."links_translations" ADD CONSTRAINT "links_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "links_translations_languages_code_foreign" ON "public"."links_translations" IS NULL;

CREATE UNIQUE INDEX links_translations_links_id_languages_code_uindex ON public.links_translations USING btree (links_id, languages_code);

COMMENT ON INDEX "public"."links_translations_links_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

ALTER TABLE IF EXISTS "public"."tasks_translations" DROP CONSTRAINT IF EXISTS "tasks_translations_languages_code_foreign";

DROP INDEX IF EXISTS tasks_translations_tasks_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."tasks_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."tasks_translations" ADD CONSTRAINT "tasks_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tasks_translations_languages_code_foreign" ON "public"."tasks_translations" IS NULL;

CREATE UNIQUE INDEX tasks_translations_tasks_id_languages_code_uindex ON public.tasks_translations USING btree (tasks_id, languages_code);

COMMENT ON INDEX "public"."tasks_translations_tasks_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations" DROP CONSTRAINT IF EXISTS "notificationtemplates_translations_languages_code_foreign";

DROP INDEX IF EXISTS notificationtemplates_translations_notificationtemplates_id_lan;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations" ADD CONSTRAINT "notificationtemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "notificationtemplates_translations_languages_code_foreign" ON "public"."notificationtemplates_translations" IS NULL;

CREATE UNIQUE INDEX notificationtemplates_translations_notificationtemplates_id_lan ON public.notificationtemplates_translations USING btree (notificationtemplates_id, languages_code);

COMMENT ON INDEX "public"."notificationtemplates_translations_notificationtemplates_id_lan"  IS NULL;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

ALTER TABLE IF EXISTS "public"."studytopics_translations" DROP CONSTRAINT IF EXISTS "studytopics_translations_languages_code_foreign";

DROP INDEX IF EXISTS studytopics_translations_studytopics_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."studytopics_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."studytopics_translations" ADD CONSTRAINT "studytopics_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "studytopics_translations_languages_code_foreign" ON "public"."studytopics_translations" IS NULL;

CREATE UNIQUE INDEX studytopics_translations_studytopics_id_languages_code_uindex ON public.studytopics_translations USING btree (studytopics_id, languages_code);

COMMENT ON INDEX "public"."studytopics_translations_studytopics_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

ALTER TABLE IF EXISTS "public"."lessons_translations" DROP CONSTRAINT IF EXISTS "lessons_translations_languages_code_foreign";

DROP INDEX IF EXISTS lessons_translations_lessons_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."lessons_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_translations" ADD CONSTRAINT "lessons_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lessons_translations_languages_code_foreign" ON "public"."lessons_translations" IS NULL;

CREATE UNIQUE INDEX lessons_translations_lessons_id_languages_code_uindex ON public.lessons_translations USING btree (lessons_id, languages_code);

COMMENT ON INDEX "public"."lessons_translations_lessons_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN ALTER TABLE "public"."questionalternatives_translations" ---

ALTER TABLE IF EXISTS "public"."questionalternatives_translations" DROP CONSTRAINT IF EXISTS "questionalternatives_translations_languages_code_foreign";

DROP INDEX IF EXISTS questionalternatives_translations_questionalternatives_id_langu;

ALTER TABLE IF EXISTS "public"."questionalternatives_translations"
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."questionalternatives_translations" ADD CONSTRAINT "questionalternatives_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "questionalternatives_translations_languages_code_foreign" ON "public"."questionalternatives_translations" IS NULL;

CREATE UNIQUE INDEX questionalternatives_translations_questionalternatives_id_langu ON public.questionalternatives_translations USING btree (questionalternatives_id, languages_code);

COMMENT ON INDEX "public"."questionalternatives_translations_questionalternatives_id_langu"  IS NULL;

--- END ALTER TABLE "public"."questionalternatives_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations" DROP CONSTRAINT IF EXISTS "achievements_translations_languages_code_foreign";

DROP INDEX IF EXISTS achievements_translations_achievements_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."achievements_translations"
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."achievements_translations" ADD CONSTRAINT "achievements_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code);

COMMENT ON CONSTRAINT "achievements_translations_languages_code_foreign" ON "public"."achievements_translations" IS NULL;

CREATE UNIQUE INDEX achievements_translations_achievements_id_languages_code_uindex ON public.achievements_translations USING btree (achievements_id, languages_code);

COMMENT ON INDEX "public"."achievements_translations_achievements_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."prompts_translations" ---

ALTER TABLE IF EXISTS "public"."prompts_translations" DROP CONSTRAINT IF EXISTS "prompts_translations_languages_code_foreign";

DROP INDEX IF EXISTS prompts_translations_prompts_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."prompts_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."prompts_translations" ADD CONSTRAINT "prompts_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "prompts_translations_languages_code_foreign" ON "public"."prompts_translations" IS NULL;

CREATE UNIQUE INDEX prompts_translations_prompts_id_languages_code_uindex ON public.prompts_translations USING btree (prompts_id, languages_code);

COMMENT ON INDEX "public"."prompts_translations_prompts_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."prompts_translations" ---

--- BEGIN ALTER TABLE "public"."faqs_translations" ---

ALTER TABLE IF EXISTS "public"."faqs_translations" DROP CONSTRAINT IF EXISTS "faqs_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."faqs_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."faqs_translations" ADD CONSTRAINT "faqs_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqs_translations_languages_code_foreign" ON "public"."faqs_translations" IS NULL;

--- END ALTER TABLE "public"."faqs_translations" ---

--- BEGIN ALTER TABLE "public"."faqcategories_translations" ---

ALTER TABLE IF EXISTS "public"."faqcategories_translations" DROP CONSTRAINT IF EXISTS "faqcategories_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."faqcategories_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."faqcategories_translations" ADD CONSTRAINT "faqcategories_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqcategories_translations_languages_code_foreign" ON "public"."faqcategories_translations" IS NULL;

--- END ALTER TABLE "public"."faqcategories_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

ALTER TABLE IF EXISTS "public"."pages_translations" DROP CONSTRAINT IF EXISTS "pages_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL,
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."pages_translations" ADD CONSTRAINT "pages_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_translations_languages_code_foreign" ON "public"."pages_translations" IS NULL;

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_translations" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_translations" DROP CONSTRAINT IF EXISTS "timedmetadata_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata_translations" ADD CONSTRAINT "timedmetadata_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "timedmetadata_translations_languages_code_foreign" ON "public"."timedmetadata_translations" IS NULL;

--- END ALTER TABLE "public"."timedmetadata_translations" ---

--- BEGIN ALTER TABLE "public"."calendarentries_translations" ---

ALTER TABLE IF EXISTS "public"."calendarentries_translations" DROP CONSTRAINT IF EXISTS "calendarentries_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL,
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."calendarentries_translations" ADD CONSTRAINT "calendarentries_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "calendarentries_translations_languages_code_foreign" ON "public"."calendarentries_translations" IS NULL;

--- END ALTER TABLE "public"."calendarentries_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

ALTER TABLE IF EXISTS "public"."messagetemplates_translations" DROP CONSTRAINT IF EXISTS "messagetemplates_translations_languages_code_foreign";

DROP INDEX IF EXISTS messagetemplates_translations_messagetemplates_id_languages_cod;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL,
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations" ADD CONSTRAINT "messagetemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "messagetemplates_translations_languages_code_foreign" ON "public"."messagetemplates_translations" IS NULL;

CREATE UNIQUE INDEX messagetemplates_translations_messagetemplates_id_languages_cod ON public.messagetemplates_translations USING btree (messagetemplates_id, languages_code);

COMMENT ON INDEX "public"."messagetemplates_translations_messagetemplates_id_languages_cod"  IS NULL;

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."shows_translations" ---

ALTER TABLE IF EXISTS "public"."shows_translations" DROP CONSTRAINT IF EXISTS "shows_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."shows_translations"
	ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."shows_translations" ADD CONSTRAINT "shows_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "shows_translations_languages_code_foreign" ON "public"."shows_translations" IS NULL;

--- END ALTER TABLE "public"."shows_translations" ---
