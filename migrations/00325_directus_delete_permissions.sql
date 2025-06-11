-- +goose Up

GRANT DELETE ON "public"."applicationgroups_languages" TO directus;
GRANT DELETE ON "public"."applicationgroups_languages_subs" TO directus;

-- +goose Down

REVOKE DELETE ON "public"."applicationgroups_languages" FROM directus;
REVOKE DELETE ON "public"."applicationgroups_languages_subs" FROM directus;
