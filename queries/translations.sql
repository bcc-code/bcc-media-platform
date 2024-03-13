-- name: ListEpisodeTranslations :many
WITH episodes AS (SELECT e.id
                  FROM episodes e
                           LEFT JOIN seasons s ON s.id = e.season_id
                           LEFT JOIN shows sh ON sh.id = s.show_id
                  WHERE e.translations_required
                    AND e.status = ANY ('{published,unlisted}')
                    AND (e.season_id IS NULL OR (s.status = ANY ('{published,unlisted}')
                      AND sh.status = ANY ('{published,unlisted}'))))
SELECT et.id,
       episodes_id                                                   as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM episodes_translations et
         JOIN episodes e ON e.id = et.episodes_id
WHERE et.languages_code = @language::varchar;

-- name: ClearEpisodeTranslations :exec
DELETE
FROM episodes_translations
WHERE episodes_id = ANY (@episode_ids::int[])
  AND languages_code != 'no';

-- name: UpdateEpisodeTranslation :exec
INSERT INTO episodes_translations (episodes_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (episodes_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                        description = EXCLUDED.description;

-- name: ListSeasonTranslations :many
WITH seasons AS (SELECT s.id
                 FROM seasons s
                          JOIN shows sh ON sh.id = s.show_id
                 WHERE s.translations_required
                   AND s.status = ANY ('{published,unlisted}')
                   AND sh.status = ANY ('{published,unlisted}'))
SELECT et.id,
       seasons_id                                                    as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM seasons_translations et
         JOIN seasons e ON e.id = et.seasons_id
WHERE et.languages_code = @language::varchar;

-- name: ClearSeasonTranslations :exec
DELETE
FROM seasons_translations
WHERE seasons_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: UpdateSeasonTranslation :exec
INSERT INTO seasons_translations (seasons_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (seasons_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                       description = EXCLUDED.description;

-- name: ListShowTranslations :many
WITH shows AS (SELECT s.id
               FROM shows s
               WHERE s.translations_required
                 AND s.status = ANY ('{published,unlisted}'))
SELECT et.id,
       shows_id                                                      as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM shows_translations et
         JOIN shows e ON e.id = et.shows_id
WHERE et.languages_code = @language::varchar;

-- name: ClearShowTranslations :exec
DELETE
FROM shows_translations
WHERE shows_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: UpdateShowTranslation :exec
INSERT INTO shows_translations (shows_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (shows_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: ListEventTranslations :many
WITH events AS (SELECT s.id
                FROM events s
                WHERE s.status = ANY ('{published,unlisted}'))
SELECT et.id,
       events_id                                                     as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM events_translations et
         JOIN events e ON e.id = et.events_id
WHERE et.languages_code = @language::varchar;

-- name: ClearEventTranslations :exec
DELETE
FROM events_translations
WHERE events_id = ANY ($1::int[])
  AND languages_code != 'no';

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

-- name: ClearCalendarEntryTranslations :exec
DELETE
FROM calendarentries_translations
WHERE calendarentries_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: UpdateCalendarEntryTranslation :exec
INSERT INTO calendarentries_translations (calendarentries_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (calendarentries_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                               description = EXCLUDED.description;

-- name: ListSectionTranslations :many
WITH sections AS (SELECT s.id
                  FROM sections s
                  WHERE s.translations_required
                    AND s.status = 'published'
                    AND s.show_title = true)
SELECT st.id,
       sections_id                                                   as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM sections_translations st
         JOIN sections e ON e.id = st.sections_id
WHERE st.languages_code = @language::varchar;

-- name: ClearSectionTranslations :exec
DELETE
FROM sections_translations
WHERE sections_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: UpdateSectionTranslation :exec
INSERT INTO sections_translations (sections_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (sections_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                        description = EXCLUDED.description;

-- name: ListPageTranslations :many
WITH pages AS (SELECT s.id
               FROM pages s
               WHERE s.translations_required
                 AND s.status = ANY ('{published,unlisted}'))
SELECT st.id,
       pages_id                                                      as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM pages_translations st
         JOIN pages e ON e.id = st.pages_id
WHERE st.languages_code = @language::varchar;

-- name: ClearPageTranslations :exec
DELETE
FROM pages_translations
WHERE pages_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: UpdatePageTranslation :exec
INSERT INTO pages_translations (pages_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (pages_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: ListLinkTranslations :many
WITH links AS (SELECT s.id
               FROM links s
               WHERE s.translations_required
                 AND s.status = ANY ('{published,unlisted}'))
SELECT st.id,
       links_id                                                      as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM links_translations st
         JOIN links e ON e.id = st.links_id
WHERE st.languages_code = @language::varchar;

-- name: UpdateLinkTranslation :exec
INSERT INTO links_translations (links_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (links_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: ListStudyTopicTranslations :many
WITH items AS (SELECT i.id
               FROM studytopics i
               WHERE i.translations_required
                 AND i.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       studytopics_id                                                as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM studytopics_translations ts
         JOIN items i ON i.id = ts.studytopics_id
WHERE ts.languages_code = @language::varchar;

-- name: UpdateStudyTopicTranslation :exec
INSERT INTO studytopics_translations (studytopics_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (studytopics_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                           description = EXCLUDED.description;

-- name: ListLessonTranslations :many
WITH lessons AS (SELECT s.id
                 FROM lessons s
                 WHERE s.translations_required
                   AND s.status = ANY ('{published,unlisted}'))
SELECT st.id,
       lessons_id                                                    as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM lessons_translations st
         JOIN lessons e ON e.id = st.lessons_id
WHERE st.languages_code = @language::varchar;

-- name: UpdateLessonTranslation :exec
INSERT INTO lessons_translations (lessons_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (lessons_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                       description = EXCLUDED.description;

-- name: ListTaskTranslations :many
WITH items AS (SELECT i.id
               FROM tasks i
               WHERE i.translations_required
                 AND i.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       tasks_id                                                      as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM tasks_translations ts
         JOIN items i ON i.id = ts.tasks_id
WHERE ts.languages_code = @language::varchar;

-- name: UpdateTaskTranslation :exec
INSERT INTO tasks_translations (tasks_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (tasks_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: ListAlternativeTranslations :many
WITH items AS (SELECT i.id
               FROM questionalternatives i
                        JOIN tasks t ON t.id = i.task_id
               WHERE t.translations_required
                 AND t.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       questionalternatives_id           as parent_id,
       languages_code                    as language,
       json_build_object('title', title) as values
FROM questionalternatives_translations ts
         JOIN items i ON i.id = ts.questionalternatives_id
WHERE ts.languages_code = @language::varchar;

-- name: UpdateAlternativeTranslation :exec
INSERT INTO questionalternatives_translations (questionalternatives_id, languages_code, title)
VALUES (@item_id, @language, @title)
ON CONFLICT (questionalternatives_id, languages_code) DO UPDATE SET title = EXCLUDED.title;

-- name: ListAchievementTranslations :many
WITH items AS (SELECT i.id
               FROM achievements i
                        JOIN achievementgroups g ON g.id = i.group_id
               WHERE g.translations_required
                 AND g.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       achievements_id                                               as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM achievements_translations ts
         JOIN items i ON i.id = ts.achievements_id
WHERE ts.languages_code = @language::varchar;

-- name: UpdateAchievementTranslation :exec
INSERT INTO achievements_translations (achievements_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (achievements_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                            description = EXCLUDED.description;

-- name: ListAchievementGroupTranslations :many
WITH items AS (SELECT i.id
               FROM achievementgroups i
               WHERE i.translations_required
                 AND i.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       achievementgroups_id                                          as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM achievementgroups_translations ts
         JOIN items i ON i.id = ts.achievementgroups_id
WHERE ts.languages_code = @language::varchar;

-- name: UpdateAchievementGroupTranslation :exec
INSERT INTO achievementgroups_translations (achievementgroups_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (achievementgroups_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                                 description = EXCLUDED.description;

-- name: ListStudyTopicOriginalTranslations :many
SELECT items.id,
       json_build_object('title', items.title, 'description', items.description) as values
FROM studytopics items
WHERE items.translations_required
  AND status = ANY ('{published,unlisted}');

-- name: ClearStudyTopicTranslations :exec
DELETE
FROM studytopics_translations ts
WHERE ts.studytopics_id = ANY ($1::uuid[]);

-- name: ListLessonOriginalTranslations :many
SELECT items.id,
       json_build_object('title', items.title, 'description', items.description) as values
FROM lessons items
WHERE items.translations_required
  AND status = ANY ('{published,unlisted}');

-- name: ClearLessonTranslations :exec
DELETE
FROM lessons_translations ts
WHERE ts.lessons_id = ANY ($1::uuid[]);

-- name: ListTaskOriginalTranslations :many
SELECT items.id,
       json_build_object('title', items.title, 'description', items.description) as values
FROM tasks items
WHERE items.translations_required
  AND status = ANY ('{published,unlisted}');

-- name: ClearTaskTranslations :exec
DELETE
FROM tasks_translations ts
WHERE ts.tasks_id = ANY ($1::uuid[]);

-- name: ListQuestionAlternativesOriginalTranslations :many
SELECT items.id,
       json_build_object('title', items.title) as values
FROM questionalternatives items
         JOIN tasks t ON t.id = items.task_id
WHERE t.translations_required
  AND t.status = ANY ('{published,unlisted}');

-- name: ClearQuestionAlternativeTranslations :exec
DELETE
FROM questionalternatives_translations ts
WHERE ts.questionalternatives_id = ANY ($1::uuid[]);

-- name: ListAchievementOriginalTranslations :many
SELECT items.id,
       json_build_object('title', items.title, 'description', items.description) as values
FROM achievements items
         JOIN achievementgroups g ON g.id = items.group_id
WHERE g.translations_required
  AND items.status = ANY ('{published,unlisted}');

-- name: ClearAchievementTranslations :exec
DELETE
FROM achievements_translations ts
WHERE ts.achievements_id = ANY ($1::uuid[]);

-- name: ListAchievementGroupOriginalTranslations :many
SELECT items.id,
       json_build_object('title', items.title) as values
FROM achievementgroups items
WHERE status = ANY ('{published,unlisted}');

-- name: ClearAchievementGroupTranslations :exec
DELETE
FROM achievementgroups_translations ts
WHERE ts.achievementgroups_id = ANY ($1::uuid[]);

--------------
-- SURVEYS ---
--------------

-- name: ListSurveyOriginalTranslations :many
SELECT items.id,
       json_build_object('title', items.title, 'description', items.description) as values
FROM surveys items
WHERE items.translations_required
  AND status = ANY ('{published,unlisted}');

-- name: ListSurveyTranslations :many
WITH items AS (SELECT i.id
               FROM surveys i
               WHERE i.translations_required
                 AND i.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       surveys_id                                                    as parent_id,
       languages_code                                                as language,
       json_build_object('title', title, 'description', description) as values
FROM surveys_translations ts
         JOIN items i ON i.id = ts.surveys_id
WHERE ts.languages_code = @language::varchar;

-- name: ClearSurveyTranslations :exec
DELETE
FROM surveys_translations ts
WHERE ts.surveys_id = ANY ($1::uuid[]);

-- name: UpdateSurveyTranslation :exec
INSERT INTO surveys_translations (surveys_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (surveys_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                       description = EXCLUDED.description;

-- name: ListSurveyQuestionOriginalTranslations :many
SELECT items.id,
       json_build_object('title', items.title, 'description', items.description, 'placeholder',
                         items.placeholder) as values
FROM surveyquestions items
         JOIN surveys s ON s.id = items.survey_id
WHERE s.translations_required
  AND s.status = ANY ('{published,unlisted}');

-- name: ListSurveyQuestionTranslations :many
SELECT ts.id,
       surveyquestions_id                                                                                 as parent_id,
       languages_code                                                                                     as language,
       json_build_object('title', ts.title, 'description', ts.description, 'placeholder', ts.placeholder) as values
FROM surveyquestions_translations ts
         JOIN surveyquestions items ON items.id = ts.surveyquestions_id
         JOIN surveys s ON s.id = items.survey_id AND s.status = ANY ('{published,unlisted}')
WHERE s.translations_required
  AND ts.languages_code = @language::varchar;

-- name: ClearSurveyQuestionTranslations :exec
DELETE
FROM surveyquestions_translations ts
WHERE ts.surveyquestions_id = ANY ($1::uuid[]);

-- name: UpdateSurveyQuestionTranslation :exec
INSERT INTO surveyquestions_translations (surveyquestions_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (surveyquestions_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                               description = EXCLUDED.description;

----------
-- FAQ ---
----------

-- name: ListFAQOriginalTranslations :many
SELECT items.id, json_build_object('question', items.question, 'answer', items.answer) as values
FROM faqs items
WHERE items.translations_required
  AND status = ANY ('{published,unlisted}');

-- name: ListFAQTranslations :many
WITH items AS (SELECT i.id
               FROM faqs i
               WHERE i.translations_required
                 AND i.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       faqs_id                                                         as parent_id,
       languages_code                                                  as language,
       json_build_object('question', ts.question, 'answer', ts.answer) as values
FROM faqs_translations ts
         JOIN items i ON i.id = ts.faqs_id
WHERE ts.languages_code = @language::varchar;

-- name: ClearFAQTranslations :exec
DELETE
FROM faqs_translations ts
WHERE ts.faqs_id = ANY ($1::uuid[]);

-- name: UpdateFAQTranslation :exec
INSERT INTO faqs_translations (faqs_id, languages_code, question, answer)
VALUES (@item_id, @language, @question, @answer)
ON CONFLICT (faqs_id, languages_code) DO UPDATE SET question = EXCLUDED.question,
                                                    answer   = EXCLUDED.answer;

-- name: ListFAQCategoryOriginalTranslations :many
SELECT items.id, json_build_object('title', items.title, 'description', items.description) as values
FROM faqcategories items
WHERE status = ANY ('{published,unlisted}');

-- name: ListFAQCategoryTranslations :many
WITH items AS (SELECT i.id
               FROM faqcategories i
               WHERE i.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       faqcategories_id                                                    as parent_id,
       languages_code                                                      as language,
       json_build_object('title', ts.title, 'description', ts.description) as values
FROM faqcategories_translations ts
         JOIN items i ON i.id = ts.faqcategories_id
WHERE ts.languages_code = @language::varchar;

-- name: ClearFAQCategoryTranslations :exec
DELETE
FROM faqcategories_translations ts
WHERE ts.faqcategories_id = ANY ($1::uuid[]);

-- name: UpdateFAQCategoryTranslation :exec
INSERT INTO faqcategories_translations (faqcategories_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (faqcategories_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                             description = EXCLUDED.description;

-- name: ListGameOriginalTranslations :many
SELECT items.id, json_build_object('title', items.title, 'description', items.description) as values
FROM games items
WHERE items.translations_required
  AND status = ANY ('{published,unlisted}');

-- name: ListGameTranslations :many
WITH items AS (SELECT i.id
               FROM games i
               WHERE i.translations_required
                 AND i.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       games_id                                                            as parent_id,
       languages_code                                                      as language,
       json_build_object('title', ts.title, 'description', ts.description) as values
FROM games_translations ts
         JOIN items i ON i.id = ts.games_id
WHERE ts.languages_code = @language::varchar;

-- name: ClearGameTranslations :exec
DELETE
FROM games_translations ts
WHERE ts.games_id = ANY ($1::uuid[]);

-- name: UpdateGameTranslation :exec
INSERT INTO games_translations (games_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (games_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                     description = EXCLUDED.description;

-- name: ListPlaylistOriginalTranslations :many
SELECT items.id, json_build_object('title', items.title, 'description', items.description) as values
FROM playlists items
WHERE items.translations_required
  AND status = ANY ('{published,unlisted}');

-- name: ListPlaylistTranslations :many
WITH items AS (SELECT i.id
               FROM playlists i
               WHERE i.translations_required
                 AND i.status = ANY ('{published,unlisted}'))
SELECT ts.id,
       playlists_id                                                        as parent_id,
       languages_code                                                      as language,
       json_build_object('title', ts.title, 'description', ts.description) as values
FROM playlists_translations ts
         JOIN items i ON i.id = ts.playlists_id
WHERE ts.languages_code = @language::varchar;

-- name: ClearPlaylistTranslations :exec
DELETE
FROM playlists_translations ts
WHERE ts.playlists_id = ANY ($1::uuid[]);

-- name: UpdatePlaylistTranslation :exec
INSERT INTO playlists_translations (playlists_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (playlists_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                         description = EXCLUDED.description;


-- name: ListMediaItemOriginalTranslations :many
SELECT items.id, json_build_object('title', items.title, 'description', items.description) as values
FROM mediaitems items
WHERE items.translations_required;

-- name: ListMediaItemTranslations :many
WITH items AS (SELECT i.id
               FROM mediaitems i
               WHERE i.translations_required)
SELECT ts.id,
       mediaitems_id                                                       as parent_id,
       languages_code                                                      as language,
       json_build_object('title', ts.title, 'description', ts.description) as values
FROM mediaitems_translations ts
         JOIN items i ON i.id = ts.mediaitems_id
WHERE ts.languages_code = @language::varchar;

-- name: ClearMediaItemTranslations :exec
DELETE
FROM mediaitems_translations ts
WHERE ts.mediaitems_id = ANY ($1::uuid[]);

-- name: UpdateMediaItemTranslation :exec
INSERT INTO mediaitems_translations (mediaitems_id, languages_code, title, description)
VALUES (@item_id, @language, @title, @description)
ON CONFLICT (mediaitems_id, languages_code) DO UPDATE SET title       = EXCLUDED.title,
                                                          description = EXCLUDED.description;
