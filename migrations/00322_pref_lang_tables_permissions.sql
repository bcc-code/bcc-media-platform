-- +goose Up

-- Grant SELECT permissions to api user on new tables
GRANT SELECT ON "public"."applicationgroups_languages" TO api;
GRANT SELECT ON "public"."applicationgroups_languages_subs" TO api;

-- Grant SELECT permissions to background_worker on new tables
GRANT SELECT ON "public"."applicationgroups_languages" TO background_worker;
GRANT SELECT ON "public"."applicationgroups_languages_subs" TO background_worker;

-- Grant SELECT, INSERT, UPDATE permissions to directus user on new tables
GRANT SELECT, INSERT, UPDATE ON "public"."applicationgroups_languages" TO directus;
GRANT SELECT, INSERT, UPDATE ON "public"."applicationgroups_languages_subs" TO directus;

-- Grant usage on sequences to directus user
GRANT USAGE, SELECT ON SEQUENCE "public"."applicationgroups_languages_id_seq" TO directus;
GRANT USAGE, SELECT ON SEQUENCE "public"."applicationgroups_languages_subs_id_seq" TO directus;

-- +goose Down

-- Revoke permissions from api user
REVOKE SELECT ON "public"."applicationgroups_languages" FROM api;
REVOKE SELECT ON "public"."applicationgroups_languages_subs" FROM api;

-- Revoke permissions from background_worker
REVOKE SELECT ON "public"."applicationgroups_languages" FROM background_worker;
REVOKE SELECT ON "public"."applicationgroups_languages_subs" FROM background_worker;

-- Revoke permissions from directus user
REVOKE SELECT, INSERT, UPDATE ON "public"."applicationgroups_languages" FROM directus;
REVOKE SELECT, INSERT, UPDATE ON "public"."applicationgroups_languages_subs" FROM directus;

-- Revoke sequence permissions from directus user
REVOKE USAGE, SELECT ON SEQUENCE "public"."applicationgroups_languages_id_seq" FROM directus;
REVOKE USAGE, SELECT ON SEQUENCE "public"."applicationgroups_languages_subs_id_seq" FROM directus;
