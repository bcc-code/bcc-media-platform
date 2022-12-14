--name: getAchievements :many
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

--name: listAchievements :many
SELECT id
FROM "public"."achievements"
WHERE status = 'published';

--name: getAchievementsForGroups :many
SELECT id, group_id
FROM "public"."achievements"
WHERE group_id = ANY ($1::uuid[]);

--name: getAchievementsForActions :many
SELECT id, action
FROM achievementconditions
WHERE collection = $1
  AND action = ANY ($2);
