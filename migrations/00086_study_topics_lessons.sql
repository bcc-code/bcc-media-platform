-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-05T13:02:06.914Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."lessons_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."lessons_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."lessons_translations_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."lessons_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."lessons_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."lessons_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."lessons_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."lessons_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."studytopics_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."studytopics_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."studytopics_translations_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."studytopics_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."studytopics_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."studytopics_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."studytopics_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."studytopics_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."lessons_relations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."lessons_relations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."lessons_relations_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."lessons_relations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."lessons_relations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."lessons_relations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."lessons_relations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."lessons_relations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."tasks_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."tasks_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."tasks_translations_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."tasks_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."tasks_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."tasks_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."tasks_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."tasks_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."questionalternatives_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."questionalternatives_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."questionalternatives_translations_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."questionalternatives_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."questionalternatives_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."studies_translations_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."studies_translations_id_seq" 
	INCREMENT BY 1 
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."studies_translations_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."studies_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."studies_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."studies_translations_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."studies_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."studies_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."studies_translations_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."studies_translations_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."studies_translations_id_seq" ---

--- BEGIN CREATE TABLE "public"."tasks_translations" ---

CREATE TABLE IF NOT EXISTS "public"."tasks_translations" (
	"id" int4 NOT NULL DEFAULT nextval('tasks_translations_id_seq'::regclass) ,
	"tasks_id" uuid NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" varchar(255) NULL  ,
	CONSTRAINT "tasks_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "tasks_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "tasks_translations_tasks_id_foreign" FOREIGN KEY (tasks_id) REFERENCES tasks(id) ON DELETE CASCADE 
);

ALTER TABLE IF EXISTS "public"."tasks_translations" OWNER TO btv;

GRANT SELECT ON TABLE "public"."tasks_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."tasks_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."tasks_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."tasks_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."tasks_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."tasks_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."tasks_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."tasks_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."tasks_translations"."tasks_id"  IS NULL;


COMMENT ON COLUMN "public"."tasks_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."tasks_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "tasks_translations_pkey" ON "public"."tasks_translations" IS NULL;


COMMENT ON CONSTRAINT "tasks_translations_languages_code_foreign" ON "public"."tasks_translations" IS NULL;


COMMENT ON CONSTRAINT "tasks_translations_tasks_id_foreign" ON "public"."tasks_translations" IS NULL;

COMMENT ON TABLE "public"."tasks_translations"  IS NULL;

--- END CREATE TABLE "public"."tasks_translations" ---

--- BEGIN CREATE TABLE "public"."lessons_translations" ---

CREATE TABLE IF NOT EXISTS "public"."lessons_translations" (
	"id" int4 NOT NULL DEFAULT nextval('lessons_translations_id_seq'::regclass) ,
	"lessons_id" uuid NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" varchar(255) NULL  ,
	CONSTRAINT "lessons_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE CASCADE ,
	CONSTRAINT "lessons_translations_lessons_id_foreign" FOREIGN KEY (lessons_id) REFERENCES lessons(id) ON DELETE CASCADE ,
	CONSTRAINT "lessons_translations_pkey" PRIMARY KEY (id) 
);

ALTER TABLE IF EXISTS "public"."lessons_translations" OWNER TO btv;

GRANT SELECT ON TABLE "public"."lessons_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."lessons_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."lessons_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."lessons_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."lessons_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."lessons_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."lessons_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."lessons_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."lessons_translations"."lessons_id"  IS NULL;


COMMENT ON COLUMN "public"."lessons_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."lessons_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "lessons_translations_languages_code_foreign" ON "public"."lessons_translations" IS NULL;


COMMENT ON CONSTRAINT "lessons_translations_lessons_id_foreign" ON "public"."lessons_translations" IS NULL;


COMMENT ON CONSTRAINT "lessons_translations_pkey" ON "public"."lessons_translations" IS NULL;

COMMENT ON TABLE "public"."lessons_translations"  IS NULL;

--- END CREATE TABLE "public"."lessons_translations" ---

--- BEGIN CREATE TABLE "public"."lessons_relations" ---

CREATE TABLE IF NOT EXISTS "public"."lessons_relations" (
	"id" int4 NOT NULL DEFAULT nextval('lessons_relations_id_seq'::regclass) ,
	"lessons_id" uuid NULL  ,
	"item" varchar(255) NULL  ,
	"sort" int4 NULL  ,
	"collection" varchar(255) NULL  ,
	CONSTRAINT "lessons_relations_lessons_id_foreign" FOREIGN KEY (lessons_id) REFERENCES lessons(id) ON DELETE CASCADE ,
	CONSTRAINT "lessons_relations_pkey" PRIMARY KEY (id) 
);

ALTER TABLE IF EXISTS "public"."lessons_relations" OWNER TO btv;

GRANT SELECT ON TABLE "public"."lessons_relations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."lessons_relations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."lessons_relations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."lessons_relations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."lessons_relations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."lessons_relations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."lessons_relations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."lessons_relations"."id"  IS NULL;


COMMENT ON COLUMN "public"."lessons_relations"."lessons_id"  IS NULL;


COMMENT ON COLUMN "public"."lessons_relations"."item"  IS NULL;


COMMENT ON COLUMN "public"."lessons_relations"."sort"  IS NULL;


COMMENT ON COLUMN "public"."lessons_relations"."collection"  IS NULL;

COMMENT ON CONSTRAINT "lessons_relations_lessons_id_foreign" ON "public"."lessons_relations" IS NULL;


COMMENT ON CONSTRAINT "lessons_relations_pkey" ON "public"."lessons_relations" IS NULL;

COMMENT ON TABLE "public"."lessons_relations"  IS NULL;

--- END CREATE TABLE "public"."lessons_relations" ---

--- BEGIN ALTER TABLE "public"."links" ---

REVOKE SELECT ON TABLE "public"."links" FROM api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

REVOKE SELECT ON TABLE "public"."links_translations" FROM api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN CREATE TABLE "public"."tasks" ---

CREATE TABLE IF NOT EXISTS "public"."tasks" (
	"id" uuid NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"type" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"question_type" varchar(255) NULL  ,
	"sort" int4 NULL  ,
	"lesson_id" uuid NOT NULL  ,
	"title" varchar(255) NULL  ,
	"alternatives_multiselect" bool NULL  ,
	CONSTRAINT "tasks_lesson_id_foreign" FOREIGN KEY (lesson_id) REFERENCES lessons(id) ,
	CONSTRAINT "tasks_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "tasks_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "tasks_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) 
);

ALTER TABLE IF EXISTS "public"."tasks" OWNER TO btv;

GRANT SELECT ON TABLE "public"."tasks" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."tasks" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."tasks" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."tasks" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."tasks" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."tasks" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."tasks" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."tasks" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."tasks" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."tasks" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."tasks" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."tasks" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."tasks" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."tasks" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."tasks" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."tasks"."id"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."status"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."type"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."question_type"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."sort"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."lesson_id"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."title"  IS NULL;


COMMENT ON COLUMN "public"."tasks"."alternatives_multiselect"  IS NULL;

COMMENT ON CONSTRAINT "tasks_lesson_id_foreign" ON "public"."tasks" IS NULL;


COMMENT ON CONSTRAINT "tasks_pkey" ON "public"."tasks" IS NULL;


COMMENT ON CONSTRAINT "tasks_user_updated_foreign" ON "public"."tasks" IS NULL;


COMMENT ON CONSTRAINT "tasks_user_created_foreign" ON "public"."tasks" IS NULL;

COMMENT ON TABLE "public"."tasks"  IS NULL;

--- END CREATE TABLE "public"."tasks" ---

--- BEGIN CREATE TABLE "public"."questionalternatives" ---

CREATE TABLE IF NOT EXISTS "public"."questionalternatives" (
	"id" uuid NOT NULL  ,
	"task_id" uuid NULL  ,
	"sort" int4 NULL  ,
	"title" varchar(255) NULL  ,
	CONSTRAINT "questionalternatives_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "questionalternatives_task_id_foreign" FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE 
);

ALTER TABLE IF EXISTS "public"."questionalternatives" OWNER TO btv;

GRANT SELECT ON TABLE "public"."questionalternatives" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."questionalternatives" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."questionalternatives" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."questionalternatives" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."questionalternatives" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."questionalternatives" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."questionalternatives" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."questionalternatives" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."questionalternatives" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."questionalternatives" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."questionalternatives" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."questionalternatives" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."questionalternatives" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."questionalternatives" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."questionalternatives" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."questionalternatives"."id"  IS NULL;


COMMENT ON COLUMN "public"."questionalternatives"."task_id"  IS NULL;


COMMENT ON COLUMN "public"."questionalternatives"."sort"  IS NULL;


COMMENT ON COLUMN "public"."questionalternatives"."title"  IS NULL;

COMMENT ON CONSTRAINT "questionalternatives_pkey" ON "public"."questionalternatives" IS NULL;


COMMENT ON CONSTRAINT "questionalternatives_task_id_foreign" ON "public"."questionalternatives" IS NULL;

COMMENT ON TABLE "public"."questionalternatives"  IS NULL;

--- END CREATE TABLE "public"."questionalternatives" ---

--- BEGIN CREATE TABLE "public"."lessons" ---

CREATE TABLE IF NOT EXISTS "public"."lessons" (
	"id" uuid NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"title" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"topic_id" uuid NOT NULL  ,
	"sort" int4 NULL  ,
	CONSTRAINT "lessons_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "lessons_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "lessons_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "lessons_topic_id_foreign" FOREIGN KEY (topic_id) REFERENCES studytopics(id) ON DELETE CASCADE 
);

ALTER TABLE IF EXISTS "public"."lessons" OWNER TO btv;

GRANT SELECT ON TABLE "public"."lessons" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."lessons" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."lessons" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."lessons" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."lessons" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."lessons" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."lessons" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."lessons"."id"  IS NULL;


COMMENT ON COLUMN "public"."lessons"."status"  IS NULL;


COMMENT ON COLUMN "public"."lessons"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."lessons"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."lessons"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."lessons"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."lessons"."title"  IS NULL;


COMMENT ON COLUMN "public"."lessons"."topic_id"  IS NULL;


COMMENT ON COLUMN "public"."lessons"."sort"  IS NULL;

COMMENT ON CONSTRAINT "lessons_pkey" ON "public"."lessons" IS NULL;


COMMENT ON CONSTRAINT "lessons_user_created_foreign" ON "public"."lessons" IS NULL;


COMMENT ON CONSTRAINT "lessons_user_updated_foreign" ON "public"."lessons" IS NULL;


COMMENT ON CONSTRAINT "lessons_topic_id_foreign" ON "public"."lessons" IS NULL;

COMMENT ON TABLE "public"."lessons"  IS NULL;

--- END CREATE TABLE "public"."lessons" ---

--- BEGIN CREATE TABLE "public"."studytopics" ---

CREATE TABLE IF NOT EXISTS "public"."studytopics" (
	"id" uuid NOT NULL  ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"title" varchar(255) NOT NULL  ,
	CONSTRAINT "studytopics_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "studytopics_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "studytopics_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) 
);

ALTER TABLE IF EXISTS "public"."studytopics" OWNER TO btv;

GRANT SELECT ON TABLE "public"."studytopics" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."studytopics" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."studytopics" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."studytopics" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."studytopics" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."studytopics" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."studytopics" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."studytopics"."id"  IS NULL;


COMMENT ON COLUMN "public"."studytopics"."status"  IS NULL;


COMMENT ON COLUMN "public"."studytopics"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."studytopics"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."studytopics"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."studytopics"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."studytopics"."title"  IS NULL;

COMMENT ON CONSTRAINT "studytopics_pkey" ON "public"."studytopics" IS NULL;


COMMENT ON CONSTRAINT "studytopics_user_updated_foreign" ON "public"."studytopics" IS NULL;


COMMENT ON CONSTRAINT "studytopics_user_created_foreign" ON "public"."studytopics" IS NULL;

COMMENT ON TABLE "public"."studytopics"  IS NULL;

--- END CREATE TABLE "public"."studytopics" ---

--- BEGIN CREATE TABLE "public"."studytopics_translations" ---

CREATE TABLE IF NOT EXISTS "public"."studytopics_translations" (
	"id" int4 NOT NULL DEFAULT nextval('studytopics_translations_id_seq'::regclass) ,
	"studytopics_id" uuid NULL  ,
	"languages_code" varchar(255) NULL  ,
	"title" varchar(255) NULL  ,
	CONSTRAINT "studytopics_translations_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "studytopics_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL ,
	CONSTRAINT "studytopics_translations_studytopics_id_foreign" FOREIGN KEY (studytopics_id) REFERENCES studytopics(id) ON DELETE SET NULL 
);

ALTER TABLE IF EXISTS "public"."studytopics_translations" OWNER TO btv;

GRANT SELECT ON TABLE "public"."studytopics_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."studytopics_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."studytopics_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."studytopics_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."studytopics_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."studytopics_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."studytopics_translations" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."studytopics_translations"."id"  IS NULL;


COMMENT ON COLUMN "public"."studytopics_translations"."studytopics_id"  IS NULL;


COMMENT ON COLUMN "public"."studytopics_translations"."languages_code"  IS NULL;


COMMENT ON COLUMN "public"."studytopics_translations"."title"  IS NULL;

COMMENT ON CONSTRAINT "studytopics_translations_pkey" ON "public"."studytopics_translations" IS NULL;


COMMENT ON CONSTRAINT "studytopics_translations_languages_code_foreign" ON "public"."studytopics_translations" IS NULL;


COMMENT ON CONSTRAINT "studytopics_translations_studytopics_id_foreign" ON "public"."studytopics_translations" IS NULL;

COMMENT ON TABLE "public"."studytopics_translations"  IS NULL;

--- END CREATE TABLE "public"."studytopics_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tasks', 'fact_check', NULL, '{{type}}', true, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'lessons', 'open');

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'ageratings_translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tasks_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'config';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('lessons_relations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

UPDATE "public"."directus_collections" SET "group" = 'translations' WHERE "collection" = 'shows_translations';

UPDATE "public"."directus_collections" SET "sort" = 2, "group" = 'translations' WHERE "collection" = 'pages_translations';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'messages';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('translations', 'folder', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 21, NULL, 'open');

UPDATE "public"."directus_collections" SET "sort" = 3, "group" = 'translations' WHERE "collection" = 'collections_translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('studytopics_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 22, NULL, 'open');

UPDATE "public"."directus_collections" SET "sort" = 4, "group" = 'translations' WHERE "collection" = 'episodes_translations';

UPDATE "public"."directus_collections" SET "sort" = 5, "group" = 'translations' WHERE "collection" = 'seasons_translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('questionalternatives', NULL, NULL, '{{title}}', true, false, '[{"language":"en-US","translation":"Question Alternatives","singular":"Question Alternative","plural":"Question Alternatives"}]', NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'tasks', 'open');

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections" SET "sort" = 6, "group" = 'translations' WHERE "collection" = 'sections_translations';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'episodes_tags';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'sections_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'collections_items';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'episodes_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'FAQ';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'episodes_usergroups_download';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'episodes_usergroups_earlyaccess';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 18 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 19 WHERE "collection" = 'applications_usergroups';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('studies', 'menu_book', NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 3, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('lessons', 'content_paste_search', NULL, '{{title}}', false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'studytopics', 'open');

UPDATE "public"."directus_collections" SET "sort" = 7, "group" = 'translations' WHERE "collection" = 'events_translations';

UPDATE "public"."directus_collections" SET "sort" = 8, "group" = 'translations' WHERE "collection" = 'categories_translations';

UPDATE "public"."directus_collections" SET "sort" = 9, "group" = 'translations' WHERE "collection" = 'calendarentries_translations';

UPDATE "public"."directus_collections" SET "sort" = 10, "group" = 'translations' WHERE "collection" = 'tags_translations';

UPDATE "public"."directus_collections" SET "sort" = 11, "group" = 'translations' WHERE "collection" = 'faqs_translations';

UPDATE "public"."directus_collections" SET "sort" = 12, "group" = 'translations' WHERE "collection" = 'faq_categories_translations';

UPDATE "public"."directus_collections" SET "sort" = 13, "group" = 'translations' WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 15, "group" = 'translations' WHERE "collection" = 'messagetemplates_translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('lessons_translations', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('studytopics', 'topic', NULL, '{{title}}', false, false, '[{"language":"en-US","translation":"Topics","singular":"Topic","plural":"Topics"}]', 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'studies', 'open');

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'seasons_tags';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'shows_tags';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (849, 'lessons', 'sort', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (822, 'lessons', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (830, 'tasks', 'lesson_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 8, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (848, 'lessons', 'topic_id', NULL, 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (840, 'tasks', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 10, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (841, 'studytopics', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (854, 'studytopics', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (817, 'questionalternatives', 'task_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (810, 'questionalternatives', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (819, 'questionalternatives', 'sort', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (856, 'tasks_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (857, 'tasks_translations', 'tasks_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (858, 'tasks_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (863, 'studytopics_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (871, 'lessons_relations', 'collection', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (823, 'lessons', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (866, 'lessons', 'relations', 'm2a', 'list-m2a', '{"limit":100,"allowDuplicates":true}', 'related-values', NULL, false, false, 11, 'full', NULL, 'Where should this lesson be visible?', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (855, 'tasks', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, true, 14, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (860, 'lessons_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (861, 'lessons_translations', 'lessons_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (862, 'lessons_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (859, 'lessons', 'translations', 'translations', 'translations', NULL, 'translations', NULL, false, true, 12, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (864, 'lessons_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (865, 'tasks_translations', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (794, 'tasks', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (821, 'tasks', 'sort', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (796, 'tasks', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (797, 'tasks', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (798, 'tasks', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (867, 'lessons_relations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (868, 'lessons_relations', 'lessons_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (869, 'lessons_relations', 'item', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (870, 'lessons_relations', 'sort', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (807, 'tasks', 'question_type', NULL, 'select-dropdown', '{"choices":[{"text":"Alternatives","value":"alternatives"},{"text":"Text","value":"text"}]}', 'labels', NULL, false, true, 11, 'full', NULL, NULL, '[{"name":"Required if Question","rule":{"_and":[{"type":{"_eq":"question"}}]},"required":true,"options":{"allowOther":false,"allowNone":false},"hidden":false}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (872, 'tasks', 'alternatives_multiselect', 'cast-boolean', 'boolean', NULL, 'boolean', NULL, false, true, 13, 'full', NULL, NULL, '[{"name":"visible if alternatives","rule":{"_and":[{"_and":[{"type":{"_eq":"question"}},{"question_type":{"_eq":"alternatives"}}]}]},"hidden":false,"options":{"iconOn":"check_box","iconOff":"check_box_outline_blank","label":"Enabled"}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (799, 'tasks', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (806, 'tasks', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Question","value":"question"},{"text":"Poster","value":"poster"}]}', 'raw', NULL, false, false, 9, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (838, 'questionalternatives', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (845, 'studytopics', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (846, 'studytopics', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (844, 'studytopics', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (824, 'lessons', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (839, 'lessons', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, 9, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (831, 'lessons', 'tasks', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (795, 'tasks', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (825, 'lessons', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (826, 'lessons', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (827, 'lessons', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 7, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (818, 'tasks', 'questionalternatives', 'o2m', 'list-o2m', NULL, NULL, NULL, false, true, 12, 'full', NULL, NULL, '[{"name":"view if alternatives","rule":{"_and":[{"_and":[{"type":{"_eq":"question"}},{"question_type":{"_eq":"alternatives"}}]}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (851, 'studytopics_translations', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (852, 'studytopics_translations', 'studytopics_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (853, 'studytopics_translations', 'languages_code', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (847, 'studytopics', 'lessons', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (842, 'studytopics', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (843, 'studytopics', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (850, 'studytopics', 'translations', 'translations', 'translations', '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"no","userLanguage":true}', 'translations', NULL, false, true, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (239, 'tasks', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (240, 'tasks', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (246, 'questionalternatives', 'task_id', 'tasks', 'questionalternatives', NULL, NULL, NULL, 'sort', 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (247, 'lessons', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (248, 'lessons', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (250, 'tasks', 'lesson_id', 'lessons', 'tasks', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (253, 'studytopics', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (254, 'studytopics', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (255, 'lessons', 'topic_id', 'studytopics', 'lessons', NULL, NULL, NULL, 'sort', 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (256, 'studytopics_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'studytopics_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (257, 'studytopics_translations', 'studytopics_id', 'studytopics', 'translations', NULL, NULL, 'languages_code', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (258, 'tasks_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'tasks_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (259, 'tasks_translations', 'tasks_id', 'tasks', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (260, 'lessons_translations', 'languages_code', 'languages', NULL, NULL, NULL, 'lessons_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (261, 'lessons_translations', 'lessons_id', 'lessons', 'translations', NULL, NULL, 'languages_code', NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (262, 'lessons_relations', 'item', NULL, NULL, 'collection', 'episodes', 'lessons_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (263, 'lessons_relations', 'lessons_id', 'lessons', 'relations', NULL, NULL, 'item', 'sort', 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-05T13:02:08.351Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."links" ---

GRANT SELECT ON TABLE "public"."links" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

GRANT SELECT ON TABLE "public"."links_translations" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN DROP TABLE "public"."tasks_translations" ---

DROP TABLE IF EXISTS "public"."tasks_translations";

--- END DROP TABLE "public"."tasks_translations" ---

--- BEGIN DROP TABLE "public"."lessons_translations" ---

DROP TABLE IF EXISTS "public"."lessons_translations";

--- END DROP TABLE "public"."lessons_translations" ---

--- BEGIN DROP TABLE "public"."lessons_relations" ---

DROP TABLE IF EXISTS "public"."lessons_relations";

--- END DROP TABLE "public"."lessons_relations" ---

--- BEGIN DROP TABLE "public"."tasks" ---

DROP TABLE IF EXISTS "public"."tasks";

--- END DROP TABLE "public"."tasks" ---

--- BEGIN DROP TABLE "public"."questionalternatives" ---

DROP TABLE IF EXISTS "public"."questionalternatives";

--- END DROP TABLE "public"."questionalternatives" ---

--- BEGIN DROP TABLE "public"."lessons" ---

DROP TABLE IF EXISTS "public"."lessons";

--- END DROP TABLE "public"."lessons" ---

--- BEGIN DROP TABLE "public"."studytopics" ---

DROP TABLE IF EXISTS "public"."studytopics";

--- END DROP TABLE "public"."studytopics" ---

--- BEGIN DROP TABLE "public"."studytopics_translations" ---

DROP TABLE IF EXISTS "public"."studytopics_translations";

--- END DROP TABLE "public"."studytopics_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'FAQ';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'calendarentries' WHERE "collection" = 'calendarentries_translations';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'categories' WHERE "collection" = 'categories_translations';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'episodes_tags';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'episodes' WHERE "collection" = 'episodes_translations';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'episodes_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'episodes_usergroups_download';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'events' WHERE "collection" = 'events_translations';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'faq_categories' WHERE "collection" = 'faq_categories_translations';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections" SET "sort" = 2, "group" = 'faqs' WHERE "collection" = 'faqs_translations';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'messagetemplates' WHERE "collection" = 'messagetemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'pages' WHERE "collection" = 'pages_translations';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'seasons' WHERE "collection" = 'seasons_translations';

UPDATE "public"."directus_collections" SET "group" = 'shows' WHERE "collection" = 'shows_translations';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'tags' WHERE "collection" = 'tags_translations';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'episodes_usergroups_earlyaccess';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'shows_tags';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'seasons_tags';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'sections_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 2, "group" = 'sections' WHERE "collection" = 'sections_translations';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'collections_items';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'notificationtemplates' WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'messages';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 1, "group" = 'collections' WHERE "collection" = 'collections_translations';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'applications_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'tasks';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'tasks_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'lessons_relations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'studytopics_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'questionalternatives';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'studies';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'lessons';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'lessons_translations';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'studytopics';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 849;

DELETE FROM "public"."directus_fields" WHERE "id" = 822;

DELETE FROM "public"."directus_fields" WHERE "id" = 830;

DELETE FROM "public"."directus_fields" WHERE "id" = 848;

DELETE FROM "public"."directus_fields" WHERE "id" = 840;

DELETE FROM "public"."directus_fields" WHERE "id" = 841;

DELETE FROM "public"."directus_fields" WHERE "id" = 854;

DELETE FROM "public"."directus_fields" WHERE "id" = 817;

DELETE FROM "public"."directus_fields" WHERE "id" = 810;

DELETE FROM "public"."directus_fields" WHERE "id" = 819;

DELETE FROM "public"."directus_fields" WHERE "id" = 856;

DELETE FROM "public"."directus_fields" WHERE "id" = 857;

DELETE FROM "public"."directus_fields" WHERE "id" = 858;

DELETE FROM "public"."directus_fields" WHERE "id" = 863;

DELETE FROM "public"."directus_fields" WHERE "id" = 871;

DELETE FROM "public"."directus_fields" WHERE "id" = 823;

DELETE FROM "public"."directus_fields" WHERE "id" = 866;

DELETE FROM "public"."directus_fields" WHERE "id" = 855;

DELETE FROM "public"."directus_fields" WHERE "id" = 860;

DELETE FROM "public"."directus_fields" WHERE "id" = 861;

DELETE FROM "public"."directus_fields" WHERE "id" = 862;

DELETE FROM "public"."directus_fields" WHERE "id" = 859;

DELETE FROM "public"."directus_fields" WHERE "id" = 864;

DELETE FROM "public"."directus_fields" WHERE "id" = 865;

DELETE FROM "public"."directus_fields" WHERE "id" = 794;

DELETE FROM "public"."directus_fields" WHERE "id" = 821;

DELETE FROM "public"."directus_fields" WHERE "id" = 796;

DELETE FROM "public"."directus_fields" WHERE "id" = 797;

DELETE FROM "public"."directus_fields" WHERE "id" = 798;

DELETE FROM "public"."directus_fields" WHERE "id" = 867;

DELETE FROM "public"."directus_fields" WHERE "id" = 868;

DELETE FROM "public"."directus_fields" WHERE "id" = 869;

DELETE FROM "public"."directus_fields" WHERE "id" = 870;

DELETE FROM "public"."directus_fields" WHERE "id" = 807;

DELETE FROM "public"."directus_fields" WHERE "id" = 872;

DELETE FROM "public"."directus_fields" WHERE "id" = 799;

DELETE FROM "public"."directus_fields" WHERE "id" = 806;

DELETE FROM "public"."directus_fields" WHERE "id" = 838;

DELETE FROM "public"."directus_fields" WHERE "id" = 845;

DELETE FROM "public"."directus_fields" WHERE "id" = 846;

DELETE FROM "public"."directus_fields" WHERE "id" = 844;

DELETE FROM "public"."directus_fields" WHERE "id" = 824;

DELETE FROM "public"."directus_fields" WHERE "id" = 839;

DELETE FROM "public"."directus_fields" WHERE "id" = 831;

DELETE FROM "public"."directus_fields" WHERE "id" = 795;

DELETE FROM "public"."directus_fields" WHERE "id" = 825;

DELETE FROM "public"."directus_fields" WHERE "id" = 826;

DELETE FROM "public"."directus_fields" WHERE "id" = 827;

DELETE FROM "public"."directus_fields" WHERE "id" = 818;

DELETE FROM "public"."directus_fields" WHERE "id" = 851;

DELETE FROM "public"."directus_fields" WHERE "id" = 852;

DELETE FROM "public"."directus_fields" WHERE "id" = 853;

DELETE FROM "public"."directus_fields" WHERE "id" = 847;

DELETE FROM "public"."directus_fields" WHERE "id" = 842;

DELETE FROM "public"."directus_fields" WHERE "id" = 843;

DELETE FROM "public"."directus_fields" WHERE "id" = 850;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 239;

DELETE FROM "public"."directus_relations" WHERE "id" = 240;

DELETE FROM "public"."directus_relations" WHERE "id" = 246;

DELETE FROM "public"."directus_relations" WHERE "id" = 247;

DELETE FROM "public"."directus_relations" WHERE "id" = 248;

DELETE FROM "public"."directus_relations" WHERE "id" = 250;

DELETE FROM "public"."directus_relations" WHERE "id" = 253;

DELETE FROM "public"."directus_relations" WHERE "id" = 254;

DELETE FROM "public"."directus_relations" WHERE "id" = 255;

DELETE FROM "public"."directus_relations" WHERE "id" = 256;

DELETE FROM "public"."directus_relations" WHERE "id" = 257;

DELETE FROM "public"."directus_relations" WHERE "id" = 258;

DELETE FROM "public"."directus_relations" WHERE "id" = 259;

DELETE FROM "public"."directus_relations" WHERE "id" = 260;

DELETE FROM "public"."directus_relations" WHERE "id" = 261;

DELETE FROM "public"."directus_relations" WHERE "id" = 262;

DELETE FROM "public"."directus_relations" WHERE "id" = 263;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
