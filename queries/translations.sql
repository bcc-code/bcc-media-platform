-- name: ListEpisodeTranslations :many
WITH episodes AS (SELECT e.id
                  FROM episodes e
                           LEFT JOIN seasons s ON s.id = e.season_id
                           LEFT JOIN shows sh ON sh.id = s.show_id
                  WHERE e.status = ANY ('{published,unlisted}')
                    AND s.status = ANY ('{published,unlisted}')
                    AND sh.status = ANY ('{published,unlisted}'))
SELECT et.id, episodes_id as parent_id, languages_code, title, description, extra_description
FROM episodes_translations et
         JOIN episodes e ON e.id = et.episodes_id
WHERE et.languages_code = ANY ($1::varchar[]);

-- name: ClearEpisodeTranslations :exec
DELETE
FROM episodes_translations
WHERE episodes_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: ListSeasonTranslations :many
WITH seasons AS (SELECT s.id
                 FROM seasons s
                          LEFT JOIN shows sh ON sh.id = s.show_id
                 WHERE s.status = ANY ('{published,unlisted}')
                   AND sh.status = ANY ('{published,unlisted}'))
SELECT et.id, seasons_id as parent_id, languages_code, title, description
FROM seasons_translations et
         JOIN seasons e ON e.id = et.seasons_id
WHERE et.languages_code = ANY ($1::varchar[]);

-- name: ClearSeasonTranslations :exec
DELETE
FROM seasons_translations
WHERE seasons_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: ListShowTranslations :many
WITH shows AS (SELECT s.id
               FROM shows s
               WHERE s.status = ANY ('{published,unlisted}'))
SELECT et.id, shows_id as parent_id, languages_code, title, description
FROM shows_translations et
         JOIN shows e ON e.id = et.shows_id
WHERE et.languages_code = ANY ($1::varchar[]);

-- name: ClearShowTranslations :exec
DELETE
FROM shows_translations
WHERE shows_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: ListSectionTranslations :many
WITH sections AS (SELECT s.id
                  FROM sections s
                  WHERE s.status = 'published'
                    AND s.show_title = true)
SELECT st.id, sections_id as parent_id, languages_code, title, description
FROM sections_translations st
         JOIN sections e ON e.id = st.sections_id
WHERE st.languages_code = ANY ($1::varchar[]);

-- name: ClearSectionTranslations :exec
DELETE
FROM sections_translations
WHERE sections_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: ListPageTranslations :many
WITH pages AS (SELECT s.id
               FROM pages s
               WHERE s.status = ANY ('{published,unlisted}'))
SELECT st.id, pages_id as parent_id, languages_code, title, description
FROM pages_translations st
         JOIN pages e ON e.id = st.pages_id
WHERE st.languages_code = ANY ($1::varchar[]);

-- name: ClearPageTranslations :exec
DELETE
FROM pages_translations
WHERE pages_id = ANY ($1::int[])
  AND languages_code != 'no';

-- name: ListLinkTranslations :many
WITH links AS (SELECT s.id
               FROM links s
               WHERE s.status = ANY ('{published,unlisted}'))
SELECT st.id, links_id as parent_id, languages_code, title, description
FROM links_translations st
         JOIN links e ON e.id = st.links_id
WHERE st.languages_code = ANY ($1::varchar[]);

-- name: ListStudyTopicTranslations :many
WITH items AS (SELECT i.id
               FROM studytopics i
               WHERE i.status = ANY ('{published,unlisted}'))
SELECT ts.id, studytopics_id as parent_id, languages_code, title, description
FROM studytopics_translations ts
         JOIN items i ON i.id = ts.studytopics_id
WHERE ts.languages_code = ANY ($1::varchar[]);

-- name: ListLessonTranslations :many
WITH lessons AS (SELECT s.id
                 FROM lessons s
                 WHERE s.status = ANY ('{published,unlisted}'))
SELECT st.id, lessons_id as parent_id, languages_code, title, description
FROM lessons_translations st
         JOIN lessons e ON e.id = st.lessons_id
WHERE st.languages_code = ANY ($1::varchar[]);

-- name: ListTaskTranslations :many
WITH items AS (SELECT i.id
               FROM tasks i
               WHERE i.status = ANY ('{published,unlisted}'))
SELECT ts.id, tasks_id as parent_id, languages_code, title, description
FROM tasks_translations ts
         JOIN items i ON i.id = ts.tasks_id
WHERE ts.languages_code = ANY ($1::varchar[]);

-- name: ListAlternativeTranslations :many
WITH items AS (SELECT i.id
               FROM questionalternatives i)
SELECT ts.id, questionalternatives_id as parent_id, languages_code, title
FROM questionalternatives_translations ts
         JOIN items i ON i.id = ts.questionalternatives_id
WHERE ts.languages_code = ANY ($1::varchar[]);

-- name: ListAchievementTranslations :many
WITH items AS (SELECT i.id
               FROM achievements i)
SELECT ts.id, achievements_id as parent_id, languages_code, title, description
FROM achievements_translations ts
         JOIN items i ON i.id = ts.achievements_id
WHERE ts.languages_code = ANY ($1::varchar[]);

-- name: ListAchievementGroupTranslations :many
WITH items AS (SELECT i.id
               FROM achievementgroups i)
SELECT ts.id, achievementgroups_id as parent_id, languages_code, title, description
FROM achievementgroups_translations ts
         JOIN items i ON i.id = ts.achievementgroups_id
WHERE ts.languages_code = ANY ($1::varchar[]);

-- name: ListStudyTopicOriginalTranslations :many
SELECT items.id, items.title, items.description
FROM studytopics items
WHERE status = ANY ('{published,unlisted}');

-- name: ClearStudyTopicTranslations :exec
DELETE
FROM studytopics_translations ts
WHERE ts.studytopics_id = ANY ($1::uuid[]);

-- name: ListLessonOriginalTranslations :many
SELECT items.id, items.title, items.description
FROM lessons items
WHERE status = ANY ('{published,unlisted}');

-- name: ClearLessonTranslations :exec
DELETE
FROM lessons_translations ts
WHERE ts.lessons_id = ANY ($1::uuid[]);

-- name: ListTaskOriginalTranslations :many
SELECT items.id, items.title, items.description
FROM tasks items
WHERE status = ANY ('{published,unlisted}');

-- name: ClearTaskTranslations :exec
DELETE
FROM tasks_translations ts
WHERE ts.tasks_id = ANY ($1::uuid[]);

-- name: ListQuestionAlternativesOriginalTranslations :many
SELECT items.id, items.title
FROM questionalternatives items
         JOIN tasks t ON t.id = items.task_id
WHERE t.status = ANY ('{published,unlisted}');

-- name: ClearQuestionAlternativeTranslations :exec
DELETE
FROM questionalternatives_translations ts
WHERE ts.questionalternatives_id = ANY ($1::uuid[]);

-- name: ListAchievementOriginalTranslations :many
SELECT items.id, items.title, items.description
FROM achievements items
WHERE status = ANY ('{published,unlisted}');

-- name: ClearAchievementTranslations :exec
DELETE
FROM achievements_translations ts
WHERE ts.achievements_id = ANY ($1::uuid[]);

-- name: ListAchievementGroupOriginalTranslations :many
SELECT items.id, items.title
FROM achievementgroups items
WHERE status = ANY ('{published,unlisted}');

-- name: ClearAchievementGroupTranslations :exec
DELETE
FROM achievementgroups_translations ts
WHERE ts.achievementgroups_id = ANY ($1::uuid[]);


-- name: ListSurveyOriginalTranslations :many
SELECT items.id, items.title, items.description
FROM surveys items
WHERE status = ANY ('{published,unlisted}');

-- name: ClearSurveyTranslations :exec
DELETE
FROM surveys_translations ts
WHERE ts.surveys_id = ANY ($1::uuid[]);

-- name: ListSurveyTranslations :many
WITH items AS (SELECT i.id
               FROM surveys i
               WHERE i.status = ANY ('{published,unlisted}'))
SELECT ts.id, surveys_id as parent_id, languages_code, title, description
FROM surveys_translations ts
         JOIN items i ON i.id = ts.surveys_id
WHERE ts.languages_code = ANY ($1::varchar[]);

-- name: ListSurveyQuestionOriginalTranslations :many
SELECT items.id, items.title, items.description, items.placeholder
FROM surveyquestions items;

-- name: ClearSurveyQuestionTranslations :exec
DELETE
FROM surveyquestions_translations ts
WHERE ts.surveyquestions_id = ANY ($1::uuid[]);

-- name: ListSurveyQuestionTranslations :many
SELECT ts.id, surveyquestions_id as parent_id, languages_code, ts.title, ts.description, ts.placeholder
FROM surveyquestions_translations ts
         JOIN surveyquestions items ON items.id = ts.surveyquestions_id
         JOIN surveys s ON s.id = items.survey_id AND s.status = ANY ('{published,unlisted}')
WHERE ts.languages_code = ANY ($1::varchar[]);

----------
-- FAQ ---
----------

-- name: ListFAQOriginalTranslations :many
SELECT items.id, items.question, items.answer
FROM faqs items
WHERE status = ANY ('{published,unlisted}');

-- name: ListFAQTranslations :many
WITH items AS (SELECT i.id
               FROM faqs i
               WHERE i.status = ANY ('{published,unlisted}'))
SELECT ts.id, faqs_id as parent_id, languages_code, question, answer
FROM faqs_translations ts
         JOIN items i ON i.id = ts.faqs_id
WHERE ts.languages_code = ANY ($1::varchar[]);

-- name: ClearFAQTranslations :exec
DELETE
FROM faqs_translations ts
WHERE ts.faqs_id = ANY ($1::uuid[]);


-- name: ListFAQCategoryOriginalTranslations :many
SELECT items.id, items.title, items.description
FROM faqcategories items
WHERE status = ANY ('{published,unlisted}');

-- name: ListFAQCategoryTranslations :many
WITH items AS (SELECT i.id
               FROM faqcategories i
               WHERE i.status = ANY ('{published,unlisted}'))
SELECT ts.id, faqcategories_id as parent_id, languages_code, title, description
FROM faqcategories_translations ts
         JOIN items i ON i.id = ts.faqcategories_id
WHERE ts.languages_code = ANY ($1::varchar[]);

-- name: ClearFAQCategoryTranslations :exec
DELETE
FROM faqcategories_translations ts
WHERE ts.faqcategories_id = ANY ($1::uuid[]);
