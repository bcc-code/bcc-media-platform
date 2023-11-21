-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-20T08:27:31.001Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."mediaitems_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_translations_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."mediaitems_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."mediaitems_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."mediaitems_translations_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."mediaitems_translations_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."mediaitems_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."shorts_usergroups_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."shorts_usergroups_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."shorts_usergroups_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."shorts_usergroups_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."shorts_usergroups_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."shorts_usergroups_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."shorts_usergroups_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."mediaitems_tags_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_tags_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."mediaitems_tags_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."mediaitems_tags_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."mediaitems_tags_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."mediaitems_tags_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."mediaitems_tags_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."mediaitems_styledimages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_styledimages_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."mediaitems_styledimages_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."mediaitems_styledimages_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."mediaitems_styledimages_id_seq" TO directus, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."mediaitems_styledimages_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."mediaitems_styledimages_id_seq" ---

--- BEGIN CREATE TABLE "public"."mediaitems" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "label"        text         NOT NULL,
    "title"        text         NULL,
    "description"  text         NULL,
    "type"         varchar(255) NOT NULL DEFAULT NULL::character varying,
    "asset_id"     int4         NULL,
    CONSTRAINT "mediaitems_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "mediaitems_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "mediaitems_asset_id_foreign" FOREIGN KEY (asset_id) REFERENCES assets (id)
);

GRANT SELECT ON TABLE "public"."mediaitems" TO directus, api, background_worker, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems"."id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."status" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."user_created" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."date_created" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."label" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."title" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."description" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."type" IS NULL;


COMMENT ON COLUMN "public"."mediaitems"."asset_id" IS NULL;

COMMENT ON CONSTRAINT "mediaitems_pkey" ON "public"."mediaitems" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_user_created_foreign" ON "public"."mediaitems" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_user_updated_foreign" ON "public"."mediaitems" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_asset_id_foreign" ON "public"."mediaitems" IS NULL;

COMMENT ON TABLE "public"."mediaitems" IS NULL;

--- END CREATE TABLE "public"."mediaitems" ---

--- BEGIN CREATE TABLE "public"."mediaitems_translations" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_translations"
(
    "id"             int4         NOT NULL DEFAULT nextval('mediaitems_translations_id_seq'::regclass),
    "mediaitems_id"  uuid         NULL,
    "languages_code" varchar(255) NULL,
    "title"          text         NULL,
    "description"    text         NULL,
    CONSTRAINT "mediaitems_translations_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL,
    CONSTRAINT "mediaitems_translations_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."mediaitems_translations" TO directus, api, background_worker, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_translations"."mediaitems_id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_translations"."title" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_translations"."description" IS NULL;

COMMENT ON CONSTRAINT "mediaitems_translations_pkey" ON "public"."mediaitems_translations" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_translations_languages_code_foreign" ON "public"."mediaitems_translations" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_translations_mediaitems_id_foreign" ON "public"."mediaitems_translations" IS NULL;

COMMENT ON TABLE "public"."mediaitems_translations" IS NULL;

--- END CREATE TABLE "public"."mediaitems_translations" ---

--- BEGIN CREATE TABLE "public"."shorts" ---

CREATE TABLE IF NOT EXISTS "public"."shorts"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "mediaitem_id" uuid         NULL,
    CONSTRAINT "shorts_pkey" PRIMARY KEY (id),
    CONSTRAINT "shorts_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "shorts_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id),
    CONSTRAINT "shorts_mediaitem_id_foreign" FOREIGN KEY (mediaitem_id) REFERENCES mediaitems (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."shorts" TO directus, api, background_worker, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."shorts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."shorts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."shorts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."shorts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."shorts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."shorts" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."shorts"."id" IS NULL;


COMMENT ON COLUMN "public"."shorts"."status" IS NULL;


COMMENT ON COLUMN "public"."shorts"."user_created" IS NULL;


COMMENT ON COLUMN "public"."shorts"."date_created" IS NULL;


COMMENT ON COLUMN "public"."shorts"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."shorts"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."shorts"."mediaitem_id" IS NULL;

COMMENT ON CONSTRAINT "shorts_pkey" ON "public"."shorts" IS NULL;


COMMENT ON CONSTRAINT "shorts_user_created_foreign" ON "public"."shorts" IS NULL;


COMMENT ON CONSTRAINT "shorts_user_updated_foreign" ON "public"."shorts" IS NULL;


COMMENT ON CONSTRAINT "shorts_mediaitem_id_foreign" ON "public"."shorts" IS NULL;

COMMENT ON TABLE "public"."shorts" IS NULL;

--- END CREATE TABLE "public"."shorts" ---

--- BEGIN CREATE TABLE "public"."shorts_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."shorts_usergroups"
(
    "id"              int4         NOT NULL DEFAULT nextval('shorts_usergroups_id_seq'::regclass),
    "shorts_id"       uuid         NULL,
    "usergroups_code" varchar(255) NULL,
    CONSTRAINT "shorts_usergroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "shorts_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code) ON DELETE CASCADE,
    CONSTRAINT "shorts_usergroups_shorts_id_foreign" FOREIGN KEY (shorts_id) REFERENCES shorts (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."shorts_usergroups" TO directus, api, background_worker, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."shorts_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."shorts_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."shorts_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."shorts_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."shorts_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."shorts_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."shorts_usergroups"."id" IS NULL;


COMMENT ON COLUMN "public"."shorts_usergroups"."shorts_id" IS NULL;


COMMENT ON COLUMN "public"."shorts_usergroups"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "shorts_usergroups_pkey" ON "public"."shorts_usergroups" IS NULL;


COMMENT ON CONSTRAINT "shorts_usergroups_usergroups_code_foreign" ON "public"."shorts_usergroups" IS NULL;


COMMENT ON CONSTRAINT "shorts_usergroups_shorts_id_foreign" ON "public"."shorts_usergroups" IS NULL;

COMMENT ON TABLE "public"."shorts_usergroups" IS NULL;

--- END CREATE TABLE "public"."shorts_usergroups" ---

--- BEGIN CREATE TABLE "public"."mediaitems_tags" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_tags"
(
    "id"            int4 NOT NULL DEFAULT nextval('mediaitems_tags_id_seq'::regclass),
    "mediaitems_id" uuid NULL,
    "tags_id"       int4 NULL,
    CONSTRAINT "mediaitems_tags_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_tags_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags (id) ON DELETE SET NULL,
    CONSTRAINT "mediaitems_tags_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."mediaitems_tags" TO directus, api, background_worker, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_tags" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_tags" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_tags" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_tags" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_tags" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_tags" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_tags"."id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_tags"."mediaitems_id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_tags"."tags_id" IS NULL;

COMMENT ON CONSTRAINT "mediaitems_tags_pkey" ON "public"."mediaitems_tags" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_tags_tags_id_foreign" ON "public"."mediaitems_tags" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_tags_mediaitems_id_foreign" ON "public"."mediaitems_tags" IS NULL;

COMMENT ON TABLE "public"."mediaitems_tags" IS NULL;

--- END CREATE TABLE "public"."mediaitems_tags" ---

--- BEGIN CREATE TABLE "public"."mediaitems_styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_styledimages"
(
    "id"              int4 NOT NULL DEFAULT nextval('mediaitems_styledimages_id_seq'::regclass),
    "mediaitems_id"   uuid NULL,
    "styledimages_id" uuid NULL,
    CONSTRAINT "mediaitems_styledimages_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages (id) ON DELETE CASCADE,
    CONSTRAINT "mediaitems_styledimages_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."mediaitems_styledimages" TO directus, api, background_worker, onsite_backup; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_styledimages" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_styledimages"."id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_styledimages"."mediaitems_id" IS NULL;


COMMENT ON COLUMN "public"."mediaitems_styledimages"."styledimages_id" IS NULL;

COMMENT ON CONSTRAINT "mediaitems_styledimages_pkey" ON "public"."mediaitems_styledimages" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_styledimages_styledimages_id_foreign" ON "public"."mediaitems_styledimages" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_styledimages_mediaitems_id_foreign" ON "public"."mediaitems_styledimages" IS NULL;

COMMENT ON TABLE "public"."mediaitems_styledimages" IS NULL;

--- END CREATE TABLE "public"."mediaitems_styledimages" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1423, 'shorts', 'roles', 'm2m', 'list-m2m', '{
  "template": "{{usergroups_code}}"
}', 'related-values', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1426, 'shorts_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1422, 'mediaitems', 'shorts', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 15, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1427, 'mediaitems', 'tags', 'm2m', 'list-m2m', '{
  "template": "{{tags_id}}"
}', 'related-values', NULL, false, false, 13, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1430, 'mediaitems_tags', 'tags_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1428, 'mediaitems_tags', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1429, 'mediaitems_tags', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1434, 'mediaitems_styledimages', 'styledimages_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1431, 'mediaitems', 'images', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 12, 'half', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1432, 'mediaitems_styledimages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1433, 'mediaitems_styledimages', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1435, 'mediaitems', 'translations_preview', 'alias,no-data,group', 'group-detail', '{
  "start": "closed"
}', NULL, NULL, false, false, 14, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1398, 'mediaitems', 'id', 'uuid', 'input', NULL, NULL, NULL, true, false, 1, 'half', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1400, 'mediaitems', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1402, 'mediaitems', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1403, 'mediaitems', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1401, 'mediaitems', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1408, 'mediaitems', 'translations', 'translations', 'translations', '{
  "languageField": "code",
  "userLanguage": true,
  "languageDirectionField": "code",
  "defaultLanguage": "en"
}', 'translations', NULL, true, false, 1, 'full', NULL, NULL, NULL, false, 'translations_preview', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1406, 'mediaitems', 'description', NULL, 'input-rich-text-md', NULL, NULL, NULL, false, false, 11, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1411, 'mediaitems_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1407, 'mediaitems', 'type', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "Short",
      "value": "short"
    },
    {
      "text": "Video",
      "value": "video"
    },
    {
      "text": "Track",
      "value": "track"
    },
    {
      "text": "Podcast",
      "value": "podcast"
    },
    {
      "text": "Other",
      "value": "other"
    }
  ]
}', 'labels', NULL, false, false, 9, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1404, 'mediaitems', 'label', NULL, 'input', NULL, NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1405, 'mediaitems', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 10, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1409, 'mediaitems_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1410, 'mediaitems_translations', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1412, 'mediaitems_translations', 'title', NULL, 'input', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Featured",
      "value": "featured"
    },
    {
      "text": "Poster",
      "value": "poster"
    },
    {
      "text": "Default",
      "value": "default"
    },
    {
      "text": "Icon",
      "value": "icon"
    },
    {
      "text": "Album",
      "value": "album"
    }
  ]
}'
WHERE "id" = 1214;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1413, 'mediaitems_translations', 'description', NULL, 'input', NULL, NULL, NULL, false, false, 5, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1399, 'mediaitems', 'status', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "$t:published",
      "value": "published"
    },
    {
      "text": "$t:draft",
      "value": "draft"
    },
    {
      "text": "$t:archived",
      "value": "archived"
    }
  ]
}', 'labels', '{
  "showAsDot": true,
  "choices": [
    {
      "text": "$t:published",
      "value": "published",
      "foreground": "#FFFFFF",
      "background": "var(--theme--primary)"
    },
    {
      "text": "$t:draft",
      "value": "draft",
      "foreground": "#18222F",
      "background": "#D3DAE4"
    },
    {
      "text": "$t:archived",
      "value": "archived",
      "foreground": "#FFFFFF",
      "background": "var(--theme--warning)"
    }
  ]
}', false, false, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1414, 'mediaitems', 'asset_id', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{name}}",
  "enableCreate": false,
  "filter": {
    "_and": [
      {
        "status": {
          "_eq": "published"
        }
      }
    ]
  }
}', 'related-values', NULL, false, false, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1415, 'shorts', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1416, 'shorts', 'status', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "$t:published",
      "value": "published"
    },
    {
      "text": "$t:draft",
      "value": "draft"
    },
    {
      "text": "$t:archived",
      "value": "archived"
    }
  ]
}', 'labels', '{
  "showAsDot": true,
  "choices": [
    {
      "text": "$t:published",
      "value": "published",
      "foreground": "#FFFFFF",
      "background": "var(--theme--primary)"
    },
    {
      "text": "$t:draft",
      "value": "draft",
      "foreground": "#18222F",
      "background": "#D3DAE4"
    },
    {
      "text": "$t:archived",
      "value": "archived",
      "foreground": "#FFFFFF",
      "background": "var(--theme--warning)"
    }
  ]
}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1417, 'shorts', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1418, 'shorts', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1419, 'shorts', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1420, 'shorts', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1421, 'shorts', 'mediaitem_id', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{label}}"
}', 'related-values', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1424, 'shorts_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1425, 'shorts_usergroups', 'shorts_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'playlists';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('mediaitems', 'library_books', 'Contains metadata for assets. Is no exposed directly.', NULL, false, false,
        NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 5, 'main_content', 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('mediaitems_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, 27, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('shorts_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, 28, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('shorts', 'autoplay', 'Shorts are globally available short-form videos', NULL, false, false, NULL, 'status',
        true, 'archived', 'draft', NULL, 'all', NULL, NULL, 4, 'main_content', 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('mediaitems_tags', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, NULL, NULL, 'open', NULL, false);

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'surveys';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'games';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('mediaitems_styledimages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all',
        NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (419, 'mediaitems', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (425, 'shorts', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (420, 'mediaitems', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (426, 'shorts', 'mediaitem_id', 'mediaitems', 'shorts', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (421, 'mediaitems_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'mediaitems_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (422, 'mediaitems_translations', 'mediaitems_id', 'mediaitems', 'translations', NULL, NULL, 'languages_code',
        NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (429, 'mediaitems_tags', 'tags_id', 'tags', NULL, NULL, NULL, 'mediaitems_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (430, 'mediaitems_tags', 'mediaitems_id', 'mediaitems', 'tags', NULL, NULL, 'tags_id', NULL, 'nullify');

UPDATE "public"."directus_relations"
SET "one_allowed_collections" = 'episodes,links,pages,seasons,shows,studytopics,games,playlists,shorts'
WHERE "id" = 214;

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (423, 'mediaitems', 'asset_id', 'assets', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (431, 'mediaitems_styledimages', 'styledimages_id', 'styledimages', NULL, NULL, NULL, 'mediaitems_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (432, 'mediaitems_styledimages', 'mediaitems_id', 'mediaitems', 'images', NULL, NULL, 'styledimages_id', NULL,
        'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (424, 'shorts', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (427, 'shorts_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'shorts_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (428, 'shorts_usergroups', 'shorts_id', 'shorts', 'roles', NULL, NULL, 'usergroups_code', NULL, 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-20T08:27:32.299Z             ***/
/***********************************************************/


--- BEGIN DROP TABLE "public"."shorts_usergroups" ---

DROP TABLE IF EXISTS "public"."shorts_usergroups";

--- END DROP TABLE "public"."shorts_usergroups" ---

--- BEGIN DROP TABLE "public"."shorts" ---

DROP TABLE IF EXISTS "public"."shorts";

--- END DROP TABLE "public"."shorts" ---

--- BEGIN DROP TABLE "public"."mediaitems_tags" ---

DROP TABLE IF EXISTS "public"."mediaitems_tags";

--- END DROP TABLE "public"."mediaitems_tags" ---

--- BEGIN DROP TABLE "public"."mediaitems_styledimages" ---

DROP TABLE IF EXISTS "public"."mediaitems_styledimages";

--- END DROP TABLE "public"."mediaitems_styledimages" ---

--- BEGIN DROP TABLE "public"."mediaitems_translations" ---

DROP TABLE IF EXISTS "public"."mediaitems_translations";

--- END DROP TABLE "public"."mediaitems_translations" ---

--- BEGIN DROP TABLE "public"."mediaitems" ---

DROP TABLE IF EXISTS "public"."mediaitems";

--- END DROP TABLE "public"."mediaitems" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'playlists';

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'surveys';

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'games';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'mediaitems';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'mediaitems_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'shorts_usergroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'shorts';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'mediaitems_tags';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'mediaitems_styledimages';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Featured",
      "value": "featured"
    },
    {
      "text": "Poster",
      "value": "poster"
    },
    {
      "text": "Default",
      "value": "default"
    },
    {
      "text": "Icon",
      "value": "icon"
    }
  ]
}'
WHERE "id" = 1214;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1423;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1426;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1422;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1427;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1430;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1428;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1429;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1434;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1431;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1432;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1433;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1435;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1398;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1400;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1402;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1403;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1401;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1408;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1406;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1411;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1407;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1404;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1405;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1409;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1410;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1412;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1413;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1399;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1414;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1415;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1416;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1417;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1418;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1419;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1420;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1421;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1424;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1425;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_allowed_collections" = 'episodes,links,pages,seasons,shows,studytopics,games,playlists'
WHERE "id" = 214;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 419;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 425;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 420;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 426;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 421;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 422;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 429;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 430;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 423;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 431;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 432;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 424;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 427;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 428;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
