-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-12T13:38:17.398Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."mediaitems_usergroups_download_id_seq" ---

CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_usergroups_download_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."mediaitems_usergroups_download_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."mediaitems_usergroups_download_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."mediaitems_usergroups_download_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."mediaitems_usergroups_download_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."mediaitems_usergroups_download_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_usergroups_earlyaccess_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."mediaitems_usergroups_earlyaccess_id_seq" ---

--- BEGIN CREATE TABLE "public"."mediaitems_usergroups_download" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_usergroups_download"
(
    "id"              int4         NOT NULL DEFAULT nextval('mediaitems_usergroups_download_id_seq'::regclass),
    "mediaitems_id"   uuid         NOT NULL,
    "usergroups_code" varchar(255) NOT NULL,
    CONSTRAINT "mediaitems_usergroups_download_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE SET NULL,
    CONSTRAINT "mediaitems_usergroups_download_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE SET NULL,
    CONSTRAINT "mediaitems_usergroups_download_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_usergroups_download_unique" UNIQUE (mediaitems_id, usergroups_code)
);

GRANT SELECT ON TABLE "public"."mediaitems_usergroups_download" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_usergroups_download" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_usergroups_download" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_usergroups_download" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_usergroups_download" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_usergroups_download" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_usergroups_download" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_usergroups_download"."id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_usergroups_download"."mediaitems_id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_usergroups_download"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "mediaitems_usergroups_download_usergroups_code_foreign" ON "public"."mediaitems_usergroups_download" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_usergroups_download_mediaitems_id_foreign" ON "public"."mediaitems_usergroups_download" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_usergroups_download_pkey" ON "public"."mediaitems_usergroups_download" IS NULL;

COMMENT ON TABLE "public"."mediaitems_usergroups_download" IS NULL;

--- END CREATE TABLE "public"."mediaitems_usergroups_download" ---

--- BEGIN CREATE TABLE "public"."mediaitems_usergroups_earlyaccess" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_usergroups_earlyaccess"
(
    "id"              int4         NOT NULL DEFAULT nextval('mediaitems_usergroups_earlyaccess_id_seq'::regclass),
    "mediaitems_id"   uuid         NOT NULL,
    "usergroups_code" varchar(255) NOT NULL,
    CONSTRAINT "mediaitems_usergroups_earlyaccess_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_usergroups_earlyaccess_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE SET NULL,
    CONSTRAINT "mediaitems_usergroups_earlyaccess_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE SET NULL,
    CONSTRAINT "mediaitems_usergroups_earlyaccess_unique" UNIQUE (mediaitems_id, usergroups_code)
);

GRANT SELECT ON TABLE "public"."mediaitems_usergroups_earlyaccess" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_usergroups_earlyaccess" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_usergroups_earlyaccess" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_usergroups_earlyaccess" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_usergroups_earlyaccess" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_usergroups_earlyaccess" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_usergroups_earlyaccess" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_usergroups_earlyaccess"."id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_usergroups_earlyaccess"."mediaitems_id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_usergroups_earlyaccess"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "mediaitems_usergroups_earlyaccess_pkey" ON "public"."mediaitems_usergroups_earlyaccess" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_usergroups_earlyaccess_usergroups_code_foreign" ON "public"."mediaitems_usergroups_earlyaccess" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_usergroups_earlyaccess_mediaitems_id_foreign" ON "public"."mediaitems_usergroups_earlyaccess" IS NULL;

COMMENT ON TABLE "public"."mediaitems_usergroups_earlyaccess" IS NULL;

--- END CREATE TABLE "public"."mediaitems_usergroups_earlyaccess" ---

--- BEGIN ALTER VIEW "public"."episode_roles" ---

CREATE OR REPLACE VIEW "public"."episode_roles" AS
SELECT e.id,
       array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying)  AS roles,
       array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
       array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
FROM (((episodes e
    LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN mediaitems_usergroups_download eud ON ((eud.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN mediaitems_usergroups_earlyaccess eue ON ((eue.mediaitems_id = e.mediaitem_id)))
GROUP BY e.id;

GRANT SELECT ON TABLE "public"."episode_roles" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_roles" IS NULL;

--- END ALTER VIEW "public"."episode_roles" ---

--- BEGIN ALTER VIEW "public"."season_roles" ---

CREATE OR REPLACE VIEW "public"."season_roles" AS
SELECT s.id,
       array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying)  AS roles,
       array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
       array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
FROM ((((seasons s
    LEFT JOIN episodes e ON ((e.season_id = s.id)))
    LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN mediaitems_usergroups_download eud ON ((eud.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN mediaitems_usergroups_earlyaccess eue ON ((eue.mediaitems_id = e.mediaitem_id)))
WHERE (((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text))
GROUP BY s.id;

GRANT SELECT ON TABLE "public"."season_roles" TO api, background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

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
    LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN mediaitems_usergroups_download eud ON ((eud.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN mediaitems_usergroups_earlyaccess eue ON ((eue.mediaitems_id = e.mediaitem_id)))
WHERE ((((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text)) AND
       (((s.status)::text = 'published'::text) OR ((s.status)::text = 'unlisted'::text)))
GROUP BY sh.id;

GRANT SELECT ON TABLE "public"."show_roles" TO api, background_worker, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles" IS NULL;

--- END ALTER VIEW "public"."show_roles" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 149;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1477, 'mediaitems', 'download_usergroups', 'm2m', 'list-m2m', '{
  "enableCreate": false
}', 'related-values', NULL, false, false, 5, 'half', NULL, 'Groups who can download.', NULL, false, 'availability',
        NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort"  = 8,
    "group" = 'configuration'
WHERE "id" = 126;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 120;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1480, 'mediaitems_usergroups_download', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1484, 'mediaitems_usergroups_earlyaccess', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, 3,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1481, 'mediaitems', 'earlyaccess_usergroups', 'm2m', 'list-m2m', '{
  "enableCreate": false
}', 'related-values', NULL, false, false, 4, 'half', NULL, 'Groups who have early access to this item.', NULL, false,
        'availability', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1482, 'mediaitems_usergroups_earlyaccess', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1483, 'mediaitems_usergroups_earlyaccess', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "sort"  = 7,
    "group" = 'configuration'
WHERE "id" = 127;

UPDATE "public"."directus_fields"
SET "options" = '{
  "start": "closed"
}'
WHERE "id" = 1441;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1478, 'mediaitems_usergroups_download', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1479, 'mediaitems_usergroups_download', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true)
FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('mediaitems_usergroups_earlyaccess', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL,
        NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('mediaitems_usergroups_download', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL,
        'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (453, 'mediaitems_usergroups_earlyaccess', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'mediaitems_id',
        NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (454, 'mediaitems_usergroups_earlyaccess', 'mediaitems_id', 'mediaitems', 'earlyaccess_usergroups', NULL, NULL,
        'usergroups_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (451, 'mediaitems_usergroups_download', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'mediaitems_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (452, 'mediaitems_usergroups_download', 'mediaitems_id', 'mediaitems', 'download_usergroups', NULL, NULL,
        'usergroups_code', NULL, 'nullify');

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true)
FROM "public"."directus_relations";


INSERT INTO mediaitems_usergroups_download (mediaitems_id, usergroups_code)
SELECT DISTINCT e.uuid, usergroups_code
FROM episodes_usergroups_download ug
         JOIN episodes e ON e.id = ug.episodes_id;

INSERT INTO mediaitems_usergroups_earlyaccess (mediaitems_id, usergroups_code)
SELECT DISTINCT e.uuid, usergroups_code
FROM episodes_usergroups_download ug
         JOIN episodes e ON e.id = ug.episodes_id;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "sort"  = 6,
    "group" = 'availability'
WHERE "id" = 126;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "sort"  = 4,
    "group" = 'availability'
WHERE "id" = 127;

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true)
FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-12T13:38:19.161Z             ***/
/***********************************************************/


UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "sort"  = 8,
    "group" = 'configuration'
WHERE "id" = 126;

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "sort"  = 7,
    "group" = 'configuration'
WHERE "id" = 127;

--- BEGIN ALTER VIEW "public"."episode_roles" ---

CREATE OR REPLACE VIEW "public"."episode_roles" AS
SELECT e.id,
       array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying)  AS roles,
       array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
       array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
FROM (((episodes e
    LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
    LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
GROUP BY e.id;

GRANT SELECT ON TABLE "public"."episode_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_roles" IS NULL;

--- END ALTER VIEW "public"."episode_roles" ---

--- BEGIN ALTER VIEW "public"."season_roles" ---

CREATE OR REPLACE VIEW "public"."season_roles" AS
SELECT s.id,
       array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying)  AS roles,
       array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
       array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
FROM ((((seasons s
    LEFT JOIN episodes e ON ((e.season_id = s.id)))
    LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
    LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
WHERE (((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text))
GROUP BY s.id;

GRANT SELECT ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

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
    LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
    LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
    LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
WHERE ((((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text)) AND
       (((s.status)::text = 'published'::text) OR ((s.status)::text = 'unlisted'::text)))
GROUP BY sh.id;

GRANT SELECT ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles" IS NULL;

--- END ALTER VIEW "public"."show_roles" ---

--- BEGIN DROP TABLE "public"."mediaitems_usergroups_download" ---

DROP TABLE IF EXISTS "public"."mediaitems_usergroups_download";

--- END DROP TABLE "public"."mediaitems_usergroups_download" ---

--- BEGIN DROP TABLE "public"."mediaitems_usergroups_earlyaccess" ---

DROP TABLE IF EXISTS "public"."mediaitems_usergroups_earlyaccess";

--- END DROP TABLE "public"."mediaitems_usergroups_earlyaccess" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'mediaitems_usergroups_earlyaccess';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'mediaitems_usergroups_download';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 120;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "sort"  = 4,
    "group" = 'availability'
WHERE "id" = 126;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 565;

UPDATE "public"."directus_fields"
SET "sort"  = 6,
    "group" = 'availability'
WHERE "id" = 127;

UPDATE "public"."directus_fields"
SET "options" = NULL
WHERE "id" = 1441;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1477;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1480;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1484;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1481;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1482;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1483;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1478;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1479;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 453;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 454;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 451;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 452;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
