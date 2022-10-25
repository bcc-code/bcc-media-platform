-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-25T11:12:39.241Z             ***/
/***********************************************************/

--- BEGIN ALTER VIEW "public"."season_roles" ---

DROP VIEW IF EXISTS "public"."season_roles";
CREATE OR REPLACE VIEW "public"."season_roles" AS
SELECT s.id,
       array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying)  AS roles,
       array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
       array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
FROM ((((seasons s
    LEFT JOIN episodes e ON ((e.season_id = s.id)))
    LEFT JOIN episodes_usergroups eu ON ((eu.episodes_id = e.id)))
    LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
    LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
GROUP BY s.id;

GRANT SELECT ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."season_roles" IS NULL;

--- END ALTER VIEW "public"."season_roles" ---

--- BEGIN ALTER VIEW "public"."show_roles" ---

DROP VIEW IF EXISTS "public"."show_roles";
CREATE OR REPLACE VIEW "public"."show_roles" AS
SELECT sh.id,
       array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying)  AS roles,
       array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
       array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
FROM (((((shows sh
    LEFT JOIN seasons s ON ((s.show_id = sh.id)))
    LEFT JOIN episodes e ON ((e.season_id = s.id)))
    LEFT JOIN episodes_usergroups eu ON ((eu.episodes_id = e.id)))
    LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
    LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
GROUP BY sh.id;

GRANT SELECT ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles" IS NULL;

--- END ALTER VIEW "public"."show_roles" ---

--- BEGIN ALTER VIEW "public"."episode_roles" ---

DROP VIEW IF EXISTS "public"."episode_roles";
CREATE OR REPLACE VIEW "public"."episode_roles" AS
SELECT e.id,
       array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying)  AS roles,
       array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
       array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
FROM (((episodes e
    LEFT JOIN episodes_usergroups eu ON ((eu.episodes_id = e.id)))
    LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
    LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
GROUP BY e.id;

GRANT SELECT ON TABLE "public"."episode_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_roles" IS NULL;

--- END ALTER VIEW "public"."episode_roles" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-25T11:12:40.857Z             ***/
/***********************************************************/

--- BEGIN ALTER VIEW "public"."episode_roles" ---

DROP VIEW IF EXISTS "public"."episode_roles";
CREATE OR REPLACE VIEW "public"."episode_roles" AS
SELECT e.id,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups eu
                 WHERE (eu.episodes_id = e.id)), ARRAY []::character varying[]) AS roles,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups_download eu
                 WHERE (eu.episodes_id = e.id)), ARRAY []::character varying[]) AS roles_download,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups_earlyaccess eu
                 WHERE (eu.episodes_id = e.id)), ARRAY []::character varying[]) AS roles_earlyaccess
FROM episodes e;

GRANT SELECT ON TABLE "public"."episode_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_roles" IS NULL;

--- END ALTER VIEW "public"."episode_roles" ---

--- BEGIN ALTER VIEW "public"."season_roles" ---

DROP VIEW IF EXISTS "public"."season_roles";
CREATE OR REPLACE VIEW "public"."season_roles" AS
SELECT se.id,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups eu
                 WHERE (eu.episodes_id IN (SELECT e.id
                                           FROM episodes e
                                           WHERE (e.season_id = se.id)))), ARRAY []::character varying[]) AS roles,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups_download eu
                 WHERE (eu.episodes_id IN (SELECT e.id
                                           FROM episodes e
                                           WHERE (e.season_id = se.id)))),
                ARRAY []::character varying[])                                                            AS roles_download,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups_earlyaccess eu
                 WHERE (eu.episodes_id IN (SELECT e.id
                                           FROM episodes e
                                           WHERE (e.season_id = se.id)))),
                ARRAY []::character varying[])                                                            AS roles_earlyaccess
FROM seasons se;

GRANT SELECT ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."season_roles" IS NULL;

--- END ALTER VIEW "public"."season_roles" ---

--- BEGIN ALTER VIEW "public"."show_roles" ---

DROP VIEW IF EXISTS "public"."show_roles";
CREATE OR REPLACE VIEW "public"."show_roles" AS
SELECT sh.id,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups eu
                 WHERE (eu.episodes_id IN (SELECT e.id
                                           FROM episodes e
                                           WHERE (e.season_id IN (SELECT se.id
                                                                  FROM seasons se
                                                                  WHERE (se.show_id = sh.id)))))),
                ARRAY []::character varying[]) AS roles,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups_download eu
                 WHERE (eu.episodes_id IN (SELECT e.id
                                           FROM episodes e
                                           WHERE (e.season_id IN (SELECT se.id
                                                                  FROM seasons se
                                                                  WHERE (se.show_id = sh.id)))))),
                ARRAY []::character varying[]) AS roles_download,
       COALESCE((SELECT array_agg(DISTINCT eu.usergroups_code) AS code
                 FROM episodes_usergroups_earlyaccess eu
                 WHERE (eu.episodes_id IN (SELECT e.id
                                           FROM episodes e
                                           WHERE (e.season_id IN (SELECT se.id
                                                                  FROM seasons se
                                                                  WHERE (se.show_id = sh.id)))))),
                ARRAY []::character varying[]) AS roles_earlyaccess
FROM shows sh;

GRANT SELECT ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles" IS NULL;

--- END ALTER VIEW "public"."show_roles" ---
