-- name: listSections :many
WITH t AS (SELECT ts.sections_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM sections_translations ts
           GROUP BY ts.sections_id),
     u AS (SELECT ug.sections_id,
                  array_agg(ug.usergroups_code) AS roles
           FROM sections_usergroups ug
           GROUP BY ug.sections_id)
SELECT s.id,
       s.page_id,
       s.style,
       s.sort,
       s.status::text = 'published'::text AS published,
       s.date_created,
       s.date_updated,
       s.collection_id,
       t.title,
       t.description,
       u.roles::character varying[] AS roles
FROM sections s
         LEFT JOIN t ON s.id = t.sections_id
         LEFT JOIN u ON s.id = u.sections_id;

-- name: getSections :many
WITH t AS (SELECT ts.sections_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM sections_translations ts
           GROUP BY ts.sections_id),
     u AS (SELECT ug.sections_id,
                  array_agg(ug.usergroups_code) AS roles
           FROM sections_usergroups ug
           GROUP BY ug.sections_id)
SELECT s.id,
       s.page_id,
       s.style,
       s.sort,
       s.status::text = 'published'::text AS published,
       s.date_created,
       s.date_updated,
       s.collection_id,
       t.title,
       t.description,
       u.roles::character varying[] AS roles
FROM sections s
         LEFT JOIN t ON s.id = t.sections_id
         LEFT JOIN u ON s.id = u.sections_id
WHERE s.id = ANY($1::int[]);

-- name: getSectionsForPageIDs :many
WITH t AS (SELECT ts.sections_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM sections_translations ts
           GROUP BY ts.sections_id),
     u AS (SELECT ug.sections_id,
                  array_agg(ug.usergroups_code) AS roles
           FROM sections_usergroups ug
           GROUP BY ug.sections_id)
SELECT s.id,
       s.page_id,
       s.style,
       s.sort,
       s.status::text = 'published'::text AS published,
       s.date_created,
       s.date_updated,
       s.collection_id,
       t.title,
       t.description,
       u.roles::character varying[] AS roles
FROM sections s
         LEFT JOIN t ON s.id = t.sections_id
         LEFT JOIN u ON s.id = u.sections_id
WHERE s.page_id = ANY($1::int[]);