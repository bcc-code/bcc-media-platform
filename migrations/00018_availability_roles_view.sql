-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-05T07:13:58.292Z             ***/
/***********************************************************/

--- BEGIN CREATE VIEW "public"."episode_roles" ---

CREATE OR REPLACE VIEW "public"."episode_roles" AS  SELECT e.id,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups eu
          WHERE (eu.episodes_id = e.id)), ARRAY[]::character varying[]) AS roles,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups_download eu
          WHERE (eu.episodes_id = e.id)), ARRAY[]::character varying[]) AS roles_download,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups_earlyaccess eu
          WHERE (eu.episodes_id = e.id)), ARRAY[]::character varying[]) AS roles_earlyaccess
   FROM episodes e;
ALTER VIEW IF EXISTS "public"."episode_roles" OWNER TO btv;
GRANT SELECT ON TABLE "public"."episode_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."episode_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."episode_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."episode_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."episode_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."episode_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."episode_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_roles"  IS NULL;

--- END CREATE VIEW "public"."episode_roles" ---

--- BEGIN CREATE VIEW "public"."episode_availability" ---

CREATE OR REPLACE VIEW "public"."episode_availability" AS  SELECT e.id,
    (((e.status)::text = 'published'::text) AND ((e.season_id IS NULL) OR (((se.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text)))) AS published,
    COALESCE(GREATEST(e.available_from, se.available_from, s.available_from), '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(LEAST(e.available_to, se.available_to, s.available_to), '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
   FROM ((episodes e
     LEFT JOIN seasons se ON ((e.season_id = se.id)))
     LEFT JOIN shows s ON ((se.show_id = s.id)));
ALTER VIEW IF EXISTS "public"."episode_availability" OWNER TO btv;
GRANT SELECT ON TABLE "public"."episode_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."episode_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."episode_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."episode_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."episode_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."episode_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."episode_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_availability"  IS NULL;

--- END CREATE VIEW "public"."episode_availability" ---

--- BEGIN CREATE VIEW "public"."season_availability" ---

CREATE OR REPLACE VIEW "public"."season_availability" AS  SELECT se.id,
    (((se.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text)) AS published,
    COALESCE(GREATEST(se.available_from, s.available_from), '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(LEAST(se.available_to, s.available_to), '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
   FROM (seasons se
     LEFT JOIN shows s ON ((se.show_id = s.id)));
ALTER VIEW IF EXISTS "public"."season_availability" OWNER TO btv;
GRANT SELECT ON TABLE "public"."season_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."season_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."season_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."season_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."season_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."season_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."season_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."season_availability"  IS NULL;

--- END CREATE VIEW "public"."season_availability" ---

--- BEGIN CREATE VIEW "public"."season_roles" ---

CREATE OR REPLACE VIEW "public"."season_roles" AS  SELECT se.id,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM episodes e
                  WHERE (e.season_id = se.id)))), ARRAY[]::character varying[]) AS roles,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups_download eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM episodes e
                  WHERE (e.season_id = se.id)))), ARRAY[]::character varying[]) AS roles_download,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups_earlyaccess eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM episodes e
                  WHERE (e.season_id = se.id)))), ARRAY[]::character varying[]) AS roles_earlyaccess
   FROM seasons se;
ALTER VIEW IF EXISTS "public"."season_roles" OWNER TO btv;
GRANT SELECT ON TABLE "public"."season_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."season_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."season_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."season_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."season_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."season_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."season_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."season_roles"  IS NULL;

--- END CREATE VIEW "public"."season_roles" ---

--- BEGIN CREATE VIEW "public"."show_availability" ---

CREATE OR REPLACE VIEW "public"."show_availability" AS  SELECT sh.id,
    ((sh.status)::text = 'published'::text) AS published,
    COALESCE(sh.available_from, '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(sh.available_to, '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
   FROM shows sh;
ALTER VIEW IF EXISTS "public"."show_availability" OWNER TO btv;
GRANT SELECT ON TABLE "public"."show_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."show_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."show_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."show_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."show_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."show_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."show_availability" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_availability"  IS NULL;

--- END CREATE VIEW "public"."show_availability" ---

--- BEGIN CREATE VIEW "public"."show_roles" ---

CREATE OR REPLACE VIEW "public"."show_roles" AS  SELECT sh.id,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM episodes e
                  WHERE (e.season_id IN ( SELECT se.id
                           FROM seasons se
                          WHERE (se.show_id = sh.id)))))), ARRAY[]::character varying[]) AS roles,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups_download eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM episodes e
                  WHERE (e.season_id IN ( SELECT se.id
                           FROM seasons se
                          WHERE (se.show_id = sh.id)))))), ARRAY[]::character varying[]) AS roles_download,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM episodes_usergroups_earlyaccess eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM episodes e
                  WHERE (e.season_id IN ( SELECT se.id
                           FROM seasons se
                          WHERE (se.show_id = sh.id)))))), ARRAY[]::character varying[]) AS roles_earlyaccess
   FROM shows sh;
ALTER VIEW IF EXISTS "public"."show_roles" OWNER TO btv;
GRANT SELECT ON TABLE "public"."show_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."show_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."show_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."show_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."show_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."show_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."show_roles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles"  IS NULL;

--- END CREATE VIEW "public"."show_roles" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-05T07:13:59.528Z             ***/
/***********************************************************/

--- BEGIN DROP VIEW "public"."episode_roles" ---

DROP VIEW IF EXISTS "public"."episode_roles";
--- END DROP VIEW "public"."episode_roles" ---

--- BEGIN DROP VIEW "public"."episode_availability" ---

DROP VIEW IF EXISTS "public"."episode_availability";
--- END DROP VIEW "public"."episode_availability" ---

--- BEGIN DROP VIEW "public"."season_availability" ---

DROP VIEW IF EXISTS "public"."season_availability";
--- END DROP VIEW "public"."season_availability" ---

--- BEGIN DROP VIEW "public"."season_roles" ---

DROP VIEW IF EXISTS "public"."season_roles";
--- END DROP VIEW "public"."season_roles" ---

--- BEGIN DROP VIEW "public"."show_availability" ---

DROP VIEW IF EXISTS "public"."show_availability";
--- END DROP VIEW "public"."show_availability" ---

--- BEGIN DROP VIEW "public"."show_roles" ---

DROP VIEW IF EXISTS "public"."show_roles";
--- END DROP VIEW "public"."show_roles" ---
