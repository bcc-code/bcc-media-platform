-- name: getComputedForGroups :many
WITH conditions AS (SELECT c.computeddata_id, json_agg(c) as conditions
                    FROM computeddata_conditions c
                    GROUP BY c.computeddata_id)
SELECT g.id    as group_id,
       d.id    as id,
       d.value as result,
       c.conditions
FROM computeddatagroups g
         JOIN computeddata d ON d.group_id = g.id
         JOIN conditions c ON c.computeddata_id = d.id
WHERE g.id = ANY ($1::uuid[]);
