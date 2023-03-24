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
WHERE a.profile_id = $1
  AND a.achievement_id = ANY ($2::uuid[]);

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
