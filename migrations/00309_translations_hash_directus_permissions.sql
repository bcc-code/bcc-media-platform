-- +goose Up

GRANT SELECT ON TABLE "public"."translations_hash" TO directus;


-- +goose Down

REVOKE SELECT ON TABLE "public"."translations_hash" FROM directus;
