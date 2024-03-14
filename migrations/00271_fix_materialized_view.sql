-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-14T14:37:31.016Z             ***/
/***********************************************************/

--- BEGIN ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

DROP MATERIALIZED VIEW IF EXISTS "public"."filter_dataset";
CREATE MATERIALIZED VIEW IF NOT EXISTS "public"."filter_dataset" AS
WITH e_tags AS (SELECT e.id,
                       array_agg(tags.code) AS tags
                FROM ((mediaitems_tags mt
                    JOIN episodes e ON ((e.mediaitem_id = mt.mediaitems_id)))
                    JOIN tags ON ((tags.id = mt.tags_id)))
                GROUP BY e.id),
     s_tags AS (SELECT st.seasons_id        AS id,
                       array_agg(tags.code) AS tags
                FROM (seasons_tags st
                    JOIN tags ON ((tags.id = st.tags_id)))
                GROUP BY st.seasons_id),
     sh_tags AS (SELECT sht.shows_id         AS id,
                        array_agg(tags.code) AS tags
                 FROM (shows_tags sht
                     JOIN tags ON ((tags.id = sht.tags_id)))
                 GROUP BY sht.shows_id),
     g_roles AS (SELECT r.games_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM games_usergroups r
                 GROUP BY r.games_id),
     p_roles AS (SELECT r.playlists_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM playlists_usergroups r
                 GROUP BY r.playlists_id),
     s_roles AS (SELECT r.shorts_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM shorts_usergroups r
                 GROUP BY r.shorts_id)
SELECT 'episodes'::text                                                                                      AS collection,
       e.id,
       e.uuid,
       COALESCE(e.season_id, 0)                                                                              AS season_id,
       COALESCE(se.show_id, 0)                                                                               AS show_id,
       COALESCE(mi.agerating_code, e.agerating_code, se.agerating_code,
                ''::character varying)                                                                       AS agerating_code,
       e.episode_number                                                                                      AS number,
       e.type,
       mi.published_at                                                                                       as publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                                                      AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags
FROM (((((((episodes e
    JOIN mediaitems mi ON ((mi.id = e.mediaitem_id)))
    LEFT JOIN episode_roles roles ON ((roles.id = e.id)))
    LEFT JOIN episode_availability av ON ((av.id = e.id)))
    LEFT JOIN e_tags ON ((e_tags.id = e.id)))
    LEFT JOIN seasons se ON ((se.id = e.season_id)))
    LEFT JOIN s_tags ON ((s_tags.id = e.season_id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
SELECT 'seasons'::text                                                               AS collection,
       se.id,
       se.uuid,
       0                                                                             AS season_id,
       se.show_id,
       COALESCE(se.agerating_code, ''::character varying)                            AS agerating_code,
       se.season_number                                                              AS number,
       ''::character varying                                                         AS type,
       se.publish_date                                                               AS publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                              AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags
FROM ((((seasons se
    LEFT JOIN season_roles roles ON ((roles.id = se.id)))
    LEFT JOIN season_availability av ON ((av.id = se.id)))
    LEFT JOIN s_tags ON ((s_tags.id = se.id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
SELECT 'shows'::text                                      AS collection,
       sh.id,
       sh.uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       COALESCE(sh.agerating_code, ''::character varying) AS agerating_code,
       0                                                  AS number,
       sh.type,
       sh.publish_date                                    AS publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(shr.roles, '{}'::character varying[])     AS roles,
       COALESCE(sh_tags.tags, '{}'::character varying[])  AS tags
FROM (((shows sh
    LEFT JOIN show_roles shr ON ((shr.id = sh.id)))
    LEFT JOIN show_availability av ON ((av.id = sh.id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = sh.id)))
UNION
SELECT 'games'::text                                      AS collection,
       0                                                  AS id,
       g.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((g.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (games g
    LEFT JOIN g_roles r ON ((r.games_id = g.id)))
UNION
SELECT 'playlists'::text                                  AS collection,
       0                                                  AS id,
       p.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((p.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (playlists p
    LEFT JOIN p_roles r ON ((r.playlists_id = p.id)))
UNION
SELECT 'shorts'::text                                     AS collection,
       0                                                  AS id,
       s.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((s.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (shorts s
    LEFT JOIN s_roles r ON ((r.shorts_id = s.id)));

GRANT SELECT ON TABLE "public"."filter_dataset" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON MATERIALIZED VIEW "public"."filter_dataset" IS NULL;

--- END ALTER MATERIALIZED VIEW "public"."filter_dataset" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-14T14:37:32.813Z             ***/
/***********************************************************/

--- BEGIN ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

DROP MATERIALIZED VIEW IF EXISTS "public"."filter_dataset";
CREATE MATERIALIZED VIEW IF NOT EXISTS "public"."filter_dataset" AS
WITH e_tags AS (SELECT e.id,
                       array_agg(tags.code) AS tags
                FROM ((mediaitems_tags mt
                    JOIN episodes e ON ((e.mediaitem_id = mt.mediaitems_id)))
                    JOIN tags ON ((tags.id = mt.tags_id)))
                GROUP BY e.id),
     s_tags AS (SELECT st.seasons_id        AS id,
                       array_agg(tags.code) AS tags
                FROM (seasons_tags st
                    JOIN tags ON ((tags.id = st.tags_id)))
                GROUP BY st.seasons_id),
     sh_tags AS (SELECT sht.shows_id         AS id,
                        array_agg(tags.code) AS tags
                 FROM (shows_tags sht
                     JOIN tags ON ((tags.id = sht.tags_id)))
                 GROUP BY sht.shows_id),
     g_roles AS (SELECT r.games_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM games_usergroups r
                 GROUP BY r.games_id),
     p_roles AS (SELECT r.playlists_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM playlists_usergroups r
                 GROUP BY r.playlists_id),
     s_roles AS (SELECT r.shorts_id,
                        array_agg(r.usergroups_code) AS roles
                 FROM shorts_usergroups r
                 GROUP BY r.shorts_id)
SELECT 'episodes'::text                                                                                      AS collection,
       e.id,
       e.uuid,
       COALESCE(e.season_id, 0)                                                                              AS season_id,
       COALESCE(se.show_id, 0)                                                                               AS show_id,
       COALESCE(e.agerating_code, se.agerating_code,
                ''::character varying)                                                                       AS agerating_code,
       e.episode_number                                                                                      AS number,
       e.type,
       e.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                                                      AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags
FROM ((((((episodes e
    LEFT JOIN episode_roles roles ON ((roles.id = e.id)))
    LEFT JOIN episode_availability av ON ((av.id = e.id)))
    LEFT JOIN e_tags ON ((e_tags.id = e.id)))
    LEFT JOIN seasons se ON ((se.id = e.season_id)))
    LEFT JOIN s_tags ON ((s_tags.id = e.season_id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
SELECT 'seasons'::text                                                               AS collection,
       se.id,
       se.uuid,
       0                                                                             AS season_id,
       se.show_id,
       COALESCE(se.agerating_code, ''::character varying)                            AS agerating_code,
       se.season_number                                                              AS number,
       ''::character varying                                                         AS type,
       se.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                              AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags
FROM ((((seasons se
    LEFT JOIN season_roles roles ON ((roles.id = se.id)))
    LEFT JOIN season_availability av ON ((av.id = se.id)))
    LEFT JOIN s_tags ON ((s_tags.id = se.id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
SELECT 'shows'::text                                      AS collection,
       sh.id,
       sh.uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       COALESCE(sh.agerating_code, ''::character varying) AS agerating_code,
       0                                                  AS number,
       sh.type,
       sh.publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(shr.roles, '{}'::character varying[])     AS roles,
       COALESCE(sh_tags.tags, '{}'::character varying[])  AS tags
FROM (((shows sh
    LEFT JOIN show_roles shr ON ((shr.id = sh.id)))
    LEFT JOIN show_availability av ON ((av.id = sh.id)))
    LEFT JOIN sh_tags ON ((sh_tags.id = sh.id)))
UNION
SELECT 'games'::text                                      AS collection,
       0                                                  AS id,
       g.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((g.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (games g
    LEFT JOIN g_roles r ON ((r.games_id = g.id)))
UNION
SELECT 'playlists'::text                                  AS collection,
       0                                                  AS id,
       p.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((p.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (playlists p
    LEFT JOIN p_roles r ON ((r.playlists_id = p.id)))
UNION
SELECT 'shorts'::text                                     AS collection,
       0                                                  AS id,
       s.id                                               AS uuid,
       0                                                  AS season_id,
       0                                                  AS show_id,
       ''::character varying                              AS agerating_code,
       0                                                  AS number,
       ''::character varying                              AS type,
       '1800-01-01 00:00:00'::timestamp without time zone AS publish_date,
       ((s.status)::text = 'published'::text)             AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags
FROM (shorts s
    LEFT JOIN s_roles r ON ((r.shorts_id = s.id)));

CREATE UNIQUE INDEX filter_dataset_uuid ON public.filter_dataset USING btree (uuid);

ALTER MATERIALIZED VIEW IF EXISTS "public"."filter_dataset" OWNER TO bccm;

GRANT SELECT ON TABLE "public"."filter_dataset" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."filter_dataset" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."filter_dataset" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."filter_dataset" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."filter_dataset" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."filter_dataset" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."filter_dataset" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."filter_dataset" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON MATERIALIZED VIEW "public"."filter_dataset" IS NULL;

DROP ROLE refresh_materialized_views;

--- END ALTER MATERIALIZED VIEW "public"."filter_dataset" ---
