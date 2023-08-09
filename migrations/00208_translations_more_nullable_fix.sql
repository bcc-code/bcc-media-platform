-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T09:26:32.399Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."pages_translations" ---

ALTER TABLE IF EXISTS "public"."pages_translations" DROP CONSTRAINT IF EXISTS "pages_translations_pages_id_foreign";

DELETE FROM "public"."pages_translations" WHERE "pages_id" IS NULL;

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "pages_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."pages_translations" ADD CONSTRAINT "pages_translations_pages_id_foreign" FOREIGN KEY (pages_id) REFERENCES pages(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_translations_pages_id_foreign" ON "public"."pages_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."pages_translations" DROP CONSTRAINT IF EXISTS "pages_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."pages_translations"
    ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."pages_translations" ADD CONSTRAINT "pages_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_translations_languages_code_foreign" ON "public"."pages_translations" IS NULL;

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

ALTER TABLE IF EXISTS "public"."links_translations" DROP CONSTRAINT IF EXISTS "links_translations_links_id_foreign";

DROP INDEX IF EXISTS links_translations_links_id_languages_code_uindex;

DELETE FROM "public"."links_translations" WHERE "links_id" IS NULL;

ALTER TABLE IF EXISTS "public"."links_translations"
	ALTER COLUMN "links_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."links_translations" ADD CONSTRAINT "links_translations_links_id_foreign" FOREIGN KEY (links_id) REFERENCES links(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "links_translations_links_id_foreign" ON "public"."links_translations" IS NULL;

CREATE UNIQUE INDEX links_translations_links_id_languages_code_uindex ON public.links_translations USING btree (links_id, languages_code);

COMMENT ON INDEX "public"."links_translations_links_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" DROP CONSTRAINT IF EXISTS "achievementgroups_translations_achievementgroups_id_foreign";

DELETE FROM "public"."achievementgroups_translations" WHERE "achievementgroups_id" IS NULL;

DROP INDEX IF EXISTS achievementgroups_translations_achievementgroups_id_languages_c;

ALTER TABLE IF EXISTS "public"."achievementgroups_translations"
	ALTER COLUMN "achievementgroups_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" ADD CONSTRAINT "achievementgroups_translations_achievementgroups_id_foreign" FOREIGN KEY (achievementgroups_id) REFERENCES achievementgroups(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievementgroups_translations_achievementgroups_id_foreign" ON "public"."achievementgroups_translations" IS NULL;



ALTER TABLE IF EXISTS "public"."achievementgroups_translations" DROP CONSTRAINT IF EXISTS "achievementgroups_translations_languages_code_foreign";

DROP INDEX IF EXISTS achievementgroups_translations_achievementgroups_id_languages_c;

DELETE FROM "public"."achievementgroups_translations" WHERE "languages_code" IS NULL;

ALTER TABLE IF EXISTS "public"."achievementgroups_translations"
    ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" ADD CONSTRAINT "achievementgroups_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievementgroups_translations_achievementgroups_id_foreign" ON "public"."achievementgroups_translations" IS NULL;


CREATE UNIQUE INDEX achievementgroups_translations_achievementgroups_id_languages_c ON public.achievementgroups_translations USING btree (achievementgroups_id, languages_code);

COMMENT ON INDEX "public"."achievementgroups_translations_achievementgroups_id_languages_c"  IS NULL;

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations" DROP CONSTRAINT IF EXISTS "achievements_translations_achievements_id_foreign";

DROP INDEX IF EXISTS achievements_translations_achievements_id_languages_code_uindex;

DELETE FROM "public"."achievements_translations" WHERE "achievements_id" IS NULL;

ALTER TABLE IF EXISTS "public"."achievements_translations"
	ALTER COLUMN "achievements_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."achievements_translations" ADD CONSTRAINT "achievements_translations_achievements_id_foreign" FOREIGN KEY (achievements_id) REFERENCES achievements(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievements_translations_achievements_id_foreign" ON "public"."achievements_translations" IS NULL;

CREATE UNIQUE INDEX achievements_translations_achievements_id_languages_code_uindex ON public.achievements_translations USING btree (achievements_id, languages_code);

COMMENT ON INDEX "public"."achievements_translations_achievements_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

ALTER TABLE IF EXISTS "public"."tasks_translations" DROP CONSTRAINT IF EXISTS "tasks_translations_tasks_id_foreign";

DROP INDEX IF EXISTS tasks_translations_tasks_id_languages_code_uindex;

DELETE FROM "public"."tasks_translations" WHERE "tasks_id" IS NULL;

ALTER TABLE IF EXISTS "public"."tasks_translations"
	ALTER COLUMN "tasks_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."tasks_translations" ADD CONSTRAINT "tasks_translations_tasks_id_foreign" FOREIGN KEY (tasks_id) REFERENCES tasks(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tasks_translations_tasks_id_foreign" ON "public"."tasks_translations" IS NULL;

CREATE UNIQUE INDEX tasks_translations_tasks_id_languages_code_uindex ON public.tasks_translations USING btree (tasks_id, languages_code);

COMMENT ON INDEX "public"."tasks_translations_tasks_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

ALTER TABLE IF EXISTS "public"."studytopics_translations" DROP CONSTRAINT IF EXISTS "studytopics_translations_studytopics_id_foreign";

DROP INDEX IF EXISTS studytopics_translations_studytopics_id_languages_code_uindex;

DELETE FROM "public"."studytopics_translations" WHERE "studytopics_id" IS NULL;

ALTER TABLE IF EXISTS "public"."studytopics_translations"
	ALTER COLUMN "studytopics_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."studytopics_translations" ADD CONSTRAINT "studytopics_translations_studytopics_id_foreign" FOREIGN KEY (studytopics_id) REFERENCES studytopics(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "studytopics_translations_studytopics_id_foreign" ON "public"."studytopics_translations" IS NULL;

CREATE UNIQUE INDEX studytopics_translations_studytopics_id_languages_code_uindex ON public.studytopics_translations USING btree (studytopics_id, languages_code);

COMMENT ON INDEX "public"."studytopics_translations_studytopics_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

ALTER TABLE IF EXISTS "public"."lessons_translations" DROP CONSTRAINT IF EXISTS "lessons_translations_lessons_id_foreign";

DROP INDEX IF EXISTS lessons_translations_lessons_id_languages_code_uindex;

DELETE FROM "public"."lessons_translations" WHERE "lessons_id" IS NULL;

ALTER TABLE IF EXISTS "public"."lessons_translations"
	ALTER COLUMN "lessons_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_translations" ADD CONSTRAINT "lessons_translations_lessons_id_foreign" FOREIGN KEY (lessons_id) REFERENCES lessons(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lessons_translations_lessons_id_foreign" ON "public"."lessons_translations" IS NULL;

CREATE UNIQUE INDEX lessons_translations_lessons_id_languages_code_uindex ON public.lessons_translations USING btree (lessons_id, languages_code);

COMMENT ON INDEX "public"."lessons_translations_lessons_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN ALTER TABLE "public"."questionalternatives_translations" ---

ALTER TABLE IF EXISTS "public"."questionalternatives_translations" DROP CONSTRAINT IF EXISTS "questionalternatives_translations_question__261421c7_foreign";

DROP INDEX IF EXISTS questionalternatives_translations_questionalternatives_id_langu;

DELETE FROM "public"."questionalternatives_translations" WHERE "questionalternatives_id" IS NULL;


ALTER TABLE IF EXISTS "public"."questionalternatives_translations"
	ALTER COLUMN "questionalternatives_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."questionalternatives_translations" ADD CONSTRAINT "questionalternatives_translations_question__261421c7_foreign" FOREIGN KEY (questionalternatives_id) REFERENCES questionalternatives(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "questionalternatives_translations_question__261421c7_foreign" ON "public"."questionalternatives_translations" IS NULL;

CREATE UNIQUE INDEX questionalternatives_translations_questionalternatives_id_langu ON public.questionalternatives_translations USING btree (questionalternatives_id, languages_code);

COMMENT ON INDEX "public"."questionalternatives_translations_questionalternatives_id_langu"  IS NULL;

--- END ALTER TABLE "public"."questionalternatives_translations" ---

--- BEGIN ALTER TABLE "public"."faqcategories_translations" ---

ALTER TABLE IF EXISTS "public"."faqcategories_translations" DROP CONSTRAINT IF EXISTS "faqcategories_translations_faqcategories_id_foreign";

DELETE FROM "public"."faqcategories_translations" WHERE "faqcategories_id" IS NULL;

ALTER TABLE IF EXISTS "public"."faqcategories_translations"
	ALTER COLUMN "faqcategories_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."faqcategories_translations" ADD CONSTRAINT "faqcategories_translations_faqcategories_id_foreign" FOREIGN KEY (faqcategories_id) REFERENCES faqcategories(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqcategories_translations_faqcategories_id_foreign" ON "public"."faqcategories_translations" IS NULL;

--- END ALTER TABLE "public"."faqcategories_translations" ---

--- BEGIN ALTER TABLE "public"."faqs_translations" ---

ALTER TABLE IF EXISTS "public"."faqs_translations" DROP CONSTRAINT IF EXISTS "faqs_translations_faqs_id_foreign";

DELETE FROM "public"."faqs_translations" WHERE "faqs_id" IS NULL;

ALTER TABLE IF EXISTS "public"."faqs_translations"
	ALTER COLUMN "faqs_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."faqs_translations" ADD CONSTRAINT "faqs_translations_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqs_translations_faqs_id_foreign" ON "public"."faqs_translations" IS NULL;

--- END ALTER TABLE "public"."faqs_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T09:26:34.438Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."links_translations" ---

ALTER TABLE IF EXISTS "public"."links_translations" DROP CONSTRAINT IF EXISTS "links_translations_links_id_foreign";

DROP INDEX IF EXISTS links_translations_links_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."links_translations"
	ALTER COLUMN "links_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."links_translations" ADD CONSTRAINT "links_translations_links_id_foreign" FOREIGN KEY (links_id) REFERENCES links(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "links_translations_links_id_foreign" ON "public"."links_translations" IS NULL;

CREATE UNIQUE INDEX links_translations_links_id_languages_code_uindex ON public.links_translations USING btree (links_id, languages_code);

COMMENT ON INDEX "public"."links_translations_links_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

ALTER TABLE IF EXISTS "public"."tasks_translations" DROP CONSTRAINT IF EXISTS "tasks_translations_tasks_id_foreign";

DROP INDEX IF EXISTS tasks_translations_tasks_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."tasks_translations"
	ALTER COLUMN "tasks_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."tasks_translations" ADD CONSTRAINT "tasks_translations_tasks_id_foreign" FOREIGN KEY (tasks_id) REFERENCES tasks(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tasks_translations_tasks_id_foreign" ON "public"."tasks_translations" IS NULL;

CREATE UNIQUE INDEX tasks_translations_tasks_id_languages_code_uindex ON public.tasks_translations USING btree (tasks_id, languages_code);

COMMENT ON INDEX "public"."tasks_translations_tasks_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

ALTER TABLE IF EXISTS "public"."studytopics_translations" DROP CONSTRAINT IF EXISTS "studytopics_translations_studytopics_id_foreign";

DROP INDEX IF EXISTS studytopics_translations_studytopics_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."studytopics_translations"
	ALTER COLUMN "studytopics_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."studytopics_translations" ADD CONSTRAINT "studytopics_translations_studytopics_id_foreign" FOREIGN KEY (studytopics_id) REFERENCES studytopics(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "studytopics_translations_studytopics_id_foreign" ON "public"."studytopics_translations" IS NULL;

CREATE UNIQUE INDEX studytopics_translations_studytopics_id_languages_code_uindex ON public.studytopics_translations USING btree (studytopics_id, languages_code);

COMMENT ON INDEX "public"."studytopics_translations_studytopics_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

ALTER TABLE IF EXISTS "public"."lessons_translations" DROP CONSTRAINT IF EXISTS "lessons_translations_lessons_id_foreign";

DROP INDEX IF EXISTS lessons_translations_lessons_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."lessons_translations"
	ALTER COLUMN "lessons_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_translations" ADD CONSTRAINT "lessons_translations_lessons_id_foreign" FOREIGN KEY (lessons_id) REFERENCES lessons(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lessons_translations_lessons_id_foreign" ON "public"."lessons_translations" IS NULL;

CREATE UNIQUE INDEX lessons_translations_lessons_id_languages_code_uindex ON public.lessons_translations USING btree (lessons_id, languages_code);

COMMENT ON INDEX "public"."lessons_translations_lessons_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN ALTER TABLE "public"."questionalternatives_translations" ---

ALTER TABLE IF EXISTS "public"."questionalternatives_translations" DROP CONSTRAINT IF EXISTS "questionalternatives_translations_question__261421c7_foreign";

DROP INDEX IF EXISTS questionalternatives_translations_questionalternatives_id_langu;

ALTER TABLE IF EXISTS "public"."questionalternatives_translations"
	ALTER COLUMN "questionalternatives_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."questionalternatives_translations" ADD CONSTRAINT "questionalternatives_translations_question__261421c7_foreign" FOREIGN KEY (questionalternatives_id) REFERENCES questionalternatives(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "questionalternatives_translations_question__261421c7_foreign" ON "public"."questionalternatives_translations" IS NULL;

CREATE UNIQUE INDEX questionalternatives_translations_questionalternatives_id_langu ON public.questionalternatives_translations USING btree (questionalternatives_id, languages_code);

COMMENT ON INDEX "public"."questionalternatives_translations_questionalternatives_id_langu"  IS NULL;

--- END ALTER TABLE "public"."questionalternatives_translations" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" DROP CONSTRAINT IF EXISTS "achievementgroups_translations_achievementgroups_id_foreign";

DROP INDEX IF EXISTS achievementgroups_translations_achievementgroups_id_languages_c;

ALTER TABLE IF EXISTS "public"."achievementgroups_translations"
	ALTER COLUMN "achievementgroups_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" ADD CONSTRAINT "achievementgroups_translations_achievementgroups_id_foreign" FOREIGN KEY (achievementgroups_id) REFERENCES achievementgroups(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievementgroups_translations_achievementgroups_id_foreign" ON "public"."achievementgroups_translations" IS NULL;

CREATE UNIQUE INDEX achievementgroups_translations_achievementgroups_id_languages_c ON public.achievementgroups_translations USING btree (achievementgroups_id, languages_code);

COMMENT ON INDEX "public"."achievementgroups_translations_achievementgroups_id_languages_c"  IS NULL;

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations" DROP CONSTRAINT IF EXISTS "achievements_translations_achievements_id_foreign";

DROP INDEX IF EXISTS achievements_translations_achievements_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."achievements_translations"
	ALTER COLUMN "achievements_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."achievements_translations" ADD CONSTRAINT "achievements_translations_achievements_id_foreign" FOREIGN KEY (achievements_id) REFERENCES achievements(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievements_translations_achievements_id_foreign" ON "public"."achievements_translations" IS NULL;

CREATE UNIQUE INDEX achievements_translations_achievements_id_languages_code_uindex ON public.achievements_translations USING btree (achievements_id, languages_code);

COMMENT ON INDEX "public"."achievements_translations_achievements_id_languages_code_uindex"  IS NULL;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."faqs_translations" ---

ALTER TABLE IF EXISTS "public"."faqs_translations" DROP CONSTRAINT IF EXISTS "faqs_translations_faqs_id_foreign";

ALTER TABLE IF EXISTS "public"."faqs_translations"
	ALTER COLUMN "faqs_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."faqs_translations" ADD CONSTRAINT "faqs_translations_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqs_translations_faqs_id_foreign" ON "public"."faqs_translations" IS NULL;

--- END ALTER TABLE "public"."faqs_translations" ---

--- BEGIN ALTER TABLE "public"."faqcategories_translations" ---

ALTER TABLE IF EXISTS "public"."faqcategories_translations" DROP CONSTRAINT IF EXISTS "faqcategories_translations_faqcategories_id_foreign";

ALTER TABLE IF EXISTS "public"."faqcategories_translations"
	ALTER COLUMN "faqcategories_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."faqcategories_translations" ADD CONSTRAINT "faqcategories_translations_faqcategories_id_foreign" FOREIGN KEY (faqcategories_id) REFERENCES faqcategories(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqcategories_translations_faqcategories_id_foreign" ON "public"."faqcategories_translations" IS NULL;

--- END ALTER TABLE "public"."faqcategories_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

ALTER TABLE IF EXISTS "public"."pages_translations" DROP CONSTRAINT IF EXISTS "pages_translations_pages_id_foreign";

ALTER TABLE IF EXISTS "public"."pages_translations"
	ALTER COLUMN "pages_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."pages_translations" ADD CONSTRAINT "pages_translations_pages_id_foreign" FOREIGN KEY (pages_id) REFERENCES pages(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "pages_translations_pages_id_foreign" ON "public"."pages_translations" IS NULL;

--- END ALTER TABLE "public"."pages_translations" ---
