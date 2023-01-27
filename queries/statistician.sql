-- name: GetAllMemberIDs :many
SELECT user_id FROM users.profiles GROUP BY user_id;

-- name: InsertMember :exec
INSERT INTO stats.members_data (id, age_group, org_id) VALUES (@id, @age_group, @org);

-- name: InsertOrg :exec
INSERT INTO stats.orgs(id, type, name)
VALUES (
	@org_id, @type, @name
) ON CONFLICT ON CONSTRAINT orgs_pk DO UPDATE SET
	name = @name
;

-- name: InsertOrgCounts :exec
insert into stats.org_counts(org_id, count_persons, age_group)
values (
	@org_id, @count_persons, @age_group
) ON CONFLICT ON CONSTRAINT org_counts_pk DO UPDATE SET
	count_persons = @count_persons
;

-- name: GetLessonProgressGroupedByOrg :many
-- counts generates a count per orgid and age group
--   SUB Query: Get the last task of the lesson
-- totals: Sum age groups for the orgs
-- Main Query: Calculate the % of answers per org for the task
WITH counts AS (SELECT m.org_id, count(*) as cnt FROM users.taskanswers a
         LEFT JOIN users.profiles p on p.id = a.profile_id
         LEFT JOIN stats.members_data m ON p.user_id = text(m.id)
         WHERE a.task_id  IN (
             SELECT DISTINCT  ON (l.id)  t.id FROM tasks t
                    LEFT JOIN lessons l ON t.lesson_id = l.id AND l.status = 'published'
                WHERE t.status = 'published' AND l.id = @lesson_id::uuid
                ORDER BY l.id, t.sort DESC)
         AND org_id IS NOT NULL
         AND m.age_group = ANY(@age_groups::text[])
group by m.org_id), totals as (
    SELECT org_id, SUM(count_persons) cnt
    FROM stats.org_counts
	WHERE age_group = ANY(@age_groups::text[])
    group by org_id
)
SELECT c.org_id, o.name, o.type, c.cnt as answers, t.cnt as totals, round(cast((c.cnt::float/t.cnt) as numeric), 2)::float as perc FROM counts c
LEFT JOIN totals t ON c.org_id = t.org_id
LEFT JOIN stats.orgs o ON o.id = t.org_id
WHERE t.cnt >= @min_size::int AND t.cnt <= @max_size::int
ORDER BY perc DESC ;

