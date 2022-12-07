-- name: getTopics :many
WITH ts AS (SELECT studytopics_id,
                   json_object_agg(languages_code, title) as title
            FROM studytopics_translations
            GROUP BY studytopics_id)
SELECT s.id,
       s.title as original_title,
       ts.title
FROM studytopics s
         LEFT JOIN ts ON ts.studytopics_id = s.id
WHERE s.status = 'published'
  AND s.id = ANY ($1::uuid[]);

-- name: getLessons :many
WITH ts AS (SELECT lessons_id,
                   json_object_agg(languages_code, title) as title
            FROM lessons_translations
            GROUP BY lessons_id)
SELECT l.id,
       l.topic_id,
       l.title as original_title,
       ts.title
FROM lessons l
         LEFT JOIN ts ON ts.lessons_id = l.id
WHERE l.status = 'published'
  AND l.id = ANY ($1::uuid[]);

-- name: getTasks :many
WITH ts AS (SELECT tasks_id,
                   json_object_agg(languages_code, title) as title
            FROM tasks_translations
            GROUP BY tasks_id)
SELECT t.id,
       t.title as original_title,
       t.type,
       t.question_type,
       t.lesson_id,
       t.alternatives_multiselect,
       ts.title
FROM tasks t
         LEFT JOIN ts ON ts.tasks_id = t.id
WHERE t.status = 'published'
  AND t.id = ANY ($1::uuid[]);

-- name: getQuestionAlternatives :many
WITH ts AS (SELECT questionalternatives_id, json_object_agg(languages_code, title) AS title
            FROM questionalternatives_translations
            GROUP BY questionalternatives_id)
SELECT qa.id, qa.title as original_title, qa.task_id, qa.is_correct, ts.title
FROM questionalternatives qa
         LEFT JOIN ts ON ts.questionalternatives_id = qa.id
WHERE qa.task_id = ANY ($1::uuid[]);

-- name: getLessonsForTopics :many
SELECT l.id, l.topic_id AS parent_id
FROM lessons l
WHERE l.status = 'published'
  AND l.topic_id = ANY ($1::uuid[]);

-- name: getTasksForLessons :many
SELECT t.id, t.lesson_id AS parent_id
FROM tasks t
WHERE t.status = 'published'
  AND t.lesson_id = ANY ($1::uuid[]);

-- name: GetAnsweredTasks :many
SELECT ta.task_id
FROM "users"."taskanswers" ta
WHERE ta.profile_id = $1
  AND ta.task_id = ANY ($2::uuid[]);

-- name: SetTaskCompleted :exec
INSERT INTO "users"."taskanswers" (profile_id, task_id, updated_at)
VALUES ($1, $2, NOW())
ON CONFLICT (profile_id, task_id) DO UPDATE SET updated_at = EXCLUDED.updated_at;

-- name: SetMessage :exec
INSERT INTO "users"."messages" (id, item_id, message, updated_at, created_at)
VALUES ($1, $2, $3, NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET message    = EXCLUDED.message,
                               updated_at = EXCLUDED.updated_at;
