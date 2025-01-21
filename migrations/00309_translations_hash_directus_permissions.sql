-- +goose Up

GRANT SELECT, UPDATE, DELETE ON TABLE "public"."translations_hash" TO directus;


-- +goose Down

REVOKE SELECT, UPDATE, DELETE ON TABLE "public"."translations_hash" FROM directus;
