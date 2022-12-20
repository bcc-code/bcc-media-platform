-- name: getAchievements :many
WITH ts AS (SELECT achievements_id, json_object_agg(languages_code, title) as title
            FROM achievements_translations
            GROUP BY achievements_id),
     cons AS (SELECT achievement_id,
                     json_agg(c) as conditions
              FROM achievementconditions c
              GROUP BY achievement_id)
SELECT a.id,
       a.group_id,
       a.title as original_title,
       ts.title,
       cons.conditions
FROM "public"."achievements" a
         LEFT JOIN ts ON ts.achievements_id = a.id
         LEFT JOIN cons ON cons.achievement_id = a.id
WHERE a.id = ANY ($1::uuid[]);

-- name: listAchievements :many
SELECT id
FROM "public"."achievements"
WHERE status = 'published';

-- name: getAchievementsForGroups :many
SELECT id, group_id::uuid as parent_id
FROM "public"."achievements"
WHERE group_id = ANY ($1::uuid[]);

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
