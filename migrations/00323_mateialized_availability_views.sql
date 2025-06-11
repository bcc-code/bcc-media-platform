-- +goose Up

DROP MATERIALIZED VIEW IF EXISTS public.filter_dataset;
DROP VIEW IF EXISTS public.show_availability;
DROP VIEW IF EXISTS public.season_availability;
DROP VIEW IF EXISTS public.episode_availability;

CREATE MATERIALIZED VIEW public.episode_availability AS
SELECT e.id,
       e.status::text = 'published'::text AND
       (e.season_id IS NULL OR se.status::text = 'published'::text AND s.status::text = 'published'::text) AS published,
       COALESCE(GREATEST(mi.available_from, se.available_from, s.available_from),
                '1800-01-01 00:00:00'::timestamp without time zone)                                        AS available_from,
       COALESCE(LEAST(mi.available_to, se.available_to, s.available_to),
                '3000-01-01 00:00:00'::timestamp without time zone)                                        AS available_to,
       COALESCE(GREATEST(mi.published_at, se.publish_date, s.publish_date),
                '3000-01-01 00:00:00'::timestamp without time zone)                                        AS published_on,
       COALESCE(array_remove(array_agg(DISTINCT aal.languages_code), NULL::character varying),
                '{}'::character varying[])                                                                 AS audio,
       COALESCE(array_remove(array_agg(DISTINCT asl.languages_code), NULL::character varying),
                '{}'::character varying[])                                                                 AS subtitle,
       e.season_id
FROM episodes e
         JOIN mediaitems mi ON mi.id = e.mediaitem_id
         LEFT JOIN seasons se ON e.season_id = se.id
         LEFT JOIN shows s ON se.show_id = s.id
         LEFT JOIN assetstreams astr ON mi.asset_id = astr.asset_id
         LEFT JOIN assetstreams_audio_languages aal ON astr.id = aal.assetstreams_id
         LEFT JOIN assetstreams_subtitle_languages asl ON astr.id = asl.assetstreams_id
GROUP BY e.id, mi.id, se.id, s.id;

CREATE MATERIALIZED VIEW public.season_availability AS
SELECT se.id,
       se.status::text = 'published'::text AND s.status::text = 'published'::text                                  AS published,
       COALESCE(GREATEST(se.available_from, s.available_from),
                '1800-01-01 00:00:00'::timestamp without time zone)                                                AS available_from,
       COALESCE(LEAST(se.available_to, s.available_to),
                '3000-01-01 00:00:00'::timestamp without time zone)                                                AS available_to,
       ARRAY(SELECT DISTINCT unnest.unnest
             FROM unnest(array_accum(ea.audio)) unnest(unnest))                                                    AS audio,
       ARRAY(SELECT DISTINCT unnest.unnest
             FROM unnest(array_accum(ea.subtitle)) unnest(unnest))                                                 AS subtitles,
       se.show_id
FROM seasons se
         LEFT JOIN shows s ON se.show_id = s.id
         LEFT JOIN episode_availability ea ON se.id = ea.season_id AND ea.published
GROUP BY se.id, ea.published, se.available_from, se.available_to, se.show_id, s.status, s.available_from,
         s.available_to;

CREATE MATERIALIZED VIEW public.show_availability AS
SELECT sh.id,
       sh.status::text = 'published'::text                                             AS published,
       COALESCE(sh.available_from, '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
       COALESCE(sh.available_to, '3000-01-01 00:00:00'::timestamp without time zone)   AS available_to,
       ARRAY(SELECT DISTINCT unnest.unnest
             FROM unnest(array_accum(sa.audio)) unnest(unnest))                        AS audio,
       ARRAY(SELECT DISTINCT unnest.unnest
             FROM unnest(array_accum(sa.subtitles)) unnest(unnest))                    AS subtitles,
       sh.id                                                                           AS show_id
FROM shows sh
         LEFT JOIN season_availability sa ON sh.id = sa.show_id AND sa.published
GROUP BY sh.id, sh.status, sh.available_from, sh.available_to;

CREATE MATERIALIZED VIEW public.filter_dataset AS
WITH e_tags AS (SELECT e.id,
                       array_agg(tags.code) AS tags
                FROM mediaitems_tags mt
                         JOIN episodes e ON e.mediaitem_id = mt.mediaitems_id
                         JOIN tags ON tags.id = mt.tags_id
                GROUP BY e.id),
     s_tags AS (SELECT st.seasons_id        AS id,
                       array_agg(tags.code) AS tags
                FROM seasons_tags st
                         JOIN tags ON tags.id = st.tags_id
                GROUP BY st.seasons_id),
     sh_tags AS (SELECT sht.shows_id         AS id,
                        array_agg(tags.code) AS tags
                 FROM shows_tags sht
                          JOIN tags ON tags.id = sht.tags_id
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
       mi.published_at                                                                                       AS publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                                                      AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags,
       av.audio,
       av.subtitle                                                                                           AS subtitles
FROM episodes e
         JOIN mediaitems mi ON mi.id = e.mediaitem_id
         LEFT JOIN episode_roles roles ON roles.id = e.id
         LEFT JOIN episode_availability av ON av.id = e.id
         LEFT JOIN e_tags ON e_tags.id = e.id
         LEFT JOIN seasons se ON se.id = e.season_id
         LEFT JOIN s_tags ON s_tags.id = e.season_id
         LEFT JOIN sh_tags ON sh_tags.id = se.show_id
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
       ARRAY(SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags,
       av.audio,
       av.subtitles
FROM seasons se
         LEFT JOIN season_roles roles ON roles.id = se.id
         LEFT JOIN season_availability av ON av.id = se.id
         LEFT JOIN s_tags ON s_tags.id = se.id
         LEFT JOIN sh_tags ON sh_tags.id = se.show_id
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
       COALESCE(sh_tags.tags, '{}'::character varying[])  AS tags,
       av.audio,
       av.subtitles
FROM shows sh
         LEFT JOIN show_roles shr ON shr.id = sh.id
         LEFT JOIN show_availability av ON av.id = sh.id
         LEFT JOIN sh_tags ON sh_tags.id = sh.id
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
       g.status::text = 'published'::text                 AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags,
       '{}'::character varying[]                          AS audio,
       '{}'::character varying[]                          AS subtitles
FROM games g
         LEFT JOIN g_roles r ON r.games_id = g.id
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
       p.status::text = 'published'::text                 AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags,
       '{}'::character varying[]                          AS audio,
       '{}'::character varying[]                          AS subtitles
FROM playlists p
         LEFT JOIN p_roles r ON r.playlists_id = p.id
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
       s.status::text = 'published'::text                 AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags,
       '{no}'::character varying[]                        AS audio,
       '{no}'::character varying[]                        AS subtitles
FROM shorts s
         LEFT JOIN s_roles r ON r.shorts_id = s.id;

GRANT SELECT ON TABLE public.filter_dataset TO api;
GRANT SELECT ON TABLE public.filter_dataset TO background_worker;

GRANT SELECT ON TABLE public.episode_availability TO api;
GRANT SELECT ON TABLE public.episode_availability TO background_worker;

GRANT SELECT ON TABLE public.season_availability TO api;
GRANT SELECT ON TABLE public.season_availability TO background_worker;

GRANT SELECT ON TABLE public.show_availability TO api;
GRANT SELECT ON TABLE public.show_availability TO background_worker;

-- +goose Down

DROP MATERIALIZED VIEW IF EXISTS public.filter_dataset;
DROP MATERIALIZED VIEW IF EXISTS public.show_availability;
DROP MATERIALIZED VIEW IF EXISTS public.season_availability;
DROP MATERIALIZED VIEW IF EXISTS public.episode_availability;

CREATE VIEW public.episode_availability AS
SELECT e.id,
       e.status::text = 'published'::text AND
       (e.season_id IS NULL OR se.status::text = 'published'::text AND s.status::text = 'published'::text) AS published,
       COALESCE(GREATEST(mi.available_from, se.available_from, s.available_from),
                '1800-01-01 00:00:00'::timestamp without time zone)                                        AS available_from,
       COALESCE(LEAST(mi.available_to, se.available_to, s.available_to),
                '3000-01-01 00:00:00'::timestamp without time zone)                                        AS available_to,
       COALESCE(GREATEST(mi.published_at, se.publish_date, s.publish_date),
                '3000-01-01 00:00:00'::timestamp without time zone)                                        AS published_on,
       COALESCE(array_remove(array_agg(DISTINCT aal.languages_code), NULL::character varying),
                '{}'::character varying[])                                                                 AS audio,
       COALESCE(array_remove(array_agg(DISTINCT asl.languages_code), NULL::character varying),
                '{}'::character varying[])                                                                 AS subtitle,
       e.season_id
FROM episodes e
         JOIN mediaitems mi ON mi.id = e.mediaitem_id
         LEFT JOIN seasons se ON e.season_id = se.id
         LEFT JOIN shows s ON se.show_id = s.id
         LEFT JOIN assetstreams astr ON mi.asset_id = astr.asset_id
         LEFT JOIN assetstreams_audio_languages aal ON astr.id = aal.assetstreams_id
         LEFT JOIN assetstreams_subtitle_languages asl ON astr.id = asl.assetstreams_id
GROUP BY e.id, mi.id, se.id, s.id;

CREATE VIEW public.season_availability AS
SELECT se.id,
       se.status::text = 'published'::text AND s.status::text = 'published'::text                                  AS published,
       COALESCE(GREATEST(se.available_from, s.available_from),
                '1800-01-01 00:00:00'::timestamp without time zone)                                                AS available_from,
       COALESCE(LEAST(se.available_to, s.available_to),
                '3000-01-01 00:00:00'::timestamp without time zone)                                                AS available_to,
       ARRAY(SELECT DISTINCT unnest.unnest
             FROM unnest(array_accum(ea.audio)) unnest(unnest))                                                    AS audio,
       ARRAY(SELECT DISTINCT unnest.unnest
             FROM unnest(array_accum(ea.subtitle)) unnest(unnest))                                                 AS subtitles,
       se.show_id
FROM seasons se
         LEFT JOIN shows s ON se.show_id = s.id
         LEFT JOIN episode_availability ea ON se.id = ea.season_id AND ea.published
GROUP BY se.id, ea.published, se.available_from, se.available_to, se.show_id, s.status, s.available_from,
         s.available_to;

CREATE VIEW public.show_availability AS
SELECT sh.id,
       sh.status::text = 'published'::text                                             AS published,
       COALESCE(sh.available_from, '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
       COALESCE(sh.available_to, '3000-01-01 00:00:00'::timestamp without time zone)   AS available_to,
       ARRAY(SELECT DISTINCT unnest.unnest
             FROM unnest(array_accum(sa.audio)) unnest(unnest))                        AS audio,
       ARRAY(SELECT DISTINCT unnest.unnest
             FROM unnest(array_accum(sa.subtitles)) unnest(unnest))                    AS subtitles,
       sh.id                                                                           AS show_id
FROM shows sh
         LEFT JOIN season_availability sa ON sh.id = sa.show_id AND sa.published
GROUP BY sh.id, sh.status, sh.available_from, sh.available_to;

CREATE MATERIALIZED VIEW public.filter_dataset AS
WITH e_tags AS (SELECT e.id,
                       array_agg(tags.code) AS tags
                FROM mediaitems_tags mt
                         JOIN episodes e ON e.mediaitem_id = mt.mediaitems_id
                         JOIN tags ON tags.id = mt.tags_id
                GROUP BY e.id),
     s_tags AS (SELECT st.seasons_id        AS id,
                       array_agg(tags.code) AS tags
                FROM seasons_tags st
                         JOIN tags ON tags.id = st.tags_id
                GROUP BY st.seasons_id),
     sh_tags AS (SELECT sht.shows_id         AS id,
                        array_agg(tags.code) AS tags
                 FROM shows_tags sht
                          JOIN tags ON tags.id = sht.tags_id
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
       mi.published_at                                                                                       AS publish_date,
       av.published,
       av.available_from,
       av.available_to,
       COALESCE(roles.roles, '{}'::character varying[])                                                      AS roles,
       ARRAY(SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags,
       av.audio,
       av.subtitle                                                                                           AS subtitles
FROM episodes e
         JOIN mediaitems mi ON mi.id = e.mediaitem_id
         LEFT JOIN episode_roles roles ON roles.id = e.id
         LEFT JOIN episode_availability av ON av.id = e.id
         LEFT JOIN e_tags ON e_tags.id = e.id
         LEFT JOIN seasons se ON se.id = e.season_id
         LEFT JOIN s_tags ON s_tags.id = e.season_id
         LEFT JOIN sh_tags ON sh_tags.id = se.show_id
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
       ARRAY(SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags,
       av.audio,
       av.subtitles
FROM seasons se
         LEFT JOIN season_roles roles ON roles.id = se.id
         LEFT JOIN season_availability av ON av.id = se.id
         LEFT JOIN s_tags ON s_tags.id = se.id
         LEFT JOIN sh_tags ON sh_tags.id = se.show_id
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
       COALESCE(sh_tags.tags, '{}'::character varying[])  AS tags,
       av.audio,
       av.subtitles
FROM shows sh
         LEFT JOIN show_roles shr ON shr.id = sh.id
         LEFT JOIN show_availability av ON av.id = sh.id
         LEFT JOIN sh_tags ON sh_tags.id = sh.id
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
       g.status::text = 'published'::text                 AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags,
       '{}'::character varying[]                          AS audio,
       '{}'::character varying[]                          AS subtitles
FROM games g
         LEFT JOIN g_roles r ON r.games_id = g.id
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
       p.status::text = 'published'::text                 AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags,
       '{}'::character varying[]                          AS audio,
       '{}'::character varying[]                          AS subtitles
FROM playlists p
         LEFT JOIN p_roles r ON r.playlists_id = p.id
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
       s.status::text = 'published'::text                 AS published,
       '1800-01-01 00:00:00'::timestamp without time zone AS available_from,
       '3000-01-01 00:00:00'::timestamp without time zone AS available_to,
       COALESCE(r.roles, '{}'::character varying[])       AS roles,
       '{}'::character varying[]                          AS tags,
       '{no}'::character varying[]                        AS audio,
       '{no}'::character varying[]                        AS subtitles
FROM shorts s
         LEFT JOIN s_roles r ON r.shorts_id = s.id;

GRANT SELECT ON TABLE public.filter_dataset TO api;
GRANT SELECT ON TABLE public.filter_dataset TO background_worker;

GRANT SELECT ON TABLE public.episode_availability TO api;
GRANT SELECT ON TABLE public.episode_availability TO background_worker;

GRANT SELECT ON TABLE public.season_availability TO api;
GRANT SELECT ON TABLE public.season_availability TO background_worker;

GRANT SELECT ON TABLE public.show_availability TO api;
GRANT SELECT ON TABLE public.show_availability TO background_worker;
