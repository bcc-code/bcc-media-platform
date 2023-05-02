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
       t.competition_mode,
       ts.title,
       ts.secondary_title,
       ts.description,
       images.images
FROM tasks t
         LEFT JOIN ts ON ts.tasks_id = t.id
         LEFT JOIN images ON images.task_id = t.id
WHERE t.status = 'published'
  AND t.id = ANY ($1::uuid[])
ORDER BY t.sort;

-- name: getLessonsForItemsInCollection :many
SELECT rl.lessons_id AS id,
       rl.item       AS parent_id
FROM lessons_relations rl
WHERE rl.collection = $1
  AND rl.item = ANY ($2::varchar[])
ORDER BY rl.sort;

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
  AND rl.lessons_id = ANY ($1::uuid[])
ORDER BY rl.sort;

-- name: getLinksForLessons :many
SELECT rl.item       AS id,
       rl.lessons_id AS parent_id
FROM lessons_relations rl
WHERE rl.collection = 'links'
  AND rl.lessons_id = ANY ($1::uuid[])
ORDER BY rl.sort;

-- name: getQuestionAlternatives :many
WITH ts AS (SELECT questionalternatives_id, json_object_agg(languages_code, title) AS title
            FROM questionalternatives_translations
            GROUP BY questionalternatives_id)
SELECT qa.id, qa.title as original_title, qa.task_id, qa.is_correct, ts.title
FROM questionalternatives qa
         LEFT JOIN ts ON ts.questionalternatives_id = qa.id
WHERE qa.task_id = ANY ($1::uuid[])
ORDER BY qa.sort;

-- name: GetQuestionAlternativesByIDs :many
WITH ts AS (SELECT questionalternatives_id, json_object_agg(languages_code, title) AS title
            FROM questionalternatives_translations
            GROUP BY questionalternatives_id)
SELECT qa.id, qa.title as original_title, qa.task_id, qa.is_correct, ts.title
FROM questionalternatives qa
         LEFT JOIN ts ON ts.questionalternatives_id = qa.id
WHERE qa.id = ANY ($1::uuid[])
ORDER BY qa.sort;

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

-- name: getCompletedAndLockedTasks :many
SELECT a.task_id as id, a.profile_id as parent_id
FROM users.taskanswers a
         LEFT JOIN public.tasks t on a.task_id = t.id
WHERE a.profile_id = ANY ($1::uuid[])
  AND a.locked = true
  AND t.competition_mode = true
;

-- name: getCompletedLessons :many
WITH total AS (SELECT t.lesson_id,
                      COUNT(t.id) task_count
               FROM tasks t
               WHERE t.status = 'published'
               GROUP BY t.lesson_id),
     completed AS (SELECT t.lesson_id, ta.profile_id, COUNT(t.id) completed_count
                   FROM tasks t
                            JOIN "users"."taskanswers" ta ON ta.task_id = t.id
                   GROUP BY t.lesson_id, ta.profile_id)
SELECT completed.lesson_id::uuid as id, completed.profile_id::uuid as parent_id
FROM completed
         JOIN total ON total.lesson_id = completed.lesson_id
WHERE completed.profile_id = ANY ($1::uuid[])
-- >= instead of = In case somethig has been archived later
  AND completed.completed_count >= total.task_count;


-- name: getCompletedTopics :many
WITH total AS (SELECT l.topic_id,
                      COUNT(t.id) task_count
               FROM tasks t
                        JOIN lessons l ON l.id = t.lesson_id
               WHERE t.status = 'published'
               GROUP BY l.topic_id),
     completed AS (SELECT l.topic_id, ta.profile_id, COUNT(t.id) completed_count
                   FROM tasks t
                            JOIN "users"."taskanswers" ta ON ta.task_id = t.id
                            JOIN lessons l ON t.lesson_id = l.id
                   GROUP BY l.topic_id, ta.profile_id)
SELECT completed.topic_id::uuid as id, completed.profile_id::uuid as parent_id
FROM completed
         JOIN total ON total.topic_id = completed.topic_id
WHERE completed.profile_id = ANY (@profile_ids::uuid[])
  AND completed.completed_count >= total.task_count;

-- name: GetAnsweredTasks :many
SELECT ta.task_id
FROM "users"."taskanswers" ta
WHERE ta.profile_id = $1
  AND ta.task_id = ANY ($2::uuid[]);

-- name: GetSelectedAlternativesAndLockStatus :many
SELECT ta.task_id, ta.selected_alternatives::uuid[] as selected_alternatives, ta.locked as locked
FROM "users"."taskanswers" ta
WHERE ta.profile_id = $1
  AND ta.task_id = ANY (@task_ids::uuid[]);

-- name: SetTaskCompleted :exec
INSERT INTO "users"."taskanswers" (profile_id, task_id, selected_alternatives, updated_at)
VALUES ($1, $2, @selected_alternatives::uuid[], NOW())
ON CONFLICT (profile_id, task_id) DO UPDATE SET updated_at            = EXCLUDED.updated_at,
                                                selected_alternatives = @selected_alternatives::uuid[];

-- name: UpsertMessage :exec
INSERT INTO "users"."messages" (id, item_id, message, updated_at, created_at, metadata, age_group, org_id)
VALUES ($1, $2, $3, NOW(), NOW(), $4, @age_group::TEXT, @org_id::int4)
ON CONFLICT (id) DO UPDATE SET message    = EXCLUDED.message,
                               metadata   = EXCLUDED.metadata,
                               updated_at = EXCLUDED.updated_at;

-- name: UpdateMessage :exec
UPDATE users.messages
SET message    = @message::text,
    metadata   = @metadata,
    updated_at = now()
WHERE id = @id::varchar(32);

-- name: SetAnswerLock :exec
UPDATE users.taskanswers
SET locked = @locked::bool
WHERE (task_id, profile_id) IN (SELECT ta.task_id, ta.profile_id
                                FROM users.taskanswers ta
                                         LEFT JOIN public.tasks t ON ta.task_id = t.id
                                WHERE ta.profile_id = @profile_id::uuid
                                  AND t.lesson_id = @lesson_id::uuid
                                  AND t.competition_mode = true);

-- name: getDefaultLessonIDForTopicIDs :many
WITH completed AS (SELECT DISTINCT ON (task.lesson_id) task.lesson_id
                   FROM users.taskanswers answer
                            JOIN tasks task ON task.id = answer.task_id
                            JOIN lessons lesson ON lesson.id = task.lesson_id
                   WHERE lesson.topic_id = ANY (@topic_ids::uuid[])
                     AND answer.profile_id = @profile_id::uuid
                   ORDER BY task.lesson_id, lesson.sort)
SELECT DISTINCT ON (l.topic_id) l.topic_id as source, l.id as result
FROM lessons l
         LEFT JOIN completed c on c.lesson_id = l.id
WHERE c.lesson_id IS NULL
  AND l.topic_id = ANY (@topic_ids::uuid[])
ORDER BY l.topic_id, l.sort;
