-- name: getTopics :many
WITH ts AS (SELECT studytopics_id,
                   json_object_agg(languages_code, title)       as title,
                   json_object_agg(languages_code, description) as description
            FROM studytopics_translations
            GROUP BY studytopics_id),
     imgs AS (SELECT images.topic_id, json_agg(images) as json
              FROM (SELECT topic_id, style, language, filename_disk
                    FROM studytopics_images
                             JOIN directus_files df on file = df.id) images
              GROUP BY images.topic_id)
SELECT s.id,
       s.title       as original_title,
       s.description as original_description,
       ts.title,
       ts.description,
       img.json      as images
FROM studytopics s
         LEFT JOIN ts ON ts.studytopics_id = s.id
         LEFT JOIN imgs img ON img.topic_id = s.id
WHERE s.status = 'published'
  AND s.id = ANY ($1::uuid[]);

-- name: getLessons :many
WITH ts AS (SELECT lessons_id,
                   json_object_agg(languages_code, title)       as title,
                   json_object_agg(languages_code, description) as description
            FROM lessons_translations
            GROUP BY lessons_id),
     imgs AS (SELECT images.lesson_id, json_agg(images) as json
              FROM (SELECT lesson_id, style, language, filename_disk
                    FROM lessons_images
                             JOIN directus_files df on file = df.id) images
              GROUP BY images.lesson_id)
SELECT l.id,
       l.topic_id,
       l.title       as original_title,
       l.description as original_description,
       ts.title,
       ts.description,
       img.json      as images
FROM lessons l
         LEFT JOIN ts ON ts.lessons_id = l.id
         LEFT JOIN imgs img ON img.lesson_id = l.id
WHERE l.status = 'published'
  AND l.id = ANY ($1::uuid[]);

-- name: getTasks :many
WITH ts AS (SELECT tasks_id,
                   json_object_agg(languages_code, title)           as title,
                   json_object_agg(languages_code, description)     as description,
                   json_object_agg(languages_code, secondary_title) as secondary_title
            FROM tasks_translations
            GROUP BY tasks_id),
     images AS (SELECT img.task_id, json_object_agg(img.language, df.filename_disk) as images
                FROM tasks_images img
                         JOIN directus_files df ON df.id = img.image
                GROUP BY img.task_id)
SELECT t.id,
       t.title           as original_title,
       t.secondary_title as original_secondary_title,
       t.description     as original_description,
       t.type,
       t.question_type,
       t.lesson_id,
       t.alternatives_multiselect,
       t.image_type,
       t.link_id,
       t.episode_id,
       ts.title,
       ts.secondary_title,
       ts.description,
       images.images
FROM tasks t
         LEFT JOIN ts ON ts.tasks_id = t.id
         LEFT JOIN images ON images.task_id = t.id
WHERE t.status = 'published'
  AND t.id = ANY ($1::uuid[]);

-- name: getLessonsForItemsInCollection :many
SELECT rl.lessons_id AS id,
       rl.item       AS parent_id
FROM lessons_relations rl
WHERE rl.collection = $1
  AND rl.item = ANY ($2::varchar[]);

-- name: getEpisodesForLessons :many
SELECT rl.item       AS id,
       rl.lessons_id AS parent_id
FROM lessons_relations rl
         JOIN episode_availability access ON access.id = rl.item::int
         JOIN episode_roles roles ON roles.id = rl.item::int
WHERE rl.collection = 'episodes'
  AND access.published
  AND access.available_to > now()
  AND (
        (roles.roles && $2::varchar[] AND access.available_from < now()) OR
        (roles.roles_earlyaccess && $2::varchar[])
    )
  AND rl.lessons_id = ANY ($1::uuid[]);

-- name: getLinksForLessons :many
SELECT rl.item       AS id,
       rl.lessons_id AS parent_id
FROM lessons_relations rl
WHERE rl.collection = 'links'
  AND rl.lessons_id = ANY ($1::uuid[]);

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
  AND l.topic_id = ANY ($1::uuid[])
ORDER BY l.sort;

-- name: getTasksForLessons :many
SELECT t.id, t.lesson_id AS parent_id
FROM tasks t
WHERE t.status = 'published'
  AND t.lesson_id = ANY ($1::uuid[])
ORDER BY t.sort;

-- name: getCompletedTasks :many
SELECT ta.task_id as id, ta.profile_id as parent_id
FROM "users"."taskanswers" ta
WHERE ta.profile_id = ANY ($1::uuid[]);

-- name: getCompletedLessons :many
WITH total AS (SELECT t.lesson_id,
                      COUNT(t.id) task_count
               FROM tasks t
               GROUP BY t.lesson_id),
     completed AS (SELECT t.lesson_id, ta.profile_id, COUNT(t.id) completed_count
                   FROM tasks t
                            JOIN "users"."taskanswers" ta ON ta.task_id = t.id
                   GROUP BY t.lesson_id, ta.profile_id)
SELECT total.lesson_id as id, p.id as parent_id
FROM users.profiles p
         JOIN completed ON completed.profile_id = p.id
         JOIN total ON total.lesson_id = completed.lesson_id
WHERE p.id = ANY ($1::uuid[])
  AND completed.completed_count = total.task_count;

-- name: getCompletedTopics :many
WITH total AS (SELECT l.topic_id,
                      COUNT(t.id) task_count
               FROM tasks t
                        JOIN lessons l ON l.id = t.lesson_id
               GROUP BY l.topic_id),
     completed AS (SELECT t.lesson_id, ta.profile_id, COUNT(t.id) completed_count
                   FROM tasks t
                            JOIN "users"."taskanswers" ta ON ta.task_id = t.id
                            JOIN lessons l ON l.id = t.lesson_id
                   GROUP BY t.lesson_id, ta.profile_id)
SELECT total.topic_id as id, p.id as parent_id
FROM users.profiles p
         JOIN completed ON completed.profile_id = p.id
         JOIN total ON total.topic_id = completed.lesson_id
WHERE p.id = ANY ($1::uuid[])
  AND completed.completed_count = total.task_count;

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
INSERT INTO "users"."messages" (id, item_id, message, updated_at, created_at, metadata)
VALUES ($1, $2, $3, NOW(), NOW(), $4)
ON CONFLICT (id) DO UPDATE SET message    = EXCLUDED.message,
                               metadata   = EXCLUDED.metadata,
                               updated_at = EXCLUDED.updated_at;
