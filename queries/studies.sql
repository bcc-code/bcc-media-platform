-- name: getTopics :many
WITH ts AS (SELECT studytopics_id,
                   json_object_agg(languages_code, title) as title
            FROM studytopics_translations
            GROUP BY studytopics_id)
SELECT s.id,
       ts.title
FROM studytopics s
         LEFT JOIN ts ON ts.studytopics_id = s.id
WHERE s.status = 'published'
  AND s.id = ANY ($1::uuid[]);

-- name: getLessons :many
SELECT l.id, l.topic_id FROM lessons l WHERE l.status = 'published' AND l.id = ANY($1::uuid[]);

-- name: getTasks :many
SELECT
    t.id,
    t.type,
    t.question_type,
    t.lesson_id,
    t.alternatives_multiselect
FROM tasks t
WHERE t.status = 'published'
  AND t.id = ANY ($1::uuid[]);
