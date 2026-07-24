-- name: GetUserIDByEmail :one
SELECT id FROM directus_users WHERE email = $1;

-- name: GetDirectusUserByID :one
-- admin_access mirrors Directus 11's derivation: any policy with
-- admin_access attached to the user directly or to the user's role or any
-- of its ancestors (child roles inherit parent policies).
WITH RECURSIVE role_chain(id) AS (
    SELECT u.role
    FROM directus_users u
    WHERE u.id = $1
    UNION ALL
    SELECT pr.parent
    FROM directus_roles pr
             JOIN role_chain c ON pr.id = c.id
    WHERE pr.parent IS NOT NULL
)
SELECT u.id, u.email, u.first_name, u.last_name, u.role, u.status, u.avatar,
       r.name AS role_name,
       EXISTS (
           SELECT 1
           FROM directus_access a
                    JOIN directus_policies p ON p.id = a.policy
           WHERE p.admin_access
             AND (a."user" = u.id OR a.role IN (SELECT id FROM role_chain))
       )::bool AS admin_access
FROM directus_users u
         LEFT JOIN directus_roles r ON r.id = u.role
WHERE u.id = $1;
