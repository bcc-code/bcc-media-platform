-- name: GetEpisodeTranslatable :many
WITH episodes AS (SELECT e.id
                  FROM episodes e
                           LEFT JOIN seasons s ON s.id = e.season_id
                           LEFT JOIN shows sh ON sh.id = s.show_id
                  WHERE e.translations_required
                    AND e.status = ANY ('{published,unlisted}')
                    AND (e.season_id IS NULL OR (s.status = ANY ('{published,unlisted}')
                      AND sh.status = ANY ('{published,unlisted}'))))
SELECT e.id, title, description
FROM episodes_translations et
         JOIN episodes e ON e.id = et.episodes_id
WHERE et.languages_code = 'no';

-- name: GetSeasonTranslatable :many
SELECT s.id, title, description
FROM seasons_translations st
         JOIN seasons s ON s.id = st.seasons_id
         JOIN shows sh ON sh.id = s.show_id
WHERE st.languages_code = 'no'
  AND s.translations_required
  AND s.status = ANY ('{published,unlisted}')
  AND sh.status = ANY ('{published,unlisted}');


-- name: UpdateSeasonTranslation :exec
INSERT INTO seasons_translations (seasons_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (seasons_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                       description = EXCLUDED.description;

-- name: GetShowTranslatable :many
SELECT s.id, title, description
FROM shows_translations st
         JOIN shows s ON s.id = st.shows_id
WHERE st.languages_code = 'no'
  AND s.translations_required
  AND s.status = ANY ('{published,unlisted}');

-- name: UpdateShowTranslation :exec
INSERT INTO shows_translations (shows_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (shows_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: GetEventTranslatable :many
SELECT e.id, title, description
FROM events_translations et
         JOIN events e ON e.id = et.events_id
WHERE et.languages_code = 'no' AND e.status = ANY ('{published,unlisted}');


-- name: UpdateEventTranslation :exec
INSERT INTO events_translations (events_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (events_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                      description = EXCLUDED.description;

-- name: ListCalendarEntryTranslations :many
WITH calendarentries AS (SELECT s.id
                         FROM calendarentries s
                         WHERE s.status = ANY ('{published,unlisted}'))
SELECT et.id,
       calendarentries_id                                            as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM calendarentries_translations et
         JOIN events e ON e.id = et.calendarentries_id
WHERE et.languages_code = @language::varchar;

-- name: UpdateCalendarEntryTranslation :exec
INSERT INTO calendarentries_translations (calendarentries_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (calendarentries_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                               description = EXCLUDED.description;

-- name: GetSectionTranslatable :many
SELECT s.id,title,description
FROM sections_translations st
         JOIN sections s ON s.id = st.sections_id
WHERE st.languages_code = 'no'
  AND s.translations_required
  AND s.status = 'published'
  AND s.show_title = true;

-- name: UpdateSectionTranslation :exec
INSERT INTO sections_translations (sections_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (sections_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                        description = EXCLUDED.description;

-- name: GetPageTranslatable :many
SELECT p.id, title, description
FROM pages_translations pt
         JOIN pages p ON p.id = pt.pages_id
WHERE pt.languages_code = 'no' AND p.translations_required AND p.status = ANY ('{published,unlisted}');

-- name: UpdatePageTranslation :exec
INSERT INTO pages_translations (pages_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (pages_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;
-- name: GetLinkTranslatable :many
SELECT e.id, title, description
FROM links_translations st
         JOIN links e ON e.id = st.links_id
WHERE st.languages_code = 'no' AND e.translations_required AND status = ANY ('{published,unlisted}');

-- name: UpdateLinkTranslation :exec
INSERT INTO links_translations (links_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (links_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: UpdateStudyTopicTranslation :exec
INSERT INTO studytopics_translations (studytopics_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (studytopics_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                           description = EXCLUDED.description;

-- name: UpdateLessonTranslation :exec
INSERT INTO lessons_translations (lessons_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (lessons_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                       description = EXCLUDED.description;

-- name: UpdateTaskTranslation :exec
INSERT INTO tasks_translations (tasks_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (tasks_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: UpdateAlternativeTranslation :exec
INSERT INTO questionalternatives_translations (questionalternatives_id, languages_code, title)
VALUES (@item_id, @language, @title)
ON CONFLICT (questionalternatives_id, languages_code) DO UPDATE SET title = EXCLUDED.title;

-- name: UpdateAchievementTranslation :exec
INSERT INTO achievements_translations (achievements_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (achievements_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                            description = EXCLUDED.description;

-- name: UpdateAchievementGroupTranslation :exec
INSERT INTO achievementgroups_translations (achievementgroups_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (achievementgroups_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                                 description = EXCLUDED.description;

--------------
-- SURVEYS ---
--------------

-- name: UpdateSurveyTranslation :exec
INSERT INTO surveys_translations (surveys_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (surveys_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                       description = EXCLUDED.description;

-- name: UpdateSurveyQuestionTranslation :exec
INSERT INTO surveyquestions_translations (surveyquestions_id, languages_code, title, description, action_button_text, cancel_button_text)
VALUES (@item_id, @language, @title, @description, @action_button_text, @cancel_button_text)
ON CONFLICT (surveyquestions_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                               description = EXCLUDED.description,
                                                               action_button_text = EXCLUDED.action_button_text,
                                                               cancel_button_text = EXCLUDED.cancel_button_text;

----------
-- FAQ ---
----------

-- name: UpdateFAQTranslation :exec
INSERT INTO faqs_translations (faqs_id, languages_code, question, answer)
VALUES (@item_id, @language, @question::text, @answer::text)
ON CONFLICT (faqs_id, languages_code) DO UPDATE SET question = EXCLUDED.question,
                                                    answer   = EXCLUDED.answer;

-- name: UpdateFAQCategoryTranslation :exec
INSERT INTO faqcategories_translations (faqcategories_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (faqcategories_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                             description = EXCLUDED.description;

-- name: UpdateGameTranslation :exec
INSERT INTO games_translations (games_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (games_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: GetPlaylistTranslatable :many
SELECT id, title, description FROM playlists
WHERE translations_required
  AND status = ANY ('{published,unlisted}');

-- name: UpdatePlaylistTranslation :exec
INSERT INTO playlists_translations (playlists_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (playlists_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                         description = EXCLUDED.description;

-- name: UpdateMediaItemTranslation :exec
INSERT INTO mediaitems_translations (mediaitems_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (mediaitems_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                          description = EXCLUDED.description;

-- name: GetLessonsTranslatableText :many

SELECT id, title, description FROM lessons WHERE status = ANY ('{published,unlisted}') AND translations_required;

-- name: UpdateEpisodeTranslation :exec
INSERT INTO episodes_translations (episodes_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (episodes_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                        description = EXCLUDED.description;
