-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-07T13:43:21.837Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons"
    ALTER COLUMN "translations_required" DROP DEFAULT;

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."episodes_categories" ---

ALTER TABLE IF EXISTS "public"."episodes_categories"
    DROP COLUMN IF EXISTS "categories_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."episodes_categories"
    DROP CONSTRAINT IF EXISTS "episodes_categories_categories_id_foreign";

--- END ALTER TABLE "public"."episodes_categories" ---

--- BEGIN ALTER TABLE "public"."lists_relations" ---

ALTER TABLE IF EXISTS "public"."lists_relations"
    DROP COLUMN IF EXISTS "lists_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."lists_relations"
    DROP CONSTRAINT IF EXISTS "lists_relations_lists_id_foreign";

--- END ALTER TABLE "public"."lists_relations" ---

--- BEGIN ALTER TABLE "public"."categories_translations" ---

ALTER TABLE IF EXISTS "public"."categories_translations"
    DROP COLUMN IF EXISTS "categories_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."categories_translations"
    DROP CONSTRAINT IF EXISTS "categories_translations_categories_id_foreign";

--- END ALTER TABLE "public"."categories_translations" ---

--- BEGIN DROP TABLE "public"."categories" ---

DROP TABLE IF EXISTS "public"."categories";

--- END DROP TABLE "public"."categories" ---

--- BEGIN DROP TABLE "public"."lists" ---

DROP TABLE IF EXISTS "public"."lists";

--- END DROP TABLE "public"."lists" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "width" = 'full'
WHERE "id" = 1351;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1353;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1354;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1355;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1356;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1382;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1352;

UPDATE "public"."directus_fields"
SET "sort"  = 1,
    "group" = 'configuration'
WHERE "id" = 1191;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 884;

UPDATE "public"."directus_fields"
SET "required" = true
WHERE "id" = 1077;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 1067;

UPDATE "public"."directus_fields"
SET "required" = true
WHERE "id" = 1062;

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 1065;

UPDATE "public"."directus_fields"
SET "width" = 'full'
WHERE "id" = 1049;

UPDATE "public"."directus_fields"
SET "interface" = 'input'
WHERE "id" = 1221;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1192;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1200;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1193;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1194;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1201;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1206;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1195;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1207;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1217;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 1196;

UPDATE "public"."directus_fields"
SET "width" = 'full'
WHERE "id" = 1190;

UPDATE "public"."directus_fields"
SET "hidden" = false,
    "sort"   = 8
WHERE "id" = 1202;

UPDATE "public"."directus_fields"
SET "interface" = 'input'
WHERE "id" = 1222;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 69;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 179;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 180;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 72;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 73;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 74;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 75;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 76;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 77;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 78;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 79;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 80;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 81;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 150;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 181;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 182;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 184;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 185;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 189;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 71;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 178;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 70;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 183;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 177;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'asset_management';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('Metadata', 'folder', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 9, NULL,
        'open', NULL, false);

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "sort" = 22
WHERE "collection" = 'playlists_styledimages';

UPDATE "public"."directus_collections"
SET "sort" = 25
WHERE "collection" = 'playlists_translations';

UPDATE "public"."directus_collections"
SET "sort" = 26
WHERE "collection" = 'playlists_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'studies';

UPDATE "public"."directus_collections"
SET "group" = NULL
WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'computeddata_group';

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'notifications_group';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'faqs_group';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'applications_group';

UPDATE "public"."directus_collections"
SET "sort" = 19
WHERE "collection" = 'translations';

UPDATE "public"."directus_collections"
SET "sort" = 20
WHERE "collection" = 'songcollections_translations';

UPDATE "public"."directus_collections"
SET "sort" = 21
WHERE "collection" = 'phrases_translations';

UPDATE "public"."directus_collections"
SET "sort" = 23
WHERE "collection" = 'songs_translations';

UPDATE "public"."directus_collections"
SET "sort" = 24
WHERE "collection" = 'timedmetadata_persons';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'Metadata'
WHERE "collection" = 'persons';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'Metadata'
WHERE "collection" = 'songs_group';

UPDATE "public"."directus_collections"
SET "sort"  = 3,
    "group" = 'Metadata'
WHERE "collection" = 'phrases';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'achievements_group';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'messages_group';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'timedmetadata';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'images';

UPDATE "public"."directus_collections"
SET "sort" = 18
WHERE "collection" = 'styledimages';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'lists';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'categories';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 120;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 202;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 123;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 203;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 204;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 122;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 121;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 201;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 124;

DELETE
FROM "public"."directus_permissions"
WHERE "id" = 200;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 19;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 20;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 21;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 22;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 44;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 56;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 57;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 59;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN DROP TABLE "public"."lists_relations" ---

DROP TABLE IF EXISTS "public"."lists_relations";

--- END DROP TABLE "public"."lists_relations" ---

--- BEGIN DROP TABLE "public"."categories_translations" ---

DROP TABLE IF EXISTS "public"."categories_translations";

--- END DROP TABLE "public"."categories_translations" ---

--- BEGIN DROP TABLE "public"."episodes_categories" ---

DROP TABLE IF EXISTS "public"."episodes_categories";

--- END DROP TABLE "public"."episodes_categories" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-07T13:43:23.595Z             ***/
/***********************************************************/


--- BEGIN CREATE TABLE "public"."episodes_categories" ---

CREATE TABLE IF NOT EXISTS "public"."episodes_categories"
(
    "episodes_id" int4 NOT NULL,
    "id"          int4 NOT NULL DEFAULT nextval('episodes_categories_id_seq'::regclass),
    CONSTRAINT "episodes_categories_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes (id) ON DELETE CASCADE,
    CONSTRAINT "episodes_categories_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."episodes_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."episodes_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."episodes_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."episodes_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."episodes_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."episodes_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."episodes_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."episodes_categories" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."episodes_categories"."episodes_id" IS NULL;


COMMENT ON COLUMN "public"."episodes_categories"."id" IS NULL;

COMMENT ON CONSTRAINT "episodes_categories_episodes_id_foreign" ON "public"."episodes_categories" IS NULL;


COMMENT ON CONSTRAINT "episodes_categories_pkey" ON "public"."episodes_categories" IS NULL;

COMMENT ON TABLE "public"."episodes_categories" IS NULL;

--- END CREATE TABLE "public"."episodes_categories" ---


--- BEGIN CREATE TABLE "public"."lists_relations" ---

CREATE TABLE IF NOT EXISTS "public"."lists_relations"
(
    "collection" varchar(255) NULL     DEFAULT NULL::character varying,
    "id"         int4         NOT NULL DEFAULT nextval('lists_relations_id_seq'::regclass),
    "item"       varchar(255) NULL     DEFAULT NULL::character varying,
    "sort"       int4         NULL,
    CONSTRAINT "lists_relations_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."lists_relations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."lists_relations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."lists_relations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."lists_relations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."lists_relations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."lists_relations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."lists_relations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."lists_relations" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."lists_relations"."collection" IS NULL;


COMMENT ON COLUMN "public"."lists_relations"."id" IS NULL;


COMMENT ON COLUMN "public"."lists_relations"."item" IS NULL;


COMMENT ON COLUMN "public"."lists_relations"."sort" IS NULL;

COMMENT ON CONSTRAINT "lists_relations_pkey" ON "public"."lists_relations" IS NULL;

COMMENT ON TABLE "public"."lists_relations" IS NULL;

--- END CREATE TABLE "public"."lists_relations" ---

--- BEGIN CREATE TABLE "public"."categories_translations" ---

CREATE TABLE IF NOT EXISTS "public"."categories_translations"
(
    "id"             int4         NOT NULL DEFAULT nextval('categories_translations_id_seq'::regclass),
    "languages_code" varchar(255) NOT NULL DEFAULT NULL::character varying,
    "name"           varchar(255) NOT NULL DEFAULT NULL::character varying,
    CONSTRAINT "categories_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code),
    CONSTRAINT "categories_translations_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."categories_translations" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."categories_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."categories_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."categories_translations"."name" IS NULL;

COMMENT ON CONSTRAINT "categories_translations_languages_code_foreign" ON "public"."categories_translations" IS NULL;


COMMENT ON CONSTRAINT "categories_translations_pkey" ON "public"."categories_translations" IS NULL;

COMMENT ON TABLE "public"."categories_translations" IS NULL;

--- END CREATE TABLE "public"."categories_translations" ---


--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons"
    ALTER COLUMN "translations_required" SET DEFAULT true;

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN CREATE TABLE "public"."categories" ---

CREATE TABLE IF NOT EXISTS "public"."categories"
(
    "appear_in_search" bool        NULL     DEFAULT false,
    "date_created"     timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated"     timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id"               int4        NOT NULL DEFAULT nextval('categories_id_seq'::regclass),
    "legacy_id"        int4        NULL,
    "parent_id"        int4        NULL,
    "sort"             int4        NULL,
    "user_created"     uuid        NULL,
    "user_updated"     uuid        NULL,
    CONSTRAINT "categories_parent_id_foreign" FOREIGN KEY (parent_id) REFERENCES categories (id),
    CONSTRAINT "categories_pkey" PRIMARY KEY (id),
    CONSTRAINT "categories_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "categories_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

ALTER TABLE IF EXISTS "public"."categories"
    OWNER TO manager;

GRANT SELECT ON TABLE "public"."categories" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."categories" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."categories" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."categories" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."categories" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."categories" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."categories" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."categories" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."categories"."appear_in_search" IS NULL;


COMMENT ON COLUMN "public"."categories"."date_created" IS NULL;


COMMENT ON COLUMN "public"."categories"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."categories"."id" IS NULL;


COMMENT ON COLUMN "public"."categories"."legacy_id" IS NULL;


COMMENT ON COLUMN "public"."categories"."parent_id" IS NULL;


COMMENT ON COLUMN "public"."categories"."sort" IS NULL;


COMMENT ON COLUMN "public"."categories"."user_created" IS NULL;


COMMENT ON COLUMN "public"."categories"."user_updated" IS NULL;

COMMENT ON CONSTRAINT "categories_parent_id_foreign" ON "public"."categories" IS NULL;


COMMENT ON CONSTRAINT "categories_pkey" ON "public"."categories" IS NULL;


COMMENT ON CONSTRAINT "categories_user_created_foreign" ON "public"."categories" IS NULL;


COMMENT ON CONSTRAINT "categories_user_updated_foreign" ON "public"."categories" IS NULL;

COMMENT ON TABLE "public"."categories" IS NULL;

--- END CREATE TABLE "public"."categories" ---

--- BEGIN ALTER TABLE "public"."episodes_categories" ---

ALTER TABLE IF EXISTS "public"."episodes_categories"
    ADD COLUMN IF NOT EXISTS "categories_id" int4 NOT NULL; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."episodes_categories"."categories_id" IS NULL;

ALTER TABLE IF EXISTS "public"."episodes_categories"
    ADD CONSTRAINT "episodes_categories_categories_id_foreign" FOREIGN KEY (categories_id) REFERENCES categories (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "episodes_categories_categories_id_foreign" ON "public"."episodes_categories" IS NULL;

--- END ALTER TABLE "public"."episodes_categories" ---

--- BEGIN CREATE TABLE "public"."lists" ---

CREATE TABLE IF NOT EXISTS "public"."lists"
(
    "date_created"       timestamptz  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated"       timestamptz  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id"                 int4         NOT NULL DEFAULT nextval('lists_id_seq'::regclass),
    "legacy_category_id" int4         NULL,
    "legacy_name_id"     int4         NULL,
    "name"               varchar(255) NOT NULL DEFAULT NULL::character varying,
    "user_created"       uuid         NULL,
    "user_updated"       uuid         NULL,
    CONSTRAINT "lists_pkey" PRIMARY KEY (id),
    CONSTRAINT "lists_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "lists_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

ALTER TABLE IF EXISTS "public"."lists"
    OWNER TO manager;

GRANT SELECT ON TABLE "public"."lists" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."lists" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."lists" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."lists" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."lists" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."lists" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."lists" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."lists" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."lists"."date_created" IS NULL;


COMMENT ON COLUMN "public"."lists"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."lists"."id" IS NULL;


COMMENT ON COLUMN "public"."lists"."legacy_category_id" IS NULL;


COMMENT ON COLUMN "public"."lists"."legacy_name_id" IS NULL;


COMMENT ON COLUMN "public"."lists"."name" IS NULL;


COMMENT ON COLUMN "public"."lists"."user_created" IS NULL;


COMMENT ON COLUMN "public"."lists"."user_updated" IS NULL;

COMMENT ON CONSTRAINT "lists_pkey" ON "public"."lists" IS NULL;


COMMENT ON CONSTRAINT "lists_user_created_foreign" ON "public"."lists" IS NULL;


COMMENT ON CONSTRAINT "lists_user_updated_foreign" ON "public"."lists" IS NULL;

COMMENT ON TABLE "public"."lists" IS NULL;

--- END CREATE TABLE "public"."lists" ---

--- BEGIN ALTER TABLE "public"."lists_relations" ---

ALTER TABLE IF EXISTS "public"."lists_relations"
    ADD COLUMN IF NOT EXISTS "lists_id" int4 NULL;

COMMENT ON COLUMN "public"."lists_relations"."lists_id" IS NULL;

ALTER TABLE IF EXISTS "public"."lists_relations"
    ADD CONSTRAINT "lists_relations_lists_id_foreign" FOREIGN KEY (lists_id) REFERENCES lists (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "lists_relations_lists_id_foreign" ON "public"."lists_relations" IS NULL;

--- END ALTER TABLE "public"."lists_relations" ---

--- BEGIN ALTER TABLE "public"."categories_translations" ---

ALTER TABLE IF EXISTS "public"."categories_translations"
    ADD COLUMN IF NOT EXISTS "categories_id" int4 NOT NULL; --WARN: Add a new column not nullable without a default value can occure in a sql error during execution!

COMMENT ON COLUMN "public"."categories_translations"."categories_id" IS NULL;

ALTER TABLE IF EXISTS "public"."categories_translations"
    ADD CONSTRAINT "categories_translations_categories_id_foreign" FOREIGN KEY (categories_id) REFERENCES categories (id);

COMMENT ON CONSTRAINT "categories_translations_categories_id_foreign" ON "public"."categories_translations" IS NULL;

--- END ALTER TABLE "public"."categories_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'config';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('lists', 'format_list_numbered', 'Manually selected and ordered shows/episodes.', '{{name}}', true, false, NULL,
        NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 5, 'page_management', 'open', NULL, false);

UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'main_content';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url",
                                             "versioning")
VALUES ('categories', 'bookmarks', NULL, '{{translations}}', true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all',
        NULL, NULL, 7, 'page_management', 'open', NULL, false);

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'studies';

UPDATE "public"."directus_collections"
SET "sort" = 23
WHERE "collection" = 'playlists_styledimages';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'playlists_translations';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'playlists_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'computeddata_group';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'notifications_group';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'faqs_group';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'applications_group';

UPDATE "public"."directus_collections"
SET "group" = 'lists'
WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'timedmetadata';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "sort" = 18
WHERE "collection" = 'images';

UPDATE "public"."directus_collections"
SET "sort" = 19
WHERE "collection" = 'styledimages';

UPDATE "public"."directus_collections"
SET "sort" = 20
WHERE "collection" = 'translations';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'achievements_group';

UPDATE "public"."directus_collections"
SET "sort"  = 8,
    "group" = NULL
WHERE "collection" = 'songs_group';

UPDATE "public"."directus_collections"
SET "sort"  = 9,
    "group" = NULL
WHERE "collection" = 'persons';

UPDATE "public"."directus_collections"
SET "sort"  = 10,
    "group" = NULL
WHERE "collection" = 'phrases';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'messages_group';

UPDATE "public"."directus_collections"
SET "sort" = 21
WHERE "collection" = 'songcollections_translations';

UPDATE "public"."directus_collections"
SET "sort" = 22
WHERE "collection" = 'phrases_translations';

UPDATE "public"."directus_collections"
SET "sort" = 24
WHERE "collection" = 'songs_translations';

UPDATE "public"."directus_collections"
SET "sort" = 25
WHERE "collection" = 'timedmetadata_persons';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'Metadata';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (69, 'categories', 'appear_in_search', 'cast-boolean', 'boolean', '{
  "label": "Appear in search"
}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (179, 'lists', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL,
        NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (180, 'lists', 'legacy_category_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (72, 'categories', 'episodes', 'm2m', 'list-m2m', '{
  "enableCreate": false,
  "template": "{{episodes_id.translations}}"
}', 'related-values', '{
  "template": "{{episodes_id.translations}}"
}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (73, 'categories', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (74, 'categories', 'legacy_id', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (75, 'categories', 'parent_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 9, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (76, 'categories', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (77, 'categories', 'subcategories', 'o2m', 'list-o2m-tree-view', NULL, NULL, NULL, false, true, 10, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (78, 'categories', 'translations', 'translations', 'translations', '{
  "languageField": "code"
}', 'translations', '{
  "defaultLanguage": "no",
  "languageField": "code",
  "template": "{{name}}",
  "userLanguage": true
}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (79, 'categories', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (80, 'categories', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (81, 'categories_translations', 'categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (150, 'episodes_categories', 'categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (181, 'lists', 'legacy_name_id', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (182, 'lists', 'name', NULL, 'input', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, true, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (184, 'lists', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (185, 'lists', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (189, 'lists_relations', 'lists_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (71, 'categories', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (178, 'lists', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (70, 'categories', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (183, 'lists', 'relations', 'm2a', 'list-m2a', '{}', 'related-values', '{
  "template": "{{item:shows}}{{item:episodes}}{{item:shows.translations}}"
}', false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "hidden" = true
WHERE "id" = 884;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 1065;

UPDATE "public"."directus_fields"
SET "required" = false
WHERE "id" = 1062;

UPDATE "public"."directus_fields"
SET "width" = 'half'
WHERE "id" = 1049;

UPDATE "public"."directus_fields"
SET "hidden" = false
WHERE "id" = 1067;

UPDATE "public"."directus_fields"
SET "required" = false
WHERE "id" = 1077;

UPDATE "public"."directus_fields"
SET "sort"  = 2,
    "group" = NULL
WHERE "id" = 1191;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1192;

UPDATE "public"."directus_fields"
SET "width" = 'half'
WHERE "id" = 1190;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1194;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1195;

UPDATE "public"."directus_fields"
SET "sort" = 8
WHERE "id" = 1196;

UPDATE "public"."directus_fields"
SET "hidden" = true,
    "sort"   = 9
WHERE "id" = 1202;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 1207;

UPDATE "public"."directus_fields"
SET "interface" = NULL
WHERE "id" = 1222;

UPDATE "public"."directus_fields"
SET "interface" = NULL
WHERE "id" = 1221;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1193;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 1356;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (177, 'lists', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "width" = 'half'
WHERE "id" = 1351;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1352;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1353;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1354;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1355;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 1382;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1200;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1201;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1217;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1206;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (120, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (202, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (123, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (203, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (204, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'share', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (122, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (121, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (201, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (124, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'lists', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation",
                                             "presets", "fields")
VALUES (200, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'categories', 'create', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (19, 'categories', 'parent_id', 'categories', 'subcategories', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (20, 'categories', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (21, 'categories', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (22, 'categories_translations', 'categories_id', 'categories', 'translations', NULL, NULL, 'languages_code',
        NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (44, 'episodes_categories', 'categories_id', 'categories', 'episodes', NULL, NULL, 'episodes_id', NULL,
        'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (56, 'lists', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (57, 'lists', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (59, 'lists_relations', 'lists_id', 'lists', 'relations', NULL, NULL, 'item', 'sort', 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
