-- name: getAchievements :many
WITH ts AS (SELECT achievements_id,
                   json_object_agg(languages_code, title)       as title,
                   json_object_agg(languages_code, description) as description
            FROM achievements_translations
            GROUP BY achievements_id),
     cons AS (SELECT achievement_id,
                     json_agg(c) as conditions
              FROM achievementconditions c
              GROUP BY achievement_id),
     images AS (SELECT achievement_id, json_object_agg(COALESCE(language, 'no'), df.filename_disk) as images
                FROM achievements_images
                         JOIN directus_files df on achievements_images.image = df.id
                GROUP BY achievement_id)
SELECT a.id,
       a.group_id,
       a.title       as original_title,
       a.description as original_description,
       ts.title,
       ts.description,
       images.images,
       cons.conditions
FROM "public"."achievements" a
         LEFT JOIN ts ON ts.achievements_id = a.id
         LEFT JOIN cons ON cons.achievement_id = a.id
         LEFT JOIN images ON images.achievement_id = a.id
WHERE a.id = ANY ($1::uuid[])
ORDER BY sort;

-- name: ListAchievements :many
SELECT id
FROM "public"."achievements"
WHERE status = 'published'
ORDER BY sort;

-- name: ListAchievementGroups :many
SELECT id
FROM "public"."achievementgroups"
WHERE status = 'published';

-- name: getAchievementsForGroups :many
SELECT id, group_id::uuid as parent_id
FROM "public"."achievements"
WHERE group_id = ANY ($1::uuid[])
ORDER BY sort;

-- name: getAchievementsForActions :many
SELECT achievement_id::uuid as id, action::varchar as parent_id
FROM achievementconditions
WHERE collection = $1::varchar
  AND action = ANY ($2::varchar[]);

-- name: getAchievementGroups :many
WITH ts AS (SELECT achievementgroups_id, json_object_agg(languages_code, title) as title
            FROM achievementgroups_translations
            GROUP BY achievementgroups_id)
SELECT ag.id, ag.title as original_title, ts.title
FROM achievementgroups ag
         LEFT JOIN ts ON ts.achievementgroups_id = ag.id
WHERE ag.id = ANY ($1::uuid[]);

-- name: GetAchievedAchievements :many
SELECT a.achievement_id as id
FROM "users"."achievements" a
WHERE a.profile_id = @profile_id
  AND a.achievement_id = ANY (@achievement_ids::uuid[]);

-- name: getAchievedAchievementsForProfiles :many
SELECT a.achievement_id as id, a.profile_id as parent_id
FROM "users"."achievements" a
WHERE a.profile_id = ANY ($1::uuid[])
ORDER BY a.achieved_at DESC;

-- name: getUnconfirmedAchievedAchievementsForProfiles :many
SELECT a.achievement_id as id, a.profile_id as parent_id
FROM "users"."achievements" a
WHERE a.profile_id = ANY ($1::uuid[])
  AND a.confirmed_at IS NULL;

-- name: ConfirmAchievement :exec
UPDATE "users"."achievements"
SET confirmed_at = NOW()
WHERE profile_id = $1
  AND achievement_id = $2;

-- name: GetAchievementsWithConditionAmountAchieved :many
SELECT c.achievement_id AS id, array_agg(c.id)::uuid[] AS condition_ids
FROM "public"."achievementconditions" c
         LEFT JOIN "users"."achievements" achieved
                   ON achieved.profile_id = $1 AND achieved.achievement_id = c.achievement_id
WHERE achieved IS NULL
  AND c.collection = $2
  AND c.action = $3
  AND c.amount <= $4
GROUP BY c.achievement_id;

-- name: GetNewConditionsForProfile :many
SELECT
    ac.achievement_id::uuid achievement_id,
    ac.id::uuid condition_id,
    ac.action,
    ac.collection,
    coalesce(ac.amount, 0)::int amount,
    COALESCE(array_agg(st.studytopics_id) FILTER (WHERE studytopics_id IS NOT NULL), '{}')::uuid[] studytopics
FROM achievements a
                                                                                                      LEFT JOIN users.achievements ua ON ua.profile_id = @profile_id::uuid AND a.id = ua.achievement_id
                                                                                                      LEFT JOIN achievementconditions ac ON ac.achievement_id = a.id
                                                                                                      LEFT JOIN achievementconditions_studytopics st ON ac.id = st.achievementconditions_id
WHERE status = 'published'
  AND action = 'completed'
  AND profile_id IS NULL
GROUP BY ac.id;

-- name: GetAchievementsWithTopicsCompletedAchieved :many
SELECT c.achievement_id AS id, array_agg(c.id)::uuid[] AS condition_ids
FROM "public"."achievementconditions" c
         LEFT JOIN "users"."achievements" achieved
                   ON achieved.profile_id = @profile_id AND achieved.achievement_id = c.achievement_id
         LEFT JOIN "public"."achievementconditions_studytopics" t ON t.achievementconditions_id = c.id
WHERE achieved IS NULL
  AND c.collection = 'topics'
  AND t.studytopics_id = ANY (@topic_ids::uuid[])
GROUP BY c.achievement_id;

-- name: SetAchievementAchieved :exec
INSERT INTO "users"."achievements" (profile_id, achievement_id, achieved_at, condition_ids)
VALUES ($1, $2, now(), $3)
ON CONFLICT(profile_id, achievement_id) DO UPDATE SET achieved_at = now();

-- name: achievementAchievedAt :many
SELECT a.achievement_id,
       a.achieved_at,
       a.confirmed_at
FROM "users"."achievements" a
WHERE a.profile_id = $1
  AND a.achievement_id = ANY ($2::uuid[]);

-- name: completedLessonsByTopic :many
WITH total AS (SELECT l.topic_id, t.lesson_id,
                      COUNT(t.id) task_count
               FROM tasks t
                        JOIN lessons l ON l.id = t.lesson_id
               WHERE t.status = 'published'
               GROUP BY l.topic_id, t.lesson_id),
     completed AS (SELECT l.topic_id, t.lesson_id, ta.profile_id, COUNT(t.id) completed_count
                   FROM tasks t
                            JOIN lessons l ON l.id = t.lesson_id
                            JOIN "users"."taskanswers" ta ON ta.task_id = t.id
                   GROUP BY l.topic_id, t.lesson_id, ta.profile_id)
SELECT total.topic_id as topic_id, completed.lesson_id::uuid as lesson_id, completed.profile_id::uuid as profile_id
FROM completed
         JOIN total ON total.lesson_id = completed.lesson_id
WHERE completed.profile_id = ANY (@profile_ids::uuid[]) AND
      completed.completed_count >= total.task_count
GROUP BY total.topic_id, completed.lesson_id::uuid, completed.profile_id::uuid;


-- name: GetAchieventsTranslatableTexts :many
SELECT id, title, description FROM achievements a
                              WHERE a.status = ANY ('{published,unlisted}')
                                AND (a.date_updated > @date_updated::timestamp OR a.date_updated IS NULL);

-- name: GetAchieventGroupsTranslatableTexts :many
SELECT id, title FROM achievementgroups a WHERE a.status = ANY ('{published,unlisted}')
                                                        AND (a.date_updated > @date_updated::timestamp OR a.date_updated IS NULL);


-- name: CreateAchievementGroup :one
INSERT INTO "achievementgroups" (id, user_created, date_created, title) VALUES (
                                                                                        gen_random_uuid(),
                                                                                        @user_created::uuid,
                                                                                        now(),
                                                                                        @title
                                                                                    ) RETURNING id;

-- name: CreateAchievement :one

INSERT INTO "achievements" (
                                     id,
    status,
    user_created,
    date_created,
    group_id,
    title,
    description,
    sort
) VALUES (
             gen_random_uuid(),
             @status,
             @user_created::uuid,
             now(),
             @group_id::uuid,
             @title,
             @description,
             @sort
         ) returning id;

-- name: CreateCondition :one
INSERT INTO "achievementconditions" (id, collection, action, amount, achievement_id)
VALUES (gen_random_uuid(), @collection, @action, @amount, @achievement_id) RETURNING id;

-- name: CreateTask :one
INSERT INTO tasks (
                   id,
                   user_created,
                   date_created,
                   question_type,
                   lesson_id,
                   title,
                   type,
                   status
)
VALUES (
          gen_random_uuid(),
          @user_created::uuid,
          now(),
          @question_type,
          @lesson_id::uuid,
          @title,
        @type,
        @status
       ) returning id;

-- name: AddStudytopicFilterToCondition :exec
INSERT INTO "achievementconditions_studytopics" (achievementconditions_id, studytopics_id)
VALUES (@condition_id::uuid, @studytopic_id::uuid);
