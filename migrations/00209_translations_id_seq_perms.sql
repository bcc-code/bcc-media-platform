-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T09:51:49.582Z             ***/
/***********************************************************/

--- BEGIN ALTER SEQUENCE "public"."links_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."links_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."links_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."links_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."links_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."episodes_translations_id_seq" ---

GRANT USAGE ON SEQUENCE "public"."episodes_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."episodes_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."sections_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."sections_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."shows_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."shows_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."seasons_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."seasons_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."episodes_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievementgroups_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."achievementgroups_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."achievementgroups_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."achievementgroups_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."achievementgroups_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."questionalternatives_translations_id_seq1" ---

GRANT SELECT ON SEQUENCE "public"."questionalternatives_translations_id_seq1" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."questionalternatives_translations_id_seq1" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."questionalternatives_translations_id_seq1" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."questionalternatives_translations_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."lessons_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."lessons_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."lessons_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."lessons_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."lessons_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."faqs_translations_id_seq" ---

GRANT USAGE ON SEQUENCE "public"."faqs_translations_id_seq1" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqs_translations_id_seq1" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."faqs_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."tasks_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."tasks_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."tasks_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."tasks_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."tasks_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."studytopics_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."studytopics_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."studytopics_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."studytopics_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."studytopics_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."questionalternatives_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."questionalternatives_translations_id_seq" TO background_worker;
GRANT SELECT ON SEQUENCE "public"."questionalternatives_translations_id_seq1" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."questionalternatives_translations_id_seq1" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."questionalternatives_translations_id_seq1" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."questionalternatives_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."tags_translations_id_seq" ---

GRANT USAGE ON SEQUENCE "public"."tags_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."tags_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."tags_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."ageratings_translations_id_seq" ---

GRANT USAGE ON SEQUENCE "public"."ageratings_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."ageratings_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."ageratings_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievements_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."achievements_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."achievements_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."achievements_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."achievements_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."faqcategories_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."faqcategories_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."faqcategories_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."faqcategories_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."faqcategories_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."games_translations_id_seq" ---

GRANT SELECT ON SEQUENCE "public"."games_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."games_translations_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."games_translations_id_seq" TO background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."games_translations_id_seq" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T09:51:51.320Z             ***/
/***********************************************************/

--- BEGIN ALTER SEQUENCE "public"."faqs_translations_id_seq" ---

REVOKE USAGE ON SEQUENCE "public"."faqs_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."faqs_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."faqs_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."lessons_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."lessons_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."lessons_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."lessons_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."lessons_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."links_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."links_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."links_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."links_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."links_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."tvguideentry_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."tvguideentry_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

ALTER SEQUENCE "public"."tvguideentry_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."tvguideentry_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."tvguideentry_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."tvguideentry_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."tvguideentry_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."tvguideentry_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."tvguideentry_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."tvguideentry_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."tvguideentry_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."tvguideentry_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."tvguideentry_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."tvguideentry_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."games_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."games_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."games_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."games_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."games_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."tasks_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."tasks_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."tasks_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."tasks_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."tasks_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."questionalternatives_translations_id_seq1" ---

REVOKE SELECT ON SEQUENCE "public"."questionalternatives_translations_id_seq1" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."questionalternatives_translations_id_seq1" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."questionalternatives_translations_id_seq1" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."questionalternatives_translations_id_seq1" ---

--- BEGIN ALTER SEQUENCE "public"."episodes_translations_id_seq" ---

REVOKE USAGE ON SEQUENCE "public"."episodes_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."episodes_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."episodes_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievements_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."achievements_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."achievements_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."achievements_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."achievements_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."ageratings_translations_id_seq" ---

REVOKE USAGE ON SEQUENCE "public"."ageratings_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."ageratings_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."ageratings_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."studytopics_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."studytopics_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."studytopics_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."studytopics_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."studytopics_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."questionalternatives_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."questionalternatives_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."questionalternatives_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."questionalternatives_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."questionalternatives_translations_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."webconfig_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."webconfig_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

ALTER SEQUENCE "public"."webconfig_id_seq" OWNER TO manager;
GRANT SELECT ON SEQUENCE "public"."webconfig_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."webconfig_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."webconfig_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."webconfig_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."webconfig_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."webconfig_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."webconfig_id_seq" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."webconfig_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."webconfig_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."webconfig_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON SEQUENCE "public"."webconfig_id_seq" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."webconfig_id_seq" IS NULL;

--- END CREATE SEQUENCE "public"."webconfig_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."achievementgroups_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."achievementgroups_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."achievementgroups_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."achievementgroups_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."achievementgroups_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."tags_translations_id_seq" ---

REVOKE USAGE ON SEQUENCE "public"."tags_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."tags_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."tags_translations_id_seq" ---

--- BEGIN ALTER SEQUENCE "public"."faqcategories_translations_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."faqcategories_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."faqcategories_translations_id_seq" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."faqcategories_translations_id_seq" FROM background_worker;
--WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."faqcategories_translations_id_seq" ---
