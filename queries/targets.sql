-- name: GetTargets :many
WITH groups AS (SELECT targets_id, array_agg(usergroups_code)::varchar[] as codes
                FROM targets_usergroups
                GROUP BY targets_id)
SELECT t.id,
       t.type,
       g.codes AS group_codes
FROM targets t
         LEFT JOIN groups g ON g.targets_id = t.id
WHERE id = ANY ($1::uuid[]);

-- name: GetMemberIDs :many
SELECT u.id
FROM users.users u
WHERE @everyone::bool = true
   OR u.active_bcc;
