-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-01T07:36:54.028Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text;

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

ALTER TABLE IF EXISTS "public"."achievementgroups_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text;

ALTER TABLE IF EXISTS "public"."achievementgroups_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text;

ALTER TABLE IF EXISTS "public"."achievements_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

ALTER TABLE IF EXISTS "public"."studytopics_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text;

ALTER TABLE IF EXISTS "public"."studytopics_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."episodes_translations" ---

ALTER TABLE IF EXISTS "public"."episodes_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text,
	ALTER COLUMN "title" DROP DEFAULT ;

--- END ALTER TABLE "public"."episodes_translations" ---

--- BEGIN ALTER TABLE "public"."events_translations" ---

ALTER TABLE IF EXISTS "public"."events_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text,
	ALTER COLUMN "description" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."events_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text,
	ALTER COLUMN "title" DROP DEFAULT ;

--- END ALTER TABLE "public"."events_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "message" SET DATA TYPE text USING "message"::text,
	ALTER COLUMN "message" DROP DEFAULT ;

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

ALTER TABLE IF EXISTS "public"."pages_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

ALTER TABLE IF EXISTS "public"."pages_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text;

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN ALTER TABLE "public"."seasons_translations" ---

ALTER TABLE IF EXISTS "public"."seasons_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text,
	ALTER COLUMN "title" DROP DEFAULT ;

--- END ALTER TABLE "public"."seasons_translations" ---

--- BEGIN ALTER TABLE "public"."shows_translations" ---

ALTER TABLE IF EXISTS "public"."shows_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text,
	ALTER COLUMN "title" DROP DEFAULT ;

--- END ALTER TABLE "public"."shows_translations" ---

--- BEGIN ALTER TABLE "public"."sections_translations" ---

ALTER TABLE IF EXISTS "public"."sections_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text,
	ALTER COLUMN "title" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."sections_translations"
	ALTER COLUMN "description" DROP DEFAULT ;

--- END ALTER TABLE "public"."sections_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-01T07:36:55.647Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."episodes_translations" ---

ALTER TABLE IF EXISTS "public"."episodes_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255),
	ALTER COLUMN "title" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."episodes_translations" ---

--- BEGIN ALTER TABLE "public"."events_translations" ---

ALTER TABLE IF EXISTS "public"."events_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255),
	ALTER COLUMN "description" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."events_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255),
	ALTER COLUMN "title" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."events_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

ALTER TABLE IF EXISTS "public"."messagetemplates_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "message" SET DATA TYPE varchar(255) USING "message"::varchar(255),
	ALTER COLUMN "message" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

ALTER TABLE IF EXISTS "public"."pages_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

ALTER TABLE IF EXISTS "public"."pages_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255);

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN ALTER TABLE "public"."seasons_translations" ---

ALTER TABLE IF EXISTS "public"."seasons_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255),
	ALTER COLUMN "title" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."seasons_translations" ---

--- BEGIN ALTER TABLE "public"."sections_translations" ---

ALTER TABLE IF EXISTS "public"."sections_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255),
	ALTER COLUMN "title" SET DEFAULT NULL::character varying;

ALTER TABLE IF EXISTS "public"."sections_translations"
	ALTER COLUMN "description" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."sections_translations" ---

--- BEGIN ALTER TABLE "public"."shows_translations" ---

ALTER TABLE IF EXISTS "public"."shows_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255),
	ALTER COLUMN "title" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."shows_translations" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255);

ALTER TABLE IF EXISTS "public"."notificationtemplates_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

ALTER TABLE IF EXISTS "public"."studytopics_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255);

ALTER TABLE IF EXISTS "public"."studytopics_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

ALTER TABLE IF EXISTS "public"."achievementgroups_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255);

ALTER TABLE IF EXISTS "public"."achievementgroups_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

ALTER TABLE IF EXISTS "public"."achievements_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255);

ALTER TABLE IF EXISTS "public"."achievements_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

--- END ALTER TABLE "public"."achievements_translations" ---
