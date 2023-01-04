-- name: GetTargets :many
WITH groups AS (SELECT targets_id, array_agg(usergroups_code)::varchar[] as codes FROM targets_usergroups GROUP BY targets_id)
SELECT t.id,
       t.label,
       t.type,
       g.codes
FROM targets t
         LEFT JOIN groups g ON g.targets_id = t.id
WHERE id = ANY ($1::uuid[]);
