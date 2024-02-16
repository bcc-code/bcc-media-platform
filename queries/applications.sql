-- name: getApplications :many
SELECT a.id::int                                 AS id,
       a.uuid                                    AS uuid,
       a.group_id                                AS group_id,
       a.code::varchar                           AS code,
       a.default                                 AS "default",
       a.client_version,
       a.status = 'published'                    AS published,
       a.page_id                                 AS default_page_id,
       a.search_page_id                          AS search_page_id,
       a.games_page_id                           AS games_page_id,
       a.standalone_related_collection_id        AS standalone_related_collection_id,
       g.support_email                           AS support_email,
       COALESCE(r.roles, '{}')::varchar[]        AS roles,
       COALESCE(ls_roles.roles, '{}')::varchar[] AS livestream_roles
FROM applications a
         JOIN applicationgroups g ON g.id = a.group_id
         LEFT JOIN (SELECT r.applicationgroups_id, array_agg(DISTINCT r.usergroups_code) roles
                    FROM applicationgroups_usergroups r
                    GROUP BY r.applicationgroups_id) r ON r.applicationgroups_id = g.id
         LEFT JOIN (SELECT r.applicationgroups_id, array_agg(DISTINCT r.usergroups_code) roles
                    FROM applicationgroups_usergroups_ls r
                    GROUP BY r.applicationgroups_id) ls_roles ON ls_roles.applicationgroups_id = g.id
WHERE a.id = ANY ($1::int[])
  AND a.status = 'published';

-- name: listApplications :many
SELECT a.id::int                                 AS id,
       a.uuid                                    AS uuid,
       a.group_id                                AS group_id,
       a.code::varchar                           AS code,
       a.default                                 AS "default",
       a.client_version,
       a.status = 'published'                    AS published,
       a.page_id                                 AS default_page_id,
       a.search_page_id                          AS search_page_id,
       a.games_page_id                           AS games_page_id,
       a.standalone_related_collection_id        AS standalone_related_collection_id,
       g.support_email                           AS support_email,
       COALESCE(r.roles, '{}')::varchar[]        AS roles,
       COALESCE(ls_roles.roles, '{}')::varchar[] AS livestream_roles
FROM applications a
         JOIN applicationgroups g ON g.id = a.group_id
         LEFT JOIN (SELECT r.applicationgroups_id, array_agg(DISTINCT r.usergroups_code) roles
                    FROM applicationgroups_usergroups r
                    GROUP BY r.applicationgroups_id) r ON r.applicationgroups_id = g.id
         LEFT JOIN (SELECT r.applicationgroups_id, array_agg(DISTINCT r.usergroups_code) roles
                    FROM applicationgroups_usergroups_ls r
                    GROUP BY r.applicationgroups_id) ls_roles ON ls_roles.applicationgroups_id = g.id
WHERE a.status = 'published';

-- name: getApplicationGroups :many
WITH roles AS (SELECT r.applicationgroups_id,
                      array_agg(DISTINCT r.usergroups_code) as roles
               FROM applicationgroups_usergroups r
               GROUP BY r.applicationgroups_id)
SELECT g.id,
       COALESCE(r.roles, '{}')::varchar[] AS roles
FROM applicationgroups g
         LEFT JOIN roles r ON g.id = r.applicationgroups_id
WHERE g.id = ANY (@id::uuid[]);

-- name: getApplicationIDsForCodes :many
SELECT p.id, p.code
FROM applications p
WHERE p.code = ANY ($1::varchar[]);
