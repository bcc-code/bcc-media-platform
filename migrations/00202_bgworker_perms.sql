-- +goose Up

GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE "public"."games_translations" TO background_worker;
GRANT SELECT ON TABLE "public"."games" TO background_worker;

-- +goose Down
