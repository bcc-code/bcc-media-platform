-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T08:40:32.674Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

GRANT INSERT ON TABLE "public"."notificationtemplates_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."seasons_translations" ---

GRANT INSERT ON TABLE "public"."seasons_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."seasons_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."seasons_translations" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

GRANT INSERT ON TABLE "public"."links_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."links_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

GRANT INSERT ON TABLE "public"."achievementgroups_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievementgroups_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

GRANT INSERT ON TABLE "public"."achievements_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievements_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."ageratings_translations" ---

GRANT INSERT ON TABLE "public"."ageratings_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."ageratings_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."ageratings_translations" ---

--- BEGIN ALTER TABLE "public"."episodes_translations" ---

GRANT INSERT ON TABLE "public"."episodes_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."episodes_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."episodes_translations" ---

--- BEGIN ALTER TABLE "public"."events_translations" ---

GRANT INSERT ON TABLE "public"."events_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."events_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."events_translations" ---

--- BEGIN ALTER TABLE "public"."tags_translations" ---

GRANT INSERT ON TABLE "public"."tags_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."tags_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."tags_translations" ---

--- BEGIN ALTER TABLE "public"."sections_translations" ---

GRANT INSERT ON TABLE "public"."sections_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."sections_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."sections_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

GRANT INSERT ON TABLE "public"."pages_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."pages_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN ALTER TABLE "public"."calendarentries_translations" ---

GRANT INSERT ON TABLE "public"."calendarentries_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."calendarentries_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."calendarentries_translations" ---

--- BEGIN ALTER TABLE "public"."categories_translations" ---

GRANT INSERT ON TABLE "public"."categories_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."categories_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."categories_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

GRANT INSERT ON TABLE "public"."messagetemplates_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."messagetemplates_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."shows_translations" ---

GRANT INSERT ON TABLE "public"."shows_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."shows_translations" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."shows_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-08-03T08:40:34.473Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."ageratings_translations" ---

REVOKE INSERT ON TABLE "public"."ageratings_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."ageratings_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."ageratings_translations" ---

--- BEGIN ALTER TABLE "public"."episodes_translations" ---

REVOKE INSERT ON TABLE "public"."episodes_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."episodes_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."episodes_translations" ---

--- BEGIN ALTER TABLE "public"."events_translations" ---

REVOKE INSERT ON TABLE "public"."events_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."events_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."events_translations" ---

--- BEGIN ALTER TABLE "public"."tags_translations" ---

REVOKE INSERT ON TABLE "public"."tags_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."tags_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."tags_translations" ---

--- BEGIN ALTER TABLE "public"."applications" ---

GRANT SELECT ON TABLE "public"."applications" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."applications" ---

--- BEGIN ALTER TABLE "public"."links_translations" ---

REVOKE INSERT ON TABLE "public"."links_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."links_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."links_translations" ---

--- BEGIN ALTER TABLE "public"."notificationtemplates_translations" ---

REVOKE INSERT ON TABLE "public"."notificationtemplates_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."notificationtemplates_translations" ---

--- BEGIN ALTER TABLE "public"."achievementgroups_translations" ---

REVOKE INSERT ON TABLE "public"."achievementgroups_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."achievementgroups_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."achievementgroups_translations" ---

--- BEGIN ALTER TABLE "public"."achievements_translations" ---

REVOKE INSERT ON TABLE "public"."achievements_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."achievements_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."achievements_translations" ---

--- BEGIN ALTER TABLE "public"."calendarentries_translations" ---

REVOKE INSERT ON TABLE "public"."calendarentries_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."calendarentries_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."calendarentries_translations" ---

--- BEGIN ALTER TABLE "public"."categories_translations" ---

REVOKE INSERT ON TABLE "public"."categories_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."categories_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."categories_translations" ---

--- BEGIN ALTER TABLE "public"."messagetemplates_translations" ---

REVOKE INSERT ON TABLE "public"."messagetemplates_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."messagetemplates_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."messagetemplates_translations" ---

--- BEGIN ALTER TABLE "public"."pages_translations" ---

REVOKE INSERT ON TABLE "public"."pages_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."pages_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."pages_translations" ---

--- BEGIN ALTER TABLE "public"."seasons_translations" ---

REVOKE INSERT ON TABLE "public"."seasons_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."seasons_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."seasons_translations" ---

--- BEGIN ALTER TABLE "public"."sections_translations" ---

REVOKE INSERT ON TABLE "public"."sections_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."sections_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."sections_translations" ---

--- BEGIN ALTER TABLE "public"."shows_translations" ---

REVOKE INSERT ON TABLE "public"."shows_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON TABLE "public"."shows_translations" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."shows_translations" ---
