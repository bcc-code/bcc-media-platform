-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T11:37:51.589Z             ***/
/***********************************************************/

--- BEGIN ALTER VIEW "public"."season_roles" ---

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
WHERE (((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text))
GROUP BY s.id;

GRANT SELECT ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."season_roles" IS NULL;

--- END ALTER VIEW "public"."season_roles" ---

--- BEGIN ALTER VIEW "public"."show_roles" ---

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
WHERE ((((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text)) AND
       (((s.status)::text = 'published'::text) OR ((s.status)::text = 'unlisted'::text)))
GROUP BY sh.id;
GRANT SELECT ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles" IS NULL;

--- END ALTER VIEW "public"."show_roles" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Item",
      "value": "item"
    },
    {
      "text": "Message",
      "value": "message"
    },
    {
      "text": "Embed (Web)",
      "value": "embed_web"
    },
    {
      "text": "Achievements",
      "value": "achievements"
    }
  ]
}'
WHERE "id" = 536;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T11:37:53.073Z             ***/
/***********************************************************/

--- BEGIN ALTER VIEW "public"."show_roles" ---

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
WHERE (((e.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text))
GROUP BY sh.id;
GRANT SELECT ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."show_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles" IS NULL;

--- END ALTER VIEW "public"."show_roles" ---

--- BEGIN ALTER VIEW "public"."season_roles" ---

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
WHERE ((e.status)::text = 'published'::text)
GROUP BY s.id;
GRANT SELECT ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."season_roles" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."season_roles" IS NULL;

--- END ALTER VIEW "public"."season_roles" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Item",
      "value": "item"
    },
    {
      "text": "Message",
      "value": "message"
    },
    {
      "text": "Embed (Web)",
      "value": "embed_web"
    }
  ]
}'
WHERE "id" = 536;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
