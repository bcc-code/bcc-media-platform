-- +goose Up

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION update_date_updated_column()
                      RETURNS TRIGGER AS $$
                      BEGIN
                          NEW.date_updated = CURRENT_TIMESTAMP;
                          RETURN NEW;
                      END;
                      $$ language 'plpgsql';

-- +goose StatementEnd

GRANT EXECUTE ON FUNCTION update_date_updated_column() TO directus;
GRANT EXECUTE ON FUNCTION update_date_updated_column() TO api;
GRANT EXECUTE ON FUNCTION update_date_updated_column() TO background_worker;

ALTER TABLE mediaitems_tags ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE achievementgroups_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE mediaitems_styledimages ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE achievementconditions_studytopics ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE achievementconditions ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE ageratings_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE applicationgroups_usergroups_ls ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE applicationgroups_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE assetstreams_audio_languages ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE assetstreams_subtitle_languages ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE achievements_images ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE achievements_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE collections_entries ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE calendarentries_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE episodes_tags ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE mediaitems_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE mediaitems_usergroups_download ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE mediaitems_usergroups_earlyaccess ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE episodes_assets ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE episodes_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE events_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE faqs_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE games_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE faqs_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE playlists_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE seasons_tags ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE shorts_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE shows_tags ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE faqcategories_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE games_styledimages ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE games_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE lessons_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE languages ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE lessons_relations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE materialized_views_meta ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE links_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE notifications_targets ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE notificationtemplates_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE pages_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE persons_styledimages ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE playlists_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE playlists_styledimages ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE mediaitems_assets ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE collections_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE mediaitems_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE computeddata_conditions ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE persons ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE lessons_images ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE messagetemplates_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE messages_messagetemplates ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE phrases_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE prompts_targets ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE prompts_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE questionalternatives ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE questionalternatives_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE seasons_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE seasons_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE sections_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE sections_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE shows_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE shows_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE songcollections ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE songcollections_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE songs ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE songs_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE studytopics_images ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE studytopics_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE surveyquestions_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE surveys_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE tags_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE targets ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE targets_usergroups ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE tasks_images ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE tasks_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE timedmetadata_persons ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE timedmetadata_styledimages ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE timedmetadata_translations ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE translations_hash ADD COLUMN IF NOT EXISTS date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_tags;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON mediaitems_tags
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON achievementgroups_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON achievementgroups_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_styledimages;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON mediaitems_styledimages
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON achievementconditions_studytopics;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON achievementconditions_studytopics
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON achievementconditions;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON achievementconditions
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON ageratings_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON ageratings_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON applicationgroups_usergroups_ls;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON applicationgroups_usergroups_ls
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON applicationgroups_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON applicationgroups_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON assetstreams_audio_languages;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON assetstreams_audio_languages
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON assetstreams_subtitle_languages;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON assetstreams_subtitle_languages
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON achievements_images;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON achievements_images
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON achievements_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON achievements_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON collections_entries;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON collections_entries
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON calendarentries_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON calendarentries_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON episodes_tags;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON episodes_tags
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON mediaitems_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_usergroups_download;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON mediaitems_usergroups_download
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_usergroups_earlyaccess;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON mediaitems_usergroups_earlyaccess
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON episodes_assets;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON episodes_assets
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON episodes_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON episodes_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON events_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON events_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON faqs_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON faqs_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON games_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON games_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON faqs_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON faqs_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON playlists_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON playlists_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON seasons_tags;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON seasons_tags
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON shorts_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON shorts_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON shows_tags;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON shows_tags
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON faqcategories_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON faqcategories_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON games_styledimages;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON games_styledimages
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON games_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON games_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON lessons_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON lessons_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON languages;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON languages
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON lessons_relations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON lessons_relations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON materialized_views_meta;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON materialized_views_meta
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON links_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON links_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON notifications_targets;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON notifications_targets
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON notificationtemplates_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON notificationtemplates_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON pages_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON pages_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON persons_styledimages;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON persons_styledimages
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON playlists_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON playlists_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON playlists_styledimages;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON playlists_styledimages
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_assets;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON mediaitems_assets
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON collections_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON collections_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON mediaitems_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON computeddata_conditions;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON computeddata_conditions
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON persons;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON persons
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON lessons_images;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON lessons_images
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON messagetemplates_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON messagetemplates_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON messages_messagetemplates;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON messages_messagetemplates
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON phrases_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON phrases_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON prompts_targets;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON prompts_targets
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON prompts_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON prompts_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON questionalternatives;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON questionalternatives
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON questionalternatives_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON questionalternatives_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON seasons_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON seasons_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON seasons_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON seasons_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON sections_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON sections_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON sections_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON sections_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON shows_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON shows_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON shows_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON shows_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON songcollections;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON songcollections
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON songcollections_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON songcollections_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON songs;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON songs
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON songs_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON songs_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON studytopics_images;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON studytopics_images
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON studytopics_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON studytopics_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON surveyquestions_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON surveyquestions_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON surveys_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON surveys_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON tags_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON tags_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON targets;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON targets
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON targets_usergroups;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON targets_usergroups
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON tasks_images;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON tasks_images
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON tasks_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON tasks_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON timedmetadata_persons;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON timedmetadata_persons
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON timedmetadata_styledimages;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON timedmetadata_styledimages
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON timedmetadata_translations;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON timedmetadata_translations
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();
DROP TRIGGER IF EXISTS update_date_updated ON translations_hash;
       CREATE TRIGGER update_date_updated
           BEFORE UPDATE ON translations_hash
           FOR EACH ROW
           EXECUTE FUNCTION update_date_updated_column();

-- +goose Down

DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_tags;
DROP TRIGGER IF EXISTS update_date_updated ON achievementgroups_translations;
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_styledimages;
DROP TRIGGER IF EXISTS update_date_updated ON achievementconditions_studytopics;
DROP TRIGGER IF EXISTS update_date_updated ON achievementconditions;
DROP TRIGGER IF EXISTS update_date_updated ON ageratings_translations;
DROP TRIGGER IF EXISTS update_date_updated ON applicationgroups_usergroups_ls;
DROP TRIGGER IF EXISTS update_date_updated ON applicationgroups_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON assetstreams_audio_languages;
DROP TRIGGER IF EXISTS update_date_updated ON assetstreams_subtitle_languages;
DROP TRIGGER IF EXISTS update_date_updated ON achievements_images;
DROP TRIGGER IF EXISTS update_date_updated ON achievements_translations;
DROP TRIGGER IF EXISTS update_date_updated ON collections_entries;
DROP TRIGGER IF EXISTS update_date_updated ON calendarentries_translations;
DROP TRIGGER IF EXISTS update_date_updated ON episodes_tags;
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_usergroups_download;
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_usergroups_earlyaccess;
DROP TRIGGER IF EXISTS update_date_updated ON episodes_assets;
DROP TRIGGER IF EXISTS update_date_updated ON episodes_translations;
DROP TRIGGER IF EXISTS update_date_updated ON events_translations;
DROP TRIGGER IF EXISTS update_date_updated ON faqs_translations;
DROP TRIGGER IF EXISTS update_date_updated ON games_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON faqs_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON playlists_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON seasons_tags;
DROP TRIGGER IF EXISTS update_date_updated ON shorts_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON shows_tags;
DROP TRIGGER IF EXISTS update_date_updated ON faqcategories_translations;
DROP TRIGGER IF EXISTS update_date_updated ON games_styledimages;
DROP TRIGGER IF EXISTS update_date_updated ON games_translations;
DROP TRIGGER IF EXISTS update_date_updated ON lessons_translations;
DROP TRIGGER IF EXISTS update_date_updated ON languages;
DROP TRIGGER IF EXISTS update_date_updated ON lessons_relations;
DROP TRIGGER IF EXISTS update_date_updated ON materialized_views_meta;
DROP TRIGGER IF EXISTS update_date_updated ON links_translations;
DROP TRIGGER IF EXISTS update_date_updated ON notifications_targets;
DROP TRIGGER IF EXISTS update_date_updated ON notificationtemplates_translations;
DROP TRIGGER IF EXISTS update_date_updated ON pages_translations;
DROP TRIGGER IF EXISTS update_date_updated ON persons_styledimages;
DROP TRIGGER IF EXISTS update_date_updated ON playlists_translations;
DROP TRIGGER IF EXISTS update_date_updated ON playlists_styledimages;
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_assets;
DROP TRIGGER IF EXISTS update_date_updated ON collections_translations;
DROP TRIGGER IF EXISTS update_date_updated ON mediaitems_translations;
DROP TRIGGER IF EXISTS update_date_updated ON computeddata_conditions;
DROP TRIGGER IF EXISTS update_date_updated ON persons;
DROP TRIGGER IF EXISTS update_date_updated ON lessons_images;
DROP TRIGGER IF EXISTS update_date_updated ON messagetemplates_translations;
DROP TRIGGER IF EXISTS update_date_updated ON messages_messagetemplates;
DROP TRIGGER IF EXISTS update_date_updated ON phrases_translations;
DROP TRIGGER IF EXISTS update_date_updated ON prompts_targets;
DROP TRIGGER IF EXISTS update_date_updated ON prompts_translations;
DROP TRIGGER IF EXISTS update_date_updated ON questionalternatives;
DROP TRIGGER IF EXISTS update_date_updated ON questionalternatives_translations;
DROP TRIGGER IF EXISTS update_date_updated ON seasons_translations;
DROP TRIGGER IF EXISTS update_date_updated ON seasons_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON sections_translations;
DROP TRIGGER IF EXISTS update_date_updated ON sections_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON shows_translations;
DROP TRIGGER IF EXISTS update_date_updated ON shows_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON songcollections;
DROP TRIGGER IF EXISTS update_date_updated ON songcollections_translations;
DROP TRIGGER IF EXISTS update_date_updated ON songs;
DROP TRIGGER IF EXISTS update_date_updated ON songs_translations;
DROP TRIGGER IF EXISTS update_date_updated ON studytopics_images;
DROP TRIGGER IF EXISTS update_date_updated ON studytopics_translations;
DROP TRIGGER IF EXISTS update_date_updated ON surveyquestions_translations;
DROP TRIGGER IF EXISTS update_date_updated ON surveys_translations;
DROP TRIGGER IF EXISTS update_date_updated ON tags_translations;
DROP TRIGGER IF EXISTS update_date_updated ON targets;
DROP TRIGGER IF EXISTS update_date_updated ON targets_usergroups;
DROP TRIGGER IF EXISTS update_date_updated ON tasks_images;
DROP TRIGGER IF EXISTS update_date_updated ON tasks_translations;
DROP TRIGGER IF EXISTS update_date_updated ON timedmetadata_persons;
DROP TRIGGER IF EXISTS update_date_updated ON timedmetadata_styledimages;
DROP TRIGGER IF EXISTS update_date_updated ON timedmetadata_translations;
DROP TRIGGER IF EXISTS update_date_updated ON translations_hash;

DROP FUNCTION update_date_updated_column();

ALTER TABLE mediaitems_tags DROP COLUMN date_updated;
ALTER TABLE achievementgroups_translations DROP COLUMN date_updated;
ALTER TABLE mediaitems_styledimages DROP COLUMN date_updated;
ALTER TABLE achievementconditions_studytopics DROP COLUMN date_updated;
ALTER TABLE achievementconditions DROP COLUMN date_updated;
ALTER TABLE ageratings_translations DROP COLUMN date_updated;
ALTER TABLE applicationgroups_usergroups_ls DROP COLUMN date_updated;
ALTER TABLE applicationgroups_usergroups DROP COLUMN date_updated;
ALTER TABLE assetstreams_audio_languages DROP COLUMN date_updated;
ALTER TABLE assetstreams_subtitle_languages DROP COLUMN date_updated;
ALTER TABLE achievements_images DROP COLUMN date_updated;
ALTER TABLE achievements_translations DROP COLUMN date_updated;
ALTER TABLE collections_entries DROP COLUMN date_updated;
ALTER TABLE calendarentries_translations DROP COLUMN date_updated;
ALTER TABLE episodes_tags DROP COLUMN date_updated;
ALTER TABLE mediaitems_usergroups DROP COLUMN date_updated;
ALTER TABLE mediaitems_usergroups_download DROP COLUMN date_updated;
ALTER TABLE mediaitems_usergroups_earlyaccess DROP COLUMN date_updated;
ALTER TABLE episodes_assets DROP COLUMN date_updated;
ALTER TABLE episodes_translations DROP COLUMN date_updated;
ALTER TABLE events_translations DROP COLUMN date_updated;
ALTER TABLE faqs_translations DROP COLUMN date_updated;
ALTER TABLE games_usergroups DROP COLUMN date_updated;
ALTER TABLE faqs_usergroups DROP COLUMN date_updated;
ALTER TABLE playlists_usergroups DROP COLUMN date_updated;
ALTER TABLE seasons_tags DROP COLUMN date_updated;
ALTER TABLE shorts_usergroups DROP COLUMN date_updated;
ALTER TABLE shows_tags DROP COLUMN date_updated;
ALTER TABLE faqcategories_translations DROP COLUMN date_updated;
ALTER TABLE games_styledimages DROP COLUMN date_updated;
ALTER TABLE games_translations DROP COLUMN date_updated;
ALTER TABLE lessons_translations DROP COLUMN date_updated;
ALTER TABLE languages DROP COLUMN date_updated;
ALTER TABLE lessons_relations DROP COLUMN date_updated;
ALTER TABLE materialized_views_meta DROP COLUMN date_updated;
ALTER TABLE links_translations DROP COLUMN date_updated;
ALTER TABLE notifications_targets DROP COLUMN date_updated;
ALTER TABLE notificationtemplates_translations DROP COLUMN date_updated;
ALTER TABLE pages_translations DROP COLUMN date_updated;
ALTER TABLE persons_styledimages DROP COLUMN date_updated;
ALTER TABLE playlists_translations DROP COLUMN date_updated;
ALTER TABLE playlists_styledimages DROP COLUMN date_updated;
ALTER TABLE mediaitems_assets DROP COLUMN date_updated;
ALTER TABLE collections_translations DROP COLUMN date_updated;
ALTER TABLE mediaitems_translations DROP COLUMN date_updated;
ALTER TABLE computeddata_conditions DROP COLUMN date_updated;
ALTER TABLE persons DROP COLUMN date_updated;
ALTER TABLE lessons_images DROP COLUMN date_updated;
ALTER TABLE messagetemplates_translations DROP COLUMN date_updated;
ALTER TABLE messages_messagetemplates DROP COLUMN date_updated;
ALTER TABLE phrases_translations DROP COLUMN date_updated;
ALTER TABLE prompts_targets DROP COLUMN date_updated;
ALTER TABLE prompts_translations DROP COLUMN date_updated;
ALTER TABLE questionalternatives DROP COLUMN date_updated;
ALTER TABLE questionalternatives_translations DROP COLUMN date_updated;
ALTER TABLE seasons_translations DROP COLUMN date_updated;
ALTER TABLE seasons_usergroups DROP COLUMN date_updated;
ALTER TABLE sections_translations DROP COLUMN date_updated;
ALTER TABLE sections_usergroups DROP COLUMN date_updated;
ALTER TABLE shows_translations DROP COLUMN date_updated;
ALTER TABLE shows_usergroups DROP COLUMN date_updated;
ALTER TABLE songcollections DROP COLUMN date_updated;
ALTER TABLE songcollections_translations DROP COLUMN date_updated;
ALTER TABLE songs DROP COLUMN date_updated;
ALTER TABLE songs_translations DROP COLUMN date_updated;
ALTER TABLE studytopics_images DROP COLUMN date_updated;
ALTER TABLE studytopics_translations DROP COLUMN date_updated;
ALTER TABLE surveyquestions_translations DROP COLUMN date_updated;
ALTER TABLE surveys_translations DROP COLUMN date_updated;
ALTER TABLE tags_translations DROP COLUMN date_updated;
ALTER TABLE targets DROP COLUMN date_updated;
ALTER TABLE targets_usergroups DROP COLUMN date_updated;
ALTER TABLE tasks_images DROP COLUMN date_updated;
ALTER TABLE tasks_translations DROP COLUMN date_updated;
ALTER TABLE timedmetadata_persons DROP COLUMN date_updated;
ALTER TABLE timedmetadata_styledimages DROP COLUMN date_updated;
ALTER TABLE timedmetadata_translations DROP COLUMN date_updated;
ALTER TABLE translations_hash DROP COLUMN date_updated;
