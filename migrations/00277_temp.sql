-- +goose Up
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-04-23T12:54:53.435Z                 ***/
/***************************************************************/

--- BEGIN CREATE SEQUENCE "public"."contributiontypes_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."contributiontypes_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."contributiontypes_translations_id_seq" OWNER TO bccm;
GRANT SELECT ON SEQUENCE "public"."contributiontypes_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."contributiontypes_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."contributiontypes_translations_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."contributiontypes_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."contributiontypes_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."mediaitems_contributions_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_contributions_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."mediaitems_contributions_id_seq" OWNER TO bccm;
GRANT SELECT ON SEQUENCE "public"."mediaitems_contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."mediaitems_contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."mediaitems_contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."mediaitems_contributions_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."mediaitems_contributions_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."timedmetadata_styledimages_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."timedmetadata_styledimages_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."timedmetadata_styledimages_id_seq" OWNER TO bccm;
GRANT SELECT ON SEQUENCE "public"."timedmetadata_styledimages_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."timedmetadata_styledimages_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."timedmetadata_styledimages_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."timedmetadata_styledimages_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."timedmetadata_styledimages_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."directus_fields_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."directus_fields_id_seq" START WITH 100000;

--- END ALTER SEQUENCE "public"."directus_fields_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."timedmetadata_contributions_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."timedmetadata_contributions_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."timedmetadata_contributions_id_seq" OWNER TO bccm;
GRANT SELECT ON SEQUENCE "public"."timedmetadata_contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."timedmetadata_contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."timedmetadata_contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."timedmetadata_contributions_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."timedmetadata_contributions_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."performances_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."performances_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."performances_id_seq" OWNER TO bccm;
GRANT SELECT ON SEQUENCE "public"."performances_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."performances_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."performances_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."performances_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."performances_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."contributions_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."contributions_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."contributions_id_seq" OWNER TO bccm;
GRANT SELECT ON SEQUENCE "public"."contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."contributions_id_seq" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."contributions_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."contributions_id_seq" ---

--- BEGIN CREATE TABLE "public"."contributiontypes_translations" ---

CREATE TABLE IF NOT EXISTS "public"."contributiontypes_translations" (
	"id" int4 NOT NULL DEFAULT nextval('contributiontypes_translations_id_seq'::regclass) ,
	"title" varchar(255) NULL  ,
	"languages_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"contributiontypes_code" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "contributiontypes_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "contributiontypes_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "contributiontypes_translations_contributio__529345bf_foreign" FOREIGN KEY (contributiontypes_code) REFERENCES contributiontypes(code) ON DELETE CASCADE 
);

ALTER TABLE IF EXISTS "public"."contributiontypes_translations" OWNER TO bccm;

GRANT SELECT ON TABLE "public"."contributiontypes_translations" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."contributiontypes_translations" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."contributiontypes_translations" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."contributiontypes_translations" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."contributiontypes_translations" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."contributiontypes_translations" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."contributiontypes_translations" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."contributiontypes_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes_translations"."title"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes_translations"."contributiontypes_code"  IS NULL;

COMMENT ON CONSTRAINT "contributiontypes_translations_pkey" ON "public"."contributiontypes_translations" IS NULL;


COMMENT ON CONSTRAINT "contributiontypes_translations_languages_code_foreign" ON "public"."contributiontypes_translations" IS NULL;


COMMENT ON CONSTRAINT "contributiontypes_translations_contributio__529345bf_foreign" ON "public"."contributiontypes_translations" IS NULL;

COMMENT ON TABLE "public"."contributiontypes_translations"  IS NULL;

--- END CREATE TABLE "public"."contributiontypes_translations" ---

--- BEGIN CREATE TABLE "public"."contributiontypes" ---

CREATE TABLE IF NOT EXISTS "public"."contributiontypes" (
	"code" varchar(255) NOT NULL  ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"title" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"hide_in_lists" bool NULL  ,
	CONSTRAINT "contributiontypes_pkey" PRIMARY KEY (code) ,
	CONSTRAINT "contributiontypes_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "contributiontypes_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) 
);

ALTER TABLE IF EXISTS "public"."contributiontypes" OWNER TO bccm;

GRANT SELECT ON TABLE "public"."contributiontypes" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."contributiontypes" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."contributiontypes" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."contributiontypes" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."contributiontypes" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."contributiontypes" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."contributiontypes" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."contributiontypes"."code"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes"."title"  IS NULL;


COMMENT ON COLUMN "public"."contributiontypes"."hide_in_lists"  IS NULL;

COMMENT ON CONSTRAINT "contributiontypes_pkey" ON "public"."contributiontypes" IS NULL;


COMMENT ON CONSTRAINT "contributiontypes_user_created_foreign" ON "public"."contributiontypes" IS NULL;


COMMENT ON CONSTRAINT "contributiontypes_user_updated_foreign" ON "public"."contributiontypes" IS NULL;

COMMENT ON TABLE "public"."contributiontypes"  IS NULL;

--- END CREATE TABLE "public"."contributiontypes" ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems" ADD COLUMN IF NOT EXISTS "primary_episode_id" int4 NULL  ;

COMMENT ON COLUMN "public"."mediaitems"."primary_episode_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems" ADD CONSTRAINT "mediaitems_primary_episode_id_foreign" FOREIGN KEY (primary_episode_id) REFERENCES episodes(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_primary_episode_id_foreign" ON "public"."mediaitems" IS NULL;

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN CREATE TABLE "public"."contributions" ---

CREATE TABLE IF NOT EXISTS "public"."contributions" (
	"id" int4 NOT NULL DEFAULT nextval('contributions_id_seq'::regclass) ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"person_id" uuid NULL  ,
	"type" varchar(255) NOT NULL  ,
	CONSTRAINT "contributions_type_foreign" FOREIGN KEY (type) REFERENCES contributiontypes(code) ,
	CONSTRAINT "contributions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "contributions_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "contributions_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "contributions_person_foreign" FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL 
);

ALTER TABLE IF EXISTS "public"."contributions" OWNER TO bccm;

GRANT SELECT ON TABLE "public"."contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."contributions"."id"  IS NULL;


COMMENT ON COLUMN "public"."contributions"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."contributions"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."contributions"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."contributions"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."contributions"."person_id"  IS NULL;


COMMENT ON COLUMN "public"."contributions"."type"  IS NULL;

COMMENT ON CONSTRAINT "contributions_type_foreign" ON "public"."contributions" IS NULL;


COMMENT ON CONSTRAINT "contributions_pkey" ON "public"."contributions" IS NULL;


COMMENT ON CONSTRAINT "contributions_user_created_foreign" ON "public"."contributions" IS NULL;


COMMENT ON CONSTRAINT "contributions_user_updated_foreign" ON "public"."contributions" IS NULL;


COMMENT ON CONSTRAINT "contributions_person_foreign" ON "public"."contributions" IS NULL;

COMMENT ON TABLE "public"."contributions"  IS NULL;

--- END CREATE TABLE "public"."contributions" ---

--- BEGIN CREATE TABLE "public"."timedmetadata_contributions" ---

CREATE TABLE IF NOT EXISTS "public"."timedmetadata_contributions" (
	"id" int4 NOT NULL DEFAULT nextval('timedmetadata_contributions_id_seq'::regclass) ,
	"timedmetadata_id" uuid NULL  ,
	"contributions_id" int4 NULL  ,
	CONSTRAINT "timedmetadata_contributions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "timedmetadata_contributions_contributions_id_foreign" FOREIGN KEY (contributions_id) REFERENCES contributions(id) ON DELETE CASCADE ,
	CONSTRAINT "timedmetadata_contributions_timedmetadata_id_foreign" FOREIGN KEY (timedmetadata_id) REFERENCES timedmetadata(id) ON DELETE CASCADE 
);

ALTER TABLE IF EXISTS "public"."timedmetadata_contributions" OWNER TO bccm;

GRANT SELECT ON TABLE "public"."timedmetadata_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."timedmetadata_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."timedmetadata_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."timedmetadata_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."timedmetadata_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."timedmetadata_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."timedmetadata_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."timedmetadata_contributions"."id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_contributions"."timedmetadata_id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_contributions"."contributions_id"  IS NULL;

COMMENT ON CONSTRAINT "timedmetadata_contributions_pkey" ON "public"."timedmetadata_contributions" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_contributions_contributions_id_foreign" ON "public"."timedmetadata_contributions" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_contributions_timedmetadata_id_foreign" ON "public"."timedmetadata_contributions" IS NULL;

COMMENT ON TABLE "public"."timedmetadata_contributions"  IS NULL;

--- END CREATE TABLE "public"."timedmetadata_contributions" ---

--- BEGIN CREATE TABLE "public"."timedmetadata_styledimages" ---

CREATE TABLE IF NOT EXISTS "public"."timedmetadata_styledimages" (
	"id" int4 NOT NULL DEFAULT nextval('timedmetadata_styledimages_id_seq'::regclass) ,
	"timedmetadata_id" uuid NULL  ,
	"styledimages_id" uuid NULL  ,
	CONSTRAINT "timedmetadata_styledimages_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "timedmetadata_styledimages_styledimages_id_foreign" FOREIGN KEY (styledimages_id) REFERENCES styledimages(id) ON DELETE CASCADE ,
	CONSTRAINT "timedmetadata_styledimages_timedmetadata_id_foreign" FOREIGN KEY (timedmetadata_id) REFERENCES timedmetadata(id) ON DELETE CASCADE 
);

ALTER TABLE IF EXISTS "public"."timedmetadata_styledimages" OWNER TO bccm;

GRANT SELECT ON TABLE "public"."timedmetadata_styledimages" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."timedmetadata_styledimages" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."timedmetadata_styledimages" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."timedmetadata_styledimages" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."timedmetadata_styledimages" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."timedmetadata_styledimages" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."timedmetadata_styledimages" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."timedmetadata_styledimages"."id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_styledimages"."timedmetadata_id"  IS NULL;


COMMENT ON COLUMN "public"."timedmetadata_styledimages"."styledimages_id"  IS NULL;

COMMENT ON CONSTRAINT "timedmetadata_styledimages_pkey" ON "public"."timedmetadata_styledimages" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_styledimages_styledimages_id_foreign" ON "public"."timedmetadata_styledimages" IS NULL;


COMMENT ON CONSTRAINT "timedmetadata_styledimages_timedmetadata_id_foreign" ON "public"."timedmetadata_styledimages" IS NULL;

COMMENT ON TABLE "public"."timedmetadata_styledimages"  IS NULL;

--- END CREATE TABLE "public"."timedmetadata_styledimages" ---

--- BEGIN CREATE TABLE "public"."performances" ---

CREATE TABLE IF NOT EXISTS "public"."performances" (
	"id" int4 NOT NULL DEFAULT nextval('performances_id_seq'::regclass) ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	CONSTRAINT "performances_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "performances_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "performances_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) 
);

ALTER TABLE IF EXISTS "public"."performances" OWNER TO bccm;

GRANT SELECT ON TABLE "public"."performances" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."performances" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."performances" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."performances" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."performances" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."performances" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."performances" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."performances"."id"  IS NULL;


COMMENT ON COLUMN "public"."performances"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."performances"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."performances"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."performances"."date_updated"  IS NULL;

COMMENT ON CONSTRAINT "performances_pkey" ON "public"."performances" IS NULL;


COMMENT ON CONSTRAINT "performances_user_created_foreign" ON "public"."performances" IS NULL;


COMMENT ON CONSTRAINT "performances_user_updated_foreign" ON "public"."performances" IS NULL;

COMMENT ON TABLE "public"."performances"  IS NULL;

--- END CREATE TABLE "public"."performances" ---

--- BEGIN CREATE TABLE "public"."mediaitems_contributions" ---

CREATE TABLE IF NOT EXISTS "public"."mediaitems_contributions" (
	"id" int4 NOT NULL DEFAULT nextval('mediaitems_contributions_id_seq'::regclass) ,
	"mediaitems_id" uuid NULL  ,
	"contributions_id" int4 NULL  ,
	CONSTRAINT "mediaitems_contributions_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "mediaitems_contributions_contributions_id_foreign" FOREIGN KEY (contributions_id) REFERENCES contributions(id) ON DELETE SET NULL ,
	CONSTRAINT "mediaitems_contributions_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems(id) ON DELETE SET NULL 
);

ALTER TABLE IF EXISTS "public"."mediaitems_contributions" OWNER TO bccm;

GRANT SELECT ON TABLE "public"."mediaitems_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_contributions" TO bccm; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."mediaitems_contributions"."id"  IS NULL;


COMMENT ON COLUMN "public"."mediaitems_contributions"."mediaitems_id"  IS NULL;


COMMENT ON COLUMN "public"."mediaitems_contributions"."contributions_id"  IS NULL;

COMMENT ON CONSTRAINT "mediaitems_contributions_pkey" ON "public"."mediaitems_contributions" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_contributions_contributions_id_foreign" ON "public"."mediaitems_contributions" IS NULL;


COMMENT ON CONSTRAINT "mediaitems_contributions_mediaitems_id_foreign" ON "public"."mediaitems_contributions" IS NULL;

COMMENT ON TABLE "public"."mediaitems_contributions"  IS NULL;

--- END CREATE TABLE "public"."mediaitems_contributions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1488, 'mediaitems', 'primary_episode_id', 'm2o', 'select-dropdown-m2o', '{}', NULL, NULL, false, false, 14, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3001, 'contributiontypes_translations', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3002, 'contributiontypes_translations', 'title', NULL, 'input', NULL, NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3005, 'contributiontypes_translations', 'languages_code', 'm2o', 'select-dropdown-m2o', '{"enableSelect":false,"enableCreate":false}', NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3013, 'contributiontypes', 'code', NULL, 'input', NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3014, 'contributiontypes', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3015, 'contributiontypes', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3016, 'contributiontypes', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3017, 'contributiontypes', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3018, 'contributiontypes', 'title', NULL, 'input', NULL, NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3019, 'contributiontypes', 'hide_in_lists', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3020, 'contributiontypes', 'contributions', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3021, 'contributions', 'type', 'm2o', 'select-dropdown-m2o', '{"enableCreate":false,"template":"{{title}}"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3022, 'contributiontypes_translations', 'contributiontypes_code', 'm2o', 'select-dropdown-m2o', '{"enableCreate":false}', NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1233;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1232;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1230;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1299;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1235;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1231;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1239;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1296;

UPDATE "public"."directus_fields" SET "sort" = 3, "width" = 'half' WHERE "id" = 1329;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1308;

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'half' WHERE "id" = 1404;

UPDATE "public"."directus_fields" SET "hidden" = true, "sort" = 12 WHERE "id" = 1422;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 1398;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1406;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1407;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 1403;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1414;

UPDATE "public"."directus_fields" SET "options" = '{"headerIcon":"energy_program_saving"}', "sort" = 8 WHERE "id" = 483;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1405;

UPDATE "public"."directus_fields" SET "sort" = 6, "width" = 'full', "group" = 'metadata' WHERE "id" = 1427;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1431;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1501, 'performances', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1502, 'performances', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1503, 'performances', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1504, 'performances', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1505, 'performances', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1506, 'contributions', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1507, 'contributions', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1508, 'contributions', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1509, 'contributions', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 495;

UPDATE "public"."directus_fields" SET "options" = '{"headerIcon":"format_list_numbered"}', "sort" = 9 WHERE "id" = 1460;

UPDATE "public"."directus_fields" SET "options" = '{"headerIcon":"design_services"}', "sort" = 7 WHERE "id" = 1442;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1465;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1510, 'contributions', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1511, 'contributions', 'person_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{name}}"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1516, 'timedmetadata_contributions', 'contributions_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1513, 'timedmetadata', 'contributions', 'm2m', 'list-m2m', '{"tableSpacing":"compact","layout":"table","fields":["contributions_id.person.name","contributions_id.speech"]}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1512, 'contributions', 'speech', NULL, 'select-dropdown', '{"choices":[{"text":"lyricist","value":"Lyricist"},{"text":"composer","value":"Composer"},{"text":"speaker","value":"Speaker"},{"text":"arranger","value":"Arranger"},{"text":"singer","value":"Singer"}]}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1514, 'timedmetadata_contributions', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1515, 'timedmetadata_contributions', 'timedmetadata_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1518, 'mediaitems_contributions', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1519, 'mediaitems_contributions', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1517, 'mediaitems', 'contributions', 'm2m', 'list-m2m', '{"layout":"table","tableSpacing":"compact"}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1497, 'timedmetadata', 'images', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, 'details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1520, 'mediaitems_contributions', 'contributions_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1498, 'timedmetadata_styledimages', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1499, 'timedmetadata_styledimages', 'timedmetadata_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1500, 'timedmetadata_styledimages', 'styledimages_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1523, 'mediaitems', '_assets', 'alias,no-data,group', 'group-detail', '{"headerIcon":"file_present"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 1340;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('contributiontypes_translations', NULL, NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('contributiontypes', NULL, NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('performances', NULL, NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('timedmetadata_styledimages', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('contributions', NULL, NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('timedmetadata_contributions', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('mediaitems_contributions', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (467, 'timedmetadata_contributions', 'contributions_id', 'contributions', NULL, NULL, NULL, 'timedmetadata_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (460, 'timedmetadata_styledimages', 'styledimages_id', 'styledimages', NULL, NULL, NULL, 'timedmetadata_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (461, 'timedmetadata_styledimages', 'timedmetadata_id', 'timedmetadata', 'images', NULL, NULL, 'styledimages_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (462, 'performances', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (463, 'performances', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (464, 'contributions', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (465, 'contributions', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (466, 'contributions', 'person_id', 'persons', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (468, 'timedmetadata_contributions', 'timedmetadata_id', 'timedmetadata', 'contributions', NULL, NULL, 'contributions_id', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (469, 'mediaitems_contributions', 'contributions_id', 'contributions', NULL, NULL, NULL, 'mediaitems_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (470, 'mediaitems_contributions', 'mediaitems_id', 'mediaitems', 'contributions', NULL, NULL, 'contributions_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (456, 'mediaitems', 'primary_episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (474, 'contributiontypes', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (471, 'contributiontypes_translations', 'languages_code', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (475, 'contributiontypes', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (476, 'contributions', 'type', 'contributiontypes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (477, 'contributiontypes_translations', 'contributiontypes_code', 'contributiontypes', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-04-23T12:54:56.076Z                 ***/
/***************************************************************/

--- BEGIN ALTER SEQUENCE "public"."directus_fields_id_seq" ---

ALTER SEQUENCE IF EXISTS "public"."directus_fields_id_seq" START WITH 1;

--- END ALTER SEQUENCE "public"."directus_fields_id_seq" ---

--- BEGIN ALTER TABLE "public"."mediaitems" ---

ALTER TABLE IF EXISTS "public"."mediaitems" DROP COLUMN IF EXISTS "primary_episode_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."mediaitems" DROP CONSTRAINT IF EXISTS "mediaitems_primary_episode_id_foreign";

--- END ALTER TABLE "public"."mediaitems" ---

--- BEGIN DROP TABLE "public"."contributiontypes_translations" ---

DROP TABLE IF EXISTS "public"."contributiontypes_translations";

--- END DROP TABLE "public"."contributiontypes_translations" ---

--- BEGIN DROP TABLE "public"."contributiontypes" ---

DROP TABLE IF EXISTS "public"."contributiontypes";

--- END DROP TABLE "public"."contributiontypes" ---

--- BEGIN DROP TABLE "public"."contributions" ---

DROP TABLE IF EXISTS "public"."contributions";

--- END DROP TABLE "public"."contributions" ---

--- BEGIN DROP TABLE "public"."timedmetadata_contributions" ---

DROP TABLE IF EXISTS "public"."timedmetadata_contributions";

--- END DROP TABLE "public"."timedmetadata_contributions" ---

--- BEGIN DROP TABLE "public"."timedmetadata_styledimages" ---

DROP TABLE IF EXISTS "public"."timedmetadata_styledimages";

--- END DROP TABLE "public"."timedmetadata_styledimages" ---

--- BEGIN DROP TABLE "public"."performances" ---

DROP TABLE IF EXISTS "public"."performances";

--- END DROP TABLE "public"."performances" ---

--- BEGIN DROP TABLE "public"."mediaitems_contributions" ---

DROP TABLE IF EXISTS "public"."mediaitems_contributions";

--- END DROP TABLE "public"."mediaitems_contributions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'contributiontypes_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'contributiontypes';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'performances';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'timedmetadata_styledimages';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'contributions';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'timedmetadata_contributions';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'mediaitems_contributions';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 11, "width" = 'full' WHERE "id" = 1329;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1340, 'timedmetadata', 'persons', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 6, 'half', NULL, NULL, '[{"name":"hide if not person","rule":{"_and":[{"chapter_type":{"_nin":["testimony","appeal","speech"]}}]},"hidden":true,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"junctionFieldLocation":"bottom","allowDuplicates":false,"enableSearchFilter":false,"enableLink":false}}]', false, 'details', NULL, NULL);

UPDATE "public"."directus_fields" SET "options" = NULL, "sort" = 12 WHERE "id" = 1442;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1233;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 1230;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1232;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1235;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1299;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1296;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1231;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1431;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1239;

UPDATE "public"."directus_fields" SET "hidden" = false, "sort" = 16 WHERE "id" = 1422;

UPDATE "public"."directus_fields" SET "sort" = 5, "width" = 'half', "group" = 'details' WHERE "id" = 1427;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1406;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1308;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1405;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 1398;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 1403;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1414;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1407;

UPDATE "public"."directus_fields" SET "sort" = 6, "width" = 'full' WHERE "id" = 1404;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 495;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1465;

UPDATE "public"."directus_fields" SET "options" = NULL, "sort" = 14 WHERE "id" = 483;

UPDATE "public"."directus_fields" SET "options" = NULL, "sort" = 15 WHERE "id" = 1460;

DELETE FROM "public"."directus_fields" WHERE "id" = 1488;

DELETE FROM "public"."directus_fields" WHERE "id" = 3001;

DELETE FROM "public"."directus_fields" WHERE "id" = 3002;

DELETE FROM "public"."directus_fields" WHERE "id" = 3005;

DELETE FROM "public"."directus_fields" WHERE "id" = 3013;

DELETE FROM "public"."directus_fields" WHERE "id" = 3014;

DELETE FROM "public"."directus_fields" WHERE "id" = 3015;

DELETE FROM "public"."directus_fields" WHERE "id" = 3016;

DELETE FROM "public"."directus_fields" WHERE "id" = 3017;

DELETE FROM "public"."directus_fields" WHERE "id" = 3018;

DELETE FROM "public"."directus_fields" WHERE "id" = 3019;

DELETE FROM "public"."directus_fields" WHERE "id" = 3020;

DELETE FROM "public"."directus_fields" WHERE "id" = 3021;

DELETE FROM "public"."directus_fields" WHERE "id" = 3022;

DELETE FROM "public"."directus_fields" WHERE "id" = 1501;

DELETE FROM "public"."directus_fields" WHERE "id" = 1502;

DELETE FROM "public"."directus_fields" WHERE "id" = 1503;

DELETE FROM "public"."directus_fields" WHERE "id" = 1504;

DELETE FROM "public"."directus_fields" WHERE "id" = 1505;

DELETE FROM "public"."directus_fields" WHERE "id" = 1506;

DELETE FROM "public"."directus_fields" WHERE "id" = 1507;

DELETE FROM "public"."directus_fields" WHERE "id" = 1508;

DELETE FROM "public"."directus_fields" WHERE "id" = 1509;

DELETE FROM "public"."directus_fields" WHERE "id" = 1510;

DELETE FROM "public"."directus_fields" WHERE "id" = 1511;

DELETE FROM "public"."directus_fields" WHERE "id" = 1516;

DELETE FROM "public"."directus_fields" WHERE "id" = 1513;

DELETE FROM "public"."directus_fields" WHERE "id" = 1512;

DELETE FROM "public"."directus_fields" WHERE "id" = 1514;

DELETE FROM "public"."directus_fields" WHERE "id" = 1515;

DELETE FROM "public"."directus_fields" WHERE "id" = 1518;

DELETE FROM "public"."directus_fields" WHERE "id" = 1519;

DELETE FROM "public"."directus_fields" WHERE "id" = 1517;

DELETE FROM "public"."directus_fields" WHERE "id" = 1497;

DELETE FROM "public"."directus_fields" WHERE "id" = 1520;

DELETE FROM "public"."directus_fields" WHERE "id" = 1498;

DELETE FROM "public"."directus_fields" WHERE "id" = 1499;

DELETE FROM "public"."directus_fields" WHERE "id" = 1500;

DELETE FROM "public"."directus_fields" WHERE "id" = 1523;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 467;

DELETE FROM "public"."directus_relations" WHERE "id" = 460;

DELETE FROM "public"."directus_relations" WHERE "id" = 461;

DELETE FROM "public"."directus_relations" WHERE "id" = 462;

DELETE FROM "public"."directus_relations" WHERE "id" = 463;

DELETE FROM "public"."directus_relations" WHERE "id" = 464;

DELETE FROM "public"."directus_relations" WHERE "id" = 465;

DELETE FROM "public"."directus_relations" WHERE "id" = 466;

DELETE FROM "public"."directus_relations" WHERE "id" = 468;

DELETE FROM "public"."directus_relations" WHERE "id" = 469;

DELETE FROM "public"."directus_relations" WHERE "id" = 470;

DELETE FROM "public"."directus_relations" WHERE "id" = 456;

DELETE FROM "public"."directus_relations" WHERE "id" = 474;

DELETE FROM "public"."directus_relations" WHERE "id" = 471;

DELETE FROM "public"."directus_relations" WHERE "id" = 475;

DELETE FROM "public"."directus_relations" WHERE "id" = 476;

DELETE FROM "public"."directus_relations" WHERE "id" = 477;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
