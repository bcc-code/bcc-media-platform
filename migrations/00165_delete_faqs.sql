-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-04T07:17:57.214Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections"
    ALTER COLUMN "advanced_type" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."collections" ---

--- BEGIN DROP TABLE "public"."faqs_translations" ---

DROP TABLE IF EXISTS "public"."faqs_translations";

--- END DROP TABLE "public"."faqs_translations" ---

--- BEGIN DROP TABLE "public"."faq_categories_translations" ---

DROP TABLE IF EXISTS "public"."faq_categories_translations";

--- END DROP TABLE "public"."faq_categories_translations" ---

--- BEGIN DROP TABLE "public"."faqs_usergroups" ---

DROP TABLE IF EXISTS "public"."faqs_usergroups";

--- END DROP TABLE "public"."faqs_usergroups" ---

--- BEGIN DROP TABLE "public"."faqs" ---

DROP TABLE IF EXISTS "public"."faqs";

--- END DROP TABLE "public"."faqs" ---

--- BEGIN DROP TABLE "public"."faq_categories" ---

DROP TABLE IF EXISTS "public"."faq_categories";

--- END DROP TABLE "public"."faq_categories" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faq_categories';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqs_usergroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqs';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqs_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faq_categories_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'FAQ';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 349;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 350;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 351;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 352;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 353;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 354;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 355;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 356;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 357;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 358;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 359;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 360;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 361;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 362;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 363;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 364;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 365;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 366;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 367;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 368;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 369;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 370;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 372;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 373;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 374;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 371;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 104;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 105;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 106;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 107;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 108;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 109;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 110;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 111;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 112;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-04T07:17:58.792Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections"
    ALTER COLUMN "advanced_type" DROP DEFAULT;

--- END ALTER TABLE "public"."collections" ---

--- BEGIN CREATE TABLE "public"."faq_categories" ---

CREATE TABLE IF NOT EXISTS "public"."faq_categories"
(
    "id"     int4         NOT NULL DEFAULT nextval('faq_categories_id_seq'::regclass),
    "sort"   int4         NULL,
    "status" varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    CONSTRAINT "faq_categories_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."faq_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faq_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faq_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faq_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faq_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faq_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faq_categories" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faq_categories" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faq_categories" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faq_categories" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faq_categories" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faq_categories" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faq_categories" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faq_categories" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faq_categories" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faq_categories" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faq_categories"."id" IS NULL;


COMMENT ON COLUMN "public"."faq_categories"."sort" IS NULL;


COMMENT ON COLUMN "public"."faq_categories"."status" IS NULL;

COMMENT ON CONSTRAINT "faq_categories_pkey" ON "public"."faq_categories" IS NULL;

COMMENT ON TABLE "public"."faq_categories" IS NULL;

--- END CREATE TABLE "public"."faq_categories" ---

--- BEGIN CREATE TABLE "public"."faq_categories_translations" ---

CREATE TABLE IF NOT EXISTS "public"."faq_categories_translations"
(
    "faq_categories_id" int4         NULL,
    "id"                int4         NOT NULL DEFAULT nextval('faq_categories_translations_id_seq'::regclass),
    "languages_code"    varchar(255) NULL     DEFAULT NULL::character varying,
    "title"             varchar(255) NULL     DEFAULT NULL::character varying,
    CONSTRAINT "faq_categories_translations_faq_categories_id_foreign" FOREIGN KEY (faq_categories_id) REFERENCES faq_categories (id) ON DELETE CASCADE,
    CONSTRAINT "faq_categories_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE,
    CONSTRAINT "faq_categories_translations_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."faq_categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faq_categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faq_categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faq_categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faq_categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faq_categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faq_categories_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faq_categories_translations" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faq_categories_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faq_categories_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faq_categories_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faq_categories_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faq_categories_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faq_categories_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faq_categories_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faq_categories_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faq_categories_translations"."faq_categories_id" IS NULL;


COMMENT ON COLUMN "public"."faq_categories_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."faq_categories_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."faq_categories_translations"."title" IS NULL;

COMMENT ON CONSTRAINT "faq_categories_translations_faq_categories_id_foreign" ON "public"."faq_categories_translations" IS NULL;


COMMENT ON CONSTRAINT "faq_categories_translations_languages_code_foreign" ON "public"."faq_categories_translations" IS NULL;


COMMENT ON CONSTRAINT "faq_categories_translations_pkey" ON "public"."faq_categories_translations" IS NULL;

COMMENT ON TABLE "public"."faq_categories_translations" IS NULL;

--- END CREATE TABLE "public"."faq_categories_translations" ---

--- BEGIN CREATE TABLE "public"."faqs" ---

CREATE TABLE IF NOT EXISTS "public"."faqs"
(
    "category"     int4         NOT NULL,
    "date_created" timestamptz  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated" timestamptz  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id"           int4         NOT NULL DEFAULT nextval('faqs_id_seq'::regclass),
    "sort"         int4         NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NOT NULL,
    "user_updated" uuid         NOT NULL,
    CONSTRAINT "faqs_category_foreign" FOREIGN KEY (category) REFERENCES faq_categories (id),
    CONSTRAINT "faqs_pkey" PRIMARY KEY (id),
    CONSTRAINT "faqs_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "faqs_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faqs"."category" IS NULL;


COMMENT ON COLUMN "public"."faqs"."date_created" IS NULL;


COMMENT ON COLUMN "public"."faqs"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."faqs"."id" IS NULL;


COMMENT ON COLUMN "public"."faqs"."sort" IS NULL;


COMMENT ON COLUMN "public"."faqs"."status" IS NULL;


COMMENT ON COLUMN "public"."faqs"."user_created" IS NULL;


COMMENT ON COLUMN "public"."faqs"."user_updated" IS NULL;

COMMENT ON CONSTRAINT "faqs_category_foreign" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_pkey" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_user_created_foreign" ON "public"."faqs" IS NULL;


COMMENT ON CONSTRAINT "faqs_user_updated_foreign" ON "public"."faqs" IS NULL;

COMMENT ON TABLE "public"."faqs" IS NULL;

--- END CREATE TABLE "public"."faqs" ---

--- BEGIN CREATE TABLE "public"."faqs_translations" ---

CREATE TABLE IF NOT EXISTS "public"."faqs_translations"
(
    "answer"         text         NULL,
    "faqs_id"        int4         NULL,
    "id"             int4         NOT NULL DEFAULT nextval('faqs_translations_id_seq'::regclass),
    "languages_code" varchar(255) NULL     DEFAULT NULL::character varying,
    "question"       varchar(255) NULL     DEFAULT NULL::character varying,
    CONSTRAINT "faqs_translations_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs (id) ON DELETE CASCADE,
    CONSTRAINT "faqs_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE,
    CONSTRAINT "faqs_translations_pkey" PRIMARY KEY (id)
);

GRANT SELECT ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs_translations" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs_translations" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs_translations" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faqs_translations"."answer" IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."faqs_id" IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."id" IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."languages_code" IS NULL;


COMMENT ON COLUMN "public"."faqs_translations"."question" IS NULL;

COMMENT ON CONSTRAINT "faqs_translations_faqs_id_foreign" ON "public"."faqs_translations" IS NULL;


COMMENT ON CONSTRAINT "faqs_translations_languages_code_foreign" ON "public"."faqs_translations" IS NULL;


COMMENT ON CONSTRAINT "faqs_translations_pkey" ON "public"."faqs_translations" IS NULL;

COMMENT ON TABLE "public"."faqs_translations" IS NULL;

--- END CREATE TABLE "public"."faqs_translations" ---

--- BEGIN CREATE TABLE "public"."faqs_usergroups" ---

CREATE TABLE IF NOT EXISTS "public"."faqs_usergroups"
(
    "faqs_id"         int4         NULL,
    "id"              int4         NOT NULL DEFAULT nextval('faqs_usergroups_id_seq'::regclass),
    "usergroups_code" varchar(255) NULL     DEFAULT NULL::character varying,
    CONSTRAINT "faqs_usergroups_faqs_id_foreign" FOREIGN KEY (faqs_id) REFERENCES faqs (id),
    CONSTRAINT "faqs_usergroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "faqs_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups (code)
);

GRANT SELECT ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs_usergroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs_usergroups" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."faqs_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."faqs_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."faqs_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."faqs_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."faqs_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."faqs_usergroups" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."faqs_usergroups" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."faqs_usergroups"."faqs_id" IS NULL;


COMMENT ON COLUMN "public"."faqs_usergroups"."id" IS NULL;


COMMENT ON COLUMN "public"."faqs_usergroups"."usergroups_code" IS NULL;

COMMENT ON CONSTRAINT "faqs_usergroups_faqs_id_foreign" ON "public"."faqs_usergroups" IS NULL;


COMMENT ON CONSTRAINT "faqs_usergroups_pkey" ON "public"."faqs_usergroups" IS NULL;


COMMENT ON CONSTRAINT "faqs_usergroups_usergroups_code_foreign" ON "public"."faqs_usergroups" IS NULL;

COMMENT ON TABLE "public"."faqs_usergroups" IS NULL;

--- END CREATE TABLE "public"."faqs_usergroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('FAQ', 'folder', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#6BFFE1', NULL, 6, NULL,
        'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faqs', 'question_mark', NULL, '{{translations.question}}', false, false, NULL, 'status', true, 'archived',
        'draft', 'sort', 'all', NULL, NULL, 1, 'FAQ', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faq_categories', 'folder', NULL, '{{translations.title}}', false, false, NULL, 'status', true, 'archived',
        'draft', 'sort', 'all', NULL, NULL, 2, 'FAQ', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faqs_usergroups', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, 1, 'faqs', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faqs_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, 12, 'translations', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('faq_categories_translations', 'import_export', NULL, '{{title}}', true, false, NULL, NULL, true, NULL, NULL,
        NULL, 'all', NULL, NULL, 13, 'translations', 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (349, 'faq_categories', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (350, 'faq_categories', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (351, 'faq_categories', 'status', NULL, 'select-dropdown', '{
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
  "choices": [
    {
      "text": "$t:published",
      "value": "published",
      "foreground": "#FFFFFF",
      "background": "var(--primary)"
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
      "background": "var(--warning)"
    }
  ],
  "showAsDot": true
}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (352, 'faq_categories', 'translations', 'translations', 'translations', '{
  "defaultLanguage": "no",
  "languageField": "code"
}', 'translations', '{
  "defaultLanguage": "no",
  "languageField": "code",
  "template": "{{title}}",
  "userLanguage": true
}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (353, 'faq_categories_translations', 'faq_categories_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (354, 'faq_categories_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (355, 'faq_categories_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full',
        NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (356, 'faq_categories_translations', 'title', NULL, 'input', '{
  "iconLeft": "category"
}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (357, 'faqs', 'category', 'm2o', 'select-dropdown-m2o', '{
  "template": "{{translations}}"
}', 'related-values', '{
  "template": "{{translations.title}}"
}', false, false, NULL, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (358, 'faqs', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (359, 'faqs', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (360, 'faqs', 'groups', 'm2m', 'list-m2m', '{
  "enableCreate": false
}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (361, 'faqs', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (362, 'faqs', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL,
        NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (363, 'faqs', 'status', NULL, 'select-dropdown', '{
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
  "choices": [
    {
      "text": "$t:published",
      "value": "published",
      "foreground": "#FFFFFF",
      "background": "var(--primary)"
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
      "background": "var(--warning)"
    }
  ],
  "showAsDot": true
}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (364, 'faqs', 'translations', 'translations', 'translations', '{
  "defaultLanguage": "no",
  "languageField": "code"
}', 'translations', '{
  "defaultLanguage": "no",
  "languageField": "code",
  "template": "{{question}}",
  "userLanguage": true
}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (365, 'faqs', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (366, 'faqs', 'user_updated', 'user-created,user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (367, 'faqs_translations', 'answer', NULL, 'input-rich-text-html', '{
  "placeholder": "This is the answer!",
  "toolbar": [
    "blockquote",
    "bold",
    "bullist",
    "code",
    "customImage",
    "customLink",
    "customMedia",
    "italic",
    "numlist",
    "removeformat",
    "underline"
  ],
  "trim": true
}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (368, 'faqs_translations', 'faqs_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (369, 'faqs_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (370, 'faqs_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (372, 'faqs_usergroups', 'faqs_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (373, 'faqs_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false,
        NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (374, 'faqs_usergroups', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (371, 'faqs_translations', 'question', NULL, 'input', '{
  "iconLeft": "question_mark",
  "placeholder": "What is a question?"
}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (104, 'faq_categories_translations', 'faq_categories_id', 'faq_categories', 'translations', NULL, NULL,
        'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (105, 'faq_categories_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'faq_categories_id', NULL,
        'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (106, 'faqs', 'category', 'faq_categories', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (107, 'faqs', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (108, 'faqs', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (109, 'faqs_translations', 'faqs_id', 'faqs', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (110, 'faqs_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'faqs_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (111, 'faqs_usergroups', 'faqs_id', 'faqs', 'groups', NULL, NULL, 'usergroups_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (112, 'faqs_usergroups', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'faqs_id', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
