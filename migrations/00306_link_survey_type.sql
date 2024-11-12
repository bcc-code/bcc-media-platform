-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2024-11-11T09:33:10.307Z            ***/
/**********************************************************/

--- BEGIN ALTER SEQUENCE "public"."messages_messagetemplates_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."messages_messagetemplates_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."messages_messagetemplates_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."playlists_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."playlists_usergroups_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."playlists_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."faqcategories_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."faqcategories_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."faqcategories_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."shows_tags_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."shows_tags_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."shows_tags_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."collections_entries_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."collections_entries_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."collections_entries_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."surveyquestions_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."surveyquestions_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."surveyquestions_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notifications_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."notifications_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."notifications_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_styledimages_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."mediaitems_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."playlists_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."playlists_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."playlists_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."targets_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."targets_usergroups_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."targets_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."timedmetadata_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."timedmetadata_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."timedmetadata_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievementconditions_studytopics_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."achievementconditions_studytopics_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."achievementconditions_studytopics_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."playlists_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."playlists_styledimages_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."playlists_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."timedmetadata_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."timedmetadata_styledimages_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."timedmetadata_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."faqs_usergroups_id_seq1" ---

ALTER SEQUENCE IF EXISTS "public"."faqs_usergroups_id_seq1" OWNER TO builder;

--- END ALTER SEQUENCE "public"."faqs_usergroups_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."sections_links_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."sections_links_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."sections_links_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."episodes_assets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."episodes_assets_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."episodes_assets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."seasons_tags_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."seasons_tags_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."seasons_tags_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_tags_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_tags_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."mediaitems_tags_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."songcollections_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."songcollections_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."songcollections_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."links_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."links_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."links_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notifications_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."notifications_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."notifications_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."faqs_translations_id_seq1" ---

ALTER SEQUENCE IF EXISTS "public"."faqs_translations_id_seq1" OWNER TO builder;

--- END ALTER SEQUENCE "public"."faqs_translations_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."achievementgroups_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."achievementgroups_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."achievementgroups_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."songs_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."songs_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."songs_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."messages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."messages_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."messages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_usergroups_earlyaccess_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_contributions_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_contributions_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."mediaitems_contributions_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."mediaitems_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."timedmetadata_persons_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."timedmetadata_persons_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."timedmetadata_persons_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."surveys_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."surveys_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."surveys_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_assets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_assets_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."mediaitems_assets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."applicationgroups_usergroups_ls_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."games_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."games_usergroups_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."games_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_usergroups_download_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_usergroups_download_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."mediaitems_usergroups_download_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."timedmetadata_contributions_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."timedmetadata_contributions_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."timedmetadata_contributions_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."prompts_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."prompts_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."prompts_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."shorts_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."shorts_usergroups_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."shorts_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."games_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."games_styledimages_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."games_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."surveys_targets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."surveys_targets_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."surveys_targets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."links_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."links_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."links_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."applicationgroups_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."applicationgroups_usergroups_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."applicationgroups_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."persons_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."persons_styledimages_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."persons_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."notificationtemplates_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."images_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."images_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."images_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."phrases_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."phrases_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."phrases_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq1" ---

ALTER SEQUENCE IF EXISTS "public"."notificationtemplates_translations_id_seq1" OWNER TO builder;

--- END ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."notifications_targets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."notifications_targets_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."notifications_targets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievements_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."achievements_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."achievements_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."prompts_targets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."prompts_targets_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."prompts_targets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_usergroups_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."mediaitems_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."contributions_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."contributions_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."contributions_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."games_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."games_translations_id_seq" OWNER TO builder;

--- END ALTER SEQUENCE "public"."games_translations_id_seq" ---

--- BEGIN ALTER TABLE "users"."profiles" ---

ALTER TABLE IF EXISTS "users"."profiles" DROP CONSTRAINT IF EXISTS "profiles_applicationgroups_id_fk";

--- END ALTER TABLE "users"."profiles" ---

--- BEGIN ALTER TABLE "users"."progress" ---

ALTER TABLE IF EXISTS "users"."progress" DROP CONSTRAINT IF EXISTS "progress_episode_id_fk";

ALTER TABLE IF EXISTS "users"."progress" DROP CONSTRAINT IF EXISTS "progress_show_id_fk";

--- END ALTER TABLE "users"."progress" ---

--- BEGIN ALTER TABLE "public"."mediaitems_translations" ---

CREATE INDEX mediaitems_translations_mediaitems_id_index ON public.mediaitems_translations USING btree (mediaitems_id);

COMMENT ON INDEX "public"."mediaitems_translations_mediaitems_id_index"  IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_translations" OWNER TO builder;

--- END ALTER TABLE "public"."mediaitems_translations" ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems" OWNER TO builder;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN ALTER TABLE "public"."achievementgroups" ---

ALTER TABLE IF EXISTS "public"."achievementgroups" OWNER TO builder;

--- END ALTER TABLE "public"."achievementgroups" ---

--- BEGIN ALTER TABLE "users"."taskanswers" ---

ALTER TABLE IF EXISTS "users"."taskanswers" DROP CONSTRAINT IF EXISTS "taskanswers_tasks_id_fk";

--- END ALTER TABLE "users"."taskanswers" ---

--- BEGIN ALTER TABLE "public"."mediaitems_assets" ---

ALTER TABLE IF EXISTS "public"."mediaitems_assets" OWNER TO builder;

--- END ALTER TABLE "public"."mediaitems_assets" ---

--- BEGIN ALTER TABLE "public"."achievementconditions" ---

ALTER TABLE IF EXISTS "public"."achievementconditions" OWNER TO builder;

--- END ALTER TABLE "public"."achievementconditions" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" OWNER TO builder;

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."applicationgroups_usergroups_ls" ---

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups_ls" OWNER TO builder;

--- END ALTER TABLE "public"."applicationgroups_usergroups_ls" ---

--- BEGIN ALTER TABLE "public"."computeddata_conditions" ---

ALTER TABLE IF EXISTS "public"."computeddata_conditions" OWNER TO builder;

--- END ALTER TABLE "public"."computeddata_conditions" ---

--- BEGIN ALTER TABLE "public"."faqs_translations" ---

ALTER TABLE IF EXISTS "public"."faqs_translations" OWNER TO builder;

--- END ALTER TABLE "public"."faqs_translations" ---

--- BEGIN ALTER TABLE "public"."shorts_usergroups" ---

ALTER TABLE IF EXISTS "public"."shorts_usergroups" OWNER TO builder;

--- END ALTER TABLE "public"."shorts_usergroups" ---

--- BEGIN ALTER TABLE "public"."shorts" ---

ALTER TABLE IF EXISTS "public"."shorts" OWNER TO builder;

--- END ALTER TABLE "public"."shorts" ---

--- BEGIN ALTER TABLE "public"."playlists" ---

ALTER TABLE IF EXISTS "public"."playlists" OWNER TO builder;

--- END ALTER TABLE "public"."playlists" ---

--- BEGIN ALTER TABLE "public"."faqcategories_translations" ---

ALTER TABLE IF EXISTS "public"."faqcategories_translations" OWNER TO builder;

--- END ALTER TABLE "public"."faqcategories_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_images" ---

ALTER TABLE IF EXISTS "public"."lessons_images" OWNER TO builder;

--- END ALTER TABLE "public"."lessons_images" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" OWNER TO builder;

--- END ALTER TABLE "public"."images" ---

--- BEGIN ALTER TABLE "public"."songs" ---

ALTER TABLE IF EXISTS "public"."songs" OWNER TO builder;

--- END ALTER TABLE "public"."songs" ---

--- BEGIN ALTER TABLE "users"."achievements" ---

ALTER TABLE IF EXISTS "users"."achievements" DROP CONSTRAINT IF EXISTS "achievements_achievements_id_fk";

--- END ALTER TABLE "users"."achievements" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

ALTER TABLE IF EXISTS "public"."links_translations" OWNER TO builder;

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."messages_messagetemplates" ---

ALTER TABLE IF EXISTS "public"."messages_messagetemplates" OWNER TO builder;

--- END ALTER TABLE "public"."messages_messagetemplates" ---

--- BEGIN ALTER TABLE "public"."persons_styledimages" ---

ALTER TABLE IF EXISTS "public"."persons_styledimages" OWNER TO builder;

--- END ALTER TABLE "public"."persons_styledimages" ---

--- BEGIN ALTER TABLE "public"."phrases_translations" ---

ALTER TABLE IF EXISTS "public"."phrases_translations" OWNER TO builder;

--- END ALTER TABLE "public"."phrases_translations" ---

--- BEGIN ALTER TABLE "public"."targets" ---

ALTER TABLE IF EXISTS "public"."targets" OWNER TO builder;

--- END ALTER TABLE "public"."targets" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_persons" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_persons" OWNER TO builder;

--- END ALTER TABLE "public"."timedmetadata_persons" ---

--- BEGIN ALTER TABLE "users"."surveyquestionanswers" ---

ALTER TABLE IF EXISTS "users"."surveyquestionanswers" DROP CONSTRAINT IF EXISTS "surveyquestionanswers_surveyquestions_id_fk";

--- END ALTER TABLE "users"."surveyquestionanswers" ---

--- BEGIN ALTER TABLE "users"."collections" ---

ALTER TABLE IF EXISTS "users"."collections" DROP CONSTRAINT IF EXISTS "collections_applicationgroups_id_fk";

--- END ALTER TABLE "users"."collections" ---

--- BEGIN ALTER TABLE "public"."directus_extensions" ---

ALTER TABLE IF EXISTS "public"."directus_extensions" OWNER TO builder;

--- END ALTER TABLE "public"."directus_extensions" ---

--- BEGIN ALTER TABLE "public"."directus_translations" ---

ALTER TABLE IF EXISTS "public"."directus_translations" OWNER TO builder;

--- END ALTER TABLE "public"."directus_translations" ---

--- BEGIN ALTER TABLE "public"."directus_versions" ---

ALTER TABLE IF EXISTS "public"."directus_versions" OWNER TO builder;

--- END ALTER TABLE "public"."directus_versions" ---

--- BEGIN ALTER TABLE "public"."mediaitems_tags" ---

ALTER TABLE IF EXISTS "public"."mediaitems_tags" OWNER TO builder;

--- END ALTER TABLE "public"."mediaitems_tags" ---

--- BEGIN ALTER TABLE "public"."achievements" ---

ALTER TABLE IF EXISTS "public"."achievements" OWNER TO builder;

--- END ALTER TABLE "public"."achievements" ---

--- BEGIN ALTER TABLE "public"."mediaitems_styledimages" ---

ALTER TABLE IF EXISTS "public"."mediaitems_styledimages" OWNER TO builder;

--- END ALTER TABLE "public"."mediaitems_styledimages" ---

--- BEGIN ALTER TABLE "public"."styledimages" ---

ALTER TABLE IF EXISTS "public"."styledimages" OWNER TO builder;

--- END ALTER TABLE "public"."styledimages" ---

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

CREATE INDEX timedmetadata_id_seconds_index ON public.timedmetadata USING btree (id, seconds);

COMMENT ON INDEX "public"."timedmetadata_id_seconds_index"  IS NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata" OWNER TO builder;

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN ALTER TABLE "public"."achievementconditions_studytopics" ---

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics" OWNER TO builder;

--- END ALTER TABLE "public"."achievementconditions_studytopics" ---

--- BEGIN ALTER TABLE "public"."achievements_images" ---

ALTER TABLE IF EXISTS "public"."achievements_images" OWNER TO builder;

--- END ALTER TABLE "public"."achievements_images" ---

--- BEGIN ALTER TABLE "public"."applicationgroups_usergroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups" OWNER TO builder;

--- END ALTER TABLE "public"."applicationgroups_usergroups" ---

--- BEGIN ALTER TABLE "public"."applicationgroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups"
	ALTER COLUMN "label" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."applicationgroups" OWNER TO builder;

--- END ALTER TABLE "public"."applicationgroups" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations" OWNER TO builder;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."ageratings" ---

ALTER TABLE IF EXISTS "public"."ageratings" OWNER TO builder;

--- END ALTER TABLE "public"."ageratings" ---

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups_download" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" OWNER TO builder;

--- END ALTER TABLE "public"."mediaitems_usergroups_download" ---

--- BEGIN ALTER TABLE "public"."collections_entries" ---

ALTER TABLE IF EXISTS "public"."collections_entries" OWNER TO builder;

--- END ALTER TABLE "public"."collections_entries" ---

--- BEGIN ALTER TABLE "public"."computeddata" ---

ALTER TABLE IF EXISTS "public"."computeddata" OWNER TO builder;

--- END ALTER TABLE "public"."computeddata" ---

--- BEGIN ALTER TABLE "public"."contributions" ---

ALTER TABLE IF EXISTS "public"."contributions" OWNER TO builder;

--- END ALTER TABLE "public"."contributions" ---

--- BEGIN ALTER TABLE "public"."computeddatagroups" ---

ALTER TABLE IF EXISTS "public"."computeddatagroups" OWNER TO builder;

--- END ALTER TABLE "public"."computeddatagroups" ---

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups_earlyaccess" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" OWNER TO builder;

--- END ALTER TABLE "public"."mediaitems_usergroups_earlyaccess" ---

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups" OWNER TO builder;

--- END ALTER TABLE "public"."mediaitems_usergroups" ---

--- BEGIN ALTER TABLE "public"."faqcategories" ---

ALTER TABLE IF EXISTS "public"."faqcategories" OWNER TO builder;

--- END ALTER TABLE "public"."faqcategories" ---

--- BEGIN ALTER TABLE "public"."faqs" ---

ALTER TABLE IF EXISTS "public"."faqs" OWNER TO builder;

--- END ALTER TABLE "public"."faqs" ---

--- BEGIN ALTER TABLE "public"."episodes_assets" ---

ALTER TABLE IF EXISTS "public"."episodes_assets" OWNER TO builder;

--- END ALTER TABLE "public"."episodes_assets" ---

--- BEGIN ALTER TABLE "public"."faqs_usergroups" ---

ALTER TABLE IF EXISTS "public"."faqs_usergroups" OWNER TO builder;

--- END ALTER TABLE "public"."faqs_usergroups" ---

--- BEGIN ALTER TABLE "public"."games" ---

ALTER TABLE IF EXISTS "public"."games" OWNER TO builder;

--- END ALTER TABLE "public"."games" ---

--- BEGIN ALTER TABLE "public"."playlists_usergroups" ---

ALTER TABLE IF EXISTS "public"."playlists_usergroups" OWNER TO builder;

--- END ALTER TABLE "public"."playlists_usergroups" ---

--- BEGIN ALTER TABLE "public"."seasons_tags" ---

ALTER TABLE IF EXISTS "public"."seasons_tags" OWNER TO builder;

--- END ALTER TABLE "public"."seasons_tags" ---

--- BEGIN ALTER TABLE "public"."shows_tags" ---

ALTER TABLE IF EXISTS "public"."shows_tags" OWNER TO builder;

--- END ALTER TABLE "public"."shows_tags" ---

--- BEGIN ALTER TABLE "public"."games_translations" ---

ALTER TABLE IF EXISTS "public"."games_translations" OWNER TO builder;

--- END ALTER TABLE "public"."games_translations" ---

--- BEGIN ALTER TABLE "public"."games_styledimages" ---

ALTER TABLE IF EXISTS "public"."games_styledimages" OWNER TO builder;

--- END ALTER TABLE "public"."games_styledimages" ---

--- BEGIN ALTER TABLE "public"."games_usergroups" ---

ALTER TABLE IF EXISTS "public"."games_usergroups" OWNER TO builder;

--- END ALTER TABLE "public"."games_usergroups" ---

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links" OWNER TO builder;

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."messages" ---

ALTER TABLE IF EXISTS "public"."messages" OWNER TO builder;

--- END ALTER TABLE "public"."messages" ---

--- BEGIN ALTER TABLE "public"."notifications_targets" ---

ALTER TABLE IF EXISTS "public"."notifications_targets" OWNER TO builder;

--- END ALTER TABLE "public"."notifications_targets" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations" OWNER TO builder;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates" OWNER TO builder;

--- END ALTER TABLE "public"."notificationtemplates" ---

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" OWNER TO builder;

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN ALTER TABLE "public"."phrases" ---

ALTER TABLE IF EXISTS "public"."phrases" OWNER TO builder;

--- END ALTER TABLE "public"."phrases" ---

--- BEGIN ALTER TABLE "public"."persons" ---

ALTER TABLE IF EXISTS "public"."persons" OWNER TO builder;

--- END ALTER TABLE "public"."persons" ---

--- BEGIN ALTER TABLE "public"."playlists_translations" ---

ALTER TABLE IF EXISTS "public"."playlists_translations" OWNER TO builder;

--- END ALTER TABLE "public"."playlists_translations" ---

--- BEGIN ALTER TABLE "public"."playlists_styledimages" ---

ALTER TABLE IF EXISTS "public"."playlists_styledimages" OWNER TO builder;

--- END ALTER TABLE "public"."playlists_styledimages" ---

--- BEGIN ALTER TABLE "public"."prompts" ---

ALTER TABLE IF EXISTS "public"."prompts" OWNER TO builder;

--- END ALTER TABLE "public"."prompts" ---

--- BEGIN ALTER TABLE "public"."prompts_translations" ---

ALTER TABLE IF EXISTS "public"."prompts_translations" OWNER TO builder;

--- END ALTER TABLE "public"."prompts_translations" ---

--- BEGIN ALTER TABLE "public"."songcollections" ---

ALTER TABLE IF EXISTS "public"."songcollections" OWNER TO builder;

--- END ALTER TABLE "public"."songcollections" ---

--- BEGIN ALTER TABLE "public"."prompts_targets" ---

ALTER TABLE IF EXISTS "public"."prompts_targets" OWNER TO builder;

--- END ALTER TABLE "public"."prompts_targets" ---

--- BEGIN ALTER TABLE "public"."surveyquestions" ---

ALTER TABLE IF EXISTS "public"."surveyquestions" ADD COLUMN IF NOT EXISTS "url" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."surveyquestions"."url"  IS NULL;

ALTER TABLE IF EXISTS "public"."surveyquestions" ADD COLUMN IF NOT EXISTS "action_button_text" varchar(255) NULL DEFAULT NULL::character varying ;

COMMENT ON COLUMN "public"."surveyquestions"."action_button_text"  IS NULL;

ALTER TABLE IF EXISTS "public"."surveyquestions" ADD COLUMN IF NOT EXISTS "cancel_button_text" varchar(255) NULL DEFAULT NULL::character varying ;

COMMENT ON COLUMN "public"."surveyquestions"."cancel_button_text"  IS NULL;

ALTER TABLE IF EXISTS "public"."surveyquestions" OWNER TO builder;

--- END ALTER TABLE "public"."surveyquestions" ---

--- BEGIN ALTER TABLE "public"."songs_translations" ---

ALTER TABLE IF EXISTS "public"."songs_translations" OWNER TO builder;

--- END ALTER TABLE "public"."songs_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_images" ---

ALTER TABLE IF EXISTS "public"."studytopics_images" OWNER TO builder;

--- END ALTER TABLE "public"."studytopics_images" ---

--- BEGIN ALTER TABLE "public"."surveyquestions_translations" ---

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" ADD COLUMN IF NOT EXISTS "action_button_text" text NULL  ;

COMMENT ON COLUMN "public"."surveyquestions_translations"."action_button_text"  IS NULL;

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" ADD COLUMN IF NOT EXISTS "cancel_button_text" text NULL  ;

COMMENT ON COLUMN "public"."surveyquestions_translations"."cancel_button_text"  IS NULL;

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" OWNER TO builder;

--- END ALTER TABLE "public"."surveyquestions_translations" ---

--- BEGIN ALTER TABLE "public"."surveys" ---

ALTER TABLE IF EXISTS "public"."surveys" OWNER TO builder;

--- END ALTER TABLE "public"."surveys" ---

--- BEGIN ALTER TABLE "public"."surveys_translations" ---

ALTER TABLE IF EXISTS "public"."surveys_translations" OWNER TO builder;

--- END ALTER TABLE "public"."surveys_translations" ---

--- BEGIN ALTER TABLE "public"."songcollections_translations" ---

ALTER TABLE IF EXISTS "public"."songcollections_translations" OWNER TO builder;

--- END ALTER TABLE "public"."songcollections_translations" ---

--- BEGIN ALTER TABLE "public"."targets_usergroups" ---

ALTER TABLE IF EXISTS "public"."targets_usergroups" OWNER TO builder;

--- END ALTER TABLE "public"."targets_usergroups" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_translations" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_translations" OWNER TO builder;

--- END ALTER TABLE "public"."timedmetadata_translations" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_styledimages" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_styledimages" OWNER TO builder;

--- END ALTER TABLE "public"."timedmetadata_styledimages" ---

--- BEGIN ALTER VIEW "public"."mediaitems_view" ---

ALTER TABLE IF EXISTS "public"."mediaitems_view" OWNER TO builder;

--- END ALTER VIEW "public"."mediaitems_view" ---

--- BEGIN ALTER VIEW "public"."mediaitems_view_v2" ---

ALTER TABLE IF EXISTS "public"."mediaitems_view_v2" OWNER TO builder;

--- END ALTER VIEW "public"."mediaitems_view_v2" ---

--- BEGIN ALTER VIEW "public"."episode_availability" ---

ALTER TABLE IF EXISTS "public"."episode_availability" OWNER TO builder;

--- END ALTER VIEW "public"."episode_availability" ---

--- BEGIN ALTER VIEW "public"."episode_roles" ---

ALTER TABLE IF EXISTS "public"."episode_roles" OWNER TO builder;

--- END ALTER VIEW "public"."episode_roles" ---

--- BEGIN ALTER VIEW "public"."season_roles" ---

ALTER TABLE IF EXISTS "public"."season_roles" OWNER TO builder;

--- END ALTER VIEW "public"."season_roles" ---

--- BEGIN ALTER VIEW "public"."show_roles" ---

ALTER TABLE IF EXISTS "public"."show_roles" OWNER TO builder;

--- END ALTER VIEW "public"."show_roles" ---

--- BEGIN ALTER VIEW "public"."season_availability" ---

ALTER TABLE IF EXISTS "public"."season_availability" OWNER TO builder;

--- END ALTER VIEW "public"."season_availability" ---

--- BEGIN ALTER VIEW "public"."show_availability" ---

ALTER TABLE IF EXISTS "public"."show_availability" OWNER TO builder;

--- END ALTER VIEW "public"."show_availability" ---

--- BEGIN ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

CREATE UNIQUE INDEX filter_dataset_uuid ON public.filter_dataset USING btree (uuid);

COMMENT ON INDEX "public"."filter_dataset_uuid"  IS NULL;

--- END ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

--- BEGIN ALTER FUNCTION "public"."update_view"(character varying) ---

ALTER FUNCTION "public"."update_view"(character varying) OWNER TO builder;
--- END ALTER FUNCTION "public"."update_view"(character varying) ---

--- BEGIN ALTER FUNCTION "public"."filter_dataset"(character varying[]) ---

ALTER FUNCTION "public"."filter_dataset"(character varying[]) OWNER TO builder;
--- END ALTER FUNCTION "public"."filter_dataset"(character varying[]) ---

--- BEGIN ALTER FUNCTION "public"."mediaitems_by_episodes"(integer[]) ---

ALTER FUNCTION "public"."mediaitems_by_episodes"(integer[]) OWNER TO builder;
--- END ALTER FUNCTION "public"."mediaitems_by_episodes"(integer[]) ---

--- BEGIN ALTER FUNCTION "public"."mediaitems_by_episodes_v2"(integer[]) ---

ALTER FUNCTION "public"."mediaitems_by_episodes_v2"(integer[]) OWNER TO builder;
--- END ALTER FUNCTION "public"."mediaitems_by_episodes_v2"(integer[]) ---

--- BEGIN ALTER FUNCTION "public"."update_primary_episode"() ---

ALTER FUNCTION "public"."update_primary_episode"() OWNER TO builder;
--- END ALTER FUNCTION "public"."update_primary_episode"() ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"layout":"table","fields":["label","seconds","title"],"enableSelect":false}' WHERE "id" = 1298;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3043, 'surveyquestions', 'cancel_button_text', NULL, 'input', '{"softLength":30,"trim":true}', 'raw', NULL, false, true, 15, 'full', NULL, 'Helper text.', '[{"name":"type == link","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3042, 'surveyquestions', 'action_button_text', NULL, 'input', '{"softLength":30}', 'raw', NULL, false, true, 14, 'full', NULL, 'Text that appears on the "Call to action" button.', '[{"name":"type == link","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3041, 'surveyquestions', 'url', NULL, 'input', '{"placeholder":"https://www.example.com/","trim":true}', NULL, NULL, false, true, 13, 'full', NULL, NULL, '[{"name":"if Type=Link","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', true, NULL, '{"_and":[{"_or":[{"_and":[{"type":{"_in":["link"]}},{"url":{"_nnull":true}}]},{"type":{"_nin":["link"]}}]}]}', NULL);

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"text","value":"text"},{"text":"rating","value":"rating"},{"text":"link","value":"link","icon":"dataset_linked"}]}' WHERE "id" = 1064;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2024-11-11T09:33:11.433Z            ***/
/**********************************************************/

--- BEGIN CREATE SEQUENCE "public"."tvguideentry_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."tvguideentry_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."tvguideentry_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."tvguideentry_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."tvguideentry_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."tvguideentry_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."tvguideentry_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."tvguideentry_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."tvguideentry_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."tvguideentry_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."tvguideentry_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."appconfig_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."appconfig_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."appconfig_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."appconfig_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."appconfig_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."appconfig_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."appconfig_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."appconfig_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."appconfig_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."appconfig_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."appconfig_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."images_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."images_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."images_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."sections_links_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."sections_links_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."sections_links_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."shows_tags_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."shows_tags_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."shows_tags_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."seasons_tags_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."seasons_tags_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."seasons_tags_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."links_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."links_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."links_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notifications_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."notifications_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."notifications_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notifications_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."notifications_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."notifications_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."links_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."links_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."links_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievementgroups_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."achievementgroups_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."achievementgroups_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievements_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."achievements_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."achievements_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notifications_targets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."notifications_targets_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."notifications_targets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."targets_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."targets_usergroups_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."targets_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."surveys_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."surveys_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."surveys_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."surveyquestions_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."surveyquestions_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."surveyquestions_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."surveys_targets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."surveys_targets_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."surveys_targets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."prompts_targets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."prompts_targets_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."prompts_targets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."prompts_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."prompts_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."prompts_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievementconditions_studytopics_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."achievementconditions_studytopics_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."achievementconditions_studytopics_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."faqs_usergroups_id_seq1" ---

ALTER SEQUENCE IF EXISTS "public"."faqs_usergroups_id_seq1" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."faqs_usergroups_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."faqs_translations_id_seq1" ---

ALTER SEQUENCE IF EXISTS "public"."faqs_translations_id_seq1" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."faqs_translations_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."faqcategories_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."faqcategories_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."faqcategories_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faqs_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqs_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faqs_translations_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."faqs_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqs_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."faqs_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqs_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."faqs_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faqs_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faqs_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqs_usergroups_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faqs_usergroups_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."faqs_usergroups_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqs_usergroups_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_usergroups_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."faqs_usergroups_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqs_usergroups_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_usergroups_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."faqs_usergroups_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faqs_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."lists_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."lists_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."lists_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."lists_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."lists_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."lists_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."lists_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."lists_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."lists_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."lists_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."lists_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."lists_relations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."lists_relations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."lists_relations_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."lists_relations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."lists_relations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."lists_relations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."lists_relations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."lists_relations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."lists_relations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."lists_relations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."lists_relations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."games_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."games_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."games_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."games_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."games_usergroups_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."games_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."games_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."games_styledimages_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."games_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."timedmetadata_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."timedmetadata_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."timedmetadata_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."songcollections_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."songcollections_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."songcollections_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."phrases_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."phrases_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."phrases_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."songs_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."songs_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."songs_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."playlists_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."playlists_styledimages_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."playlists_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."timedmetadata_persons_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."timedmetadata_persons_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."timedmetadata_persons_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."playlists_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."playlists_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."playlists_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."playlists_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."playlists_usergroups_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."playlists_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."mediaitems_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."shorts_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."shorts_usergroups_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."shorts_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_tags_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_tags_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."mediaitems_tags_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_styledimages_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."mediaitems_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."applicationgroups_usergroups_ls_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."applicationgroups_usergroups_ls_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."episodes_assets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."episodes_assets_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."episodes_assets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_assets_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_assets_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."mediaitems_assets_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_usergroups_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."mediaitems_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_usergroups_download_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_usergroups_download_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."mediaitems_usergroups_download_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_usergroups_earlyaccess_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."calendarevent_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."calendarevent_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."calendarevent_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."calendarevent_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."calendarevent_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."calendarevent_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."calendarevent_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."calendarevent_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."calendarevent_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."calendarevent_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."calendarevent_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."categories_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."categories_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."categories_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."categories_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."categories_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."categories_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."categories_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."categories_translations_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."categories_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."categories_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."categories_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."categories_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."categories_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."categories_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."categories_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."categories_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."collections_items_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."collections_items_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."collections_items_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."collections_items_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."collections_items_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."collections_items_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."collections_items_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."collections_items_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."collections_items_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."collections_items_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."collections_items_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."episodes_categories_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."episodes_categories_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."episodes_categories_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."episodes_categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."episodes_categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."episodes_categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."episodes_categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."episodes_categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."episodes_categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."episodes_categories_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."episodes_categories_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faq_categories_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faq_categories_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faq_categories_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."faq_categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faq_categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faq_categories_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."faq_categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faq_categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faq_categories_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."faq_categories_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faq_categories_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faq_categories_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faq_categories_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faq_categories_translations_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."faq_categories_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faq_categories_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faq_categories_translations_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."faq_categories_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faq_categories_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faq_categories_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."faq_categories_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faq_categories_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."faqs_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."faqs_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."faqs_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."faqs_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqs_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."faqs_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqs_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."faqs_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."faqs_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."maintenancemessage_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."maintenancemessage_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."maintenancemessage_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."maintenancemessage_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."maintenancemessage_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."maintenancemessage_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."maintenancemessage_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."maintenancemessage_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."maintenancemessage_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."maintenancemessage_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."maintenancemessage_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."maintenancemessage_messagetemplates_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."maintenancemessage_messagetemplates_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."webconfig_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."webconfig_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."webconfig_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."webconfig_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."webconfig_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."webconfig_id_seq" TO matjaz; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."webconfig_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."webconfig_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."webconfig_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."webconfig_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."webconfig_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."notificationtemplates_translations_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."messages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."messages_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."messages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."messages_messagetemplates_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."messages_messagetemplates_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."messages_messagetemplates_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."collections_entries_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."collections_entries_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."collections_entries_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq1" ---

ALTER SEQUENCE IF EXISTS "public"."notificationtemplates_translations_id_seq1" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."notificationtemplates_translations_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."applicationgroups_usergroups_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."applicationgroups_usergroups_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."applicationgroups_usergroups_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."mediaitems_contributions_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."mediaitems_contributions_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."mediaitems_contributions_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."contributions_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."contributions_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."contributions_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."timedmetadata_contributions_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."timedmetadata_contributions_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."timedmetadata_contributions_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."timedmetadata_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."timedmetadata_styledimages_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."timedmetadata_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."persons_styledimages_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."persons_styledimages_id_seq" OWNER TO bccm;

--- END ALTER SEQUENCE "public"."persons_styledimages_id_seq" ---

--- BEGIN ALTER TABLE "public"."ageratings" ---

ALTER TABLE IF EXISTS "public"."ageratings" OWNER TO manager;

--- END ALTER TABLE "public"."ageratings" ---

--- BEGIN ALTER TABLE "public"."shows_tags" ---

ALTER TABLE IF EXISTS "public"."shows_tags" OWNER TO bccm;

--- END ALTER TABLE "public"."shows_tags" ---

--- BEGIN ALTER TABLE "public"."seasons_tags" ---

ALTER TABLE IF EXISTS "public"."seasons_tags" OWNER TO bccm;

--- END ALTER TABLE "public"."seasons_tags" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" OWNER TO bccm;

--- END ALTER TABLE "public"."images" ---

--- BEGIN ALTER TABLE "users"."profiles" ---

ALTER TABLE IF EXISTS "users"."profiles" ADD CONSTRAINT "profiles_applicationgroups_id_fk" FOREIGN KEY (applicationgroup_id) REFERENCES applicationgroups(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "profiles_applicationgroups_id_fk" ON "users"."profiles" IS NULL;

--- END ALTER TABLE "users"."profiles" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

ALTER TABLE IF EXISTS "public"."links_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links" OWNER TO bccm;

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."notifications" ---

ALTER TABLE IF EXISTS "public"."notifications" OWNER TO bccm;

--- END ALTER TABLE "public"."notifications" ---

--- BEGIN ALTER TABLE "public"."messages" ---

ALTER TABLE IF EXISTS "public"."messages" OWNER TO bccm;

--- END ALTER TABLE "public"."messages" ---

--- BEGIN ALTER TABLE "public"."messages_messagetemplates" ---

ALTER TABLE IF EXISTS "public"."messages_messagetemplates" OWNER TO bccm;

--- END ALTER TABLE "public"."messages_messagetemplates" ---

--- BEGIN ALTER TABLE "public"."collections_entries" ---

ALTER TABLE IF EXISTS "public"."collections_entries" OWNER TO bccm;

--- END ALTER TABLE "public"."collections_entries" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates" OWNER TO bccm;

--- END ALTER TABLE "public"."notificationtemplates" ---

--- BEGIN ALTER TABLE "users"."progress" ---

ALTER TABLE IF EXISTS "users"."progress" ADD CONSTRAINT "progress_episode_id_fk" FOREIGN KEY (episode_id) REFERENCES episodes(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "progress_episode_id_fk" ON "users"."progress" IS NULL;

ALTER TABLE IF EXISTS "users"."progress" ADD CONSTRAINT "progress_show_id_fk" FOREIGN KEY (show_id) REFERENCES shows(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "progress_show_id_fk" ON "users"."progress" IS NULL;

--- END ALTER TABLE "users"."progress" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "users"."taskanswers" ---

ALTER TABLE IF EXISTS "users"."taskanswers" ADD CONSTRAINT "taskanswers_tasks_id_fk" FOREIGN KEY (task_id) REFERENCES tasks(id);

COMMENT ON CONSTRAINT "taskanswers_tasks_id_fk" ON "users"."taskanswers" IS NULL;

--- END ALTER TABLE "users"."taskanswers" ---

--- BEGIN ALTER TABLE "public"."achievementgroups" ---

ALTER TABLE IF EXISTS "public"."achievementgroups" OWNER TO bccm;

--- END ALTER TABLE "public"."achievementgroups" ---

--- BEGIN ALTER TABLE "public"."achievements" ---

ALTER TABLE IF EXISTS "public"."achievements" OWNER TO bccm;

--- END ALTER TABLE "public"."achievements" ---

--- BEGIN ALTER TABLE "public"."achievements_images" ---

ALTER TABLE IF EXISTS "public"."achievements_images" OWNER TO bccm;

--- END ALTER TABLE "public"."achievements_images" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

ALTER TABLE IF EXISTS "public"."achievementgroups_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_images" ---

ALTER TABLE IF EXISTS "public"."studytopics_images" OWNER TO bccm;

--- END ALTER TABLE "public"."studytopics_images" ---

--- BEGIN ALTER TABLE "users"."achievements" ---

ALTER TABLE IF EXISTS "users"."achievements" ADD CONSTRAINT "achievements_achievements_id_fk" FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievements_achievements_id_fk" ON "users"."achievements" IS NULL;

--- END ALTER TABLE "users"."achievements" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."achievementconditions" ---

ALTER TABLE IF EXISTS "public"."achievementconditions" OWNER TO bccm;

--- END ALTER TABLE "public"."achievementconditions" ---

--- BEGIN ALTER TABLE "public"."lessons_images" ---

ALTER TABLE IF EXISTS "public"."lessons_images" OWNER TO bccm;

--- END ALTER TABLE "public"."lessons_images" ---

--- BEGIN ALTER TABLE "public"."computeddata" ---

ALTER TABLE IF EXISTS "public"."computeddata" OWNER TO bccm;

--- END ALTER TABLE "public"."computeddata" ---

--- BEGIN ALTER TABLE "public"."targets" ---

ALTER TABLE IF EXISTS "public"."targets" OWNER TO bccm;

--- END ALTER TABLE "public"."targets" ---

--- BEGIN ALTER TABLE "public"."targets_usergroups" ---

ALTER TABLE IF EXISTS "public"."targets_usergroups" OWNER TO bccm;

--- END ALTER TABLE "public"."targets_usergroups" ---

--- BEGIN ALTER TABLE "public"."notifications_targets" ---

ALTER TABLE IF EXISTS "public"."notifications_targets" OWNER TO bccm;

--- END ALTER TABLE "public"."notifications_targets" ---

--- BEGIN ALTER TABLE "public"."computeddatagroups" ---

ALTER TABLE IF EXISTS "public"."computeddatagroups" OWNER TO bccm;

--- END ALTER TABLE "public"."computeddatagroups" ---

--- BEGIN ALTER TABLE "public"."computeddata_conditions" ---

ALTER TABLE IF EXISTS "public"."computeddata_conditions" OWNER TO bccm;

--- END ALTER TABLE "public"."computeddata_conditions" ---

--- BEGIN ALTER TABLE "public"."surveyquestions" ---

ALTER TABLE IF EXISTS "public"."surveyquestions" DROP COLUMN IF EXISTS "url" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."surveyquestions" DROP COLUMN IF EXISTS "action_button_text" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."surveyquestions" DROP COLUMN IF EXISTS "cancel_button_text" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."surveyquestions" OWNER TO bccm;

--- END ALTER TABLE "public"."surveyquestions" ---

--- BEGIN ALTER TABLE "public"."surveys" ---

ALTER TABLE IF EXISTS "public"."surveys" OWNER TO bccm;

--- END ALTER TABLE "public"."surveys" ---

--- BEGIN ALTER TABLE "users"."collections" ---

ALTER TABLE IF EXISTS "users"."collections" ADD CONSTRAINT "collections_applicationgroups_id_fk" FOREIGN KEY (applicationgroup_id) REFERENCES applicationgroups(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "collections_applicationgroups_id_fk" ON "users"."collections" IS NULL;

--- END ALTER TABLE "users"."collections" ---

--- BEGIN ALTER TABLE "public"."surveyquestions_translations" ---

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" DROP COLUMN IF EXISTS "action_button_text" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" DROP COLUMN IF EXISTS "cancel_button_text" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."surveyquestions_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."surveyquestions_translations" ---

--- BEGIN ALTER TABLE "public"."surveys_translations" ---

ALTER TABLE IF EXISTS "public"."surveys_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."surveys_translations" ---

--- BEGIN ALTER TABLE "users"."surveyquestionanswers" ---

ALTER TABLE IF EXISTS "users"."surveyquestionanswers" ADD CONSTRAINT "surveyquestionanswers_surveyquestions_id_fk" FOREIGN KEY (question_id) REFERENCES surveyquestions(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "surveyquestionanswers_surveyquestions_id_fk" ON "users"."surveyquestionanswers" IS NULL;

--- END ALTER TABLE "users"."surveyquestionanswers" ---

--- BEGIN ALTER TABLE "public"."prompts" ---

ALTER TABLE IF EXISTS "public"."prompts" OWNER TO bccm;

--- END ALTER TABLE "public"."prompts" ---

--- BEGIN ALTER TABLE "public"."prompts_translations" ---

ALTER TABLE IF EXISTS "public"."prompts_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."prompts_translations" ---

--- BEGIN ALTER TABLE "public"."prompts_targets" ---

ALTER TABLE IF EXISTS "public"."prompts_targets" OWNER TO bccm;

--- END ALTER TABLE "public"."prompts_targets" ---

--- BEGIN ALTER TABLE "public"."achievementconditions_studytopics" ---

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics" OWNER TO bccm;

--- END ALTER TABLE "public"."achievementconditions_studytopics" ---

--- BEGIN ALTER TABLE "public"."faqcategories" ---

ALTER TABLE IF EXISTS "public"."faqcategories" OWNER TO bccm;

--- END ALTER TABLE "public"."faqcategories" ---

--- BEGIN ALTER TABLE "public"."faqs_usergroups" ---

ALTER TABLE IF EXISTS "public"."faqs_usergroups" OWNER TO bccm;

--- END ALTER TABLE "public"."faqs_usergroups" ---

--- BEGIN ALTER TABLE "public"."faqs_translations" ---

ALTER TABLE IF EXISTS "public"."faqs_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."faqs_translations" ---

--- BEGIN ALTER TABLE "public"."faqs" ---

ALTER TABLE IF EXISTS "public"."faqs" OWNER TO bccm;

--- END ALTER TABLE "public"."faqs" ---

--- BEGIN ALTER TABLE "public"."faqcategories_translations" ---

ALTER TABLE IF EXISTS "public"."faqcategories_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."faqcategories_translations" ---

--- BEGIN ALTER TABLE "public"."directus_translations" ---

ALTER TABLE IF EXISTS "public"."directus_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."directus_translations" ---

--- BEGIN ALTER TABLE "public"."games" ---

ALTER TABLE IF EXISTS "public"."games" OWNER TO bccm;

--- END ALTER TABLE "public"."games" ---

--- BEGIN ALTER TABLE "public"."applicationgroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups"
	ALTER COLUMN "label" SET DEFAULT ''::text;

ALTER TABLE IF EXISTS "public"."applicationgroups" OWNER TO bccm;

--- END ALTER TABLE "public"."applicationgroups" ---

--- BEGIN ALTER TABLE "public"."applicationgroups_usergroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups" OWNER TO bccm;

--- END ALTER TABLE "public"."applicationgroups_usergroups" ---

--- BEGIN ALTER TABLE "public"."games_usergroups" ---

ALTER TABLE IF EXISTS "public"."games_usergroups" OWNER TO bccm;

--- END ALTER TABLE "public"."games_usergroups" ---

--- BEGIN ALTER TABLE "public"."games_translations" ---

ALTER TABLE IF EXISTS "public"."games_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."games_translations" ---

--- BEGIN ALTER TABLE "public"."styledimages" ---

ALTER TABLE IF EXISTS "public"."styledimages" OWNER TO bccm;

--- END ALTER TABLE "public"."styledimages" ---

--- BEGIN ALTER TABLE "public"."games_styledimages" ---

ALTER TABLE IF EXISTS "public"."games_styledimages" OWNER TO bccm;

--- END ALTER TABLE "public"."games_styledimages" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_translations" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."timedmetadata_translations" ---

--- BEGIN ALTER TABLE "public"."timedmetadata" ---

DROP INDEX IF EXISTS timedmetadata_id_seconds_index;

ALTER TABLE IF EXISTS "public"."timedmetadata" OWNER TO bccm;

--- END ALTER TABLE "public"."timedmetadata" ---

--- BEGIN ALTER TABLE "public"."songs" ---

ALTER TABLE IF EXISTS "public"."songs" OWNER TO bccm;

--- END ALTER TABLE "public"."songs" ---

--- BEGIN ALTER TABLE "public"."songcollections" ---

ALTER TABLE IF EXISTS "public"."songcollections" OWNER TO bccm;

--- END ALTER TABLE "public"."songcollections" ---

--- BEGIN ALTER TABLE "public"."songcollections_translations" ---

ALTER TABLE IF EXISTS "public"."songcollections_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."songcollections_translations" ---

--- BEGIN ALTER TABLE "public"."phrases" ---

ALTER TABLE IF EXISTS "public"."phrases" OWNER TO bccm;

--- END ALTER TABLE "public"."phrases" ---

--- BEGIN ALTER TABLE "public"."persons" ---

ALTER TABLE IF EXISTS "public"."persons" OWNER TO bccm;

--- END ALTER TABLE "public"."persons" ---

--- BEGIN ALTER TABLE "public"."phrases_translations" ---

ALTER TABLE IF EXISTS "public"."phrases_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."phrases_translations" ---

--- BEGIN ALTER TABLE "public"."playlists" ---

ALTER TABLE IF EXISTS "public"."playlists" OWNER TO bccm;

--- END ALTER TABLE "public"."playlists" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_persons" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_persons" OWNER TO bccm;

--- END ALTER TABLE "public"."timedmetadata_persons" ---

--- BEGIN ALTER TABLE "public"."songs_translations" ---

ALTER TABLE IF EXISTS "public"."songs_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."songs_translations" ---

--- BEGIN ALTER TABLE "public"."playlists_usergroups" ---

ALTER TABLE IF EXISTS "public"."playlists_usergroups" OWNER TO bccm;

--- END ALTER TABLE "public"."playlists_usergroups" ---

--- BEGIN ALTER TABLE "public"."playlists_styledimages" ---

ALTER TABLE IF EXISTS "public"."playlists_styledimages" OWNER TO bccm;

--- END ALTER TABLE "public"."playlists_styledimages" ---

--- BEGIN ALTER TABLE "public"."playlists_translations" ---

ALTER TABLE IF EXISTS "public"."playlists_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."playlists_translations" ---

--- BEGIN ALTER TABLE "public"."directus_versions" ---

ALTER TABLE IF EXISTS "public"."directus_versions" OWNER TO bccm;

--- END ALTER TABLE "public"."directus_versions" ---

--- BEGIN ALTER TABLE "public"."directus_extensions" ---

ALTER TABLE IF EXISTS "public"."directus_extensions" OWNER TO bccm;

--- END ALTER TABLE "public"."directus_extensions" ---

--- BEGIN ALTER TABLE "public"."mediaitems_translations" ---

DROP INDEX IF EXISTS mediaitems_translations_mediaitems_id_index;

ALTER TABLE IF EXISTS "public"."mediaitems_translations" OWNER TO bccm;

--- END ALTER TABLE "public"."mediaitems_translations" ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems" OWNER TO bccm;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN ALTER TABLE "public"."shorts" ---

ALTER TABLE IF EXISTS "public"."shorts" OWNER TO bccm;

--- END ALTER TABLE "public"."shorts" ---

--- BEGIN ALTER TABLE "public"."shorts_usergroups" ---

ALTER TABLE IF EXISTS "public"."shorts_usergroups" OWNER TO bccm;

--- END ALTER TABLE "public"."shorts_usergroups" ---

--- BEGIN ALTER TABLE "public"."mediaitems_tags" ---

ALTER TABLE IF EXISTS "public"."mediaitems_tags" OWNER TO bccm;

--- END ALTER TABLE "public"."mediaitems_tags" ---

--- BEGIN ALTER TABLE "public"."episodes_assets" ---

ALTER TABLE IF EXISTS "public"."episodes_assets" OWNER TO bccm;

--- END ALTER TABLE "public"."episodes_assets" ---

--- BEGIN ALTER TABLE "public"."mediaitems_styledimages" ---

ALTER TABLE IF EXISTS "public"."mediaitems_styledimages" OWNER TO bccm;

--- END ALTER TABLE "public"."mediaitems_styledimages" ---

--- BEGIN ALTER TABLE "public"."applicationgroups_usergroups_ls" ---

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups_ls" OWNER TO bccm;

--- END ALTER TABLE "public"."applicationgroups_usergroups_ls" ---

--- BEGIN ALTER TABLE "public"."mediaitems_assets" ---

ALTER TABLE IF EXISTS "public"."mediaitems_assets" OWNER TO bccm;

--- END ALTER TABLE "public"."mediaitems_assets" ---

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups_download" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_download" OWNER TO bccm;

--- END ALTER TABLE "public"."mediaitems_usergroups_download" ---

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups" OWNER TO bccm;

--- END ALTER TABLE "public"."mediaitems_usergroups" ---

--- BEGIN ALTER TABLE "public"."mediaitems_usergroups_earlyaccess" ---

ALTER TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess" OWNER TO bccm;

--- END ALTER TABLE "public"."mediaitems_usergroups_earlyaccess" ---

--- BEGIN ALTER TABLE "public"."contributions" ---

ALTER TABLE IF EXISTS "public"."contributions" OWNER TO bccm;

--- END ALTER TABLE "public"."contributions" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_styledimages" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_styledimages" OWNER TO bccm;

--- END ALTER TABLE "public"."timedmetadata_styledimages" ---

--- BEGIN ALTER TABLE "public"."persons_styledimages" ---

ALTER TABLE IF EXISTS "public"."persons_styledimages" OWNER TO bccm;

--- END ALTER TABLE "public"."persons_styledimages" ---

--- BEGIN ALTER VIEW "public"."episode_availability" ---

ALTER TABLE IF EXISTS "public"."episode_availability" OWNER TO bccm;

--- END ALTER VIEW "public"."episode_availability" ---

--- BEGIN ALTER VIEW "public"."season_availability" ---

ALTER TABLE IF EXISTS "public"."season_availability" OWNER TO bccm;

--- END ALTER VIEW "public"."season_availability" ---

--- BEGIN ALTER VIEW "public"."episode_roles" ---

ALTER TABLE IF EXISTS "public"."episode_roles" OWNER TO bccm;

--- END ALTER VIEW "public"."episode_roles" ---

--- BEGIN ALTER VIEW "public"."season_roles" ---

ALTER TABLE IF EXISTS "public"."season_roles" OWNER TO bccm;

--- END ALTER VIEW "public"."season_roles" ---

--- BEGIN ALTER VIEW "public"."show_roles" ---

ALTER TABLE IF EXISTS "public"."show_roles" OWNER TO bccm;

--- END ALTER VIEW "public"."show_roles" ---

--- BEGIN ALTER VIEW "public"."show_availability" ---

ALTER TABLE IF EXISTS "public"."show_availability" OWNER TO bccm;

--- END ALTER VIEW "public"."show_availability" ---

--- BEGIN ALTER VIEW "public"."mediaitems_view" ---

ALTER TABLE IF EXISTS "public"."mediaitems_view" OWNER TO bccm;

--- END ALTER VIEW "public"."mediaitems_view" ---

--- BEGIN ALTER VIEW "public"."mediaitems_view_v2" ---

ALTER TABLE IF EXISTS "public"."mediaitems_view_v2" OWNER TO bccm;

--- END ALTER VIEW "public"."mediaitems_view_v2" ---

--- BEGIN ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

DROP INDEX IF EXISTS filter_dataset_uuid;

--- END ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

--- BEGIN ALTER FUNCTION "public"."mediaitems_by_episodes"(integer[]) ---

ALTER FUNCTION "public"."mediaitems_by_episodes"(integer[]) OWNER TO bccm;
--- END ALTER FUNCTION "public"."mediaitems_by_episodes"(integer[]) ---

--- BEGIN ALTER FUNCTION "public"."update_primary_episode"() ---

ALTER FUNCTION "public"."update_primary_episode"() OWNER TO bccm;
--- END ALTER FUNCTION "public"."update_primary_episode"() ---

--- BEGIN ALTER FUNCTION "public"."update_view"(character varying) ---

ALTER FUNCTION "public"."update_view"(character varying) OWNER TO bccm;
--- END ALTER FUNCTION "public"."update_view"(character varying) ---

--- BEGIN ALTER FUNCTION "public"."mediaitems_by_episodes_v2"(integer[]) ---

ALTER FUNCTION "public"."mediaitems_by_episodes_v2"(integer[]) OWNER TO bccm;
--- END ALTER FUNCTION "public"."mediaitems_by_episodes_v2"(integer[]) ---

--- BEGIN ALTER FUNCTION "public"."filter_dataset"(character varying[]) ---

ALTER FUNCTION "public"."filter_dataset"(character varying[]) OWNER TO bccm;
--- END ALTER FUNCTION "public"."filter_dataset"(character varying[]) ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"text","value":"text"},{"text":"rating","value":"rating"}]}' WHERE "id" = 1064;

UPDATE "public"."directus_fields" SET "options" = '{"layout":"table","fields":["label","timestamp","title"],"enableSelect":false}' WHERE "id" = 1298;

DELETE FROM "public"."directus_fields" WHERE "id" = 3043;

DELETE FROM "public"."directus_fields" WHERE "id" = 3042;

DELETE FROM "public"."directus_fields" WHERE "id" = 3041;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
