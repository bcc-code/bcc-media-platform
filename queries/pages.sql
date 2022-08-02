-- name: getPages :many
WITH t AS (SELECT ts.pages_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM pages_translations ts
           GROUP BY ts.pages_id),
     r AS (SELECT p_1.id                                                   AS page_id,
                  (SELECT array_agg(DISTINCT eu.usergroups_code) AS array_agg
                   FROM sections_usergroups eu
                   WHERE (eu.sections_id IN (SELECT e.id
                                             FROM episodes e
                                             WHERE e.season_id = p_1.id))) AS roles
           FROM pages p_1)
SELECT p.id,
       p.code,
       p.type,
       p.status::text = 'published'::text AS published,
       p.show_id,
       p.season_id,
       p.episode_id,
       p.collection,
       t.title,
       t.description,
       r.roles
FROM pages p
         LEFT JOIN t ON t.pages_id = p.id
         LEFT JOIN r ON r.page_id = p.id
WHERE id = ANY($1::int[]);

-- name: listPages :many
WITH t AS (SELECT ts.pages_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM pages_translations ts
           GROUP BY ts.pages_id),
     r AS (SELECT p_1.id                                                   AS page_id,
                  (SELECT array_agg(DISTINCT eu.usergroups_code) AS array_agg
                   FROM sections_usergroups eu
                   WHERE (eu.sections_id IN (SELECT e.id
                                             FROM episodes e
                                             WHERE e.season_id = p_1.id))) AS roles
           FROM pages p_1)
SELECT p.id,
       p.code,
       p.type,
       p.status::text = 'published'::text AS published,
       p.show_id,
       p.season_id,
       p.episode_id,
       p.collection,
       t.title,
       t.description,
       r.roles
FROM pages p
         LEFT JOIN t ON t.pages_id = p.id
         LEFT JOIN r ON r.page_id = p.id;

-- name: getPagesByCode :many
WITH t AS (SELECT ts.pages_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM pages_translations ts
           GROUP BY ts.pages_id),
     r AS (SELECT p_1.id                                                   AS page_id,
                  (SELECT array_agg(DISTINCT eu.usergroups_code) AS array_agg
                   FROM sections_usergroups eu
                   WHERE (eu.sections_id IN (SELECT e.id
                                             FROM episodes e
                                             WHERE e.season_id = p_1.id))) AS roles
           FROM pages p_1)
SELECT p.id,
       p.code,
       p.type,
       p.status::text = 'published'::text AS published,
       p.show_id,
       p.season_id,
       p.episode_id,
       p.collection,
       t.title,
       t.description,
       r.roles
FROM pages p
         LEFT JOIN t ON t.pages_id = p.id
         LEFT JOIN r ON r.page_id = p.id
WHERE code = ANY($1::varchar[]);