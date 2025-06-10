-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: CASCADE AI                          ***/
/***    CREATED ON: 2025-06-10T12:01:20+02:00           ***/
/**********************************************************/

-- Grant SELECT permissions to api user on new tables
GRANT SELECT ON "public"."applicationgroups_languages" TO api;
GRANT SELECT ON "public"."applicationgroups_languages_subs" TO api;

-- Grant SELECT permissions to background user on new tables
GRANT SELECT ON "public"."applicationgroups_languages" TO background;
GRANT SELECT ON "public"."applicationgroups_languages_subs" TO background;

-- Grant SELECT, INSERT, UPDATE permissions to directus user on new tables
GRANT SELECT, INSERT, UPDATE ON "public"."applicationgroups_languages" TO directus;
GRANT SELECT, INSERT, UPDATE ON "public"."applicationgroups_languages_subs" TO directus;

-- Grant usage on sequences to directus user
GRANT USAGE, SELECT ON SEQUENCE "public"."applicationgroups_languages_id_seq" TO directus;
GRANT USAGE, SELECT ON SEQUENCE "public"."applicationgroups_languages_subs_id_seq" TO directus;

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: CASCADE AI                          ***/
/***    CREATED ON: 2025-06-10T12:01:20+02:00           ***/
/**********************************************************/

-- Revoke permissions from api user
REVOKE SELECT ON "public"."applicationgroups_languages" FROM api;
REVOKE SELECT ON "public"."applicationgroups_languages_subs" FROM api;

-- Revoke permissions from background user 
REVOKE SELECT ON "public"."applicationgroups_languages" FROM background;
REVOKE SELECT ON "public"."applicationgroups_languages_subs" FROM background;

-- Revoke permissions from directus user
REVOKE SELECT, INSERT, UPDATE ON "public"."applicationgroups_languages" FROM directus;
REVOKE SELECT, INSERT, UPDATE ON "public"."applicationgroups_languages_subs" FROM directus;

-- Revoke sequence permissions from directus user
REVOKE USAGE, SELECT ON SEQUENCE "public"."applicationgroups_languages_id_seq" FROM directus;
REVOKE USAGE, SELECT ON SEQUENCE "public"."applicationgroups_languages_subs_id_seq" FROM directus;
