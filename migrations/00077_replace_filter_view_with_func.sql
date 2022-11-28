-- +goose Up
CREATE TYPE filter_dataset_row AS
(
    collection text,
    id int,
    season_id int,
    show_id int,
    agerating_code text,
    type text,
    publish_date timestamp,
    published bool,
    available_from timestamp,
    available_to timestamp,
    roles text[],
    tags text[]
);

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION filter_dataset(p_roles varchar[])
    RETURNS setof filter_dataset_row AS
$$
WITH e_tags AS (SELECT et.episodes_id       AS id,
                       array_agg(tags.code) AS tags
                FROM episodes_tags et
                         JOIN tags ON tags.id = et.tags_id
                GROUP BY et.episodes_id),
     s_tags AS (SELECT st.seasons_id        AS id,
                       array_agg(tags.code) AS tags
                FROM seasons_tags st
                         JOIN tags ON tags.id = st.tags_id
                GROUP BY st.seasons_id),
     sh_tags AS (SELECT sht.shows_id         AS id,
                        array_agg(tags.code) AS tags
                 FROM shows_tags sht
                          JOIN tags ON tags.id = sht.tags_id
                 GROUP BY sht.shows_id)
SELECT 'episodes'::text                                                                                      AS collection,
       e.id,
       e.season_id,
       se.show_id,
       COALESCE(e.agerating_code, se.agerating_code)                                                         AS agerating_code,
       e.type,
       e.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                                                      AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags
FROM episodes e
         LEFT JOIN episode_roles roles ON roles.roles && p_roles AND roles.id = e.id
         LEFT JOIN episode_availability av ON av.id = e.id
         LEFT JOIN e_tags ON e_tags.id = e.id
         LEFT JOIN seasons se ON se.id = e.season_id
         LEFT JOIN s_tags ON s_tags.id = e.season_id
         LEFT JOIN sh_tags ON sh_tags.id = se.show_id
UNION
SELECT 'seasons'::text                                                               AS collection,
       se.id,
       NULL::integer                                                                 AS season_id,
       se.show_id,
       NULL::character varying                                                       AS agerating_code,
       se.agerating_code                                                             AS type,
       se.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                              AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags
FROM seasons se
         LEFT JOIN season_roles roles ON roles.roles && p_roles AND roles.id = se.id
         LEFT JOIN season_availability av ON av.id = se.id
         LEFT JOIN s_tags ON s_tags.id = se.id
         LEFT JOIN sh_tags ON sh_tags.id = se.show_id
UNION
SELECT 'shows'::text                                     AS collection,
       sh.id,
       NULL::integer                                     AS season_id,
       NULL::integer                                     AS show_id,
       sh.agerating_code,
       sh.type,
       sh.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(shr.roles, '{}'::character varying[])    AS roles,
       COALESCE(sh_tags.tags, '{}'::character varying[]) AS tags
FROM shows sh
         LEFT JOIN show_roles shr ON shr.roles && p_roles AND shr.id = sh.id
         LEFT JOIN show_availability av ON av.id = sh.id
         LEFT JOIN sh_tags ON sh_tags.id = sh.id;
$$ LANGUAGE SQL STABLE STRICT PARALLEL SAFE;
-- +goose StatementEnd

GRANT EXECUTE ON FUNCTION filter_dataset(varchar[]) TO api;

-- +goose Down

DROP FUNCTION filter_dataset(varchar[]);
DROP TYPE filter_dataset_row;

CREATE OR REPLACE VIEW "public"."filter_dataset" AS  WITH e_tags AS (
         SELECT et.episodes_id AS id,
            array_agg(tags.code) AS tags
           FROM (episodes_tags et
             JOIN tags ON ((tags.id = et.tags_id)))
          GROUP BY et.episodes_id
        ), s_tags AS (
         SELECT st.seasons_id AS id,
            array_agg(tags.code) AS tags
           FROM (seasons_tags st
             JOIN tags ON ((tags.id = st.tags_id)))
          GROUP BY st.seasons_id
        ), sh_tags AS (
         SELECT sht.shows_id AS id,
            array_agg(tags.code) AS tags
           FROM (shows_tags sht
             JOIN tags ON ((tags.id = sht.tags_id)))
          GROUP BY sht.shows_id
        )
 SELECT 'episodes'::text AS collection,
    e.id,
    e.season_id,
    se.show_id,
    COALESCE(e.agerating_code, se.agerating_code) AS agerating_code,
    e.type,
    e.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(roles.roles, '{}'::character varying[]) AS roles,
    ARRAY( SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags
   FROM ((((((episodes e
     LEFT JOIN episode_roles roles ON ((roles.id = e.id)))
     LEFT JOIN episode_availability av ON ((av.id = e.id)))
     LEFT JOIN e_tags ON ((e_tags.id = e.id)))
     LEFT JOIN seasons se ON ((se.id = e.season_id)))
     LEFT JOIN s_tags ON ((s_tags.id = e.season_id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
 SELECT 'seasons'::text AS collection,
    se.id,
    NULL::integer AS season_id,
    se.show_id,
    NULL::character varying AS agerating_code,
    se.agerating_code AS type,
    se.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(roles.roles, '{}'::character varying[]) AS roles,
    ARRAY( SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags
   FROM ((((seasons se
     LEFT JOIN season_roles roles ON ((roles.id = se.id)))
     LEFT JOIN season_availability av ON ((av.id = se.id)))
     LEFT JOIN s_tags ON ((s_tags.id = se.id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
 SELECT 'shows'::text AS collection,
    sh.id,
    NULL::integer AS season_id,
    NULL::integer AS show_id,
    sh.agerating_code,
    sh.type,
    sh.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(shr.roles, '{}'::character varying[]) AS roles,
    COALESCE(sh_tags.tags, '{}'::character varying[]) AS tags
   FROM (((shows sh
     LEFT JOIN show_roles shr ON ((shr.id = sh.id)))
     LEFT JOIN show_availability av ON ((av.id = sh.id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = sh.id)));

GRANT SELECT ON TABLE "public"."filter_dataset" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."filter_dataset"  IS NULL;
