-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-07T14:36:46.806Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."tags_translations" ---

ALTER TABLE IF EXISTS "public"."tags_translations"
    DROP CONSTRAINT IF EXISTS "tags_translations_tags_id_foreign";

DROP INDEX IF EXISTS tags_translations_languages_code_tags_id_uindex;

ALTER TABLE IF EXISTS "public"."tags_translations"
    ALTER COLUMN "tags_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."tags_translations"
    ADD CONSTRAINT "tags_translations_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tags_translations_tags_id_foreign" ON "public"."tags_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."tags_translations"
    DROP CONSTRAINT IF EXISTS "tags_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."tags_translations"
    ADD CONSTRAINT "tags_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tags_translations_languages_code_foreign" ON "public"."tags_translations" IS NULL;

CREATE UNIQUE INDEX tags_translations_languages_code_tags_id_uindex ON public.tags_translations USING btree (languages_code, tags_id);

COMMENT ON INDEX "public"."tags_translations_languages_code_tags_id_uindex" IS NULL;

--- END ALTER TABLE "public"."tags_translations" ---

--- BEGIN ALTER TABLE "public"."playlists" ---

ALTER TABLE IF EXISTS "public"."playlists"
    DROP CONSTRAINT IF EXISTS "playlists_collection_id_foreign";

ALTER TABLE IF EXISTS "public"."playlists"
    ADD CONSTRAINT "playlists_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES collections (id) ON DELETE RESTRICT;

COMMENT ON CONSTRAINT "playlists_collection_id_foreign" ON "public"."playlists" IS NULL;

--- END ALTER TABLE "public"."playlists" ---

--- BEGIN ALTER TABLE "public"."playlists_translations" ---

ALTER TABLE IF EXISTS "public"."playlists_translations"
    DROP CONSTRAINT IF EXISTS "playlists_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."playlists_translations"
    ADD CONSTRAINT "playlists_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "playlists_translations_languages_code_foreign" ON "public"."playlists_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."playlists_translations"
    DROP CONSTRAINT IF EXISTS "playlists_translations_playlists_id_foreign";

ALTER TABLE IF EXISTS "public"."playlists_translations"
    ADD CONSTRAINT "playlists_translations_playlists_id_foreign" FOREIGN KEY (playlists_id) REFERENCES playlists (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "playlists_translations_playlists_id_foreign" ON "public"."playlists_translations" IS NULL;

--- END ALTER TABLE "public"."playlists_translations" ---

--- BEGIN ALTER TABLE "public"."events_translations" ---

ALTER TABLE IF EXISTS "public"."events_translations"
    DROP CONSTRAINT IF EXISTS "events_translations_events_id_foreign";

DROP INDEX IF EXISTS events_translations_events_id_languages_code_index;

DELETE FROM "public"."events_translations" WHERE events_id IS NULL;

ALTER TABLE IF EXISTS "public"."events_translations"
    ALTER COLUMN "events_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."events_translations"
    DROP CONSTRAINT IF EXISTS "events_translations_languages_code_foreign";

DROP INDEX IF EXISTS events_translations_events_id_languages_code_index;

ALTER TABLE IF EXISTS "public"."events_translations"
    ALTER COLUMN "languages_code" SET NOT NULL,
    ALTER COLUMN "languages_code" DROP DEFAULT;

ALTER TABLE IF EXISTS "public"."events_translations"
    ADD CONSTRAINT "events_translations_events_id_foreign" FOREIGN KEY (events_id) REFERENCES events (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "events_translations_events_id_foreign" ON "public"."events_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."events_translations"
    ADD CONSTRAINT "events_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "events_translations_languages_code_foreign" ON "public"."events_translations" IS NULL;

CREATE INDEX events_translations_events_id_languages_code_index ON public.events_translations USING btree (events_id, languages_code);

COMMENT ON INDEX "public"."events_translations_events_id_languages_code_index" IS NULL;

--- END ALTER TABLE "public"."events_translations" ---

--- BEGIN ALTER TABLE "public"."shows_tags" ---

ALTER TABLE IF EXISTS "public"."shows_tags"
    DROP CONSTRAINT IF EXISTS "shows_tags_shows_id_foreign";

ALTER TABLE IF EXISTS "public"."shows_tags"
    ALTER COLUMN "shows_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."shows_tags"
    DROP CONSTRAINT IF EXISTS "shows_tags_tags_id_foreign";

ALTER TABLE IF EXISTS "public"."shows_tags"
    ALTER COLUMN "tags_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."shows_tags"
    ADD CONSTRAINT "shows_tags_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "shows_tags_tags_id_foreign" ON "public"."shows_tags" IS NULL;

ALTER TABLE IF EXISTS "public"."shows_tags"
    ADD CONSTRAINT "shows_tags_shows_id_foreign" FOREIGN KEY (shows_id) REFERENCES shows (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "shows_tags_shows_id_foreign" ON "public"."shows_tags" IS NULL;

--- END ALTER TABLE "public"."shows_tags" ---

--- BEGIN ALTER TABLE "public"."collections_entries" ---

ALTER TABLE IF EXISTS "public"."collections_entries"
    ALTER COLUMN "item" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."collections_entries"
    ALTER COLUMN "collection" SET NOT NULL;

--- END ALTER TABLE "public"."collections_entries" ---

--- BEGIN ALTER TABLE "public"."messages_messagetemplates" ---

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    DROP CONSTRAINT IF EXISTS "messages_messagetemplates_messages_id_foreign";

DELETE FROM messages_messagetemplates WHERE messages_id IS NULL;

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    ALTER COLUMN "messages_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    DROP CONSTRAINT IF EXISTS "messages_messagetemplates_messagetemplates_id_foreign";

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    ALTER COLUMN "messagetemplates_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    ADD CONSTRAINT "messages_messagetemplates_messages_id_foreign" FOREIGN KEY (messages_id) REFERENCES messages (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "messages_messagetemplates_messages_id_foreign" ON "public"."messages_messagetemplates" IS NULL;

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    ADD CONSTRAINT "messages_messagetemplates_messagetemplates_id_foreign" FOREIGN KEY (messagetemplates_id) REFERENCES messagetemplates (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "messages_messagetemplates_messagetemplates_id_foreign" ON "public"."messages_messagetemplates" IS NULL;

--- END ALTER TABLE "public"."messages_messagetemplates" ---

--- BEGIN ALTER TABLE "public"."collections_translations" ---

ALTER TABLE IF EXISTS "public"."collections_translations"
    DROP CONSTRAINT IF EXISTS "collections_translations_collections_id_foreign";

DELETE FROM collections_translations WHERE collections_id IS NULL;

ALTER TABLE IF EXISTS "public"."collections_translations"
    ALTER COLUMN "collections_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."collections_translations"
    DROP CONSTRAINT IF EXISTS "collections_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."collections_translations"
    ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."collections_translations"
    ADD CONSTRAINT "collections_translations_collections_id_foreign" FOREIGN KEY (collections_id) REFERENCES collections (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "collections_translations_collections_id_foreign" ON "public"."collections_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."collections_translations"
    ADD CONSTRAINT "collections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "collections_translations_languages_code_foreign" ON "public"."collections_translations" IS NULL;

--- END ALTER TABLE "public"."collections_translations" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    DROP CONSTRAINT IF EXISTS "notificationtemplates_translations_notific__402aa733_foreign";

DROP INDEX IF EXISTS notificationtemplates_translations_notificationtemplates_id_lan;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    ALTER COLUMN "notificationtemplates_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    DROP CONSTRAINT IF EXISTS "notificationtemplates_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    ADD CONSTRAINT "notificationtemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "notificationtemplates_translations_languages_code_foreign" ON "public"."notificationtemplates_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    ADD CONSTRAINT "notificationtemplates_translations_notific__402aa733_foreign" FOREIGN KEY (notificationtemplates_id) REFERENCES notificationtemplates (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "notificationtemplates_translations_notific__402aa733_foreign" ON "public"."notificationtemplates_translations" IS NULL;

CREATE UNIQUE INDEX notificationtemplates_translations_notificationtemplates_id_lan ON public.notificationtemplates_translations USING btree (notificationtemplates_id, languages_code);

COMMENT ON INDEX "public"."notificationtemplates_translations_notificationtemplates_id_lan" IS NULL;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_relations" ---

ALTER TABLE IF EXISTS "public"."lessons_relations"
    DROP CONSTRAINT IF EXISTS "lessons_relations_lessons_id_foreign";

ALTER TABLE IF EXISTS "public"."lessons_relations"
    ALTER COLUMN "lessons_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_relations"
    ALTER COLUMN "item" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_relations"
    ALTER COLUMN "collection" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_relations"
    ADD CONSTRAINT "lessons_relations_lessons_id_foreign" FOREIGN KEY (lessons_id) REFERENCES lessons (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lessons_relations_lessons_id_foreign" ON "public"."lessons_relations" IS NULL;

--- END ALTER TABLE "public"."lessons_relations" ---

--- BEGIN ALTER TABLE "public"."achievements_images" ---

ALTER TABLE IF EXISTS "public"."achievements_images"
    DROP CONSTRAINT IF EXISTS "achievements_images_image_foreign";

ALTER TABLE IF EXISTS "public"."achievements_images"
    ALTER COLUMN "image" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    DROP CONSTRAINT IF EXISTS "achievements_images_achievement_id_foreign";

ALTER TABLE IF EXISTS "public"."achievements_images"
    ALTER COLUMN "achievement_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    DROP CONSTRAINT IF EXISTS "achievements_images_language_foreign";

ALTER TABLE IF EXISTS "public"."achievements_images"
    ALTER COLUMN "language" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    ADD CONSTRAINT "achievements_images_language_foreign" FOREIGN KEY (language) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievements_images_language_foreign" ON "public"."achievements_images" IS NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    ADD CONSTRAINT "achievements_images_image_foreign" FOREIGN KEY (image) REFERENCES directus_files (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievements_images_image_foreign" ON "public"."achievements_images" IS NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    ADD CONSTRAINT "achievements_images_achievement_id_foreign" FOREIGN KEY (achievement_id) REFERENCES achievements (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievements_images_achievement_id_foreign" ON "public"."achievements_images" IS NULL;

--- END ALTER TABLE "public"."achievements_images" ---

--- BEGIN ALTER TABLE "public"."lessons_images" ---

ALTER TABLE IF EXISTS "public"."lessons_images"
    DROP CONSTRAINT IF EXISTS "lessons_images_lesson_id_foreign";

ALTER TABLE IF EXISTS "public"."lessons_images"
    ALTER COLUMN "lesson_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_images"
    ADD CONSTRAINT "lessons_images_lesson_id_foreign" FOREIGN KEY (lesson_id) REFERENCES lessons (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lessons_images_lesson_id_foreign" ON "public"."lessons_images" IS NULL;

--- END ALTER TABLE "public"."lessons_images" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations"
    DROP CONSTRAINT IF EXISTS "achievements_translations_achievements_id_foreign";

ALTER TABLE IF EXISTS "public"."achievements_translations"
    ADD CONSTRAINT "achievements_translations_achievements_id_foreign" FOREIGN KEY (achievements_id) REFERENCES achievements (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievements_translations_achievements_id_foreign" ON "public"."achievements_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."achievements_translations"
    DROP CONSTRAINT IF EXISTS "achievements_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."achievements_translations"
    ADD CONSTRAINT "achievements_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievements_translations_languages_code_foreign" ON "public"."achievements_translations" IS NULL;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."targets_usergroups" ---

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    DROP CONSTRAINT IF EXISTS "targets_usergroups_targets_id_foreign";

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    ALTER COLUMN "targets_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    DROP CONSTRAINT IF EXISTS "targets_usergroups_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    ALTER COLUMN "usergroups_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    ADD CONSTRAINT "targets_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "targets_usergroups_usergroups_code_foreign" ON "public"."targets_usergroups" IS NULL;

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    ADD CONSTRAINT "targets_usergroups_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "targets_usergroups_targets_id_foreign" ON "public"."targets_usergroups" IS NULL;

--- END ALTER TABLE "public"."targets_usergroups" ---

--- BEGIN ALTER TABLE "public"."notifications_targets" ---

ALTER TABLE IF EXISTS "public"."notifications_targets"
    DROP CONSTRAINT IF EXISTS "notifications_targets_notifications_id_foreign";

ALTER TABLE IF EXISTS "public"."notifications_targets"
    ALTER COLUMN "notifications_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."notifications_targets"
    DROP CONSTRAINT IF EXISTS "notifications_targets_targets_id_foreign";

ALTER TABLE IF EXISTS "public"."notifications_targets"
    ALTER COLUMN "targets_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."notifications_targets"
    ADD CONSTRAINT "notifications_targets_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "notifications_targets_targets_id_foreign" ON "public"."notifications_targets" IS NULL;

ALTER TABLE IF EXISTS "public"."notifications_targets"
    ADD CONSTRAINT "notifications_targets_notifications_id_foreign" FOREIGN KEY (notifications_id) REFERENCES notifications (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "notifications_targets_notifications_id_foreign" ON "public"."notifications_targets" IS NULL;

--- END ALTER TABLE "public"."notifications_targets" ---

--- BEGIN ALTER TABLE "public"."prompts_translations" ---

ALTER TABLE IF EXISTS "public"."prompts_translations"
    DROP CONSTRAINT IF EXISTS "prompts_translations_prompts_id_foreign";

DROP INDEX IF EXISTS prompts_translations_prompts_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."prompts_translations"
    ALTER COLUMN "prompts_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."prompts_translations"
    ADD CONSTRAINT "prompts_translations_prompts_id_foreign" FOREIGN KEY (prompts_id) REFERENCES prompts (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "prompts_translations_prompts_id_foreign" ON "public"."prompts_translations" IS NULL;

CREATE UNIQUE INDEX prompts_translations_prompts_id_languages_code_uindex ON public.prompts_translations USING btree (prompts_id, languages_code);

COMMENT ON INDEX "public"."prompts_translations_prompts_id_languages_code_uindex" IS NULL;

--- END ALTER TABLE "public"."prompts_translations" ---

--- BEGIN ALTER TABLE "public"."prompts_targets" ---

ALTER TABLE IF EXISTS "public"."prompts_targets"
    DROP CONSTRAINT IF EXISTS "prompts_targets_prompts_id_foreign";

DELETE FROM prompts_targets WHERE prompts_id IS NULL;

ALTER TABLE IF EXISTS "public"."prompts_targets"
    ALTER COLUMN "prompts_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."prompts_targets"
    DROP CONSTRAINT IF EXISTS "prompts_targets_targets_id_foreign";

ALTER TABLE IF EXISTS "public"."prompts_targets"
    ALTER COLUMN "targets_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."prompts_targets"
    ADD CONSTRAINT "prompts_targets_prompts_id_foreign" FOREIGN KEY (prompts_id) REFERENCES prompts (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "prompts_targets_prompts_id_foreign" ON "public"."prompts_targets" IS NULL;

ALTER TABLE IF EXISTS "public"."prompts_targets"
    ADD CONSTRAINT "prompts_targets_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "prompts_targets_targets_id_foreign" ON "public"."prompts_targets" IS NULL;

--- END ALTER TABLE "public"."prompts_targets" ---

--- BEGIN ALTER TABLE "public"."achievementconditions_studytopics" ---

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    DROP CONSTRAINT IF EXISTS "achievementconditions_studytopics_achievem__2e3395b2_foreign";

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    ALTER COLUMN "achievementconditions_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    DROP CONSTRAINT IF EXISTS "achievementconditions_studytopics_studytopics_id_foreign";

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    ALTER COLUMN "studytopics_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    ADD CONSTRAINT "achievementconditions_studytopics_studytopics_id_foreign" FOREIGN KEY (studytopics_id) REFERENCES studytopics (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievementconditions_studytopics_studytopics_id_foreign" ON "public"."achievementconditions_studytopics" IS NULL;

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    ADD CONSTRAINT "achievementconditions_studytopics_achievem__2e3395b2_foreign" FOREIGN KEY (achievementconditions_id) REFERENCES achievementconditions (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievementconditions_studytopics_achievem__2e3395b2_foreign" ON "public"."achievementconditions_studytopics" IS NULL;

--- END ALTER TABLE "public"."achievementconditions_studytopics" ---

--- BEGIN ALTER TABLE "public"."faqs_usergroups" ---

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    DROP CONSTRAINT IF EXISTS "faqs_usergroups_faqs_id_foreign";

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    ALTER COLUMN "faqs_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    DROP CONSTRAINT IF EXISTS "faqs_usergroups_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    ALTER COLUMN "usergroups_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    ADD CONSTRAINT "faqs_usergroups_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqs_usergroups_faqs_id_foreign" ON "public"."faqs_usergroups" IS NULL;

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    ADD CONSTRAINT "faqs_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "faqs_usergroups_usergroups_code_foreign" ON "public"."faqs_usergroups" IS NULL;

--- END ALTER TABLE "public"."faqs_usergroups" ---

--- BEGIN ALTER TABLE "public"."assetstreams_audio_languages" ---

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    DROP CONSTRAINT IF EXISTS "assetstreams_audio_languages_assetstreams_id_foreign";

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    ALTER COLUMN "assetstreams_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    DROP CONSTRAINT IF EXISTS "assetstreams_audio_languages_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    ALTER COLUMN "languages_code" SET NOT NULL,
    ALTER COLUMN "languages_code" DROP DEFAULT;

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    ADD CONSTRAINT "assetstreams_audio_languages_assetstreams_id_foreign" FOREIGN KEY (assetstreams_id) REFERENCES assetstreams (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "assetstreams_audio_languages_assetstreams_id_foreign" ON "public"."assetstreams_audio_languages" IS NULL;

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    ADD CONSTRAINT "assetstreams_audio_languages_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code);

COMMENT ON CONSTRAINT "assetstreams_audio_languages_languages_code_foreign" ON "public"."assetstreams_audio_languages" IS NULL;

--- END ALTER TABLE "public"."assetstreams_audio_languages" ---

--- BEGIN ALTER TABLE "public"."assetstreams_subtitle_languages" ---

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    DROP CONSTRAINT IF EXISTS "assetstreams_subtitle_languages_assetstreams_id_foreign";

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    ALTER COLUMN "assetstreams_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    DROP CONSTRAINT IF EXISTS "assetstreams_subtitle_languages_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    ALTER COLUMN "languages_code" SET NOT NULL,
    ALTER COLUMN "languages_code" DROP DEFAULT;

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    ADD CONSTRAINT "assetstreams_subtitle_languages_assetstreams_id_foreign" FOREIGN KEY (assetstreams_id) REFERENCES assetstreams (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "assetstreams_subtitle_languages_assetstreams_id_foreign" ON "public"."assetstreams_subtitle_languages" IS NULL;

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    ADD CONSTRAINT "assetstreams_subtitle_languages_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code);

COMMENT ON CONSTRAINT "assetstreams_subtitle_languages_languages_code_foreign" ON "public"."assetstreams_subtitle_languages" IS NULL;

--- END ALTER TABLE "public"."assetstreams_subtitle_languages" ---

--- BEGIN ALTER TABLE "public"."applicationgroups_usergroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    DROP CONSTRAINT IF EXISTS "applicationgroups_usergroups_applicationgroups_id_foreign";

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    ALTER COLUMN "applicationgroups_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    DROP CONSTRAINT IF EXISTS "applicationgroups_usergroups_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    ALTER COLUMN "usergroups_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    ADD CONSTRAINT "applicationgroups_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "applicationgroups_usergroups_usergroups_code_foreign" ON "public"."applicationgroups_usergroups" IS NULL;

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    ADD CONSTRAINT "applicationgroups_usergroups_applicationgroups_id_foreign" FOREIGN KEY (applicationgroups_id) REFERENCES applicationgroups (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "applicationgroups_usergroups_applicationgroups_id_foreign" ON "public"."applicationgroups_usergroups" IS NULL;

--- END ALTER TABLE "public"."applicationgroups_usergroups" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_translations" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_translations"
    DROP CONSTRAINT IF EXISTS "timedmetadata_translations_timedmetadata_id_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata_translations"
    ALTER COLUMN "timedmetadata_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata_translations"
    ADD CONSTRAINT "timedmetadata_translations_timedmetadata_id_foreign" FOREIGN KEY (timedmetadata_id) REFERENCES timedmetadata (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "timedmetadata_translations_timedmetadata_id_foreign" ON "public"."timedmetadata_translations" IS NULL;

--- END ALTER TABLE "public"."timedmetadata_translations" ---

--- BEGIN ALTER TABLE "public"."games_styledimages" ---

ALTER TABLE IF EXISTS "public"."games_styledimages"
    DROP CONSTRAINT IF EXISTS "games_styledimages_games_id_foreign";

DELETE FROM games_styledimages WHERE games_id IS NULL;

ALTER TABLE IF EXISTS "public"."games_styledimages"
    ALTER COLUMN "games_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."games_styledimages"
    DROP CONSTRAINT IF EXISTS "games_styledimages_styledimages_id_foreign";

ALTER TABLE IF EXISTS "public"."games_styledimages"
    ALTER COLUMN "styledimages_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."games_styledimages"
    ADD CONSTRAINT "games_styledimages_games_id_foreign" FOREIGN KEY (games_id) REFERENCES games (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "games_styledimages_games_id_foreign" ON "public"."games_styledimages" IS NULL;

ALTER TABLE IF EXISTS "public"."games_styledimages"
    ADD CONSTRAINT "games_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "games_styledimages_styledimages_id_foreign" ON "public"."games_styledimages" IS NULL;

--- END ALTER TABLE "public"."games_styledimages" ---

--- BEGIN ALTER TABLE "public"."calendarentries_translations" ---

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
    DROP CONSTRAINT IF EXISTS "calendarentries_translations_calendarentries_id_foreign";

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
    ALTER COLUMN "calendarentries_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
    ADD CONSTRAINT "calendarentries_translations_calendarentries_id_foreign" FOREIGN KEY (calendarentries_id) REFERENCES calendarentries (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "calendarentries_translations_calendarentries_id_foreign" ON "public"."calendarentries_translations" IS NULL;

--- END ALTER TABLE "public"."calendarentries_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    DROP CONSTRAINT IF EXISTS "messagetemplates_translations_messagetemplates_id_foreign";

DROP INDEX IF EXISTS messagetemplates_translations_messagetemplates_id_languages_cod;

DELETE FROM messagetemplates_translations WHERE messagetemplates_id IS NULL;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    ALTER COLUMN "messagetemplates_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    ADD CONSTRAINT "messagetemplates_translations_messagetemplates_id_foreign" FOREIGN KEY (messagetemplates_id) REFERENCES messagetemplates (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "messagetemplates_translations_messagetemplates_id_foreign" ON "public"."messagetemplates_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    DROP CONSTRAINT IF EXISTS "messagetemplates_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    ADD CONSTRAINT "messagetemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "messagetemplates_translations_languages_code_foreign" ON "public"."messagetemplates_translations" IS NULL;

CREATE UNIQUE INDEX messagetemplates_translations_messagetemplates_id_languages_cod ON public.messagetemplates_translations USING btree (messagetemplates_id, languages_code);

COMMENT ON INDEX "public"."messagetemplates_translations_messagetemplates_id_languages_cod" IS NULL;

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."songcollections_translations" ---

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    DROP CONSTRAINT IF EXISTS "songcollections_translations_songcollections_id_foreign";

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    ALTER COLUMN "songcollections_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    DROP CONSTRAINT IF EXISTS "songcollections_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    ADD CONSTRAINT "songcollections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "songcollections_translations_languages_code_foreign" ON "public"."songcollections_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    ADD CONSTRAINT "songcollections_translations_songcollections_id_foreign" FOREIGN KEY (songcollections_id) REFERENCES songcollections (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "songcollections_translations_songcollections_id_foreign" ON "public"."songcollections_translations" IS NULL;

--- END ALTER TABLE "public"."songcollections_translations" ---

--- BEGIN ALTER TABLE "public"."phrases_translations" ---

ALTER TABLE IF EXISTS "public"."phrases_translations"
    DROP CONSTRAINT IF EXISTS "phrases_translations_phrases_key_foreign";

ALTER TABLE IF EXISTS "public"."phrases_translations"
    ALTER COLUMN "phrases_key" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."phrases_translations"
    DROP CONSTRAINT IF EXISTS "phrases_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."phrases_translations"
    ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."phrases_translations"
    ADD CONSTRAINT "phrases_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "phrases_translations_languages_code_foreign" ON "public"."phrases_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."phrases_translations"
    ADD CONSTRAINT "phrases_translations_phrases_key_foreign" FOREIGN KEY (phrases_key) REFERENCES phrases (key) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "phrases_translations_phrases_key_foreign" ON "public"."phrases_translations" IS NULL;

--- END ALTER TABLE "public"."phrases_translations" ---

--- BEGIN DROP TABLE "public"."collections_items" ---

DROP TABLE IF EXISTS "public"."collections_items";

--- END DROP TABLE "public"."collections_items" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 684;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'collections_items';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_field" = NULL
WHERE "id" = 211;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-07T14:36:48.573Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."events_translations" ---

ALTER TABLE IF EXISTS "public"."events_translations"
    DROP CONSTRAINT IF EXISTS "events_translations_events_id_foreign";

DROP INDEX IF EXISTS events_translations_events_id_languages_code_index;

ALTER TABLE IF EXISTS "public"."events_translations"
    ALTER COLUMN "events_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."events_translations"
    DROP CONSTRAINT IF EXISTS "events_translations_languages_code_foreign";

DROP INDEX IF EXISTS events_translations_events_id_languages_code_index;

ALTER TABLE IF EXISTS "public"."events_translations"
    ALTER COLUMN "languages_code" DROP NOT NULL,
    ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."events_translations"
    ADD CONSTRAINT "events_translations_events_id_foreign" FOREIGN KEY (events_id) REFERENCES events (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "events_translations_events_id_foreign" ON "public"."events_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."events_translations"
    ADD CONSTRAINT "events_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "events_translations_languages_code_foreign" ON "public"."events_translations" IS NULL;

CREATE INDEX events_translations_events_id_languages_code_index ON public.events_translations USING btree (events_id, languages_code);

COMMENT ON INDEX "public"."events_translations_events_id_languages_code_index" IS NULL;

--- END ALTER TABLE "public"."events_translations" ---

--- BEGIN ALTER TABLE "public"."tags_translations" ---

ALTER TABLE IF EXISTS "public"."tags_translations"
    DROP CONSTRAINT IF EXISTS "tags_translations_tags_id_foreign";

DROP INDEX IF EXISTS tags_translations_languages_code_tags_id_uindex;

ALTER TABLE IF EXISTS "public"."tags_translations"
    ALTER COLUMN "tags_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."tags_translations"
    DROP CONSTRAINT IF EXISTS "tags_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."tags_translations"
    ADD CONSTRAINT "tags_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "tags_translations_languages_code_foreign" ON "public"."tags_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."tags_translations"
    ADD CONSTRAINT "tags_translations_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "tags_translations_tags_id_foreign" ON "public"."tags_translations" IS NULL;

CREATE UNIQUE INDEX tags_translations_languages_code_tags_id_uindex ON public.tags_translations USING btree (languages_code, tags_id);

COMMENT ON INDEX "public"."tags_translations_languages_code_tags_id_uindex" IS NULL;

--- END ALTER TABLE "public"."tags_translations" ---

--- BEGIN ALTER TABLE "public"."shows_tags" ---

ALTER TABLE IF EXISTS "public"."shows_tags"
    DROP CONSTRAINT IF EXISTS "shows_tags_shows_id_foreign";

ALTER TABLE IF EXISTS "public"."shows_tags"
    ALTER COLUMN "shows_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."shows_tags"
    DROP CONSTRAINT IF EXISTS "shows_tags_tags_id_foreign";

ALTER TABLE IF EXISTS "public"."shows_tags"
    ALTER COLUMN "tags_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."shows_tags"
    ADD CONSTRAINT "shows_tags_shows_id_foreign" FOREIGN KEY (shows_id) REFERENCES shows (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "shows_tags_shows_id_foreign" ON "public"."shows_tags" IS NULL;

ALTER TABLE IF EXISTS "public"."shows_tags"
    ADD CONSTRAINT "shows_tags_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "shows_tags_tags_id_foreign" ON "public"."shows_tags" IS NULL;

--- END ALTER TABLE "public"."shows_tags" ---

--- BEGIN ALTER TABLE "public"."collections_entries" ---

ALTER TABLE IF EXISTS "public"."collections_entries"
    ALTER COLUMN "item" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."collections_entries"
    ALTER COLUMN "collection" DROP NOT NULL;

--- END ALTER TABLE "public"."collections_entries" ---

--- BEGIN ALTER TABLE "public"."messages_messagetemplates" ---

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    DROP CONSTRAINT IF EXISTS "messages_messagetemplates_messages_id_foreign";

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    ALTER COLUMN "messages_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    DROP CONSTRAINT IF EXISTS "messages_messagetemplates_messagetemplates_id_foreign";

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    ALTER COLUMN "messagetemplates_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    ADD CONSTRAINT "messages_messagetemplates_messages_id_foreign" FOREIGN KEY (messages_id) REFERENCES messages (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "messages_messagetemplates_messages_id_foreign" ON "public"."messages_messagetemplates" IS NULL;

ALTER TABLE IF EXISTS "public"."messages_messagetemplates"
    ADD CONSTRAINT "messages_messagetemplates_messagetemplates_id_foreign" FOREIGN KEY (messagetemplates_id) REFERENCES messagetemplates (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "messages_messagetemplates_messagetemplates_id_foreign" ON "public"."messages_messagetemplates" IS NULL;

--- END ALTER TABLE "public"."messages_messagetemplates" ---

--- BEGIN ALTER TABLE "public"."collections_translations" ---

ALTER TABLE IF EXISTS "public"."collections_translations"
    DROP CONSTRAINT IF EXISTS "collections_translations_collections_id_foreign";

ALTER TABLE IF EXISTS "public"."collections_translations"
    ALTER COLUMN "collections_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."collections_translations"
    DROP CONSTRAINT IF EXISTS "collections_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."collections_translations"
    ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."collections_translations"
    ADD CONSTRAINT "collections_translations_collections_id_foreign" FOREIGN KEY (collections_id) REFERENCES collections (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "collections_translations_collections_id_foreign" ON "public"."collections_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."collections_translations"
    ADD CONSTRAINT "collections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "collections_translations_languages_code_foreign" ON "public"."collections_translations" IS NULL;

--- END ALTER TABLE "public"."collections_translations" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    DROP CONSTRAINT IF EXISTS "notificationtemplates_translations_notific__402aa733_foreign";

DROP INDEX IF EXISTS notificationtemplates_translations_notificationtemplates_id_lan;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    ALTER COLUMN "notificationtemplates_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    DROP CONSTRAINT IF EXISTS "notificationtemplates_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    ADD CONSTRAINT "notificationtemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "notificationtemplates_translations_languages_code_foreign" ON "public"."notificationtemplates_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
    ADD CONSTRAINT "notificationtemplates_translations_notific__402aa733_foreign" FOREIGN KEY (notificationtemplates_id) REFERENCES notificationtemplates (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "notificationtemplates_translations_notific__402aa733_foreign" ON "public"."notificationtemplates_translations" IS NULL;

CREATE UNIQUE INDEX notificationtemplates_translations_notificationtemplates_id_lan ON public.notificationtemplates_translations USING btree (notificationtemplates_id, languages_code);

COMMENT ON INDEX "public"."notificationtemplates_translations_notificationtemplates_id_lan" IS NULL;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_relations" ---

ALTER TABLE IF EXISTS "public"."lessons_relations"
    DROP CONSTRAINT IF EXISTS "lessons_relations_lessons_id_foreign";

ALTER TABLE IF EXISTS "public"."lessons_relations"
    ALTER COLUMN "lessons_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_relations"
    ALTER COLUMN "item" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_relations"
    ALTER COLUMN "collection" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_relations"
    ADD CONSTRAINT "lessons_relations_lessons_id_foreign" FOREIGN KEY (lessons_id) REFERENCES lessons (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lessons_relations_lessons_id_foreign" ON "public"."lessons_relations" IS NULL;

--- END ALTER TABLE "public"."lessons_relations" ---

--- BEGIN ALTER TABLE "public"."achievements_images" ---

ALTER TABLE IF EXISTS "public"."achievements_images"
    DROP CONSTRAINT IF EXISTS "achievements_images_image_foreign";

ALTER TABLE IF EXISTS "public"."achievements_images"
    ALTER COLUMN "image" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    DROP CONSTRAINT IF EXISTS "achievements_images_achievement_id_foreign";

ALTER TABLE IF EXISTS "public"."achievements_images"
    ALTER COLUMN "achievement_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    DROP CONSTRAINT IF EXISTS "achievements_images_language_foreign";

ALTER TABLE IF EXISTS "public"."achievements_images"
    ALTER COLUMN "language" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    ADD CONSTRAINT "achievements_images_achievement_id_foreign" FOREIGN KEY (achievement_id) REFERENCES achievements (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievements_images_achievement_id_foreign" ON "public"."achievements_images" IS NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    ADD CONSTRAINT "achievements_images_image_foreign" FOREIGN KEY (image) REFERENCES directus_files (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievements_images_image_foreign" ON "public"."achievements_images" IS NULL;

ALTER TABLE IF EXISTS "public"."achievements_images"
    ADD CONSTRAINT "achievements_images_language_foreign" FOREIGN KEY (language) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievements_images_language_foreign" ON "public"."achievements_images" IS NULL;

--- END ALTER TABLE "public"."achievements_images" ---

--- BEGIN ALTER TABLE "public"."lessons_images" ---

ALTER TABLE IF EXISTS "public"."lessons_images"
    DROP CONSTRAINT IF EXISTS "lessons_images_lesson_id_foreign";

ALTER TABLE IF EXISTS "public"."lessons_images"
    ALTER COLUMN "lesson_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."lessons_images"
    ADD CONSTRAINT "lessons_images_lesson_id_foreign" FOREIGN KEY (lesson_id) REFERENCES lessons (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lessons_images_lesson_id_foreign" ON "public"."lessons_images" IS NULL;

--- END ALTER TABLE "public"."lessons_images" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations"
    DROP CONSTRAINT IF EXISTS "achievements_translations_achievements_id_foreign";

ALTER TABLE IF EXISTS "public"."achievements_translations"
    ADD CONSTRAINT "achievements_translations_achievements_id_foreign" FOREIGN KEY (achievements_id) REFERENCES achievements (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "achievements_translations_achievements_id_foreign" ON "public"."achievements_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."achievements_translations"
    DROP CONSTRAINT IF EXISTS "achievements_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."achievements_translations"
    ADD CONSTRAINT "achievements_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code);

COMMENT ON CONSTRAINT "achievements_translations_languages_code_foreign" ON "public"."achievements_translations" IS NULL;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."targets_usergroups" ---

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    DROP CONSTRAINT IF EXISTS "targets_usergroups_targets_id_foreign";

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    ALTER COLUMN "targets_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    DROP CONSTRAINT IF EXISTS "targets_usergroups_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    ALTER COLUMN "usergroups_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    ADD CONSTRAINT "targets_usergroups_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "targets_usergroups_targets_id_foreign" ON "public"."targets_usergroups" IS NULL;

ALTER TABLE IF EXISTS "public"."targets_usergroups"
    ADD CONSTRAINT "targets_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "targets_usergroups_usergroups_code_foreign" ON "public"."targets_usergroups" IS NULL;

--- END ALTER TABLE "public"."targets_usergroups" ---

--- BEGIN ALTER TABLE "public"."notifications_targets" ---

ALTER TABLE IF EXISTS "public"."notifications_targets"
    DROP CONSTRAINT IF EXISTS "notifications_targets_notifications_id_foreign";

ALTER TABLE IF EXISTS "public"."notifications_targets"
    ALTER COLUMN "notifications_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."notifications_targets"
    DROP CONSTRAINT IF EXISTS "notifications_targets_targets_id_foreign";

ALTER TABLE IF EXISTS "public"."notifications_targets"
    ALTER COLUMN "targets_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."notifications_targets"
    ADD CONSTRAINT "notifications_targets_notifications_id_foreign" FOREIGN KEY (notifications_id) REFERENCES notifications (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "notifications_targets_notifications_id_foreign" ON "public"."notifications_targets" IS NULL;

ALTER TABLE IF EXISTS "public"."notifications_targets"
    ADD CONSTRAINT "notifications_targets_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "notifications_targets_targets_id_foreign" ON "public"."notifications_targets" IS NULL;

--- END ALTER TABLE "public"."notifications_targets" ---

--- BEGIN ALTER TABLE "public"."prompts_translations" ---

ALTER TABLE IF EXISTS "public"."prompts_translations"
    DROP CONSTRAINT IF EXISTS "prompts_translations_prompts_id_foreign";

DROP INDEX IF EXISTS prompts_translations_prompts_id_languages_code_uindex;

ALTER TABLE IF EXISTS "public"."prompts_translations"
    ALTER COLUMN "prompts_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."prompts_translations"
    ADD CONSTRAINT "prompts_translations_prompts_id_foreign" FOREIGN KEY (prompts_id) REFERENCES prompts (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "prompts_translations_prompts_id_foreign" ON "public"."prompts_translations" IS NULL;

CREATE UNIQUE INDEX prompts_translations_prompts_id_languages_code_uindex ON public.prompts_translations USING btree (prompts_id, languages_code);

COMMENT ON INDEX "public"."prompts_translations_prompts_id_languages_code_uindex" IS NULL;

--- END ALTER TABLE "public"."prompts_translations" ---

--- BEGIN ALTER TABLE "public"."prompts_targets" ---

ALTER TABLE IF EXISTS "public"."prompts_targets"
    DROP CONSTRAINT IF EXISTS "prompts_targets_prompts_id_foreign";

ALTER TABLE IF EXISTS "public"."prompts_targets"
    ALTER COLUMN "prompts_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."prompts_targets"
    DROP CONSTRAINT IF EXISTS "prompts_targets_targets_id_foreign";

ALTER TABLE IF EXISTS "public"."prompts_targets"
    ALTER COLUMN "targets_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."prompts_targets"
    ADD CONSTRAINT "prompts_targets_prompts_id_foreign" FOREIGN KEY (prompts_id) REFERENCES prompts (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "prompts_targets_prompts_id_foreign" ON "public"."prompts_targets" IS NULL;

ALTER TABLE IF EXISTS "public"."prompts_targets"
    ADD CONSTRAINT "prompts_targets_targets_id_foreign" FOREIGN KEY (targets_id) REFERENCES targets (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "prompts_targets_targets_id_foreign" ON "public"."prompts_targets" IS NULL;

--- END ALTER TABLE "public"."prompts_targets" ---

--- BEGIN ALTER TABLE "public"."achievementconditions_studytopics" ---

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    DROP CONSTRAINT IF EXISTS "achievementconditions_studytopics_achievem__2e3395b2_foreign";

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    ALTER COLUMN "achievementconditions_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    DROP CONSTRAINT IF EXISTS "achievementconditions_studytopics_studytopics_id_foreign";

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    ALTER COLUMN "studytopics_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    ADD CONSTRAINT "achievementconditions_studytopics_achievem__2e3395b2_foreign" FOREIGN KEY (achievementconditions_id) REFERENCES achievementconditions (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievementconditions_studytopics_achievem__2e3395b2_foreign" ON "public"."achievementconditions_studytopics" IS NULL;

ALTER TABLE IF EXISTS "public"."achievementconditions_studytopics"
    ADD CONSTRAINT "achievementconditions_studytopics_studytopics_id_foreign" FOREIGN KEY (studytopics_id) REFERENCES studytopics (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "achievementconditions_studytopics_studytopics_id_foreign" ON "public"."achievementconditions_studytopics" IS NULL;

--- END ALTER TABLE "public"."achievementconditions_studytopics" ---

--- BEGIN ALTER TABLE "public"."faqs_usergroups" ---

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    DROP CONSTRAINT IF EXISTS "faqs_usergroups_faqs_id_foreign";

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    ALTER COLUMN "faqs_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    DROP CONSTRAINT IF EXISTS "faqs_usergroups_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    ALTER COLUMN "usergroups_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    ADD CONSTRAINT "faqs_usergroups_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "faqs_usergroups_faqs_id_foreign" ON "public"."faqs_usergroups" IS NULL;

ALTER TABLE IF EXISTS "public"."faqs_usergroups"
    ADD CONSTRAINT "faqs_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "faqs_usergroups_usergroups_code_foreign" ON "public"."faqs_usergroups" IS NULL;

--- END ALTER TABLE "public"."faqs_usergroups" ---

--- BEGIN ALTER TABLE "public"."assetstreams_audio_languages" ---

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    DROP CONSTRAINT IF EXISTS "assetstreams_audio_languages_assetstreams_id_foreign";

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    ALTER COLUMN "assetstreams_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    DROP CONSTRAINT IF EXISTS "assetstreams_audio_languages_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    ALTER COLUMN "languages_code" DROP NOT NULL,
    ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    ADD CONSTRAINT "assetstreams_audio_languages_assetstreams_id_foreign" FOREIGN KEY (assetstreams_id) REFERENCES assetstreams (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "assetstreams_audio_languages_assetstreams_id_foreign" ON "public"."assetstreams_audio_languages" IS NULL;

ALTER TABLE IF EXISTS "public"."assetstreams_audio_languages"
    ADD CONSTRAINT "assetstreams_audio_languages_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code);

COMMENT ON CONSTRAINT "assetstreams_audio_languages_languages_code_foreign" ON "public"."assetstreams_audio_languages" IS NULL;

--- END ALTER TABLE "public"."assetstreams_audio_languages" ---

--- BEGIN CREATE TABLE "public"."collections_items" ---

CREATE TABLE IF NOT EXISTS "public"."collections_items"
(
    "collection_id" int4         NULL,
    "date_created"  timestamptz  NULL,
    "date_updated"  timestamptz  NULL,
    "episode_id"    int4         NULL,
    "id"            int4         NOT NULL DEFAULT nextval('collections_items_id_seq'::regclass),
    "page_id"       int4         NULL,
    "season_id"     int4         NULL,
    "show_id"       int4         NULL,
    "sort"          int4         NULL,
    "type"          varchar(255) NULL     DEFAULT NULL::character varying,
    "user_created"  uuid         NULL,
    "user_updated"  uuid         NULL,
    "link_id"       int4         NULL,
    CONSTRAINT "collections_items_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES collections (id) ON DELETE CASCADE,
    CONSTRAINT "collections_items_episode_id_foreign" FOREIGN KEY (episode_id) REFERENCES episodes (id) ON DELETE SET NULL,
    CONSTRAINT "collections_items_link_id_foreign" FOREIGN KEY (link_id) REFERENCES links (id) ON DELETE SET NULL,
    CONSTRAINT "collections_items_page_id_foreign" FOREIGN KEY (page_id) REFERENCES pages (id) ON DELETE SET NULL,
    CONSTRAINT "collections_items_pkey" PRIMARY KEY (id),
    CONSTRAINT "collections_items_season_id_foreign" FOREIGN KEY (season_id) REFERENCES seasons (id) ON DELETE SET NULL,
    CONSTRAINT "collections_items_show_id_foreign" FOREIGN KEY (show_id) REFERENCES shows (id) ON DELETE SET NULL,
    CONSTRAINT "collections_items_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "collections_items_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."collections_items" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."collections_items" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."collections_items" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."collections_items" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."collections_items" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."collections_items" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."collections_items" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."collections_items" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."collections_items"."collection_id" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."date_created" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."episode_id" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."id" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."page_id" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."season_id" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."show_id" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."sort" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."type" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."user_created" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."collections_items"."link_id" IS NULL;

COMMENT ON CONSTRAINT "collections_items_collection_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_episode_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_link_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_page_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_pkey" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_season_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_show_id_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_user_created_foreign" ON "public"."collections_items" IS NULL;


COMMENT ON CONSTRAINT "collections_items_user_updated_foreign" ON "public"."collections_items" IS NULL;

COMMENT ON TABLE "public"."collections_items" IS NULL;

--- END CREATE TABLE "public"."collections_items" ---

--- BEGIN ALTER TABLE "public"."assetstreams_subtitle_languages" ---

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    DROP CONSTRAINT IF EXISTS "assetstreams_subtitle_languages_assetstreams_id_foreign";

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    ALTER COLUMN "assetstreams_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    DROP CONSTRAINT IF EXISTS "assetstreams_subtitle_languages_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    ALTER COLUMN "languages_code" DROP NOT NULL,
    ALTER COLUMN "languages_code" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    ADD CONSTRAINT "assetstreams_subtitle_languages_assetstreams_id_foreign" FOREIGN KEY (assetstreams_id) REFERENCES assetstreams (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "assetstreams_subtitle_languages_assetstreams_id_foreign" ON "public"."assetstreams_subtitle_languages" IS NULL;

ALTER TABLE IF EXISTS "public"."assetstreams_subtitle_languages"
    ADD CONSTRAINT "assetstreams_subtitle_languages_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code);

COMMENT ON CONSTRAINT "assetstreams_subtitle_languages_languages_code_foreign" ON "public"."assetstreams_subtitle_languages" IS NULL;

--- END ALTER TABLE "public"."assetstreams_subtitle_languages" ---

--- BEGIN ALTER TABLE "public"."applicationgroups_usergroups" ---

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    DROP CONSTRAINT IF EXISTS "applicationgroups_usergroups_applicationgroups_id_foreign";

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    ALTER COLUMN "applicationgroups_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    DROP CONSTRAINT IF EXISTS "applicationgroups_usergroups_usergroups_code_foreign";

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    ALTER COLUMN "usergroups_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    ADD CONSTRAINT "applicationgroups_usergroups_applicationgroups_id_foreign" FOREIGN KEY (applicationgroups_id) REFERENCES applicationgroups (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "applicationgroups_usergroups_applicationgroups_id_foreign" ON "public"."applicationgroups_usergroups" IS NULL;

ALTER TABLE IF EXISTS "public"."applicationgroups_usergroups"
    ADD CONSTRAINT "applicationgroups_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "applicationgroups_usergroups_usergroups_code_foreign" ON "public"."applicationgroups_usergroups" IS NULL;

--- END ALTER TABLE "public"."applicationgroups_usergroups" ---

--- BEGIN ALTER TABLE "public"."games_styledimages" ---

ALTER TABLE IF EXISTS "public"."games_styledimages"
    DROP CONSTRAINT IF EXISTS "games_styledimages_games_id_foreign";

ALTER TABLE IF EXISTS "public"."games_styledimages"
    ALTER COLUMN "games_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."games_styledimages"
    DROP CONSTRAINT IF EXISTS "games_styledimages_styledimages_id_foreign";

ALTER TABLE IF EXISTS "public"."games_styledimages"
    ALTER COLUMN "styledimages_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."games_styledimages"
    ADD CONSTRAINT "games_styledimages_games_id_foreign" FOREIGN KEY (games_id) REFERENCES games (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "games_styledimages_games_id_foreign" ON "public"."games_styledimages" IS NULL;

ALTER TABLE IF EXISTS "public"."games_styledimages"
    ADD CONSTRAINT "games_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "games_styledimages_styledimages_id_foreign" ON "public"."games_styledimages" IS NULL;

--- END ALTER TABLE "public"."games_styledimages" ---

--- BEGIN ALTER TABLE "public"."timedmetadata_translations" ---

ALTER TABLE IF EXISTS "public"."timedmetadata_translations"
    DROP CONSTRAINT IF EXISTS "timedmetadata_translations_timedmetadata_id_foreign";

ALTER TABLE IF EXISTS "public"."timedmetadata_translations"
    ALTER COLUMN "timedmetadata_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."timedmetadata_translations"
    ADD CONSTRAINT "timedmetadata_translations_timedmetadata_id_foreign" FOREIGN KEY (timedmetadata_id) REFERENCES timedmetadata (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "timedmetadata_translations_timedmetadata_id_foreign" ON "public"."timedmetadata_translations" IS NULL;

--- END ALTER TABLE "public"."timedmetadata_translations" ---

--- BEGIN ALTER TABLE "public"."calendarentries_translations" ---

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
    DROP CONSTRAINT IF EXISTS "calendarentries_translations_calendarentries_id_foreign";

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
    ALTER COLUMN "calendarentries_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
    ADD CONSTRAINT "calendarentries_translations_calendarentries_id_foreign" FOREIGN KEY (calendarentries_id) REFERENCES calendarentries (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "calendarentries_translations_calendarentries_id_foreign" ON "public"."calendarentries_translations" IS NULL;

--- END ALTER TABLE "public"."calendarentries_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    DROP CONSTRAINT IF EXISTS "messagetemplates_translations_messagetemplates_id_foreign";

DROP INDEX IF EXISTS messagetemplates_translations_messagetemplates_id_languages_cod;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    ALTER COLUMN "messagetemplates_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    DROP CONSTRAINT IF EXISTS "messagetemplates_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    ADD CONSTRAINT "messagetemplates_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "messagetemplates_translations_languages_code_foreign" ON "public"."messagetemplates_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
    ADD CONSTRAINT "messagetemplates_translations_messagetemplates_id_foreign" FOREIGN KEY (messagetemplates_id) REFERENCES messagetemplates (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "messagetemplates_translations_messagetemplates_id_foreign" ON "public"."messagetemplates_translations" IS NULL;

CREATE UNIQUE INDEX messagetemplates_translations_messagetemplates_id_languages_cod ON public.messagetemplates_translations USING btree (messagetemplates_id, languages_code);

COMMENT ON INDEX "public"."messagetemplates_translations_messagetemplates_id_languages_cod" IS NULL;

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."songcollections_translations" ---

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    DROP CONSTRAINT IF EXISTS "songcollections_translations_songcollections_id_foreign";

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    ALTER COLUMN "songcollections_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    DROP CONSTRAINT IF EXISTS "songcollections_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    ADD CONSTRAINT "songcollections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "songcollections_translations_languages_code_foreign" ON "public"."songcollections_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."songcollections_translations"
    ADD CONSTRAINT "songcollections_translations_songcollections_id_foreign" FOREIGN KEY (songcollections_id) REFERENCES songcollections (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "songcollections_translations_songcollections_id_foreign" ON "public"."songcollections_translations" IS NULL;

--- END ALTER TABLE "public"."songcollections_translations" ---

--- BEGIN ALTER TABLE "public"."phrases_translations" ---

ALTER TABLE IF EXISTS "public"."phrases_translations"
    DROP CONSTRAINT IF EXISTS "phrases_translations_phrases_key_foreign";

ALTER TABLE IF EXISTS "public"."phrases_translations"
    ALTER COLUMN "phrases_key" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."phrases_translations"
    DROP CONSTRAINT IF EXISTS "phrases_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."phrases_translations"
    ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."phrases_translations"
    ADD CONSTRAINT "phrases_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "phrases_translations_languages_code_foreign" ON "public"."phrases_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."phrases_translations"
    ADD CONSTRAINT "phrases_translations_phrases_key_foreign" FOREIGN KEY (phrases_key) REFERENCES phrases (key) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "phrases_translations_phrases_key_foreign" ON "public"."phrases_translations" IS NULL;

--- END ALTER TABLE "public"."phrases_translations" ---

--- BEGIN ALTER TABLE "public"."playlists" ---

ALTER TABLE IF EXISTS "public"."playlists"
    DROP CONSTRAINT IF EXISTS "playlists_collection_id_foreign";

ALTER TABLE IF EXISTS "public"."playlists"
    ADD CONSTRAINT "playlists_collection_id_foreign" FOREIGN KEY (collection_id) REFERENCES collections (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "playlists_collection_id_foreign" ON "public"."playlists" IS NULL;

--- END ALTER TABLE "public"."playlists" ---

--- BEGIN ALTER TABLE "public"."playlists_translations" ---

ALTER TABLE IF EXISTS "public"."playlists_translations"
    DROP CONSTRAINT IF EXISTS "playlists_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."playlists_translations"
    ADD CONSTRAINT "playlists_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "playlists_translations_languages_code_foreign" ON "public"."playlists_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."playlists_translations"
    DROP CONSTRAINT IF EXISTS "playlists_translations_playlists_id_foreign";

ALTER TABLE IF EXISTS "public"."playlists_translations"
    ADD CONSTRAINT "playlists_translations_playlists_id_foreign" FOREIGN KEY (playlists_id) REFERENCES playlists (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "playlists_translations_playlists_id_foreign" ON "public"."playlists_translations" IS NULL;

--- END ALTER TABLE "public"."playlists_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('collections_items', NULL, NULL,
        '{{page_id.translations}}{{show_id.translations}}{{season_id.translations}}{{episode_id.translations}}', true,
        false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 2, 'collections', 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (684, 'collections', 'collections_items', 'o2m', 'list-o2m', '{
  "limit": 100,
  "fields": [
    "type",
    "page_id.translations",
    "show_id.translations",
    "season_id.translations",
    "episode_id.translations",
    "link_id.translations"
  ],
  "enableSearchFilter": true,
  "template": null,
  "enableLink": true,
  "enableSelect": false
}', 'related-values', NULL, false, true, 3, 'full', NULL, NULL, '[
  {
    "name": "Hidden if not Select",
    "rule": {
      "_and": [
        {
          "filter_type": {
            "_neq": "select"
          }
        }
      ]
    },
    "hidden": true,
    "options": {
      "layout": "list",
      "enableCreate": true,
      "enableSelect": true,
      "limit": 15,
      "enableSearchFilter": false,
      "enableLink": false
    }
  }
]', false, 'config', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_field" = 'collections_items'
WHERE "id" = 211;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
