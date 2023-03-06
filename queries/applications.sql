-- name: getApplications :many
WITH roles AS (SELECT r.applications_id,
                      array_agg(DISTINCT r.usergroups_code) as roles
               FROM applications_usergroups r
               GROUP BY r.applications_id)
SELECT a.id::int                          AS id,
       a.uuid                             AS uuid,
       a.code::varchar                    AS code,
       a.default                          AS "default",
       a.client_version,
       a.status = 'published'             AS published,
       a.page_id                          AS default_page_id,
       a.search_page_id                   AS search_page_id,
       a.standalone_related_collection_id AS standalone_related_collection_id,
       COALESCE(r.roles, '{}')::varchar[] AS roles
FROM applications a
         LEFT JOIN roles r ON a.id = r.applications_id
WHERE a.id = ANY ($1::int[])
  AND a.status = 'published';

-- name: listApplications :many
WITH roles AS (SELECT r.applications_id,
                      array_agg(DISTINCT r.usergroups_code) as roles
               FROM applications_usergroups r
               GROUP BY r.applications_id)
SELECT a.id::int                          AS id,
       a.uuid                             AS uuid,
       a.code::varchar                    AS code,
       a.default                          AS "default",
       a.client_version,
       a.status = 'published'             AS published,
       a.page_id                          AS default_page_id,
       a.search_page_id                   AS search_page_id,
       a.standalone_related_collection_id AS standalone_related_collection_id,
       COALESCE(r.roles, '{}')::varchar[] AS roles
FROM applications a
         LEFT JOIN roles r ON a.id = r.applications_id
WHERE a.status = 'published';

-- name: getApplicationIDsForCodes :many
SELECT p.id, p.code
FROM applications p
WHERE p.code = ANY ($1::varchar[]);
